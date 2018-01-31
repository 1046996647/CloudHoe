//
//  ManagerViewController.m
//  HekrSDKAPP
//
//  Created by hekr on 16/3/30.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "ManagerViewController.h"
#import <HekrSDK.h>
#import "DevicesModel.h"
#import <UIImageView+WebCache.h>
#import "DevicesModel.h"
#import "Tool.h"
#import "DevAuthorizationViewController.h"
#import "DevShareViewController.h"
#import "DevInfoViewController.h"
#import "ManagerViewCell.h"
#import <SHAlertViewBlocks.h>
//#import "Toast.h"
#import "ChangeDevName.h"

//#define rgb(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1]
//#define Width                     [UIScreen mainScreen].bounds.size.width
//#define Height                    [UIScreen mainScreen].bounds.size.height
//#define Hrange(x)  (x/750.0)*Width
//#define Vrange(x)  (x/1334.0)*Height
//#define MAX_STARWORDS_LENGTH 16
@interface ManagerViewController ()<UITableViewDelegate,UITableViewDataSource,ChangeDevNameDelegate,ModelDelegate,UITextFieldDelegate>
@property (nonatomic, strong) DevicesModel *model;
@property (nonatomic, strong) HekrDevice *data;
@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) UIView *upView;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *devName;
@property (nonatomic, copy) NSString *oldDevName;
@property (nonatomic, strong) UILabel *devNameLabel;
@property (nonatomic, strong) UIView *upimagebgView;
@property (nonatomic, strong) UIButton *editButton;
@property (nonatomic, strong) UILabel *upDataLabel;
@property (nonatomic, strong) id updateInfo;
@property (nonatomic, assign) BOOL isToast;
@property (nonatomic, strong) ChangeDevName *changeDevNameView;
@property (nonatomic, assign) BOOL showUpData;
@property (nonatomic, assign) BOOL showRefurbishBtn;
@property (nonatomic, strong) UIButton *refurbishBtn;
@property (nonatomic, assign) BOOL isClick;
@property (nonatomic, strong) UIActivityIndicatorView *activity;
@end

@implementation ManagerViewController

- (instancetype)initWith:(id)data isGranted:(BOOL)isgranted UID:(NSString *)uid{
    self = [super init];
    if (self) {
        _showUpData = YES;
        _showRefurbishBtn = YES;
        _data = data;
        _uid = uid;
        if (isgranted == YES) {
            _isShow = YES;
        }else if(isgranted == NO){
            _isShow = NO;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = getViewBackgroundColor();
    _upDataLabel = [UILabel new];
    _activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];//指定进度轮的大小
    [_activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];//设置进度轮显示类型
    _refurbishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _titleArray = [NSMutableArray array];
    _imageArray = [NSMutableArray array];

    if (_data.devType == HekrDeviceTypeAnnex) {
        _titleArray = [NSMutableArray arrayWithArray:@[@"设备品类"]];
//        _imageArray = [NSMutableArray arrayWithArray:@[@"icon_varieties"]];
    }
    else{
        if (_isShow) {
            _titleArray = [NSMutableArray arrayWithArray:@[@"设备品类",@"当前连接路由器",@"MAC地址",@"共享授权",@"设备共享信息",@"设备固件信息"]];
//            _imageArray = [NSMutableArray arrayWithArray:@[@"icon_varieties",@"ic_devauthorization",@"ic_devShare",@"ic_devinfo",@"Mac_address"]];
        }else{
            _titleArray = [NSMutableArray arrayWithArray:@[@"设备品类",@"当前连接路由器",@"MAC地址",@"设备共享信息",@"设备固件信息"]];
//            _imageArray = [NSMutableArray arrayWithArray:@[@"icon_varieties",@"ic_devShare",@"ic_devinfo",@"Mac_address"]];
        }
        if (_data.devType == HekrDeviceTypeGateway) {
            [_titleArray removeObject:@"当前连接路由器"];
            [_titleArray removeObject:@"MAC地址"];
//            [_imageArray removeObject:@"Mac_address"];
        }
    }
    
    NSDictionary *type = @{@"设备品类":@"icon_varieties",@"共享授权":@"icon_scanning",@"设备共享信息":@"icon_shareDev",@"设备固件信息":@"ic_devinfo",@"当前连接路由器":@"ic_routing",@"MAC地址":@"icon_Mac_adress"};
    
//    NSString *style = [getThemeName() lowercaseString];
    NSString *style = @"original";
    for (NSString *typeName in _titleArray) {
        [_imageArray addObject:[NSString stringWithFormat:@"%@_%@",[type objectForKey:typeName],style]];
    }
    
    [self initNavView];
//    [_activity setHidesWhenStopped:YES];
//    [self createUpView];
    [self createTableview];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateVer:) name:@"updateVer" object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"DevManagerDetail"];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
//    [self initNavView];

}
-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (_data.devType != HekrDeviceTypeAnnex) {
        [self isUpdata];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"DevManagerDetail"];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)initNavView
{
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.navigationController.navigationBar.barTintColor = getNavBackgroundColor();
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:getNavPopBtnImg()] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(popClick)];
    self.navigationItem.leftBarButtonItem = left;
}

- (void)popClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)updateVer:(NSNotification *)sender{
    NSDictionary *lastOtarule = [sender userInfo];
    NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithDictionary:_data.props];
    [dict setValue:lastOtarule[@"latestBinVer"] forKey:@"binVersion"];
    [dict setValue:lastOtarule[@"latestBinType"] forKey:@"binType"];
    _data.props=dict;
    self.updateInfo = nil;
}

- (void)isUpdata{
    if (_isClick == YES) {
        return;
    }
    _isClick = YES;
    if (_refurbishBtn.hidden == NO) {
        _refurbishBtn.hidden = YES;
    }
    if (_upDataLabel.hidden == NO) {
        _upDataLabel.hidden = YES;
    }
    [self performSelector:@selector(clickAction) withObject:nil afterDelay:1.0];
    //"binUrl" : "http://fs.hekr.me/dev/fw/ota/xxx.bin",
    //"md5" : "5d41402abc4b2a76b9719d911017c592", // 固件md5
    //"latestBinType" : "B",                      // 新固件类型
    //"latestBinVer" : "1.2.3.4",                 // 新固件版本
    //"size" : 77
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    NSDictionary * kv = @{@"devTid":@"devTid",@"productPublicKey":@"productPublicKey",@"binType":@"binType",@"binVer":@"binVersion"};
    for (NSString* key in kv.allKeys) {
        NSString* v = kv[key];
        id val = [_data.props objectForKey:v];
        if (val) {
            [dict setObject:val forKey:key];
        }
    }
    
    [_activity startAnimating];
    AFHTTPSessionManager *manager = [[Hekr sharedInstance] sessionWithDefaultAuthorization];
    [manager POST:@"http://console.openapi.hekr.me/external/device/fw/ota/check"
       parameters:@[dict]
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              DDLogInfo(@"[获取固件是否需要升级]：%@",responseObject);
              [_activity stopAnimating];
              _showRefurbishBtn = YES;
              if ([responseObject isKindOfClass:[NSArray class]]) {
                  id info = [(NSArray*)responseObject filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nonnull evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
                      return [[evaluatedObject objectForKey:@"devTid"] isEqualToString:_data.tid];
                  }]].firstObject;
                  if (info && [[info objectForKey:@"update"] boolValue]) {
                      self.updateInfo = [info objectForKey:@"devFirmwareOTARawRuleVO"];
                      _showUpData = NO;
                      
                  }else{
                      _showUpData = YES;
                  }
              }else{
                  
              }
              [_tableView reloadData];
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              [_activity stopAnimating];
              _showRefurbishBtn = NO;
              _showUpData = YES;
              [_tableView reloadData];
          }];
}

- (void)clickAction{
    _isClick = NO;
}

- (UIView *)createHeaderView{
    UIView *_view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, Vrange(270)+StatusBarAndNavBarHeight)];
    UIImageView *upImage = [[UIImageView alloc]initWithFrame:_view.bounds];
    upImage.image = [UIImage imageNamed:getDeviseTopBgImg()];
    [_view addSubview:upImage];
    
    UIButton *btn_back=[[UIButton alloc] initWithFrame:CGRectMake(0, StatusBarHeight, 60, 44)];
    [btn_back setImage:[UIImage imageNamed:@"ic_userBack"] forState:UIControlStateNormal];
    [btn_back addTarget:self action:@selector(popClick) forControlEvents:UIControlEventTouchUpInside];
    [_view addSubview:btn_back];
    
    _upimagebgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Vrange(170), Vrange(170))];
    _upimagebgView.center = CGPointMake(ScreenWidth/2, StatusBarAndNavBarHeight+Vrange(85));
    _upimagebgView.backgroundColor = [UIColor clearColor];
    _upimagebgView.layer.cornerRadius = Vrange(170)/2;
    _upimagebgView.layer.borderColor = [[UIColor whiteColor] CGColor];
    _upimagebgView.layer.borderWidth = 2;
    [_view addSubview:_upimagebgView];
    
    UIImageView *devLogo = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Vrange(76), Vrange(76))];
    devLogo.center = _upimagebgView.center;
    devLogo.backgroundColor = [UIColor clearColor];
    [devLogo sd_setImageWithURL:[NSURL URLWithString:_data.props[@"logo"]] placeholderImage:[UIImage imageNamed:@"icon-device_default"]];
    devLogo.userInteractionEnabled = YES;
    [_view addSubview:devLogo];
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showTid)];
    [tgr setNumberOfTapsRequired:5];
    [_upimagebgView addGestureRecognizer:tgr];
    
    UITapGestureRecognizer *imgTgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showTid)];
    [imgTgr setNumberOfTapsRequired:5];
    [devLogo addGestureRecognizer:imgTgr];
    
    NSString *devName = _data.props[@"name"];
    CGFloat nameWidth = [self sizeWithText:devName maxSize:CGSizeMake(MAXFLOAT, 16) font:[UIFont systemFontOfSize:16]].width;
    if (nameWidth >= ScreenWidth*0.7) {
        nameWidth = ScreenWidth*0.7;
    }
    _devNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, nameWidth, 16)];
    _devNameLabel.center = CGPointMake(ScreenWidth/2, CGRectGetMaxY(_upimagebgView.frame)+Vrange(30)+8);
    _devNameLabel.text = devName;
    _devNameLabel.font = [UIFont systemFontOfSize:16];
    _devNameLabel.textColor = [UIColor whiteColor];
    _devNameLabel.layer.shadowColor = UIColorFromHex(0x000000).CGColor;
    _devNameLabel.layer.shadowOffset = CGSizeMake(1,1.5);
    _devNameLabel.layer.shadowOpacity = 0.2;
    _devNameLabel.layer.shadowRadius = 1.0;
    [_view addSubview:_devNameLabel];
    
    _editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _editButton.frame = CGRectMake(CGRectGetMaxX(_devNameLabel.frame)+5, CGRectGetMinY(_devNameLabel.frame), 16, 16);
    [_editButton setBackgroundImage:[UIImage imageNamed:@"icon-edit"] forState:UIControlStateNormal];
    [_editButton addTarget:self action:@selector(changeDevName) forControlEvents:UIControlEventTouchUpInside];
    [_view addSubview:_editButton];
    return _view;
}

- (UIView *)createFooterView{
    UIView *_view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, 30+Vrange(240))];
    UIButton *enterButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 15, ScreenWidth, Vrange(120))];
    enterButton.backgroundColor = getCellBackgroundColor();
    [enterButton setTitle:NSLocalizedString(@"进入控制页面", nil) forState:UIControlStateNormal];
    [enterButton setTitleColor:getTitledTextColor() forState:UIControlStateNormal];
    enterButton.titleLabel.font = getListTitleFont();
    [enterButton addTarget:self action:@selector(enterAction) forControlEvents:UIControlEventTouchUpInside];
    [_view addSubview:enterButton];
    UILabel *uplabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMinY(enterButton.frame)-1, ScreenWidth, 1)];
    uplabel.backgroundColor = getCellLineColor();
    uplabel.alpha = 0.5;
    [_view addSubview:uplabel];
    UILabel *downlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(enterButton.frame), ScreenWidth, 1)];
    downlabel.backgroundColor = getCellLineColor();
    downlabel.alpha = 0.5;
    [_view addSubview:downlabel];
    
    UIButton *outButton = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(downlabel.frame)+15, ScreenWidth, Vrange(120))];
    outButton.backgroundColor = getCellBackgroundColor();
    [outButton setTitle:NSLocalizedString(@"删除设备", nil) forState:UIControlStateNormal];
    [outButton setTitleColor:rgb(240, 87, 89) forState:UIControlStateNormal];
    outButton.titleLabel.font = getListTitleFont();
    [outButton addTarget:self action:@selector(devOut) forControlEvents:UIControlEventTouchUpInside];
    [_view addSubview:outButton];
    UILabel *uplabel1 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMinY(outButton.frame)-1, ScreenWidth, 1)];
    uplabel1.backgroundColor = getCellLineColor();
    uplabel1.alpha = 0.5;
    [_view addSubview:uplabel1];
    UILabel *downlabel1 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(outButton.frame), ScreenWidth, 1)];
    downlabel1.backgroundColor = getCellLineColor();
    downlabel1.alpha = 0.5;
    [_view addSubview:downlabel1];
    return _view;
}

- (void)showTid{
    if (_isToast == YES) {
        return;
    }
    _isToast = YES;
    [self performSelector:@selector(dismissTid) withObject:nil afterDelay:1.0];
    [self.view.window makeToast:_data.props[@"devTid"] duration:1.0 position:@"center"];
}

- (void)dismissTid{
    if (_isToast == YES) {
        _isToast = NO;
    }
}

- (void)changeDevName{
//    ChangeDevName *view = [[[NSBundle mainBundle] loadNibNamed:@"ChangeDevName" owner:self options:nil] firstObject];
//    _changeDevNameView = view;
//    _changeDevNameView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
//    _changeDevNameView.delegeate = self;
//    [self.view.window addSubview:_changeDevNameView];
    WS(weakSelf);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"修改设备名称", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *left = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleDefault handler:nil];
    [left setValue:getButtonBackgroundColor() forKey:@"titleTextColor"];
    
    UIAlertAction *right = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *tf = alert.textFields.firstObject;
        [weakSelf changeDevName:tf.text];
    }];
    [right setValue:getButtonBackgroundColor() forKey:@"titleTextColor"];
    
    [alert addAction:left];
    [alert addAction:right];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = weakSelf.devNameLabel.text;
        textField.text = weakSelf.devNameLabel.text;
        textField.delegate = weakSelf;
        [textField addTarget:self action:@selector(TextDidChange:) forControlEvents:UIControlEventEditingChanged];

    }];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

- (void)TextDidChange:(UITextField *)textfield
{
    NSString *toBeString = textfield.text;
    //获取高亮部分
    UITextRange *selectedRange = [textfield markedTextRange];
    //    UITextPosition *position = [textfield positionFromPosition:selectedRange.start offset:0];
    
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!selectedRange)
    {
        if (toBeString.length > MAX_STARWORDS_LENGTH)
        {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:MAX_STARWORDS_LENGTH];
            if (rangeIndex.length == 1)
            {
                textfield.text = [toBeString substringToIndex:MAX_STARWORDS_LENGTH];
            }
            else
            {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, MAX_STARWORDS_LENGTH)];
                textfield.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }
}

- (void)changeDevName:(NSString *)devName{
    NSString *url = nil;
    if (_data.devType == HekrDeviceTypeAnnex) {
        url = [NSString stringWithFormat:@"http://user.openapi.hekr.me/device/%@/%@",[_data indTid],[_data tid]];
    }
    else{
        url = [NSString stringWithFormat:@"http://user.openapi.hekr.me/device/%@",_data.props[@"devTid"]];
    }
    _oldDevName = _devNameLabel.text;
    [self devNameLabelsetName:devName];
    AFHTTPSessionManager *manager = [[Hekr sharedInstance]sessionWithDefaultAuthorization];
    [manager PATCH:url parameters:@{@"ctrlKey":[_data ctrlKey],@"deviceName":devName} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DDLogInfo(@"[修改设备名称]：%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self devNameLabelsetName:_oldDevName];
        [self.view.window makeToast:NSLocalizedString(@"修改失败", nil) duration:1.0 position:@"center"];
    }];
}

- (void)devNameLabelsetName:(NSString *)name{
    _devNameLabel.text = name;
    CGFloat nameWidth = [self sizeWithText:name maxSize:CGSizeMake(MAXFLOAT, 16) font:[UIFont systemFontOfSize:16]].width;
    if (nameWidth >= ScreenWidth*0.7) {
        nameWidth = ScreenWidth*0.7;
    }
    _devNameLabel.frame = CGRectMake(0, 0, nameWidth, 16);
    _devNameLabel.center = CGPointMake(ScreenWidth/2, CGRectGetMaxY(_upimagebgView.frame)+Vrange(30)+8);
    _editButton.frame = CGRectMake(CGRectGetMaxX(_devNameLabel.frame)+5, CGRectGetMinY(_devNameLabel.frame), 16, 16);
}

- (void)createTableview{
    CGFloat tableheight;
    tableheight = Vrange(110)*_titleArray.count;
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.bounces = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableHeaderView = [self createHeaderView];
    _tableView.tableFooterView = [self createFooterView];
    [self.view addSubview:_tableView];
    
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)enterAction{
    NSDictionary *data = _data.props;
    NSMutableDictionary *devData = [NSMutableDictionary dictionaryWithDictionary:data];
    if ([[data objectForKey:@"devType"] isEqualToString:@"GATEWAY"]) {
        NSMutableDictionary *subDevs = [NSMutableDictionary dictionary];
        for (HekrDevice *dev in _model.allDatas) {
            if ([[dev.props objectForKey:@"devType"] isEqualToString:@"SUB"]&&[dev.indTid isEqualToString:[data objectForKey:@"devTid"]]) {
                NSMutableDictionary *subData = [NSMutableDictionary dictionary];
                [subData setObject:dev.props forKey:@"devData"];
                [subDevs setObject:subData forKey:dev.tid];
            }
        }
        [devData setObject:subDevs forKey:@"subDevs"];
    }
    [self jumpTo:[NSURL URLWithString:controlURLForDevice(_data)] currentController:nil devData:devData devProtocol:nil];
}

- (void)devOut{
    [self showAlertNoMsgWithTitle:@"确定删除该设备？" leftText:@"取消" leftCallback:nil rightText:@"确定" rigthCallback:^(UIAlertAction * _Nonnull action) {
        self.model = [[DevicesModel alloc] initTool];
        self.model.delegate = self;
        [self.model deleteDev:_data];
    }];
    
}

- (void)onLoad{
//    NSNotification *notification = [NSNotification notificationWithName:@"ManagerViewReload" object:nil];
//    [[NSNotificationCenter defaultCenter]postNotification:notification];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)erroronLoad:(NSError *)error{
    if ([APIError(error) isEqualToString:@"0"]) {
        [self showAlertPromptWithTitle:@"删除设备失败" actionCallback:nil];

    }else{
        [self showAlertPromptWithTitle:APIError(error) actionCallback:nil];

    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *title=_titleArray[indexPath.row];

    ManagerViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"managercellId"];
    
    if (cell == nil) {
        cell = [[ManagerViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"managercellId"];
        UILabel *downLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, Vrange(110)-1, ScreenWidth, 1)];
        downLabel.backgroundColor = getCellLineColor();
        downLabel.alpha = 0.5;
        [cell.contentView addSubview:downLabel];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        if ([title isEqualToString:@"设备品类"]) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            UILabel *type = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth - Hrange(30) - 200, 0, 200, Vrange(110))];
            type.textColor = getDescriptiveTextColor();
            type.font = getDescTitleFont();
            type.textAlignment = NSTextAlignmentRight;
            type.text = isEN() == YES ? _data.props[@"categoryName"][@"en_US"] : _data.props[@"categoryName"][@"zh_CN"];
            [cell.contentView addSubview:type];
        }else if ([title isEqualToString:@"当前连接路由器"]) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            [cell.contentView addSubview:[self createSsidLabel]];
        }else if ([title isEqualToString:@"MAC地址"]) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            [cell.contentView addSubview:[self createMacLabel]];
        }
    }
    
    cell.backgroundColor = getCellBackgroundColor();
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell upData:_imageArray[indexPath.row] Title:_titleArray[indexPath.row]];
    
    if ([title isEqualToString:@"设备固件信息"]) {
        [self createUpDataLabel];
        [cell.contentView addSubview:_upDataLabel];
        [self createRefurbishBtn];
        [cell.contentView addSubview:_refurbishBtn];
        [cell.contentView addSubview:_activity];
    }
    
    return cell;
}

- (void)createUpDataLabel{
    _upDataLabel.frame = CGRectMake(ScreenWidth - Hrange(66) - 100, 0, 100, Vrange(110));
    _upDataLabel.text = NSLocalizedString(@"有更新", nil);
    if (_data.online) {
        _upDataLabel.textColor = rgb(245, 103, 53);
        
    }else{
        _upDataLabel.textColor = getDescriptiveTextColor();
    }
    _upDataLabel.font = getDescTitleFont();
    _upDataLabel.textAlignment = NSTextAlignmentRight;
    _upDataLabel.hidden = _showUpData;
}

- (void)createRefurbishBtn{
    CGFloat btnHeight = Vrange(110)/2;
    _refurbishBtn.frame = CGRectMake(ScreenWidth - Hrange(66) - Vrange(110), 0, Vrange(110), Vrange(110));
//    _refurbishBtn.backgroundColor = rgb(245, 103, 53);
    [_refurbishBtn addTarget:self action:@selector(isUpdata) forControlEvents:UIControlEventTouchUpInside];
    [_refurbishBtn setImage:[UIImage imageNamed:@"ic_devInfoRefurbish"] forState:UIControlStateNormal];
    [_refurbishBtn setImageEdgeInsets:UIEdgeInsetsMake(btnHeight/2, btnHeight/2, btnHeight/2, btnHeight/2)];
    _refurbishBtn.hidden = _showRefurbishBtn;
    _activity.center=_refurbishBtn.center;
}

- (UILabel *)createSsidLabel{
    UILabel *label = [UILabel new];
    label.frame = CGRectMake(ScreenWidth - Hrange(30) - 200, 0, 200, Vrange(110));
    label.text = _data.props[@"ssid"];
    label.textColor = getDescriptiveTextColor();
    label.font = getDescTitleFont();
    label.textAlignment = NSTextAlignmentRight;
    return label;
}

- (UILabel *)createMacLabel{
    UILabel *label = [UILabel new];
    label.frame = CGRectMake(ScreenWidth - Hrange(30) - 200, 0, 200, Vrange(110));
    label.text = [self getMacAddress:_data.props[@"mac"]];
    label.textColor = getDescriptiveTextColor();
    label.font = getDescTitleFont();
    label.textAlignment = NSTextAlignmentRight;
    return label;
}

- (NSString *)getMacAddress:(NSString *)macAddress{
    NSMutableArray *arr = [NSMutableArray new];
    NSInteger tipStar = 0;
    for (int i = 0; i < macAddress.length/2; i++) {
        NSString *str = [macAddress substringWithRange:NSMakeRange(tipStar, 2)];
        [arr addObject:str];
        tipStar += 2;
    }
    NSString *macaddress = [arr componentsJoinedByString:@":"];
    return macaddress;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:@"1", @"共享授权",@"2", @"设备共享信息",@"3", @"设备固件信息", nil];
    NSInteger count = [[dict objectForKey:[_titleArray objectAtIndex:indexPath.row]] integerValue];
    switch (count) {
        case 1:
            [self.navigationController pushViewController:[[DevAuthorizationViewController alloc] initWith:_data UID:_uid] animated:YES];
            break;
        case 2:
            [self.navigationController pushViewController:[[DevShareViewController alloc] initWithDATA:_data isShow:_isShow] animated:YES];
            break;
        case 3:
        {
            if (!self.updateInfo) {
                [self.navigationController pushViewController:[[DevInfoViewController alloc] initWIthupData:NO Data:_data OtaRule:nil] animated:YES];
            }else{
                [self.navigationController pushViewController:[[DevInfoViewController alloc] initWIthupData:YES Data:_data OtaRule:_updateInfo] animated:YES];
            }
        }
            break;
            
        default:
            break;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Vrange(110);
}




#pragma mark - 字体工具

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
