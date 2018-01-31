//
//  AboutHekrViewController.m
//  HekrSDKAPP
//
//  Created by hekr on 16/4/18.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "AboutHekrViewController.h"
#import <HekrSDK.h>
#import "AppDelegate.h"
#import "PINGViewController.h"
#import <Masonry.h>
#import "Tool.h"
//#define rgb(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1]
//#define Width                     [UIScreen mainScreen].bounds.size.width
//#define Height                    [UIScreen mainScreen].bounds.size.height
//#define Hrange(x)  (x/750.0)*Width
//#define Vrange(x)  (x/1334.0)*Height

@interface AboutHekrViewController ()

@end

@implementation AboutHekrViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = getViewBackgroundColor();
    // Do any additional setup after loading the view.
    [self initNavView];
    //    [self createViews];
    [self createView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //    [MobClick beginLogPageView:@"AboutHekr"];
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //    [MobClick endLogPageView:@"AboutHekr"];
    //    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)initNavView
{
//    self.automaticallyAdjustsScrollViewInsets = YES;
//    self.navigationController.navigationBar.barTintColor = getNavBackgroundColor();
//    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
//    label.backgroundColor = getCellLineColor();
//    [self.view addSubview:label];
//    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.translucent = NO;
//    UILabel *titLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width-100)/2, 0, 100, 30)];
//    titLabel.backgroundColor = [UIColor clearColor];
//    titLabel.textAlignment = NSTextAlignmentCenter;
//    titLabel.text = NSLocalizedString(@"关于我们", nil);
//    titLabel.font = [UIFont systemFontOfSize:18];
//    titLabel.textColor = getNavTitleColor();
//    self.navigationItem.titleView = titLabel;
//    
//    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:getNavPopBtnImg()] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(popClick)];
//    left.tintColor = [UIColor blackColor];
//    
//    self.navigationItem.leftBarButtonItem = left;
    
    HekrNavigationBarView *nav = [[HekrNavigationBarView alloc]initWithFrame:BarViewRectMake withTitle:@"关于我们" leftBarButtonAction:^{
        [self.navigationController popViewControllerAnimated:YES];
    } withRightTitle:nil leftBarButtonAction:nil];
    [self.view addSubview:nav];
}

- (void)createView{
    UIFont *font1;
    
    if (ScreenHeight >= 736) {
        font1 = [UIFont systemFontOfSize:16];
    }else if (ScreenHeight >= 667){
        font1 = [UIFont systemFontOfSize:15];
    }else if (ScreenHeight >= 568){
        font1 = [UIFont systemFontOfSize:13];
    }else if (ScreenHeight >= 480){
        font1 = [UIFont systemFontOfSize:12];
    }else{
        font1 = [UIFont systemFontOfSize:12];
    }
    
    
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Hrange(230), Hrange(230))];
    img.center = CGPointMake(ScreenWidth/2, Vrange(104)+img.frame.size.height/2+StatusBarAndNavBarHeight);
    img.image = [UIImage imageNamed:@"wisen_icon"];
    img.userInteractionEnabled = YES;
    img.layer.cornerRadius = 5;
    img.layer.masksToBounds = YES;
    [self.view addSubview:img];
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showNet)];
    [tgr setNumberOfTapsRequired:5];
    [img addGestureRecognizer:tgr];
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *file = [bundle pathForResource:@"Text" ofType:@"plist"];
    
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:file];
    
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(Hrange(84), CGRectGetMaxY(img.frame)+Vrange(114), ScreenWidth-Hrange(84)*2, self.view.frame.size.height-Hrange(230)-Vrange(220)-StatusBarAndNavBarHeight)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;// 字体的行间距
    
    NSDictionary *attributes = @{NSFontAttributeName:font1,
                                 NSParagraphStyleAttributeName:paragraphStyle};
    
    textView.attributedText = [[NSAttributedString alloc] initWithString:NSLocalizedString([dict[@"about"] stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"], nil) attributes:attributes];
    textView.showsVerticalScrollIndicator = NO;
    textView.textColor = getDescriptiveTextColor();
    textView.backgroundColor = [UIColor clearColor];
    textView.editable = NO;
    [self.view addSubview:textView];
    
    
    UILabel * versionLabel = [UILabel new];
    versionLabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"丛云", nil),[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];//NSLocalizedString(@"丛云 V1.4.1", nil);
    versionLabel.textColor = getDescriptiveTextColor();
    versionLabel.textAlignment = NSTextAlignmentCenter;
    versionLabel.font = font1;
    [self.view addSubview:versionLabel];
    
    UILabel * buildLabel = [UILabel new];
    buildLabel.text = [NSString stringWithFormat:@"Build: %@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
    buildLabel.textColor = getDescriptiveTextColor();
    buildLabel.textAlignment = NSTextAlignmentCenter;
    buildLabel.font = font1;
    [self.view addSubview:buildLabel];
    WS(weakSelf);
    [buildLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-10);
        make.left.equalTo(weakSelf.view.mas_left);
        make.size.mas_equalTo(CGSizeMake(Width, 16));
    }];
    
    [versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(buildLabel.mas_top);
        make.left.equalTo(weakSelf.view.mas_left);
        make.size.mas_equalTo(CGSizeMake(Width, 16));
    }];
    
    
}

- (void)showNet{
    [self.navigationController pushViewController:[PINGViewController new] animated:YES];
}



- (void)popClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGSize)sizeWithText:(NSString *)text maxSize:(CGSize)maxSize font:(UIFont *)font{
    
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
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
