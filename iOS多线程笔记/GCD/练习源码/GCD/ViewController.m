//
//  ViewController.m
//  GCD
//
//  Created by 蔡杰 on 2017/12/22.
//  Copyright © 2017年 Joseph. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //[self lockCircle];  // 在主线程中执行，会产生线程死锁
    //[NSThread detachNewThreadSelector:@selector(lockCircle) toTarget:self withObject:nil]; // 放在子线程执行不会死锁
    //[self commonFunction];
    
    [self group2];
}

#pragma mark - 创建、执行队列
- (void)customQueue {
    /**
     手动创建一个队列
     "indentify" 队列标识符
     DISPATCH_QUEUE_CONCURRENT:并行队列的宏    DISPATCH_QUEUE_SERIAL:串行队列的宏
     return 一个并行队列
     */
    dispatch_queue_t concurrent_queue = dispatch_queue_create("indentify", DISPATCH_QUEUE_SERIAL);
    
    // 获取全局默认的并行队列
    /**
     DISPATCH_QUEUE_PRIORITY_DEFAULT 设置队列权限
     第二个参数，为系统预留参数位，随便填
     */
    dispatch_queue_t globleQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    
    // 并行队列，异步执行
    dispatch_async(concurrent_queue, ^{
        NSLog(@"并行队列，异步执行");
    });
    
    // 并行队列，同步执行
    dispatch_sync(concurrent_queue, ^{
        NSLog(@"并行队列，同步执行");
    });
}

#pragma mark - 死锁
- (void)lockCircle {
    NSLog(@"主线程开始执行任务");
    
    // 主队列，当主线程空闲时会自动调度主队列里的任务，当主线程中有正在执行的任务，会暂停调度主队列中的任务。
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
    // 同步执行，没有执行完，会阻塞当前前线程
    dispatch_sync(mainQueue, ^{
        NSLog(@"下载任务 1");
    });
    dispatch_sync(mainQueue, ^{
        NSLog(@"下载任务 2");
    });
    dispatch_sync(mainQueue, ^{
        NSLog(@"下载任务 3");
    });
}

#pragma mark -  GCD常用函数
- (void)commonFunction {
    // 1、 延迟执行
    // 2、App生命周期内只执行一次
    
    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrent", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(concurrentQueue, ^{
        NSLog(@"下载任务 1");
    });
    dispatch_async(concurrentQueue, ^{
        NSLog(@"下载任务 2");
    });
    // 3、栅栏函数 控制异步执行顺序, 只能用自己创建的并行队列，不能用globle队列，否则会产生死锁
    dispatch_barrier_async(concurrentQueue, ^{
        NSLog(@" 1 和 2 执行完成了，接下来执行 下载任务3");
    });
    dispatch_async(concurrentQueue, ^{
        NSLog(@"下载任务 3");
    });
    
    // 4、快速迭代
    /**
     for 实现快速迭代是同步执行的
     GCD 实现快速迭代时多线程异步执行的
     */
    dispatch_apply(10000, dispatch_get_global_queue(0, 0), ^(size_t index) {
        NSLog(@"index：下标，无序的， 多线程异步执行");
    });
}

#pragma mark - 线程组
- (void)group1 {
    dispatch_group_t group1 = dispatch_group_create();
    
    dispatch_group_async(group1, dispatch_get_global_queue(0, 0), ^{
        NSLog(@"下载图片1---%@",[NSThread currentThread]);
    });
    dispatch_group_async(group1, dispatch_get_global_queue(0, 0), ^{
        NSLog(@"下载图片2---%@",[NSThread currentThread]);
    });
    dispatch_group_async(group1, dispatch_get_global_queue(0, 0), ^{
        NSLog(@"下载图片3---%@",[NSThread currentThread]);
    });
    dispatch_group_async(group1, dispatch_get_global_queue(0, 0), ^{
        NSLog(@"下载图片4---%@",[NSThread currentThread]);
    });
    
    // 通知group 所有任务已完成
    dispatch_group_notify(group1, dispatch_get_main_queue(), ^{
        NSLog(@"图片全部下载完成------%@",[NSThread currentThread]);
    });
    
    NSLog(@"主线程已闲置");
}

- (void)group2 {
    dispatch_queue_t globle = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group2 = dispatch_group_create();
    
    dispatch_group_enter(group2); // dispatch_group_enter 和 dispatch_group_leave 必须配对使用
    // 下面异步任务都将被添加到 group2中，每个任务完成后都需要手动离开grop
    dispatch_async(globle, ^{
        NSLog(@"下载图片1---%@",[NSThread currentThread]);
        dispatch_group_leave(group2);
    });
    
    dispatch_group_enter(group2);
    dispatch_async(globle, ^{
        NSLog(@"下载图片2---%@",[NSThread currentThread]);
        dispatch_group_leave(group2);
    });
    
    dispatch_group_enter(group2);
    dispatch_async(globle, ^{
        NSLog(@"下载图片3---%@",[NSThread currentThread]);
        dispatch_group_leave(group2);
    });
    
    //    dispatch_group_notify(group2, dispatch_get_main_queue(), ^{
    //        NSLog(@"图片全部下载完成------%@",[NSThread currentThread]);
    //    });
    
    // 指定时间通知group任务完成情况； DISPATCH_TIME_FOREVER:如果任务没有全部完成会阻塞线程；
    dispatch_group_wait(group2, DISPATCH_TIME_FOREVER);
    
    NSLog(@"主线程已闲置");
}


#pragma mark - GCD 两种封装任务的方式
- (void)twoType {
    /* 通过block封装任务 */
    // dispatch_async(<#dispatch_queue_t  _Nonnull queue#>, <#^(void)block#>)
    
    /* 同过 C 函数封装任务 */
    //dispatch_async_f(<#dispatch_queue_t  _Nonnull queue#>, <#void * _Nullable context#>, <#dispatch_function_t  _Nonnull work#>)
}

@end
