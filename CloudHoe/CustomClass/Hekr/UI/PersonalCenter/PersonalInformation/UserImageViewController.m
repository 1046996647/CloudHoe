//
//  UserImageViewController.m
//  HekrSDKAPP
//
//  Created by hekr on 16/10/18.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "UserImageViewController.h"
#import "Tool.h"

@interface UserImageViewController ()
@property (nonatomic, strong)UIImage *img;
@end

@implementation UserImageViewController

- (instancetype)initWithUserImg:(UIImage *)userImage{
    if (self = [super init]) {
        _img = userImage;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Width, Width)];
    imageView.image = _img;
    imageView.center = self.view.center;
    imageView.userInteractionEnabled = YES;
    [self.view addSubview:imageView];
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disMiss)];
    [imageView addGestureRecognizer:tgr];
    // Do any additional setup after loading the view.
}

- (void)disMiss{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self disMiss];
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
