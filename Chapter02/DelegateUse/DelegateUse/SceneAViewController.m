//
//  ViewController.m
//  DelegateUse
//
//  Created by QinTuanye on 2019/1/29.
//  Copyright © 2019年 QinTuanye. All rights reserved.
//

#import "SceneAViewController.h"
#import "SceneBViewController.h"

@interface SceneAViewController () <SceneBViewControllerDelegate>

@end

@implementation SceneAViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Segue_ID_AB"]) {
        SceneBViewController *sceneBVC = segue.destinationViewController;
        sceneBVC.delegate = self;
        NSLog(@"identifier=>%@", segue.identifier);
    }
}

- (void)sceneBViewController:(id)sceneBVC didInputed:(NSString *)string {
    self.showInformation.text = string;
}

@end
