//
//  SceneBViewController.h
//  DelegateUse
//
//  Created by QinTuanye on 2019/1/29.
//  Copyright © 2019年 QinTuanye. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SceneBViewController;

@protocol SceneBViewControllerDelegate <NSObject>

- (void)sceneBViewController:(SceneBViewController *)sceneBVC didInputed:(NSString *)string;

@end

@interface SceneBViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *inputInformation;
@property (weak, nonatomic) id<SceneBViewControllerDelegate> delegate;
@end
