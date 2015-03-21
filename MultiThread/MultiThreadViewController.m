//
//  MultiThreadViewController.m
//  MultiThread
//
//  Created by medicool on 15/3/18.
//  Copyright (c) 2015年 ZK. All rights reserved.
//

#import "MultiThreadViewController.h"
#import "ImageData.h"
#define ROW_COUNT 5
#define COLUMN_COUNT 3
#define ROW_HEIGHT 120
#define ROW_WIDTH ROW_HEIGHT
#define CELL_SPACING 10

@interface MultiThreadViewController ()
{
    NSMutableArray *_imageViews;
}
@end

@implementation MultiThreadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutUI];
}

#pragma mark - 界面布局
- (void)layoutUI
{
    //创建多个图片控件用于显示图片
    _imageViews = [NSMutableArray array];
    
    for (int r=0; r<ROW_COUNT; r++) {
        for (int c=0; c<COLUMN_COUNT; c++) {
            UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(c*ROW_WIDTH+(c*CELL_SPACING), r*ROW_HEIGHT+(r*CELL_SPACING                           ), ROW_WIDTH, ROW_HEIGHT)];
            imageView.contentMode=UIViewContentModeScaleAspectFit;
            //imageView.backgroundColor=[UIColor redColor];
            [self.view addSubview:imageView];
            [_imageViews addObject:imageView];
            
        }
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(75, 600, 220, 25);
    [button setTintColor:[UIColor whiteColor]];
    button.backgroundColor = [UIColor blueColor];
    [button setTitle:@"加载图片" forState:UIControlStateNormal];
    
    //添加方法
    [button addTarget:self action:@selector(loadImageWithMultiThread) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

#pragma mark - 多线程下载图片
- (void)loadImageWithMultiThread
{
    NSInteger count = ROW_COUNT * COLUMN_COUNT;
    for (NSInteger i = 0; i < count; i++) {
//        [NSThread detachNewThreadSelector:@selector(loadImage:) toTarget:self withObject:[NSNumber numberWithInt:i]];
        NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(loadImage:)  object:[NSNumber numberWithInteger:i]];
        thread.name = [NSString stringWithFormat:@"myThread%ld",(long)i];
        if (i == count-1) {
            thread.threadPriority = 1.0;
        }
        else
        {
            thread.threadPriority = 0.0;
        }
        
        [thread start];
    }
}

#pragma mark - 加载图片
-(void)loadImage:(NSNumber *)index{
//    NSLog(@"%i",i);
    //currentThread方法可以取得当前操作线程
    NSLog(@"current thread:%@",[NSThread currentThread]);
    
    NSInteger i = [index integerValue];
    
//    NSLog(@"%li",(long)i);//未必按顺序输出
    
    NSData *data= [self requestData:i];
    
    ImageData *imageData=[[ImageData alloc]init];
    imageData.index=i;
    imageData.data=data;
    [self performSelectorOnMainThread:@selector(updateImage:) withObject:imageData waitUntilDone:YES];
}

#pragma mark - 请求图片数据
- (NSData *)requestData:(NSInteger)index
{
    //对于多线程操作建议把线程操作放到@autoreleasepool中
    @autoreleasepool {
        if (index != ROW_COUNT*COLUMN_COUNT-1) {
            [NSThread sleepForTimeInterval:2.0];
        }
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://images.cnblogs.com/cnblogs_com/kenshincui/613474/o_%ld.jpg",index]];
        NSData *data = [NSData dataWithContentsOfURL:url];
        return data;
    }
}

#pragma mark - 将图片显示到界面
-(void)updateImage:(ImageData *)imageData{
    
    UIImage *image=[UIImage imageWithData:imageData.data];
    UIImageView *imageView= _imageViews[imageData.index];
    imageView.image=image;
    
}
@end
