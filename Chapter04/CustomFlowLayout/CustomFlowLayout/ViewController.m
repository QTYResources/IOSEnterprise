//
//  ViewController.m
//  CustomFlowLayout
//
//  Created by QinTuanye on 2019/3/1.
//  Copyright © 2019年 QinTuanye. All rights reserved.
//

#import "ViewController.h"
#import "MyCollectionViewCell.h"
#import "Marco.h"

@interface ViewController () 

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *productList;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.productList = [[NSMutableArray alloc] init];
    // 在工程中，事先导入了12张大小不一的图片，图片的名称以img_0，img_1...命名
    for (int i = 0; i <= 11; i++) {
        NSString *str = [NSString stringWithFormat:@"img_%d.jpg", i];
        // 将图片加载到数组中
        [self.productList addObject:str];
    }
    WaterFlowLayout *layout = [[WaterFlowLayout alloc] init];
    layout.delegate = self;
    layout.itemCount = [self.productList count];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.collectionView.collectionViewLayout = layout;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:0.2];
    [self.collectionView registerClass:[MyCollectionViewCell class] forCellWithReuseIdentifier:@"cellid"];
}

#pragma mark -- UICollectionDataSource
// UICollectionView被选中时调用的方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"第%ld Item 被选中", indexPath.row);
}

// 返回这个UICollectionView是否可以被选择
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

// 定义展示的Section的个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

// 每个Section的Item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.productList count];
}

// 每个UICollectionView展示的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MyCollectionViewCell *cell = (MyCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellid" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    UIImage *img = [UIImage imageNamed:self.productList[indexPath.row]];
    CGSize size = [self getImgSize:img];
    // 加载图片
    cell.imageView.image = img;
    // 将imageView的frame设为图片的大小
    cell.imageView.frame = CGRectMake(0, 0, size.width, size.height);
    return cell;
}

#pragma mark -- WaterFlowLayoutDelegate
// 自定义的FlowLayoutDelegate回调方法，返回图片的Size，赋给Flow Layout
- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self getImgSize:[UIImage imageNamed:self.productList[indexPath.row]]];
}

// 根据传入的图片得到宽、高
- (CGSize)getImgSize:(UIImage *)image {
    // 将图片近同比例（宽：高）缩放
    float rate = (ITEM_WIDTH / image.size.width);
    return CGSizeMake(ITEM_WIDTH, (image.size.height * rate));
}

@end
