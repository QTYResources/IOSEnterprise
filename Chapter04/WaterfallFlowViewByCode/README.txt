WaterfallFlowViewByCode

使用代码创建瀑布流视图

- (void)viewDidLoad {
    [super viewDidLoad];
    // 创建一个Flow Layout对象
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    // 设置Flow Layout滚动方法为垂直方法
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    // 设置Item距离顶部、a左侧栏、底部、右侧栏的边距
    flowLayout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
    UICollectionView *collect = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    // CollectionView的Delegate和dataSource设为自身所在的ViewController, 这里的self是指ViewController
    collect.delegate = self;
    collect.dataSource = self;
    
    // 设置CollectionView的背景颜色
    collect.backgroundColor = [UIColor grayColor];
    // 设置可重用的Cell Identifier，并创建Collection View的实例对象
    [collect registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kCellId];
    // 将Collection View加载到当前的UIView之上
    [self.view addSubview:collect];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;   // Section的个数设为1
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 50;  // 每个Section（分区）共有50个Item
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(60, 60);  // Item大小设为固定的60x60（宽*高）
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // 获取已经注册的cell，并重用之
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellId forIndexPath:indexPath];
    // 为了区分Cell，把Cell的背景设为随机的颜色
    cell.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
    // Cell原本是一个正方形，通过设置圆角的大小，使其成为一个圆形
    cell.layer.cornerRadius = 30;
    return cell;
}