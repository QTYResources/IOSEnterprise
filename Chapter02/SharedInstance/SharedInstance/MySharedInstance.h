//
//  MySharedInstance.h
//  SharedInstance
//
//  Created by QinTuanye on 2019/1/29.
//  Copyright © 2019年 QinTuanye. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MySharedInstance : NSObject
// 单例中的属性变量
@property (nonatomic, strong) NSString *stringPassed;
// 单例k类方法，称之为构造方法
+ (MySharedInstance *)sharedInstance;
@end
