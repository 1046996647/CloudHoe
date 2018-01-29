
//
//  ReplyVC.m
//  CloudHoe
//
//  Created by ZhangWeiLiang on 2018/1/25.
//  Copyright © 2018年 ZhangWeiLiang. All rights reserved.
//

#import "ReplyVC.h"
#import "ChatKeyBoard.h"
#import "MoreItem.h"
#import "ChatToolBarItem.h"
#import "FaceSourceManager.h"
#import "ReplyCell.h"
#import "UILabel+WLAttributedString.h"

@interface ReplyVC ()<UITableViewDelegate,UITableViewDataSource,ChatKeyBoardDelegate, ChatKeyBoardDataSource>
//@interface ReplyVC ()<ChatKeyBoardDelegate, ChatKeyBoardDataSource>


@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property(nonatomic,assign) NSInteger pageNO;
@property (nonatomic,assign) BOOL isRefresh;
@property (nonatomic, strong) NSMutableArray *zanArr;
@property(nonatomic,strong) UIView *bgView;

// 动态
@property(nonatomic,strong) UIImageView *imgView1;
@property(nonatomic,strong) UIImageView *imgView2;
@property(nonatomic,strong) UILabel *contentLab;
@property(nonatomic,strong) UILabel *nameLab;
@property(nonatomic,strong) UILabel *timeLab;
@property(nonatomic,strong) UIButton *stateBtn;
@property(nonatomic,strong) UIButton *evaBtn;
@property(nonatomic,strong) UIButton *likeBtn;

// 点赞
@property(nonatomic,strong) UIButton *likeBtn1;
@property(nonatomic,strong) UILabel *likeLab;
@property(nonatomic,strong) UICollectionView *collectionView;

// 评论
@property(nonatomic,strong) UIButton *evaBtn1;
@property(nonatomic,strong) UILabel *evaLab;

/** 聊天键盘 */
@property (nonatomic, strong) ChatKeyBoard *chatKeyBoard;

@property (nonatomic, assign) NSInteger type;
@property(nonatomic,strong) EvaluateModel *evaluateModel1;


@end

@implementation ReplyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initSubviews];
    
    self.chatKeyBoard = [ChatKeyBoard keyBoard];
//    self.chatKeyBoard = [ChatKeyBoard keyBoardWithNavgationBarTranslucent:NO];
    self.chatKeyBoard.delegate = self;
    self.chatKeyBoard.dataSource = self;
    self.chatKeyBoard.keyBoardStyle = KeyBoardStyleComment;
    
//    self.chatKeyBoard.placeHolder = @"评论";
    [self.view addSubview:self.chatKeyBoard];
    
    self.chatKeyBoard.allowVoice = NO;
    self.chatKeyBoard.allowFace = NO;
    self.chatKeyBoard.allowMore = NO;
    
    // 评论视图
    UIView *commentView = [[UIView alloc] initWithFrame:CGRectMake(0, _tableView.bottom, kScreenWidth, 49)];
    commentView.backgroundColor = [UIColor colorWithHexString:@"#E7E7E7"];
    [self.view addSubview:commentView];
    
    //    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, -0.5, kScreenWidth, .5)];
    //    line.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    //    [commentView addSubview:line];
    
    UIButton *commentBtn = [UIButton buttonWithframe:CGRectMake(10, 5, kScreenWidth-20, commentView.height-10) text:@"  回复评论" font:[UIFont systemFontOfSize:16] textColor:@"#999999" backgroundColor:@"#FFFFFF" normal:nil selected:nil];
    [commentView addSubview:commentBtn];
    commentBtn.layer.cornerRadius = 6;
    commentBtn.layer.masksToBounds = YES;
    commentBtn.layer.borderWidth = .5;
    commentBtn.layer.borderColor = [UIColor grayColor].CGColor;
    commentBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [commentBtn addTarget:self action:@selector(commentAction) forControlEvents:UIControlEventTouchUpInside];
    
    // 上拉刷新
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        if (self.dataArr.count > 0) {
            
            [self getComdetails];
        }
        
    }];
    
    
    self.pageNO = 1;
    self.dataArr = [NSMutableArray array];
}

- (void)commentAction
{
    self.type = 0;
    self.chatKeyBoard.placeHolder = [NSString stringWithFormat:@"回复:%@",self.evaluateModel.nikename];
    [self.chatKeyBoard keyboardUpforComment];
}

- (void)initSubviews
{
    _bgView = [[UIView alloc] initWithFrame:CGRectZero];
    _bgView.backgroundColor = [UIColor whiteColor];
    
    // 动态
    _imgView1 = [UIImageView imgViewWithframe:CGRectZero icon:@""];
    _imgView1.contentMode = UIViewContentModeScaleAspectFill;
    [_bgView addSubview:_imgView1];
    //    _imgView1.backgroundColor = [UIColor redColor];
    
//    _imgView2 = [UIImageView imgViewWithframe:CGRectZero icon:@""];
//    _imgView2.contentMode = UIViewContentModeScaleAspectFill;
//    [_bgView addSubview:_imgView2];
    //    _imgView2.backgroundColor = [UIColor redColor];
    
    
    _nameLab = [UILabel labelWithframe:CGRectZero text:@"MHYTFY(多肉盆栽1)" font:[UIFont systemFontOfSize:16] textAlignment:NSTextAlignmentLeft textColor:@"#313131"];
    [_bgView addSubview:_nameLab];
    [_nameLab wl_changeColorWithTextColor:[UIColor colorWithHexString:@"#999999"] changeText:@"(多肉盆栽1)"];
    
    
    _contentLab = [UILabel labelWithframe:CGRectZero text:@"今天天气好好，拍一张彩虹花盆，美美哒！" font:[UIFont systemFontOfSize:16] textAlignment:NSTextAlignmentLeft textColor:@"#313131"];
    [_bgView addSubview:_contentLab];
    _contentLab.numberOfLines = 0;
    
    _timeLab = [UILabel labelWithframe:CGRectZero text:@"3个小时前" font:[UIFont systemFontOfSize:14] textAlignment:NSTextAlignmentRight textColor:@"#999999"];
    [_bgView addSubview:_timeLab];
    

    _imgView1.frame = CGRectMake(15, 20, 55, 55);
    _imgView1.layer.cornerRadius = _imgView1.height/2;
    _imgView1.layer.masksToBounds = YES;

    _timeLab.frame = CGRectMake(kScreenWidth-120-15, 42, 120, 15);

    _nameLab.frame = CGRectMake(_imgView1.right+10, _imgView1.centerY-9, _timeLab.left-(_imgView1.right+10)-10, 18);
    _contentLab.frame = CGRectMake(_nameLab.left, _imgView1.bottom, kScreenWidth-_nameLab.left-15, 18);
    

    
    [_imgView1 sd_setImageWithURL:[NSURL URLWithString:self.model1.headimg] placeholderImage:[UIImage imageNamed:@"mrtx"]];
    _nameLab.text = self.evaluateModel.nikename;
    _contentLab.text = self.evaluateModel.comment;
    _timeLab.text = self.evaluateModel.time;

    
    // 评论
    _evaBtn1 = [UIButton buttonWithframe:CGRectMake(kScreenWidth-60-15, _contentLab.bottom+12, 60, 20) text:@"评论" font:[UIFont systemFontOfSize:14] textColor:@"#999999" backgroundColor:nil normal:@"评论" selected:nil];
    [_bgView addSubview:_evaBtn1];
    //    _evaBtn1.tag = 1;
    //    [_evaBtn1 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    _evaBtn1.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    
    _bgView.frame = CGRectMake(0, 0, kScreenWidth, _evaBtn1.bottom+17);
    
    _tableView = [UITableView tableViewWithframe:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kTopHeight-49) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    //    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableHeaderView = _bgView;
//    _tableView.backgroundColor = [UIColor redColor];

    
    [self getComdetails];
}

// 评论详情页
- (void)getComdetails
{
    
    if (!self.isRefresh) {
        [SVProgressHUD show];
        
    }
    
    NSMutableDictionary  *paramDic=[[NSMutableDictionary  alloc]initWithCapacity:0];
    
    [paramDic  setValue:self.model1.logid forKey:@"logid"];
    [paramDic  setValue:self.evaluateModel.comid forKey:@"comid"];
    [paramDic  setValue:@(self.pageNO) forKey:@"start"];


    [AFNetworking_RequestData requestMethodPOSTUrl:Comdetails dic:paramDic showHUD:NO response:NO Succed:^(id responseObject) {
        
        self.isRefresh = YES;
        [SVProgressHUD dismiss];
        //        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        NSMutableArray *arrM = [NSMutableArray array];
        id obj = responseObject[@"data"];
        if ([obj isKindOfClass:[NSArray class]] && [obj count]) {

            for (NSDictionary *dic in obj) {
                EvaluateModel *model = [EvaluateModel yy_modelWithJSON:dic];
                [arrM addObject:model];
            }
            [self.dataArr addObjectsFromArray:arrM];
            self.pageNO++;
            
            [_tableView reloadData];
            
        }
        
        else {
            
            // 拿到当前的上拉刷新控件，变为没有更多数据的状态
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
    } failure:^(NSError *error) {
        
        self.isRefresh = YES;
        [SVProgressHUD dismiss];
        //        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    }];
}

- (void)btnAction:(UIButton *)btn
{
    if (btn.tag == 0) {
        //        [self.chatKeyBoard keyboardUpforComment];
        
    }
    else {
        
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
    //    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EvaluateModel *model = self.dataArr[indexPath.row];

    return model.cellHeight;
    //    return 102;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cell_id = @"cell";
    ReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
    if (!cell) {
        cell = [[ReplyCell alloc] initWithStyle:UITableViewCellStyleDefault
                                        reuseIdentifier:cell_id];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor colorWithHexString:@"#efefef"];

    }
    EvaluateModel *model = self.dataArr[indexPath.row];

    cell.model = model;


    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    EvaluateModel *model = self.dataArr[indexPath.row];
    self.evaluateModel1 = model;
    
    self.type = 1;
    self.chatKeyBoard.placeHolder = [NSString stringWithFormat:@"回复:%@",model.nikename];
    [self.chatKeyBoard keyboardUpforComment];

}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//
//}

#pragma mark -- ChatKeyBoardDataSource
- (NSArray<MoreItem *> *)chatKeyBoardMorePanelItems
{
    MoreItem *item1 = [MoreItem moreItemWithPicName:@"sharemore_location" highLightPicName:nil itemName:@"位置"];
    MoreItem *item2 = [MoreItem moreItemWithPicName:@"sharemore_pic" highLightPicName:nil itemName:@"图片"];
    MoreItem *item3 = [MoreItem moreItemWithPicName:@"sharemore_video" highLightPicName:nil itemName:@"拍照"];
    MoreItem *item4 = [MoreItem moreItemWithPicName:@"sharemore_location" highLightPicName:nil itemName:@"位置"];
    MoreItem *item5 = [MoreItem moreItemWithPicName:@"sharemore_pic" highLightPicName:nil itemName:@"图片"];
    MoreItem *item6 = [MoreItem moreItemWithPicName:@"sharemore_video" highLightPicName:nil itemName:@"拍照"];
    MoreItem *item7 = [MoreItem moreItemWithPicName:@"sharemore_location" highLightPicName:nil itemName:@"位置"];
    MoreItem *item8 = [MoreItem moreItemWithPicName:@"sharemore_pic" highLightPicName:nil itemName:@"图片"];
    MoreItem *item9 = [MoreItem moreItemWithPicName:@"sharemore_video" highLightPicName:nil itemName:@"拍照"];
    return @[item1, item2, item3, item4, item5, item6, item7, item8, item9];
}
- (NSArray<ChatToolBarItem *> *)chatKeyBoardToolbarItems
{
    ChatToolBarItem *item1 = [ChatToolBarItem barItemWithKind:kBarItemFace normal:@"face" high:@"face_HL" select:@"keyboard"];

    ChatToolBarItem *item2 = [ChatToolBarItem barItemWithKind:kBarItemVoice normal:@"voice" high:@"voice_HL" select:@"keyboard"];

    ChatToolBarItem *item3 = [ChatToolBarItem barItemWithKind:kBarItemMore normal:@"more_ios" high:@"more_ios_HL" select:nil];

    ChatToolBarItem *item4 = [ChatToolBarItem barItemWithKind:kBarItemSwitchBar normal:@"switchDown" high:nil select:nil];

    return @[item1, item2, item3, item4];
}

- (NSArray<FaceThemeModel *> *)chatKeyBoardFacePanelSubjectItems
{
    return [FaceSourceManager loadFaceSource];
}


#pragma mark -- 发送文本
- (void)chatKeyBoardSendText:(NSString *)text
{
    //    self.sendText.text = text;

    NSMutableDictionary  *paramDic=[[NSMutableDictionary  alloc]initWithCapacity:0];

    [paramDic  setValue:self.model1.logid forKey:@"logid"];
    [paramDic  setValue:text forKey:@"comment"];
    [paramDic  setValue:self.evaluateModel.comid forKey:@"comid"];

    if (self.type == 1) {
        [paramDic  setValue:self.evaluateModel1.userId forKey:@"currentid"];
    }
    else {
        [paramDic  setValue:self.evaluateModel.userId forKey:@"currentid"];
    }

    [AFNetworking_RequestData requestMethodPOSTUrl:Comadd dic:paramDic showHUD:NO response:NO Succed:^(id responseObject) {

        EvaluateModel *model = [EvaluateModel yy_modelWithJSON:responseObject[@"data"]];
        [self.dataArr insertObject:model atIndex:0];
        [_tableView reloadData];


        [self.chatKeyBoard keyboardDownForComment];


    } failure:^(NSError *error) {

    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
