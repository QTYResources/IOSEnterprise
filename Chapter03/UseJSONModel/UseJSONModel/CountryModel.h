//
//  CountryModel.h
//  UseJSONModel
//
//  Created by QinTuanye on 2019/2/14.
//  Copyright © 2019年 QinTuanye. All rights reserved.
//

// CountryModel.h
#import "JSONModel.h"

@interface CountryModel : JSONModel
@property (assign, nonatomic) int id;
@property (strong, nonatomic) NSString *country;
@property (strong, nonatomic) NSString <Optional> *dialCode;
@property (assign, nonatomic) BOOL isInEurope;
@end
