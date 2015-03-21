//
//  SerialQueueViewController.m
//  MultiThread
//
//  Created by medicool on 15/3/20.
//  Copyright (c) 2015年 ZK. All rights reserved.
//

#import "SerialQueueViewController.h"
#import "ImageData.h"
#define ROW_COUNT 5
#define COLUMN_COUNT 3
#define ROW_HEIGHT 120
#define ROW_WIDTH ROW_HEIGHT
#define CELL_SPACING 10
#define IMAGE_COUNT ROW_COUNT * COLUMN_COUNT

@interface SerialQueueViewController ()
{
    NSMutableArray *_imageViews;
    NSMutableArray *_imageNames;
}
@end

@implementation SerialQueueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutUI];
}

#pragma mark 界面布局
-(void)layoutUI{
    //创建多个图片控件用于显示图片
    _imageViews=[NSMutableArray array];
    for (int r=0; r<ROW_COUNT; r++) {
        for (int c=0; c<COLUMN_COUNT; c++) {
            UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(c*ROW_WIDTH+(c*CELL_SPACING), r*ROW_HEIGHT+(r*CELL_SPACING                           ), ROW_WIDTH, ROW_HEIGHT)];
            imageView.contentMode=UIViewContentModeScaleAspectFit;
            //            imageView.backgroundColor=[UIColor redColor];
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
    
    //创建图片链接
    _imageNames=[NSMutableArray array];
    for (int i=0; i<IMAGE_COUNT; i++) {
        [_imageNames addObject:[NSString stringWithFormat:@"http://images.cnblogs.com/cnblogs_com/kenshincui/613474/o_%i.jpg",i]];
    }
}

#pragma mark 多线程下载图片 - 串行队列
-(void)loadImageWithMultiThread{
    int count=ROW_COUNT*COLUMN_COUNT;
    /*
     创建一个串行队列
     第一个参数：队列名称
     第二个参数：队列类型
     */
    dispatch_queue_t serialQueue = dispatch_queue_create("myThread1", DISPATCH_QUEUE_SERIAL);
    //注意queue对象不是指针类型
    //创建多个线程用于填充图片
    for (int i = 0; i < count; i++) {
        //异步执行队列任务
        dispatch_async(serialQueue, ^{
            [self loadImage:[NSNumber numberWithInt:i]];
        });
    }
}
#pragma mark - 并发队列
-(void)loadImageWithMultiThread1{
    int count = ROW_COUNT*COLUMN_COUNT;
    
    /*
     取得全局队列
     第一个参数：线程优先级
     第二个参数：标记参数，目前没有用，一般传入0
     */
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //创建多个线程用于填充图片
    for (int i = 0; i < count; i++) {
        //创建多个线程用于填充图片
        dispatch_async(globalQueue, ^{
            [self loadImage:[NSNumber numberWithInt:i]];
        });
    }
}
#pragma mark 加载图片
-(void)loadImage:(NSNumber *)index{
    int i=[index intValue];
    
    //请求数据
    NSData *data= [self requestData:i];
    NSLog(@"%@",[NSThread currentThread]);
    //更新UI界面,此处调用了主线程队列的方法（mainQueue是UI主线程）
//    [[NSOperationQueue mainQueue]addOperationWithBlock:^{
//        [self updateImageWithData:data andIndex:i];
//    }];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateImageWithData:data andIndex:i];
    });
}

#pragma mark 请求图片数据
-(NSData *)requestData:(int )index{
  
        NSURL *url=[NSURL URLWithString:_imageNames[index]];
        NSData *data=[NSData dataWithContentsOfURL:url];
        
        return data;
}

#pragma mark 将图片显示到界面
-(void)updateImageWithData:(NSData *)data andIndex:(int )index{
    UIImage *image=[UIImage imageWithData:data];
    UIImageView *imageView= _imageViews[index];
    imageView.image=image;
}

@end
