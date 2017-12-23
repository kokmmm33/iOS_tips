//
//  People.m
//  NSOperation
//
//  Created by 蔡杰 on 2017/12/22.
//  Copyright © 2017年 Joseph. All rights reserved.
//

#import "People.h"

@implementation People

static People *_instance;
+ (instancetype)instance {

    return [[People alloc] init];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [People allocWithZone:zone];
    });
    return _instance;
}



@end
