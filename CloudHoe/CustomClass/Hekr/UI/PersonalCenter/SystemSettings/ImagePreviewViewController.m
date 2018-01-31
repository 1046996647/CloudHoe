//
//  ImagePreviewViewController.m
//  HekrSDKAPP
//
//  Created by hekr on 16/7/14.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "ImagePreviewViewController.h"
#import "Tool.h"

@interface ImagePreviewViewController ()<UIScrollViewDelegate, UIActionSheetDelegate>
@property (nonatomic, strong)NSMutableArray *imageNameArray;
@property (nonatomic, assign)NSInteger count;
@property (nonatomic, strong)UIScrollView *imageScrollView;
@property (nonatomic, strong)UILabel *titLabel;
@property (nonatomic, strong)NSMutableArray *scrollImgArray;
@end

@implementation ImagePreviewViewController

- (instancetype)initWithImage:(NSMutableArray *)imageArray selectCount:(NSInteger)count{
    self = [super init];
    if (self) {
        _imageNameArray = imageArray;
        _count = count;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _scrollImgArray = [NSMutableArray new];
    [self initNavView];
    [self createScrollView];
}

- (void)initNavView
{
//    self.automaticallyAdjustsScrollViewInsets = YES;
//    self.navigationController.navigationBar.barTintColor = getNavBackgroundColor();
//    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.translucent = NO;
//    _titLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width-100)/2, 0, 100, 30)];
//    _titLabel.backgroundColor = [UIColor clearColor];
//    _titLabel.textAlignment = NSTextAlignmentCenter;
//    _titLabel.text = [NSString stringWithFormat:@"%ld/%ld",_count+1,_imageNameArray.count];
//    _titLabel.font = [UIFont systemFontOfSize:18];
//    _titLabel.textColor = getNavTitleColor();
//    self.navigationItem.titleView = _titLabel;
//    
//    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:getNavPopBtnImg()] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(popClick)];
//    left.tintColor = [UIColor blackColor];
//    self.navigationItem.leftBarButtonItem = left;
//    
//    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"删除", nil) style:UIBarButtonItemStylePlain target:self action:@selector(imageWillDelete)];
//    right.tintColor = [UIColor blackColor];
//    self.navigationItem.rightBarButtonItem = right;
    
    HekrNavigationBarView *nav = [[HekrNavigationBarView alloc]initWithFrame:BarViewRectMake withTitle:@"修改绑定" leftBarButtonAction:^{
        [self.navigationController popViewControllerAnimated:YES];
    } withRightTitle:@"删除" leftBarButtonAction:^{
        [self imageWillDelete];
    }];
    [self.view addSubview:nav];
}

- (void)popClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)imageWillDelete{
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:NSLocalizedString(@"要删除这张图片吗？", nil) delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"删除", nil),NSLocalizedString(@"取消", nil), nil];
    [sheet showInView:self.view];
    
}

- (void)createScrollView{
    _imageScrollView = [[UIScrollView alloc]initWithFrame:CoverViewRectMake];
    _imageScrollView.delegate = self;
    _imageScrollView.contentSize = CGSizeMake(Width * _imageNameArray.count, Height-StatusBarAndNavBarHeight);
    _imageScrollView.contentOffset = CGPointMake(Width * _count, 0);
    _imageScrollView.pagingEnabled = YES;
    for (int i = 0; i < _imageNameArray.count; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(Width * i, 0, Width, Height)];
        imageView.image = _imageNameArray[i];
        imageView.tag = 1015 + i;
        [_imageScrollView addSubview:imageView];
        [_scrollImgArray addObject:imageView];
    }
    [self.view addSubview:_imageScrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGPoint point = scrollView.contentOffset;
    _count = point.x / Width;
    _titLabel.text = [NSString stringWithFormat:@"%ld/%ld",_count+1,_imageNameArray.count];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self.delegata deleteImage];
        [_imageNameArray removeObjectAtIndex:_count];
        if (_imageNameArray.count == 0) {
            [self popClick];
            return;
        }
        UIImageView *image = _scrollImgArray[_count];
        [image removeFromSuperview];
        [_scrollImgArray removeObjectAtIndex:_count];
        
        CGSize size = _imageScrollView.contentSize;
        CGPoint point = _imageScrollView.contentOffset;
        _imageScrollView.contentSize = CGSizeMake(size.width - Width, Height);
        if (_count == _imageNameArray.count) {
            [_imageScrollView setContentOffset:CGPointMake(point.x - Width, 0)];
            _titLabel.text = [NSString stringWithFormat:@"%ld/%ld",_imageNameArray.count,_imageNameArray.count];
            _count --;
            return;
        }
        for (NSInteger i = _count; i < _imageNameArray.count; i++) {
            UIImageView *img = _scrollImgArray[i];
            CGRect rect = img.frame;
            img.frame = CGRectMake(rect.origin.x - Width, 0, Width, Height);
        }
        _titLabel.text = [NSString stringWithFormat:@"%ld/%ld",_count+1,_imageNameArray.count];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
