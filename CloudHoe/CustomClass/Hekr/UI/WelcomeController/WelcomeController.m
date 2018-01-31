//
//  WelcomeController.m
//  HekrSDKAPP
//
//  Created by Mike on 16/1/7.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "WelcomeController.h"
#import <AVFoundation/AVFoundation.h>
#import "PlayerView.h"
#import "Tool.h"

@interface WelcomeController ()
@property (nonatomic,weak) IBOutlet UIImageView * image1;
@property (nonatomic,weak) IBOutlet UIImageView * image2;
@property (nonatomic,weak) IBOutlet UIImageView * image3;
@property (nonatomic,weak) IBOutlet UIImageView * image4;
@property (nonatomic,weak) IBOutlet UIButton * btn;
@property (nonatomic,weak) IBOutlet UIScrollView *scroll;
@property (nonatomic,weak) IBOutlet NSLayoutConstraint * btnBottom;
@property (nonatomic,retain) PlayerView *firstView;
@property (nonatomic,retain) PlayerView *secondView;
@property (nonatomic,retain) PlayerView *thirdView;
@end

@implementation WelcomeController

- (void)viewDidLoad {
    [super viewDidLoad];
//    CGSize size = [[UIScreen mainScreen] bounds].size;
//    NSString * prefix = [NSString stringWithFormat:@"%ld-%ld-",(long)size.width,(long)size.height];
//    
//#define updateImage(x) [self.image##x setImage:[UIImage imageNamed:[prefix stringByAppendingString:@#x]]]
//    updateImage(1);
//    updateImage(2);
//    updateImage(3);
//    updateImage(4);
//    
//    NSString * btnImage = (size.width <= 320) ? @"button_4inch" : @"button";
//    [self.btn setBackgroundImage:[UIImage imageNamed:btnImage] forState:UIControlStateNormal];
//    [self.btn setBackgroundImage:[UIImage imageNamed:[btnImage stringByAppendingString:@"_pressed"]] forState:UIControlStateHighlighted];
//    CGFloat fontSize = size.width <= 320 ? 16 : (size.width <= 375 ? 20 : 27);
//    [self.btn.titleLabel setFont:[UIFont systemFontOfSize:fontSize]];
//    CGFloat constant = size.height <= 480 ? 45 : (size.width <= 320 ? 90 : (size.width <= 375 ? 105 : 118));
//    self.btnBottom.constant = constant;
    
    NSString *name1;
    NSString *name2;
    NSString *name3;
    if ([lang() isEqualToString:@"en-US"]) {
        name1 = @"authorization_first_en";
        name2 = @"grouping_second_en";
        name3 = @"control_third_en";
    }else{
        name1 = @"authorization_first";
        name2 = @"grouping_second";
        name3 = @"control_third";
    }

    
    
    self.scroll.contentSize=CGSizeMake(CGRectGetWidth(self.view.frame)*3, 0);
    self.scroll.pagingEnabled=YES;
    self.firstView=[[PlayerView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) pathForResource:name1 ofType:@"mp4"];
    self.firstView.tag=1;
    [self.scroll addSubview:self.firstView];
    [self.firstView PlayerOfPlay];
    
    self.secondView=[[PlayerView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame), 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) pathForResource:name2 ofType:@"mp4"];
    self.secondView.tag=2;
    [self.scroll addSubview:self.secondView];
    
    self.thirdView=[[PlayerView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)*2, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) pathForResource:name3 ofType:@"mp4"];
    self.thirdView.tag=3;
    [self.scroll addSubview:self.thirdView];
    
    UIButton *btn_go=[[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame)-150, CGRectGetWidth(self.view.frame), 150)];
    [btn_go addTarget:self action:@selector(onDone:) forControlEvents:UIControlEventTouchUpInside];
    [self.thirdView addSubview:btn_go];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UploadWillPlayer) name:@"UploadWillPlayer" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)UploadWillPlayer
{
    float width=[UIScreen mainScreen].bounds.size.width;
    if (_scroll.contentOffset.x/width==0) {
        [self.firstView PlayerOfPlay];
    }
    else if (_scroll.contentOffset.x/width==1)
    {
        [self.secondView PlayerOfPlay];
    }
    else if (_scroll.contentOffset.x/width==2)
    {
        [self.thirdView PlayerOfPlay];
    }
}

-(IBAction) onDone:(id)sender{
    
    if ([self.thirdView PlayerOfstate]) {
        self.onDone();
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    float width=[UIScreen mainScreen].bounds.size.width;
    if (scrollView.contentOffset.x/width==0) {
        [self.firstView PlayerOfPlay];
    }
    else if (scrollView.contentOffset.x/width==1)
    {
        [self.secondView PlayerOfPlay];
    }
    else if (scrollView.contentOffset.x/width==2)
    {
        [self.thirdView PlayerOfPlay];
    }
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
