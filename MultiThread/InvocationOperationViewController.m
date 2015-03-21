//
//  InvocationOperationViewController.m
//  MultiThread
//
//  Created by medicool on 15/3/19.
//  Copyright (c) 2015年 ZK. All rights reserved.
//

#import "InvocationOperationViewController.h"

@interface InvocationOperationViewController ()

@end

@implementation InvocationOperationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(75, 600, 220, 25);
    button.layer.cornerRadius = 4;
    button.backgroundColor = [UIColor blackColor];
    button.tintColor = [UIColor whiteColor];
    [button setTitle:@"开始" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(loadImageWithMultiThread) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

#pragma mark - 多线程操作
- (void)loadImageWithMultiThread
{
    /*
     创建一个调用操作
     object:调用方法参数
     */
    NSInvocationOperation *invocationOpertion = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(loadImage) object:nil];
    //创建完NSInvocationOperation对象并不会调用，它由一个start方法启动操作，但是注意如果直接调用start方法，则此操作会在主线程中调用，一般不会这么操作,而是添加到NSOperationQueue中
//    [invocationOpertion start];
    //创建操作队列
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc]init];
    //注意添加到操作队后，队列会开启一个线程执行此操作
    [operationQueue addOperation:invocationOpertion];
}

#pragma mark - 加载图片
- (void)loadImage
{
    NSLog(@"%@",[NSThread currentThread]);
}

@end
