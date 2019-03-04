//
//  SceneBViewController.m
//  UseBlock
//
//  Created by QinTuanye on 2019/3/4.
//  Copyright © 2019年 QinTuanye. All rights reserved.
//

#import "SceneBViewController.h"

@interface SceneBViewController ()
// 声明一个Block属性变量
@property (nonatomic, copy) ReturnTextBlock retBlock;
@end

@implementation SceneBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

// 将Block作为一个传递参数，用于初始化Block属性变量
-(void)returnText:(ReturnTextBlock)block {
    self.retBlock = block;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    // 判断属性变量（Block）是否为空
    if (self.retBlock) {
        // 执行Block属性变量，输入参数是UITextField的内容
        self.retBlock(self.inputInformation.text);
        // Scene B消失
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
    // 隐藏键盘
    [textField resignFirstResponder];
    return YES;
}

@end
