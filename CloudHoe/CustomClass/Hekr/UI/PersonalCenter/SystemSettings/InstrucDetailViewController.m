//
//  InstrucDetailViewController.m
//  HekrSDKAPP
//
//  Created by hekr on 16/4/19.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "InstrucDetailViewController.h"
#import "EasyMacro.h"
#import "Tool.h"
//#define rgb(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1]
//#define Width                     [UIScreen mainScreen].bounds.size.width
//#define Height                    [UIScreen mainScreen].bounds.size.height
//#define Hrange(x)  (x/750.0)*Width
//#define Vrange(x)  (x/1334.0)*Height
@interface InstrucDetailViewController ()

@property (strong, nonatomic) NSArray *leadArray;
@end

@implementation InstrucDetailViewController
{
    NSString *_title;
    NSInteger _number;
    UITextView *_textView;
}
- (instancetype)initWithTitle:(NSString *)title Number:(NSInteger)number{
    if (self = [super init]) {
        _title = title;
        _number = number;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)initNavView
{
//    self.automaticallyAdjustsScrollViewInsets = YES;
//    self.navigationController.navigationBar.barTintColor = getNavBackgroundColor();
//    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.translucent = NO;
//    UILabel *titLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width-70)/2, 0, 30, 30)];
//    titLabel.backgroundColor = [UIColor clearColor];
//    titLabel.textAlignment = NSTextAlignmentCenter;
//    titLabel.text = _title;
//    titLabel.font = [UIFont systemFontOfSize:18];
//    titLabel.textColor = getNavTitleColor();
//    self.navigationItem.titleView = titLabel;
//    
//    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:getNavPopBtnImg()] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(popClick)];
//    left.tintColor = [UIColor blackColor];
//    
//    self.navigationItem.leftBarButtonItem = left;
    
    HekrNavigationBarView *nav = [[HekrNavigationBarView alloc]initWithFrame:BarViewRectMake withTitle:_title leftBarButtonAction:^{
        [self.navigationController popViewControllerAnimated:YES];
    } withRightTitle:nil leftBarButtonAction:nil];
    [self.view addSubview:nav];
}

- (void)popClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = getViewBackgroundColor();
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *file = [bundle pathForResource:@"Text" ofType:@"plist"];
    
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:file];
    self.leadArray = [dict objectForKey:@"operate"];
    [self initNavView];
    [self createView];
}

- (void)createView{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, 1)];
    label.backgroundColor = rgb(218, 219, 220);
    [self.view addSubview:label];
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(Hrange(15), Hrange(15)+64, ScreenWidth-2*Hrange(15), ScreenHeight-64-Hrange(15))];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;// 字体的行间距
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16],
                                 NSParagraphStyleAttributeName:paragraphStyle};
    _textView.attributedText = [[NSAttributedString alloc] initWithString:NSLocalizedString([self.leadArray[_number]stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"], nil)  attributes:attributes];
    _textView.showsVerticalScrollIndicator = NO;
    _textView.textColor = getDescriptiveTextColor();
    _textView.backgroundColor = [UIColor clearColor];
    _textView.editable = NO;
    [self.view addSubview:_textView];
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
