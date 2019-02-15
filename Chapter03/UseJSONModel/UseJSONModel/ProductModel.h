//
//  ProductModel.h
//  UseJSONModel
//
//  Created by QinTuanye on 2019/2/14.
//  Copyright © 2019年 QinTuanye. All rights reserved.
//

/*
 {
 "id": 123,
 "name": "Product name",
 "price": 12.95
 }
 */

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProductModel : JSONModel
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) float price;
@end


NS_ASSUME_NONNULL_END
