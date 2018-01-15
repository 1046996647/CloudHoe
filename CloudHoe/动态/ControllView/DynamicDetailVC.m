//
//  DynamicDetailVC.m
//  CloudHoe
//
//  Created by ZhangWeiLiang on 2018/1/4.
//  Copyright © 2018年 ZhangWeiLiang. All rights reserved.
//

#import "DynamicDetailVC.h"
#import "DynamicDetailCell.h"
#import "UserCell.h"
#import "RelateBotanyVC.h"
#import "UILabel+WLAttributedString.h"

#import "ChatKeyBoard.h"
#import "MoreItem.h"
#import "ChatToolBarItem.h"
#import "FaceSourceManager.h"


@interface DynamicDetailVC ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,ChatKeyBoardDelegate, ChatKeyBoardDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
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

@end

@implementation DynamicDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initSubviews];
    
//    self.chatKeyBoard = [ChatKeyBoard keyBoard];
    self.chatKeyBoard = [ChatKeyBoard keyBoardWithNavgationBarTranslucent:NO];
    self.chatKeyBoard.delegate = self;
    self.chatKeyBoard.dataSource = self;
//    self.chatKeyBoard.keyBoardStyle = KeyBoardStyleComment;

    self.chatKeyBoard.placeHolder = @"评论";
    [self.view addSubview:self.chatKeyBoard];
    
    self.chatKeyBoard.allowVoice = NO;
    self.chatKeyBoard.allowFace = NO;
    self.chatKeyBoard.allowMore = NO;
    
    [self getComment];

}

// 日志点赞
- (void)clike
{
    
    NSMutableDictionary  *paramDic=[[NSMutableDictionary  alloc]initWithCapacity:0];
    
    [paramDic  setValue:self.model1.logid forKey:@"logid"];
    
    [AFNetworking_RequestData requestMethodPOSTUrl:Clike dic:paramDic showHUD:NO response:NO Succed:^(id responseObject) {
        
        if (self.model1.zanstas.integerValue == 1) {// 已赞
            
            self.model1.zanstas = @"0";
            _likeBtn.selected = NO;
            self.model1.zannum = [NSString stringWithFormat:@"%ld",(self.model1.zannum.integerValue-1)];
            
            NSString *userid = [InfoCache unarchiveObjectWithFile:@"userId"];
            for (Zanuser *model in self.zanArr) {
                if ([model.userId isEqualToString:userid]) {
                    [self.zanArr removeObject:model];
                }
            }

        }
        else {
            self.model1.zanstas = @"1";
            _likeBtn.selected = YES;
            self.model1.zannum = [NSString stringWithFormat:@"%ld",(self.model1.zannum.integerValue+1)];
            Zanuser *model = [Zanuser yy_modelWithJSON:responseObject[@"data"]];
            [self.zanArr addObject:model];
        }
        self.model1.zanuser = self.zanArr;
        [_likeBtn setTitle:self.model1.zannum forState:UIControlStateNormal];
        _likeLab.text = [NSString stringWithFormat:@"(%@)",self.model1.zannum];
        [self.collectionView reloadData];


        
    } failure:^(NSError *error) {
        
    }];
}

// 日志评论
- (void)getComment
{
    
    NSMutableDictionary  *paramDic=[[NSMutableDictionary  alloc]initWithCapacity:0];
    
    [paramDic  setValue:self.model1.logid forKey:@"logid"];
    
    [AFNetworking_RequestData requestMethodPOSTUrl:Comment dic:paramDic showHUD:YES response:NO Succed:^(id responseObject) {
        
        NSMutableArray *arrM = [NSMutableArray array];
        for (NSDictionary *dic in responseObject[@"data"]) {
            EvaluateModel *model = [EvaluateModel yy_modelWithJSON:dic];
            [arrM addObject:model];
        }
        self.dataArr = arrM;
        [_tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
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
    
    _imgView2 = [UIImageView imgViewWithframe:CGRectZero icon:@""];
    _imgView2.contentMode = UIViewContentModeScaleAspectFill;
    [_bgView addSubview:_imgView2];
//    _imgView2.backgroundColor = [UIColor redColor];
    
    [_imgView1 sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"mrtx"]];
    [_imgView2 sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"img"]];

    
    _nameLab = [UILabel labelWithframe:CGRectZero text:@"MHYTFY(多肉盆栽1)" font:[UIFont systemFontOfSize:16] textAlignment:NSTextAlignmentLeft textColor:@"#313131"];
    [_bgView addSubview:_nameLab];
    [_nameLab wl_changeColorWithTextColor:[UIColor colorWithHexString:@"#999999"] changeText:@"(多肉盆栽1)"];

    
    _contentLab = [UILabel labelWithframe:CGRectZero text:@"今天天气好好，拍一张彩虹花盆，美美哒！" font:[UIFont systemFontOfSize:16] textAlignment:NSTextAlignmentLeft textColor:@"#313131"];
    [_bgView addSubview:_contentLab];
    _contentLab.numberOfLines = 0;
    
    _timeLab = [UILabel labelWithframe:CGRectZero text:@"3个小时前" font:[UIFont systemFontOfSize:14] textAlignment:NSTextAlignmentLeft textColor:@"#999999"];
    [_bgView addSubview:_timeLab];
    
    _stateBtn = [UIButton buttonWithframe:CGRectZero text:@"关注" font:[UIFont systemFontOfSize:16] textColor:@"#999999" backgroundColor:@"" normal:@"" selected:nil];
    [_bgView addSubview:_stateBtn];
    //        _xiaDanBtn.tag = 0;
    [_stateBtn addTarget:self action:@selector(stateAction) forControlEvents:UIControlEventTouchUpInside];
    

    _evaBtn = [UIButton buttonWithframe:CGRectZero text:@"138" font:[UIFont systemFontOfSize:14] textColor:@"#999999" backgroundColor:nil normal:@"评论" selected:nil];
    [_bgView addSubview:_evaBtn];
    _evaBtn.tag = 0;
    [_evaBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    _evaBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
//    _evaBtn.userInteractionEnabled = NO;
    
    _likeBtn = [UIButton buttonWithframe:CGRectZero text:@"138" font:[UIFont systemFontOfSize:14] textColor:@"#999999" backgroundColor:nil normal:@"赞" selected:@"Group 6"];
    [_bgView addSubview:_likeBtn];
    _likeBtn.tag = 1;
    [_likeBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    _likeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    
    _imgView1.frame = CGRectMake(15, 15, 40, 40);
    _imgView1.layer.cornerRadius = _imgView1.height/2;
    _imgView1.layer.masksToBounds = YES;
    
    _stateBtn.frame = CGRectMake(kScreenWidth-15-57, 25, 57, 23);
    _stateBtn.layer.cornerRadius = _stateBtn.height/2;
    _stateBtn.layer.masksToBounds = YES;
    _stateBtn.layer.borderWidth = .5;
    _stateBtn.layer.borderColor = [UIColor colorWithHexString:@"#999999"].CGColor;
    
    _nameLab.frame = CGRectMake(_imgView1.right+10, _imgView1.centerY-9, kScreenWidth-(_imgView1.right+10)-10, 18);
    _contentLab.frame = CGRectMake(_imgView1.left, _imgView1.bottom+10, kScreenWidth-_imgView1.left*2, 18);
    _imgView2.frame = CGRectMake(_imgView1.left, _contentLab.bottom+15, kScreenWidth-_imgView1.left*2, 170);
    _timeLab.frame = CGRectMake(_imgView1.left, _imgView2.bottom+22, 120, 15);
    _likeBtn.frame = CGRectMake(kScreenWidth-15-50, _imgView2.bottom+20, 50, 20);
    _evaBtn.frame = CGRectMake(_likeBtn.left-10-_likeBtn.width, _likeBtn.top, _likeBtn.width, _likeBtn.height);
    
    [_imgView1 sd_setImageWithURL:[NSURL URLWithString:self.model1.headimg] placeholderImage:[UIImage imageNamed:@"mrtx"]];
    [_imgView2 sd_setImageWithURL:[NSURL URLWithString:self.model1.logimg] placeholderImage:[UIImage imageNamed:@"img"]];
    _nameLab.text = self.model1.nikename;
    _contentLab.text = self.model1.logcomment;
    _timeLab.text = self.model1.logtime;
    [_evaBtn setTitle:self.model1.commentnum forState:UIControlStateNormal];
    [_likeBtn setTitle:self.model1.zannum forState:UIControlStateNormal];
    if (self.model1.zanstas.integerValue == 0) {
        _likeBtn.selected = NO;
    }
    else {
        _likeBtn.selected = YES;
        
    }
    self.zanArr = self.model1.zanuser.mutableCopy;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, _likeBtn.bottom+20, kScreenWidth, 10)];
    view.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    [_bgView addSubview:view];

    // 点赞
    _likeBtn1 = [UIButton buttonWithframe:CGRectMake(15, view.bottom+17, 60, 20) text:@"点赞" font:[UIFont systemFontOfSize:14] textColor:@"#999999" backgroundColor:nil normal:@"赞" selected:nil];
    [_bgView addSubview:_likeBtn1];
//    _likeBtn1.tag = 0;
//    [_likeBtn1 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    _likeBtn1.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    
    _likeLab = [UILabel labelWithframe:CGRectMake(kScreenWidth-100-15, _likeBtn1.centerY-7, 100, 15) text:@"(6)" font:[UIFont systemFontOfSize:14] textAlignment:NSTextAlignmentRight textColor:@"#999999"];
    [_bgView addSubview:_likeLab];
    _likeLab.text = [NSString stringWithFormat:@"(%@)",self.model1.zannum];

    view = [[UIView alloc] initWithFrame:CGRectMake(0, _likeBtn1.bottom+17, kScreenWidth, .5)];
    view.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    [_bgView addSubview:view];

    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake(55, 102);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 18;
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, view.bottom, kScreenWidth,102) collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    //        collectionView.scrollsToTop = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    [collectionView registerClass:[UserCell class] forCellWithReuseIdentifier:@"cellID"];
    collectionView.contentInset = UIEdgeInsetsMake(0, 15, 0, 15);
    [_bgView addSubview:collectionView];
    self.collectionView = collectionView;
    
    view = [[UIView alloc] initWithFrame:CGRectMake(0, collectionView.bottom, kScreenWidth, 10)];
    view.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    [_bgView addSubview:view];
    
    // 评论
    _evaBtn1 = [UIButton buttonWithframe:CGRectMake(15, view.bottom+17, 60, 20) text:@"评论" font:[UIFont systemFontOfSize:14] textColor:@"#999999" backgroundColor:nil normal:@"评论" selected:nil];
    [_bgView addSubview:_evaBtn1];
//    _evaBtn1.tag = 1;
//    [_evaBtn1 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    _evaBtn1.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    
    _evaLab = [UILabel labelWithframe:CGRectMake(kScreenWidth-100-15, _evaBtn1.centerY-7, 100, 15) text:@"(6)" font:[UIFont systemFontOfSize:14] textAlignment:NSTextAlignmentRight textColor:@"#999999"];
    [_bgView addSubview:_evaLab];
    _evaLab.text = [NSString stringWithFormat:@"(%@)",self.model1.commentnum];

    
    view = [[UIView alloc] initWithFrame:CGRectMake(0, _evaBtn1.bottom+17, kScreenWidth, .5)];
    view.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    [_bgView addSubview:view];
    
    _bgView.frame = CGRectMake(0, 0, kScreenWidth, view.bottom);
    
    _tableView = [UITableView tableViewWithframe:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kTopHeight-49) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
//    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableHeaderView = _bgView;
}

- (void)btnAction:(UIButton *)btn
{
    if (btn.tag == 0) {
//        [self.chatKeyBoard keyboardUpforComment];

    }
    else {
        [self clike];
    }
}

- (void)stateAction
{
    RelateBotanyVC *vc = [[RelateBotanyVC alloc] init];
    vc.title = @"关联植物";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.zanArr.count;
//    return 10;
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
    
    Zanuser *user = self.zanArr[indexPath.item];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:user.headimg] placeholderImage:[UIImage imageNamed:@"mrtx"]];
    cell.label.text = user.nikename;
    return cell;
    
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
    DynamicDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
    if (!cell) {
        cell = [[DynamicDetailCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:cell_id];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.backgroundColor = [UIColor clearColor];
        
    }
    EvaluateModel *model = self.dataArr[indexPath.row];

    cell.model = model;
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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

    [AFNetworking_RequestData requestMethodPOSTUrl:Addcom dic:paramDic showHUD:NO response:NO Succed:^(id responseObject) {
        
        EvaluateModel *model = [EvaluateModel yy_modelWithJSON:responseObject[@"data"]];
        [self.dataArr addObject:model];
        [_tableView reloadData];
        
        self.model1.commentnum = [NSString stringWithFormat:@"%ld",(self.model1.commentnum.integerValue+1)];
        
        [self.chatKeyBoard keyboardDown];


    } failure:^(NSError *error) {
        
    }];
}

@end
