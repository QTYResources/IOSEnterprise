//
//  Card.h
//  iOSBasicKnowledge
//
//  Created by QinTuanye on 2019/1/28.
//  Copyright © 2019年 QinTuanye. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Card : NSObject
@property (nonatomic, strong) NSString *contents;    // 声明一个属性
@property (nonatomic) BOOL onSwitch;
@end

NS_ASSUME_NONNULL_END
