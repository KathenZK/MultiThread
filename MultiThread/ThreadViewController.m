//
//  ThreadViewController.m
//  MultiThread
//
//  Created by medicool on 15/3/17.
//  Copyright (c) 2015年 ZK. All rights reserved.
//

#import "ThreadViewController.h"

@interface ThreadViewController ()
{
    UIImageView *_imageView;
}
@end

@implementation ThreadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutUI];
}

- (void)layoutUI
{
    _imageView = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].applicationFrame];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_imageView];
    
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
    //方法1:使用对象方法
    //创建一个线程，第一个参数是请求的操作，第二个参数是操作方法的参数
    NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(loadImage) object:nil];
    //启动一个线程，注意启动一个线程并非就一定立即执行，而是处于就绪状态，当系统调度时才真正执行
    [thread start];
    
    //方法2:使用类方法
//    [NSThread detachNewThreadSelector:@selector(loadImage) toTarget:self withObject:nil];

}

#pragma mark - 加载图片
- (void)loadImage
{
    //请求数据
    NSData *data = [self requestData];
    
    /*将数据显示到UI控件,注意只能在主线程中更新UI,
     另外performSelectorOnMainThread方法是NSObject的分类方法，每个NSObject对象都有此方法，
     它调用的selector方法是当前调用控件的方法，例如使用UIImageView调用的时候selector就是UIImageView的方法
     Object：代表调用方法的参数,不过只能传递一个参数(如果有多个参数请使用对象进行封装)
     waitUntilDone:是否线程任务完成执行
     */
    [self performSelectorOnMainThread:@selector(updateImage:) withObject:data waitUntilDone:YES];
}

#pragma mark - 请求图片数据
- (NSData *)requestData
{
    //对于多线程操作建议把线程操作放到@autoreleasepool中
    @autoreleasepool {
        NSURL *url = [NSURL URLWithString:@"http://store.storeimages.cdn-apple.com/4451/as-images.apple.com/is/image/AppleInc/aos/published/images/m/ac/macbook/gold/macbook-gold-bb-201501?wid=1006&hei=176&fmt=png-alpha&qlt=95&.v=1425934909854"];
        NSData *data = [NSData dataWithContentsOfURL:url];
        return data;
    }
}

#pragma mark - 显示图片到界面
- (void)updateImage:(NSData *)imageData
{
    _imageView.image = [UIImage imageWithData:imageData];
    

}
@end
