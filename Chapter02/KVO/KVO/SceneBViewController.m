//
//  ViewControllerBViewController.m
//  KVO
//
//  Created by QinTuanye on 2019/2/13.
//  Copyright © 2019年 QinTuanye. All rights reserved.
//

#import "SceneBViewController.h"

@interface SceneBViewController () <UITextFieldDelegate>
@property (nonatomic, copy) NSString *textValue;    // 被观察的属性对象

@property (weak, nonatomic) IBOutlet UITextField *inputInformation;

@end

@implementation SceneBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    // 将UITextField内容赋给被观察的属性对象
    self.textValue = self.inputInformation.text;
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
    [textField resignFirstResponder];
    return YES;
}

@end
