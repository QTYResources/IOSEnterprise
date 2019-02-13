//
//  SceneBViewController.m
//  NotificationUse
//
//  Created by QinTuanye on 2019/2/13.
//  Copyright © 2019年 QinTuanye. All rights reserved.
//

#import "SceneBViewController.h"

@interface SceneBViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *inputInformation;

@end

@implementation SceneBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    // 创建一个NSDictionary，存放UITextField内容
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:self.inputInformation.text, @"value", nil];
    // 创建一个通知，通知的名字是myNotification
    NSNotification *notification = [NSNotification notificationWithName:@"myNotification" object:nil userInfo:dict];
    // 由通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    [textField resignFirstResponder];
    return YES;
}

@end
