//
//  UserInfo.h
//  SharedInstance
//
//  Created by QinTuanye on 2019/1/29.
//  Copyright © 2019年 QinTuanye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

@interface UserInfo : NSObject
singleton_interface(UserInfo)
@property(nonatomic, copy) NSString *user;  // 用户名
// 声明更多的属性变量.......
@end
