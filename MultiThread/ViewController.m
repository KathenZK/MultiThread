//
//  ViewController.m
//  MultiThread
//
//  Created by medicool on 15/3/17.
//  Copyright (c) 2015年 ZK. All rights reserved.
//

#import "ViewController.h"
#import "ThreadViewController.h"
#import "MultiThreadViewController.h"
#import "StopMultiThreadViewController.h"
#import "InvocationOperationViewController.h"
#import "BlockOperationViewController.h"
#import "SerialQueueViewController.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *list;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"多线程";
}

#pragma mark - 懒加载
- (NSArray *)list
{
    if (_list == nil) {
        _list = @[@"NSThread", @"多线程并发", @"停止多线程", @"InvocationOperation", @"BlockOperation", @"SerialQueue", @"", @"", @""];
    }
    return _list;
}

#pragma mark - 数据源代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.textLabel.text = self.list[indexPath.row];
    return cell;
}

#pragma mark - tableView的代理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str = self.list[indexPath.row];
    
    if ([str isEqualToString:@"NSThread"]) {
        ThreadViewController *vc = [[ThreadViewController alloc]init];
        vc.title = str;
        vc.view.backgroundColor = [UIColor whiteColor];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([str isEqualToString:@"多线程并发"])
    {
        MultiThreadViewController *vc = [[MultiThreadViewController alloc]init];
        vc.title = str;
        vc.view.backgroundColor = [UIColor whiteColor];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([str isEqualToString:@"停止多线程"])
    {
        StopMultiThreadViewController *vc = [[StopMultiThreadViewController alloc]init];
        vc.title = str;
        vc.view.backgroundColor = [UIColor whiteColor];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([str isEqualToString:@"InvocationOperation"])
    {
        InvocationOperationViewController *vc = [[InvocationOperationViewController alloc]init];
        vc.title = str;
        vc.view.backgroundColor = [UIColor whiteColor];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([str isEqualToString:@"BlockOperation"])
    {
        BlockOperationViewController *vc = [[BlockOperationViewController alloc]init];
        vc.title = str;
        vc.view.backgroundColor = [UIColor whiteColor];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([str isEqualToString:@"SerialQueue"])
    {
        SerialQueueViewController *vc = [[SerialQueueViewController alloc]init];
        vc.title = str;
        vc.view.backgroundColor = [UIColor whiteColor];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end
