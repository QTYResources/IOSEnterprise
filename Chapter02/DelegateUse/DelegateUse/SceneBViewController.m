//
//  SceneBViewController.m
//  DelegateUse
//
//  Created by QinTuanye on 2019/1/29.
//  Copyright © 2019年 QinTuanye. All rights reserved.
//

#import "SceneBViewController.h"

@interface SceneBViewController ()

@end

@implementation SceneBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"return=>delegate: %@", self.delegate);
    if (self.delegate) {
        // 如果有了被委托者
        // 将UITextField内容传递给Delegate内的方法
        [self.delegate sceneBViewController:self didInputed:self.inputInformation.text];
        // 让当前呈现的Scene B页面消失
        [self.navigationController popViewControllerAnimated:YES];
    }
    // 让键盘消失
    [textField resignFirstResponder];
    return YES;
}

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
