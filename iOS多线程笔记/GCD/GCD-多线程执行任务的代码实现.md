```
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
```