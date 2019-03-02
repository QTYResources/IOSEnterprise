//
//  WaterFlowLayout.m
//  CustomFlowLayout
//
//  Created by QinTuanye on 2019/3/1.
//  Copyright © 2019年 QinTuanye. All rights reserved.
//

#import "WaterFlowLayout.h"
#import "Marco.h"

@interface WaterFlowLayout ()

@property (nonatomic, strong) NSMutableArray *attriArray;   // 存放每个Item的布局属性
@property (nonatomic, assign) CGSize contentSize;

@end

@implementation WaterFlowLayout

- (void)prepareLayout {
    [super prepareLayout];
    
    self.attriArray = [[NSMutableArray alloc] init];
    // 计算每一个Item的宽度
    float WIDTH = ITEM_WIDTH;
    
    // 定义数组保存每一列的高度，该数组用来保存每一列的总高度，这样在布局时，哪列的高度小，下一个Item就放在哪一列
    CGFloat colHight[2] = {0, 0};
    // itemCount是ViewController传进来的Item个数，通过遍历每个Item，来设置每一个Item的布局
    for (int i = 0; i < self.itemCount; i++) {
        // 通过NSIndexPath，设置每个Item的位置属性
        NSIndexPath *index = [NSIndexPath indexPathForItem:i inSection:0];
        // 通过indexPath来创建创建布局属性对象
        UICollectionViewLayoutAttributes *attris = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:index];
        // 这是一个自定义的Delegate方法，在程序运行时，这里的self.delegate会变为viewController，ViewController实现了sizeForItemAtIndexPath:方法的回调，在回调方法中，返回image size，供Flow Layout使用
        CGSize itemSize = [self.delegate sizeForItemAtIndexPath:index];
        CGFloat hight = itemSize.height;
        
        // 判断左右两列的高度，如果左列高度小，下一个Item放在左列
        if (colHight[0] <= colHight[1]) {
            // 将新的Item高度加入到总高度小的那一列
            colHight[0] = colHight[0] + hight + ITEM_EDGE;
            // 设置Item的位置
            attris.frame = CGRectMake(ITEM_EDGE, colHight[0] - hight, WIDTH, hight);
        } else {
            colHight[1] = colHight[1] + hight + ITEM_EDGE;
            attris.frame = CGRectMake(ITEM_EDGE + (ITEM_EDGE + WIDTH), colHight[1] - hight, WIDTH, hight);
        }
        [self.attriArray addObject:attris];
        self.contentSize = CGSizeMake(WIDTH, (colHight[0] > colHight[1] ? colHight[0] : colHight[1]) + ITEM_EDGE);
    }
}

// 返回我们需要的布局数组
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.attriArray;
}

- (CGSize)collectionViewContentSize {
    return self.contentSize;
}

@end
