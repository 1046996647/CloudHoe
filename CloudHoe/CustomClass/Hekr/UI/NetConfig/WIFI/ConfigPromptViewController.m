//
//  ConfigPromptViewController.m
//  HekrSDKAPP
//
//  Created by hekr on 16/7/19.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "ConfigPromptViewController.h"
#import "Tool.h"
#import "InstrucDetailViewController.h"
#import "PromptCell.h"
#import "ReadWebViewController.h"

@interface ConfigPromptViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, copy)NSString *headerTitle;
@end

@implementation ConfigPromptViewController


- (instancetype)initWith:(NSMutableArray *)array{
    self = [super init];
    if (self) {
        _dataArray = array;
//        _headerTitle = NSLocalizedString(@"若需要使用以下设备，请向该设备已绑定用户寻求共享权限。\n若想绑定设备，请已绑定用户解除绑定后，重新绑定添加。", nil);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = getViewBackgroundColor();
    [self initNavView];
    [self createTable];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)initNavView
{
//    self.navigationController.navigationBar.barTintColor = getNavBackgroundColor();
//    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.translucent = NO;
//    UILabel *titLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width-100)/2, 0, 100, 30)];
//    titLabel.backgroundColor = [UIColor clearColor];
//    titLabel.textAlignment = NSTextAlignmentCenter;
//    titLabel.text = NSLocalizedString(@"问题详情", nil);
//    titLabel.font = [UIFont systemFontOfSize:18];
//    titLabel.textColor = getNavTitleColor();
//    self.navigationItem.titleView = titLabel;
//    
//    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:getNavPopBtnImg()] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(popClick)];
//    left.tintColor = [UIColor blackColor];
//    
//    self.navigationItem.leftBarButtonItem = left;
    
    HekrNavigationBarView *nav = [[HekrNavigationBarView alloc]initWithFrame:BarViewRectMake withTitle:@"问题详情" leftBarButtonAction:^{
        [self.navigationController popViewControllerAnimated:YES];
    } withRightTitle:nil leftBarButtonAction:nil];
    [self.view addSubview:nav];
}
- (void)popClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createTable{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, Width, Height-124)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = isNightTheme() ? [UIColor clearColor] : rgb(243, 243, 243);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    _tableView.tableHeaderView = [self createHeaderView];
    _tableView.tableFooterView = [self createFootView];
    [self.view addSubview:_tableView];
}

//- (UIView *)createHeaderView{
//    CGFloat height = [self sizeWithText:_headerTitle maxSize:CGSizeMake(Width-20, MAXFLOAT) font:[UIFont systemFontOfSize:15]].height+15;
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, height+20)];
//    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, Width - 20, height)];
//    label.text = _headerTitle;
//    label.font = [UIFont systemFontOfSize:15];
//    label.textColor = rgb(80, 80, 82);
//    label.numberOfLines = 0;
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_headerTitle];
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    
//    [paragraphStyle setLineSpacing:5];//调整行间距
//    
//    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_headerTitle length])];
//    label.attributedText = attributedString;
//    
//    [view addSubview:label];
//    view.backgroundColor = [UIColor clearColor];
//    return view;
//}

- (UIView *)createFootView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, 60)];
    UILabel *label = [self createPromptLabel:CGRectMake(0, 20, Width, 20) withStr:@"查看配网问题帮助" withFont:[UIFont systemFontOfSize:16]];
    [view addSubview:label];
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showFAQ)];
    [label addGestureRecognizer:tgr];
    view.backgroundColor = [UIColor clearColor];
//    view.backgroundColor = [UIColor redColor];
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PromptCell *cell = [tableView dequeueReusableCellWithIdentifier:@"promptCell"];
    if (cell == nil) {
        cell = [[PromptCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"promptCell"];
        UILabel *downLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, Vrange(160)-0.5, ScreenWidth, 0.5)];
        downLabel.backgroundColor = getCellLineColor();
        [cell.contentView addSubview:downLabel];
    }
    cell.backgroundColor = getCellBackgroundColor();
    [cell upData:_dataArray[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    CGFloat height = [self sizeWithText:_headerTitle maxSize:CGSizeMake(Width-20, MAXFLOAT) font:[UIFont systemFontOfSize:15]].height;
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, height+20)];
//    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, Width - 20, height)];
//    label.text = _headerTitle;
//    label.font = [UIFont systemFontOfSize:15];
//    label.textColor = rgb(80, 80, 82);
//    label.numberOfLines = 0;
//    [view addSubview:label];
//    return view;
//}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//   
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, 60)];
//    UILabel *label = [self createPromptLabel:CGRectMake(0, 20, Width, 20) withStr:@"还有疑问？点击这里" withFont:[UIFont systemFontOfSize:15]];
//    [view addSubview:label];
//    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showFAQ)];
//    [label addGestureRecognizer:tgr];
//    return view;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Vrange(160);
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//     CGFloat height = [self sizeWithText:_headerTitle maxSize:CGSizeMake(Width-20, MAXFLOAT) font:[UIFont systemFontOfSize:15]].height + 20;
//    return height;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 60;
//}

- (void)showFAQ{
    
//    InstrucDetailViewController *detailView = [[InstrucDetailViewController alloc]initWithTitle:NSLocalizedString(@"配网问题帮助", nil) Number:4];
//    [self.navigationController pushViewController:detailView animated:YES];
//
//            http://app.hekr.me/FAQ/issue.html?lang=①&theme=②
//            ①：en-US--英文
//               zh-CN--中文
//            ②：0--夜间主题
//               1--蓝色主题
//               2--米黄色主题
//               3--绿色主题
    NSString *themeStr = [NSString stringWithFormat:@"%lu",(unsigned long)getThemeCode()];
    NSString *url = [NSString stringWithFormat:@"http://app.hekr.me/FAQ/issue.html?lang=%@&theme=%@",lang(),themeStr];
//    if ([lang() isEqualToString:@"en-US"]) {
//        url = @"http://app.hekr.me/FAQ/configIssue.html";
//    }else{
//        url = @"http://app.hekr.me/FAQ/configIssue-CH.html";
//    }
    ReadWebViewController *readWebVC = [[ReadWebViewController alloc] initWithTitle:NSLocalizedString(@"配网问题帮助", nil) url:url];
    [self.navigationController pushViewController:readWebVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 提示Label
- (UILabel *)createPromptLabel:(CGRect)rect withStr:(NSString *)str withFont:(UIFont *)font{
    UILabel *label = nil;
    label = [[UILabel alloc]initWithFrame:rect];
    label.text = NSLocalizedString(str,nil);
    label.font = font;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = getDescriptiveTextColor();
    label.userInteractionEnabled = YES;
    CGSize size = [self sizeWithText:NSLocalizedString(str,nil) maxSize:CGSizeMake(MAXFLOAT, rect.size.height) font:font];
    UILabel *downLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, size.width, 0.5)];
    downLabel.center = CGPointMake(rect.size.width/2, CGRectGetHeight(rect)-0.5);
    downLabel.backgroundColor = getCellLineColor();
    [label addSubview:downLabel];
    return label;
}


#pragma mark - 字体工具

- (CGSize)sizeWithText:(NSString *)text maxSize:(CGSize)maxSize font:(UIFont *)font{
    
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
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
