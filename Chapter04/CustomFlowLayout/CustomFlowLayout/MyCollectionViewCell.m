//
//  MyCollectionViewCell.m
//  CustomFlowLayout
//
//  Created by QinTuanye on 2019/3/2.
//  Copyright © 2019年 QinTuanye. All rights reserved.
//

#import "MyCollectionViewCell.h"

@implementation MyCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] init];
        [self addSubview:self.imageView];
    }
    return self;
}

@end
