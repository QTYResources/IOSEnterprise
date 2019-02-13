//
//  ViewController.m
//  NotificationUse
//
//  Created by QinTuanye on 2019/2/13.
//  Copyright © 2019年 QinTuanye. All rights reserved.
//

#import "SceneAViewController.h"

@interface SceneAViewController ()
@property (weak, nonatomic) IBOutlet UILabel *showInformation;

@end

@implementation SceneAViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotification:) name:@"myNotification" object:nil];
}

- (void)getNotification:(NSNotification *)text {
    NSLog(@"getNotification...");
    self.showInformation.text = text.userInfo[@"value"];
}

- (void)dealloc {
    NSLog(@"dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"myNotification" object:nil];
}

@end
