//
//  ViewController.m
//  UseBlock
//
//  Created by QinTuanye on 2019/3/4.
//  Copyright © 2019年 QinTuanye. All rights reserved.
//

#import "SceneAViewController.h"
#import "SceneBViewController.h"

@interface SceneAViewController ()

@end

@implementation SceneAViewController

- (void)viewDidLoad {
    [super viewDidLoad];

};

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"SceneBViewController"]) {
        SceneBViewController *sceneBVC = segue.destinationViewController;
        // 将scene A的Block传递给Scene B的Block属性变量
        [sceneBVC returnText:^(NSString *showText) {
            self.showInformation.text = showText;
        }];
    }
}

@end
