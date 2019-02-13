//
//  ViewController.m
//  KVO
//
//  Created by QinTuanye on 2019/1/29.
//  Copyright © 2019年 QinTuanye. All rights reserved.
//

#import "SceneAViewController.h"
#import "SceneBViewController.h"

@interface SceneAViewController ()
// 声明一个属性变量，用来获取viewControllerB
@property (nonatomic, strong) SceneBViewController *vcB;
@property (weak, nonatomic) IBOutlet UILabel *showInformation;
@end

@implementation SceneAViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SceneBViewController"]) {
        self.vcB = segue.destinationViewController;
        [self.vcB addObserver:self forKeyPath:@"textValue" options:NSKeyValueObservingOptionNew context:nil];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
//    if ([keyPath isEqualToString:NSStringFromSelector(@selector(isFinished))]) {
//        if ([object isFinished]) {
//            @try {
//                [object removeObserver:self forKeyPath:NSStringFromSelector(@selector(isFinished))];
//            } @catch (NSException * __unused exception) {}
//        }
//    }
    
    self.showInformation.text = [self.vcB valueForKey:@"textValue"];
    NSLog(@"keyPath: %@, observe: %@", keyPath, change);
    // 移除观察者，这个观察者是self，也就是ViewControllerA
    @try {
        [self.vcB removeObserver:self forKeyPath:@"textValue"];
        self.vcB = nil;
    } @catch (NSException *exception) {
        NSLog(@"remove Observer error: %@", exception.debugDescription);
    }
}


@end
