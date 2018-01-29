//
//  GardenVC.m
//  CloudHoe
//
//  Created by ZhangWeiLiang on 2018/1/2.
//  Copyright © 2018年 ZhangWeiLiang. All rights reserved.
//

#import "GardenVC.h"
#import "PersonDynamicCell.h"
#import "RelateBotanyCell1.h"
#import "PersonDynamicVC.h"
#import "PersonBotanyVC.h"
#import "animation.h"
#import "TiaoGungView.h"
#import "GuanZhuView.h"
#import "ProfileVC.h"

@interface GardenVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray *dataArr;
@property(nonatomic,strong) UITableView *tableView;

@property(nonatomic,strong) UIView *bgView;

@property(nonatomic,strong) UIImageView *headView;
@property(nonatomic,strong) UIImageView *imgView;
@property(nonatomic,strong) UIButton *headBtn;
@property(nonatomic,strong) UILabel *nameLab;


@property(nonatomic,strong) UILabel *nengLiangLab;
@property(nonatomic,strong) UILabel *zhaoGuLab;

@property(nonatomic,strong) UIImageView *zhiWuView;
@property(nonatomic,strong) UILabel *zhiWuLab;
@property(nonatomic,strong) UIImageView *yinYingView;

@property(nonatomic,strong) UIButton *shuiBtn;
@property(nonatomic,strong) UIButton *wenduBtn;
@property(nonatomic,strong) UIButton *usbBtn;
@property(nonatomic,strong) UIButton *jiaoShuiBtn;
@property(nonatomic,strong) UIButton *LiangGuangBtn;
@property(nonatomic,strong) UIButton *gunZhuBtn;

@property(nonatomic,strong) TiaoGungView *tiaoGungView;
@property(nonatomic,strong) GuanZhuView *guanZhuView;


@end

@implementation GardenVC

- (GuanZhuView *)guanZhuView
{
    if (!_guanZhuView) {
        _guanZhuView = [[GuanZhuView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    }
    return _guanZhuView;
}

- (TiaoGungView *)tiaoGungView
{
    if (!_tiaoGungView) {
        _tiaoGungView = [[TiaoGungView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    }
    return _tiaoGungView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
//    _bgView.backgroundColor = [UIColor whiteColor];
    
    // 大图
    _imgView = [UIImageView imgViewWithframe:CGRectMake(0, 0, kScreenWidth, 375+68) icon:@"14-用户花园 copy"];
//    _imgView1.contentMode = UIViewContentModeScaleAspectFill;
    [_bgView addSubview:_imgView];
    
    // 用户头像及姓名
    _headBtn = [UIButton buttonWithframe:CGRectMake(12, 9, 110, 44) text:@"" font:[UIFont systemFontOfSize:16] textColor:@"#999999" backgroundColor:@"#9CE3DE" normal:@"" selected:nil];
    _headBtn.layer.cornerRadius = _headBtn.height/2;
    _headBtn.layer.masksToBounds = YES;
    [_bgView addSubview:_headBtn];
    //        _xiaDanBtn.tag = 0;
    [_headBtn addTarget:self action:@selector(headAction) forControlEvents:UIControlEventTouchUpInside];
    

    _headView = [UIImageView imgViewWithframe:CGRectMake(2, 2, 40, 40) icon:@""];
    _headView.layer.cornerRadius = _headView.height/2;
    _headView.layer.masksToBounds = YES;
    //    _imgView1.contentMode = UIViewContentModeScaleAspectFill;
    [_headBtn addSubview:_headView];
//    _headView.backgroundColor = [UIColor redColor];
    
    // 赵诗怡
    _nameLab = [UILabel labelWithframe:CGRectMake(_headView.right+7, _headView.centerY-11, 52, 22) text:@"" font:[UIFont boldSystemFontOfSize:16] textAlignment:NSTextAlignmentLeft textColor:@"#313131"];
    [_headBtn addSubview:_nameLab];

    
    // 能量值及照顾值
    _nengLiangLab = [UILabel labelWithframe:CGRectMake(24, _headBtn.bottom+12, 200, 16) text:@"能量值:180/2000" font:[UIFont systemFontOfSize:15] textAlignment:NSTextAlignmentLeft textColor:@"#313131"];
    [_bgView addSubview:_nengLiangLab];
    
    _zhaoGuLab = [UILabel labelWithframe:CGRectMake(_nengLiangLab.left, _nengLiangLab.bottom+8, 200, 16) text:@"照顾值:200" font:[UIFont systemFontOfSize:15] textAlignment:NSTextAlignmentLeft textColor:@"#313131"];
    [_bgView addSubview:_zhaoGuLab];
    
    // 植物
    _zhiWuView = [UIImageView imgViewWithframe:CGRectMake((kScreenWidth-120)/2, 141, 120, 120) icon:@""];
    _zhiWuView.layer.cornerRadius = _zhiWuView.height/2;
    _zhiWuView.layer.masksToBounds = YES;
    _zhiWuView.layer.borderWidth = 6;
    _zhiWuView.layer.borderColor = [UIColor colorWithHexString:@"#ffffff"].CGColor;
    //    _imgView1.contentMode = UIViewContentModeScaleAspectFill;
    [_bgView addSubview:_zhiWuView];
//    _zhiWuView.backgroundColor = [UIColor redColor];
    [_zhiWuView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"img"]];

    
    _yinYingView = [UIImageView imgViewWithframe:CGRectMake((kScreenWidth-150)/2, _zhiWuView.bottom+12, 150, 12) icon:@"Oval 14"];
    [_bgView addSubview:_yinYingView];
    
    _zhiWuLab = [UILabel labelWithframe:CGRectMake((kScreenWidth-100)/2, _yinYingView.bottom+5, 100, 26) text:@"多肉盆栽1" font:[UIFont boldSystemFontOfSize:15] textAlignment:NSTextAlignmentCenter textColor:@"#313131"];
    _zhiWuLab.backgroundColor = [UIColor colorWithHexString:@"#CCE4B8"];
    _zhiWuLab.layer.cornerRadius = _zhiWuLab.height/2;
    _zhiWuLab.layer.masksToBounds = YES;
    [_bgView addSubview:_zhiWuLab];
    
    // 按钮
    _shuiBtn = [UIButton buttonWithframe:CGRectMake(kScreenWidth-60-19, 12, 55, 60) text:@"缺水" font:[UIFont systemFontOfSize:14] textColor:@"#2D9BFB" backgroundColor:nil normal:@"" selected:nil];
    [_bgView addSubview:_shuiBtn];
    //    _evaBtn.userInteractionEnabled = NO;
    [_shuiBtn setBackgroundImage:[UIImage imageNamed:@"chushui"] forState:UIControlStateNormal];
    
    //「shift + option + 数字 8」,输出一个大一点的圆点「°」
    _wenduBtn = [UIButton buttonWithframe:CGRectMake(_shuiBtn.left, _shuiBtn.bottom+15, 55, 60) text:@"50°C" font:[UIFont systemFontOfSize:14] textColor:@"#9F3B08" backgroundColor:nil normal:@"" selected:nil];
    [_bgView addSubview:_wenduBtn];
    //    _evaBtn.userInteractionEnabled = NO;
    [_wenduBtn setBackgroundImage:[UIImage imageNamed:@"wenshi"] forState:UIControlStateNormal];

    
    _usbBtn = [UIButton buttonWithframe:CGRectMake(_shuiBtn.left, _zhiWuLab.centerY-23, 46, 46) text:@"" font:[UIFont systemFontOfSize:14] textColor:@"#999999" backgroundColor:nil normal:@"Group 29" selected:@"usb"];
    [_bgView addSubview:_usbBtn];
    //    _evaBtn.userInteractionEnabled = NO;
    
    _jiaoShuiBtn = [UIButton buttonWithframe:CGRectMake(_shuiBtn.left-10, _usbBtn.bottom+28, 73, 47) text:@"" font:[UIFont systemFontOfSize:14] textColor:@"#999999" backgroundColor:nil normal:@"jiaoshui" selected:nil];
    [_bgView addSubview:_jiaoShuiBtn];
    //    _evaBtn.userInteractionEnabled = NO;
    
    _LiangGuangBtn = [UIButton buttonWithframe:CGRectMake(_jiaoShuiBtn.left-40-37, _jiaoShuiBtn.centerY-25, 45, 50) text:@"" font:[UIFont systemFontOfSize:14] textColor:@"#999999" backgroundColor:nil normal:@"tiaoguang" selected:nil];
    [_bgView addSubview:_LiangGuangBtn];
    [_LiangGuangBtn addTarget:self action:@selector(liangGuangAction) forControlEvents:UIControlEventTouchUpInside];

    
    _gunZhuBtn = [UIButton buttonWithframe:CGRectMake(24, _jiaoShuiBtn.centerY-30, 55, 60) text:@"" font:[UIFont systemFontOfSize:14] textColor:@"#999999" backgroundColor:nil normal:@"Group 7" selected:nil];
    [_bgView addSubview:_gunZhuBtn];
    [_gunZhuBtn addTarget:self action:@selector(gunZhuAction) forControlEvents:UIControlEventTouchUpInside];

    // 最新动态
    UILabel *label = [UILabel labelWithframe:CGRectMake(15, _imgView.height-12-17, kScreenWidth-15, 17) text:@"最新动态" font:[UIFont boldSystemFontOfSize:16] textAlignment:NSTextAlignmentLeft textColor:@"#313131"];
    [_imgView addSubview:label];
    
    _bgView.height = _imgView.bottom+5;
    
    // 波纹动画
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.6 target:self selector:@selector(clickAnimation) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];

    
    _tableView = [UITableView tableViewWithframe:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kTopHeight-kTabBarHeight-32) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableHeaderView = _bgView;
    
    [self getUserInfo];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    PersonModel *model = [InfoCache unarchiveObjectWithFile:Person];
    
    [_headView sd_setImageWithURL:[NSURL URLWithString:model.headimg] placeholderImage:[UIImage imageNamed:@"mrtx"]];
    
    if (model.nikename.length == 0) {
        _nameLab.text = @"未设置";

    }
    else {
        _nameLab.text = model.nikename;
        
        CGSize size = [NSString textLength:model.nikename font:_nameLab.font];
        _nameLab.width = size.width;
        _headBtn.width = _nameLab.right+15;

    }
}

// 获取用户信息
- (void)getUserInfo
{
    
    NSMutableDictionary *paramDic=[[NSMutableDictionary  alloc]initWithCapacity:0];
    
    [AFNetworking_RequestData requestMethodPOSTUrl:GetUserInfo dic:paramDic showHUD:YES response:NO Succed:^(id responseObject) {
        
        PersonModel *model = [PersonModel yy_modelWithJSON:responseObject[@"data"]];
        [InfoCache archiveObject:model toFile:Person];
        
        [_headView sd_setImageWithURL:[NSURL URLWithString:model.headimg] placeholderImage:[UIImage imageNamed:@"mrtx"]];
        
        if (model.nikename.length == 0) {
            _nameLab.text = @"未设置";
            
        }
        else {
            _nameLab.text = model.nikename;
            
            CGSize size = [NSString textLength:model.nikename font:_nameLab.font];
            _nameLab.width = size.width;
            _headBtn.width = _nameLab.right+15;
            
        }
        
    } failure:^(NSError *error) {
        
    }];
}


-(void)clickAnimation{
    
    __block animation *andome=[[animation alloc] initWithFrame:CGRectMake(0, _zhiWuView.centerY-kScreenWidth/2, kScreenWidth, kScreenWidth)];
    andome.backgroundColor=[UIColor clearColor];
    andome.userInteractionEnabled = NO;
    [_bgView insertSubview:andome atIndex:1];

    
    // 利用时差达到波纹散发效果
    [UIView animateWithDuration:2 animations:^{
        andome.transform=CGAffineTransformScale(andome.transform, 4, 4);
        andome.alpha=0;
    } completion:^(BOOL finished) {
        [andome removeFromSuperview];
//        NSLog(@"结束动画");
    }];
    
}

- (void)gunZhuAction
{
    [[UIApplication sharedApplication].keyWindow addSubview:self.guanZhuView];

}

- (void)liangGuangAction
{

    [[UIApplication sharedApplication].keyWindow addSubview:self.tiaoGungView];
}

- (void)headAction
{
    ProfileVC *vc = [[ProfileVC alloc] init];
    vc.title = @"我的";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)moreAction:(UIButton *)btn
{
    if (btn.tag == 0) {
        PersonDynamicVC *vc = [[PersonDynamicVC alloc] init];
        vc.title = @"我的动态";
        [self.navigationController pushViewController:vc animated:YES];
    }
    else {
        PersonBotanyVC *vc = [[PersonBotanyVC alloc] init];
        vc.title = @"我的植物";
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }
    else {
        return 10;
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 175;
    }
    else {
        return 81;

    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.0001;

    }
    else {
        
        return 52;
    }
    
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
//    ReleaseJobModel *model = self.dataArr[section][0];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 52)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *label = [UILabel labelWithframe:CGRectMake(15, 0, kScreenWidth-15, 52) text:@"" font:[UIFont boldSystemFontOfSize:16] textAlignment:NSTextAlignmentLeft textColor:@"#313131"];
    [view addSubview:label];
    if (section == 0) {
    }
    else {

        label.text = @"我的植物";
    }
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 54;// 为0无效
    
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 54)];
    //    view.backgroundColor = [UIColor colorWithHexString:@"#EFEFEF"];
    UIButton *moreBtn = [UIButton buttonWithframe:CGRectMake(0, 0, kScreenWidth, view.height) text:@"查看更多植物" font:[UIFont systemFontOfSize:14] textColor:@"#6F6F6F" backgroundColor:@"#ffffff" normal:@"" selected:nil];
    [view addSubview:moreBtn];
    [moreBtn addTarget:self action:@selector(moreAction:) forControlEvents:UIControlEventTouchUpInside];
    if (section == 0) {
        [moreBtn setTitle:@"查看更多我的动态" forState:UIControlStateNormal];
        moreBtn.tag = 0;

    }
    else {
        [moreBtn setTitle:@"查看更多植物" forState:UIControlStateNormal];
        moreBtn.tag = 1;

    }
    return view;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        static NSString *cell_id = @"PersonDynamicCell";
        PersonDynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
        if (!cell) {
            cell = [[PersonDynamicCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:cell_id];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            cell.backgroundColor = [UIColor clearColor];
        }
        cell.model = nil;
        return cell;
    }
    else {
        static NSString *cell_id = @"RelateBotanyCell1";
        RelateBotanyCell1 *cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
        if (!cell) {
            cell = [[RelateBotanyCell1 alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:cell_id];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            cell.backgroundColor = [UIColor clearColor];
        }
        cell.model = nil;
        return cell;

    }

    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
