//
//  ViewController.m
//  iOSBasicKnowledge
//
//  Created by QinTuanye on 2019/1/28.
//  Copyright © 2019年 QinTuanye. All rights reserved.
//

#import "ViewController.h"

#define COLOR_FONT_LIGHTWHITE 0xffffff
#define COLOR_FONT_WHITE 0xffffff
#define COLOR_BG_RED 0xff0000
#define COLOR_BG_WHITE 0xffffff

// 获取屏幕的宽度和高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

// RGB转UIColor（十六进制）
#define RGB16(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:1.0]

@interface ViewController () <UITextFieldDelegate>
@property(nonatomic, strong) UILabel *firstLabel;
@property(nonatomic, strong) UITextField *accountTextField;
@property(nonatomic, strong) UITextField *authTextField;
@property(nonatomic, strong) UIButton *loginButton;
@property(nonatomic, strong) UIButton *registerButton;
@property(nonatomic, strong) UIButton *authCodeButton;

@end

@implementation ViewController

- (void)dkfjd {
    // 创建定制化的输入框（请输入手机号码）
    self.accountTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入手机号码" attributes:@{NSForegroundColorAttributeName:RGB16(COLOR_FONT_LIGHTWHITE)}];
    self.accountTextField.borderStyle = UITextBorderStyleNone;
    self.accountTextField.textColor = RGB16(COLOR_FONT_WHITE);
    self.accountTextField.keyboardType = UIKeyboardTypeNumberPad;

    // 创建定制化的输入框（请输入验证码）
    self.authTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入验证码" attributes:@{NSForegroundColorAttributeName:RGB16(COLOR_FONT_LIGHTWHITE)}];
    self.authTextField.borderStyle = UITextBorderStyleNone;
    self.authTextField.textColor = RGB16(COLOR_FONT_WHITE);
    self.authTextField.keyboardType = UIKeyboardTypeNumberPad;

    // 创建定制化的按钮（立即登录）
    self.loginButton.backgroundColor = RGB16(COLOR_BG_RED);
    self.loginButton.layer.cornerRadius = self.loginButton.frame.size.height / 2;
    self.loginButton.clipsToBounds = YES;

    // 创建定制化的按钮（注册账号）
    self.registerButton.backgroundColor = [UIColor clearColor];
    self.registerButton.layer.cornerRadius = self.registerButton.frame.size.height / 2;
    self.registerButton.layer.borderWidth = 1;
    self.registerButton.layer.borderColor = RGB16(COLOR_BG_WHITE).CGColor;
    self.registerButton.clipsToBounds = YES;

    // 创建定制化的按钮（获取验证码）
    self.authCodeButton.backgroundColor = RGB16(COLOR_BG_RED);
    self.authCodeButton.layer.cornerRadius = self.authCodeButton.frame.size.height / 2;
    self.authCodeButton.clipsToBounds = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 为View注册一个手势，触摸View时触发Target-Action
    UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    [self.view addGestureRecognizer:tapG];
    
// Remove all subviews from self.view
for (UIView *subView in self.view.subviews) {
    // 如果子视图是UIButton类型，则移除该子视图
    if ([subView isKindOfClass:[UIButton class]]) {
        [subView removeFromSuperview];
    }
}
    
}

#pragma mark -- 解决虚拟键盘挡住UITextField的方法
// 当某个TextField处于输入状态时
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    CGRect frame = textField.frame;
    // 键盘高度为216
    int offset = frame.origin.y + 162 - (self.view.frame.size.height - 216.0);
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    if (offset > 0) {    // 判断是否有必要上移View
        CGRect rect = CGRectMake(0.0f, -offset, width, height);
        self.view.frame = rect;
    }
    [UIView commitAnimations];
}

// 输入完成后，键盘消失。添加动画，让键盘的消失有个过渡效果
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    self.view.frame = rect;
    [UIView commitAnimations];
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -- 触摸View时
- (void)tap {
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    self.view.frame = rect;
    [UIView commitAnimations];
    [self.view endEditing:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)aNotification {
    NSDictionary *userInfo = [aNotification userInfo];
    CGRect keyboardRect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect newFrame = self.view.frame;
    newFrame.size.height -= keyboardRect.size.height;
    [UIView beginAnimations:@"ResizeTextView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = newFrame;
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)aNotification {
    NSDictionary *userInfo = [aNotification userInfo];
    CGRect keyboardRect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect newFrame = self.view.frame;
    newFrame.size.height += keyboardRect.size.height;
    [UIView beginAnimations:@"ResizeTextView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = newFrame;
    [UIView commitAnimations];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

// 重写firstLabel的getter方法
- (UILabel *)firstLabel {
    // 必须先判断_firstLabel这个实力对象是否存在，若没有，则进行实例化
    if (!_firstLabel) {
        _firstLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 100, 300, 30)];
        [_firstLabel setTextAlignment:NSTextAlignmentCenter];
        // 在这个getter方法中，切不可使用self.firstLabel，这是因为self.firstLabel本身就是在调用getter方法，这样会造成死循环
        [self.view addSubview:_firstLabel];
    }
    
    return _firstLabel;
}

//- (void)viewDidLoad {
//    [super viewDidLoad];
//
//    // (1) NSString的使用方法
//    // NSString 的赋值方法
//    NSString *myString = @"hello";
//    NSString *otherString = [myString stringByAppendingString:@"world"];
//    NSString *str = [NSString stringWithFormat:@"%d%@", 10, @"岁"];
//
//    // 判断两个字符串是否相等
//    NSString *strA = @"abc";
//    NSString *strB = [[NSString alloc] initWithString:@"abc"];
//    // strA是字符串，strB是指字符串"abc"的对象指针
//    if (strA == strB) {
//        NSLog(@"A is equal to B");
//    } else {
//        NSLog(@"A is not equal to B");
//    }
//
//    // 正确的判断两个字符串是否相等的方法
//    if ([strA isEqualToString:strB]) {    // 判断的是字符串的内容
//        NSLog(@"strA is equals to strB");
//    } else {
//        NSLog(@"strA is not equal to strB");
//    }
//
//    // (2) NSNumber的使用
//    NSNumber *charNumber = [NSNumber numberWithChar:'c'];
//    NSNumber *intNumber = [NSNumber numberWithInt:12];
//    NSNumber *floatNumber = [NSNumber numberWithFloat:10.9f];
//    NSNumber *boolNumber = [NSNumber numberWithBool:TRUE];
//
//    // 获取对象的整型值
//    int myInt = intNumber.intValue;
//
//    // 将整型添加到NSArray的方法
//    NSMutableArray *myMutableArray = [[NSMutableArray alloc] init];
//    [myMutableArray addObject:intNumber];
//
//    // (3)遍历数组中的对象
//    NSArray *myArray = @[@"a", @"b", @"c"];
//
//    // 先计算数组中有多少个对象，通过NSArray的count方法
//    for (int i = 0; i < [myArray count]; i++) {
//        // 根据数组的下标，获取到数组的对象
//        NSLog(@"for loop: %@", myArray[i]);
//    }
//
//    // 使用for-in语句遍历数组中的对象
//    for (NSString * string in myArray) {
//        NSLog(@"NSString: %@", string);
//    }
//
//    // 使用for-in语句需要注意一点，编译器并不知道数组中存在哪些类型的对象
//    for (NSString * string in myArray) {
//        // 如果数组中不完全是NSString类型的对象，在这种情况下，程序将出现闪退（Crash）
//        int value = [string integerValue];
//    }
//
//    // 在这种情况下，将采用一种更为通用的方法，j先将NSArray中的对象类型视为id类型，在对id进行操作时，
//    // 再判断对象的具体类型。
//    for (id obj in myArray) {
//        // 判断对象的类型，只有满足条件，才做处理
//        if ([obj isKindOfClass:[NSString class]]) {
//            // 对NSString类型的对象，进行方法调用
//            int value = [obj integerValue];
//        }
//    }
//
//
//
//
//}


@end
