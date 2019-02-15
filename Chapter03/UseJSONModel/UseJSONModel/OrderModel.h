//
//  OrderModel.h
//  UseJSONModel
//
//  Created by QinTuanye on 2019/2/15.
//  Copyright © 2019年 QinTuanye. All rights reserved.
//
/*
{
    "orderId": 100,
    "totalPrice": 13.45,
    "product":
    {
        "id": 123,
        "name": "Product name",
        "price": 12.95
    }
}

#import "JSONModel.h"
#import "ProductModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OrderModel : JSONModel
@property (nonatomic, assign) NSInteger orderId;
@property (nonatomic, assign) float totalPrice;
@property (nonatomic, strong) ProductModel *product;
@end

NS_ASSUME_NONNULL_END
 */

/*
{
    "orderId": 104,
    "totalPrice": 103.45,
    "products": [
                 {"id": 123, "name": "Product #1", "price": 12.95},
                 {"id": 137, "name": "Product #2", "price": 82.95}
                 ]
}
*/

#import "JSONModel.h"
#import "ProductModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OrderModel : JSONModel
@property (nonatomic, assign) NSInteger orderId;
@property (nonatomic, assign) float totalPrice;
@property (nonatomic, strong) NSArray<ProductModel *> *products;
@property (nonatomic, strong) NSString <Optional> *someKey;
@end

NS_ASSUME_NONNULL_END
