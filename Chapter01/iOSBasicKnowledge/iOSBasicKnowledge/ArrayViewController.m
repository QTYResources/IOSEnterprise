//
//  ArrayViewController.m
//  iOSBasicKnowledge
//
//  Created by QinTuanye on 2019/1/28.
//  Copyright © 2019年 QinTuanye. All rights reserved.
//

#import "ArrayViewController.h"

// NSArray的遍历性能要高于NSMutableArray
static NSString *kCellIdentifier = @"Cell Identifier";

@interface ArrayViewController ()
// 在这里声明一个实例变量（Instance Variable)
@property(nonatomic, strong) NSArray *colorArray;    // 声明一个NSArray，而不是NSMutableArray
@property(nonatomic) NSInteger applicationIconBadgeNumber;
@end

@implementation ArrayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIUserNotificationType myType = UIUserNotificationTypeBadge;
    UIUserNotificationSettings *mySetting = [UIUserNotificationSettings settingsForTypes:myType categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySetting];
}

- (void)buttonClick
{
    // 通过sharedApplication获取该程序的UIApplication对象
    UIApplication *app = [UIApplication sharedApplication];
    app.applicationIconBadgeNumber = 1;
    NSArray *myArray = [NSArray array];
    
    NSUserDefaults * myUserDefaults = [NSUserDefaults standardUserDefaults];
    [myUserDefaults setObject:myArray forKey:@"RecentlyViewed"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
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
