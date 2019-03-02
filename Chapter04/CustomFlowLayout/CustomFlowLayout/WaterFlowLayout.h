//
//  WaterFlowLayout.h
//  CustomFlowLayout
//
//  Created by QinTuanye on 2019/3/1.
//  Copyright © 2019年 QinTuanye. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WaterFlowLayoutDelegate

@required
- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface WaterFlowLayout : UICollectionViewFlowLayout
@property (nonatomic, assign) NSInteger itemCount;  // 存放Item的数量
@property (nonatomic, weak) id<WaterFlowLayoutDelegate> delegate;
@end
