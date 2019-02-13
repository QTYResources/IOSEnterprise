//
//  MySharedInstance.m
//  SharedInstance
//
//  Created by QinTuanye on 2019/1/29.
//  Copyright © 2019年 QinTuanye. All rights reserved.
//

#import "MySharedInstance.h"

@implementation MySharedInstance

+ (MySharedInstance *)sharedInstance {
    // 声明一个f静态变量，确保单例类的实例在整个App中只有一个，而且是唯一的
    static MySharedInstance *_sharedInstance = nil;
    // 声明一个静态变量，确保这个类的实例创建过程只创建一次
    static dispatch_once_t onceToken;
    // 通过Grand Central Dispatch (GCD)，执行一个Block，用来初始化单例类的实例
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[MySharedInstance alloc] initWithValue:@"Singleton initial Value2"];
    });
    return _sharedInstance;
}

- (instancetype)initWithValue:(NSString *)str {
    self = [super init];
    if (self) {
        self.stringPassed = str;
    }
    return self;
}

@end
