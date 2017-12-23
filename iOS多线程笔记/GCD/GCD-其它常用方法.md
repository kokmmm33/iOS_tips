```
// GCD常用函数
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

```