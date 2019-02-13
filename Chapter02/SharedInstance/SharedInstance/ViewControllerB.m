//
//  ViewControllB.m
//  SharedInstance
//
//  Created by QinTuanye on 2019/1/29.
//  Copyright © 2019年 QinTuanye. All rights reserved.
//

#import "ViewControllerB.h"
#import "MySharedInstance.h"
#import "UserInfo.h"

@interface ViewControllerB () <UITextFieldDelegate>
@property(weak, nonatomic) IBOutlet UITextField *inputInformation;
@end

@implementation ViewControllerB

// 单击输入键盘的完成按钮时，触发这个UITextFieldDelegate的方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"RETURN");
    UserInfo *info = [UserInfo sharedUserInfo];
    MySharedInstance *myInstance = [MySharedInstance sharedInstance];
    // 将输入的文字保存到单例的属性变量中
    myInstance.stringPassed = self.inputInformation.text;
    // ViewControllerB消失
    [self.navigationController popViewControllerAnimated:YES];
    // 键盘释放
    [textField resignFirstResponder];
    return YES;
}
@end
