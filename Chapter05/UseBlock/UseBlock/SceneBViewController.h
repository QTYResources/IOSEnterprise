//
//  SceneBViewController.h
//  UseBlock
//
//  Created by QinTuanye on 2019/3/4.
//  Copyright © 2019年 QinTuanye. All rights reserved.
//

#import <UIKit/UIKit.h>

// SceneBViewController.h
// 自定义一个Block
typedef void(^ReturnTextBlock)(NSString *showText);

@interface SceneBViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITextField *inputInformation;

// 声明一个调用Block的方法
- (void)returnText:(ReturnTextBlock)block;
@end

