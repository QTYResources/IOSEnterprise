//
//  ViewController.m
//  SharedInstance
//
//  Created by QinTuanye on 2019/1/29.
//  Copyright © 2019年 QinTuanye. All rights reserved.
//

#import "ViewControllerA.h"
#import "MySharedInstance.h"

@interface ViewControllerA ()
@property(weak, nonatomic) IBOutlet UILabel *showInformation;
@end

@implementation ViewControllerA

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 获取单例实例
    MySharedInstance *myInstance = [MySharedInstance sharedInstance];
    // 将单例中的属性变量（stringPassed）赋给A中的UILabel
    self.showInformation.text = myInstance.stringPassed;
}
@end
