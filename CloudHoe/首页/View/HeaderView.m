//
//  HeaderView.m
//  CloudHoe
//
//  Created by ZhangWeiLiang on 2018/1/3.
//  Copyright © 2018年 ZhangWeiLiang. All rights reserved.
//

#import "HeaderView.h"

@implementation HeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"#EDEEEF"];
        
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews
{
    
    //-----------轮播-----------
    NSArray *imagesURLStrings = @[
                                  @"http://192.168.2.114/Public/Uploads/2018-01-08/20180101.jpg",
                                  @"http://192.168.2.114/Public/Uploads/2018-01-08/20180113.jpg",
                                  @"http://192.168.2.114/Public/Uploads/2018-01-08/20180111.jpg"
                                  ];
    // 网络加载 --- 创建带标题的图片轮播器
    SDCycleScrollView *cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, 120*scaleWidth) delegate:self placeholderImage:nil];
    cycleScrollView2.imageURLStringsGroup = imagesURLStrings;
    cycleScrollView2.backgroundColor = [UIColor colorWithHexString:@"#EDEEEF"];
    cycleScrollView2.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    //    cycleScrollView2.titlesGroup = titles;
    cycleScrollView2.pageControlDotSize = CGSizeMake(9, 9);
    cycleScrollView2.currentPageDotColor = [UIColor colorWithHexString:@"#0FB748"]; // 自定义分页控件小圆标颜色
    //    cycleScrollView2.pageDotColor = [UIColor whiteColor]; // 其他分页控件小圆标颜色
    [self addSubview:cycleScrollView2];
    self.cycleScrollView2 = cycleScrollView2;
    
    // 浇水
    UIButton *inBtn = [UIButton buttonWithframe:CGRectMake(0, cycleScrollView2.bottom, kScreenWidth, 70) text:@"" font:[UIFont systemFontOfSize:16] textColor:@"#FFFFFF" backgroundColor:@"#FFFFFF" normal:nil selected:nil];
    [self addSubview:inBtn];
//    [inBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _imgView1 = [UIImageView imgViewWithframe:CGRectZero icon:@""];
    _imgView1.contentMode = UIViewContentModeScaleAspectFill;
    [inBtn addSubview:_imgView1];
    _imgView1.frame = CGRectMake(15, 15, 40, 40);
    _imgView1.layer.cornerRadius = _imgView1.height/2;
    _imgView1.layer.masksToBounds = YES;
//    _imgView1.backgroundColor = [UIColor redColor];
    [_imgView1 sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"mrtx"]];

    _nameLab = [UILabel labelWithframe:CGRectZero text:@"MAX好友来浇水" font:[UIFont systemFontOfSize:16] textAlignment:NSTextAlignmentLeft textColor:@"#313131"];
    [inBtn addSubview:_nameLab];
    _nameLab.frame = CGRectMake(_imgView1.right+10, _imgView1.centerY-9, 120, 18);
    
    _timeLab = [UILabel labelWithframe:CGRectZero text:@"3个小时前" font:[UIFont systemFontOfSize:14] textAlignment:NSTextAlignmentCenter textColor:@"#999999"];
    [inBtn addSubview:_timeLab];
    _timeLab.frame = CGRectMake(_nameLab.right+10, _nameLab.centerY-7, 70, 15);
    
    UIImageView *inImg = [UIImageView imgViewWithframe:CGRectZero icon:@"Back Icon-1"];
    [inBtn addSubview:inImg];
    inImg.frame = CGRectMake(inBtn.width-8-15, 28, 8, 14);
    
    // 推荐用户
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake(55, 102);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 18;
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, inBtn.bottom+10, kScreenWidth,102) collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    //        collectionView.scrollsToTop = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    [collectionView registerClass:[UserCell2 class] forCellWithReuseIdentifier:@"cellID"];
    collectionView.contentInset = UIEdgeInsetsMake(0, 15, 0, 15);
    [self addSubview:collectionView];
    self.collectionView = collectionView;
    
    //
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, collectionView.bottom+5, kScreenWidth, 44)];
    view.backgroundColor = [UIColor whiteColor];
    [self addSubview:view];

    
    UILabel *label = [UILabel labelWithframe:CGRectZero text:@"热门动态" font:[UIFont systemFontOfSize:16] textAlignment:NSTextAlignmentCenter textColor:@"#313131"];
    label.frame = CGRectMake(15, 16, 70, 17);
    [view addSubview:label];

    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, view.height-.5, kScreenWidth, .5)];
    line.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    [view addSubview:line];
    
    self.height = view.bottom;

}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    return self.model.images.count;
    return 10;
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UserCell2 *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
//    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:self.model.images[indexPath.item]]];
    
    return cell;
    
}

@end
