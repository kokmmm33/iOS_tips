```
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
```