//
//  ViewController.m
//  UseJSONModel
//
//  Created by QinTuanye on 2019/2/14.
//  Copyright © 2019年 QinTuanye. All rights reserved.
//

#import "ViewController.h"
#import "CountryModel.h"

@interface ViewController ()
@property (nonatomic, strong) NSString *city_id;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *json = @"{\"id\":\"10\", \"country\":\"Germany\", \"dialCode\":49, \"isInEurope\":true}";
    NSError *err = nil;
    CountryModel *country = [[CountryModel alloc] initWithString:json error:&err];
    NSLog(@"Country model: %@", country);
}

@end
