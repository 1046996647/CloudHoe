//
//  DebugView.m
//  HekrSDKAPP
//
//  Created by 单天赛 on 16/5/12.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "DebugView.h"

#import "EnvironmentView.h"
#import "DebugModel.h"
#import <MessageUI/MFMailComposeViewController.h>
#import "StatusBar.h"
#import "DbugHeader.h"

@interface DebugView() <MFMailComposeViewControllerDelegate,DbugHeaderDelegata>

@property (nonatomic, strong) UITableView *tableView;
@property (strong, nonatomic) UISegmentedControl *segmentHead;

@property(strong,nonatomic) UIButton *button;

@property (strong, nonatomic)  MyCustomLoggeer *logger;

@property (strong, nonatomic)   EnvironmentView *environmentView;

@property(nonatomic,strong)  DDFileLogger *fileLogger;

@property (strong, nonatomic)  UIView *topView;

@property (strong, nonatomic)  DbugHeader *headerView;
@property(assign ,nonatomic) NSUInteger isLogLevel;
@property(nonatomic,strong) NSMutableArray *searchArray;
@property(nonatomic,assign) BOOL isSearch;
@property (nonatomic, strong) UIView * maskingView;
@property (nonatomic,strong) NSString *searchText;

@end
@implementation DebugView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSegment];
        [self createTableView];
        [self createButton];
    }
    return self;
}
#pragma mark ----懒加载-------
-(DDFileLogger *)fileLogger{
    if (_fileLogger == nil) {
        _fileLogger = [[DDFileLogger alloc] init];
    }
    return _fileLogger;
}
-(NSMutableArray *)searchArray{
    if (_searchArray == nil) {
        _searchArray = [NSMutableArray array];
    }
    return _searchArray;
}
- (NSMutableArray *)logErrorArray
{
    if (_logErrorArray == nil) {
    _logErrorArray = [NSMutableArray array];
    }
    return _logErrorArray;
}
-(NSMutableArray *)logDebugArray{
    if (_logDebugArray == nil) {
        _logDebugArray = [NSMutableArray array];
    }
    return _logDebugArray;
}
-(NSMutableArray *)logWarningArray{
    if (_logWarningArray == nil) {
        _logWarningArray = [NSMutableArray array];
    }
    return _logWarningArray;
}
-(NSMutableArray *)logInfoArray{
    if (_logInfoArray == nil) {
        _logInfoArray = [NSMutableArray array];
    }
    return _logInfoArray;
}
- (NSMutableArray *)logArray
{
    if (_logArray == nil) {
        _logger = [MyCustomLoggeer sharedInstance];
        _logArray = (NSMutableArray *)_logger.logMessageArray;
        for (DebugModel *model in _logArray) {
            NSArray *items = @[@"D",@"I",@"W",@"E"];
            NSUInteger item = [items indexOfObject:model.logLevel];
            switch (item) {
                case 0:
                    [self.logDebugArray addObject:model ];
                    break;
                case 1:
                    [self.logInfoArray addObject:model];
                    break;
                case 2:
                    [self.logWarningArray addObject:model];
                    break;
                case 3:
                    [self.logErrorArray addObject:model];
                    break;
            }
        }
    [_logger addObserver:self forKeyPath:@"logMessageArray" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
    }
    return _logArray;
}
-(DbugHeader *)headerView{
    if (_headerView == nil) {
        _headerView = [[DbugHeader alloc] initWithFrame:CGRectMake(0, _topView.frame.size.height , self.frame.size.width, Vrange(235))];
        _headerView.delegate = self;
        _headerView.seachBar.delegate =self;
    }
    return _headerView;
}
- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"logMessageArray"]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            DebugModel *model = [change[@"new"] firstObject];
            [self selectLogLevel:model];
        });
    }  
}
-(void)selectLogLevel:(DebugModel *)model{
    NSArray *items = @[@"D",@"I",@"W",@"E"];
    NSUInteger item = [items indexOfObject:model.logLevel];    
    switch (item) {
        case 0:
            [self.logDebugArray insertObject:model  atIndex:0 ];
            break;
        case 1:
            [self.logInfoArray insertObject:model  atIndex:0];
            break;
        case 2:
            [self.logWarningArray insertObject:model atIndex:0];
            break;
        case 3:
            [self.logErrorArray insertObject:model  atIndex:0];
            break;
    }

    [ _logArray insertObject:model  atIndex:0];
    if((_isLogLevel == item + 1 || _isLogLevel == 0 ) && _isSearch == NO){
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [_tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
   
}
- (UISegmentedControl *)addSegmentWithArray:(NSArray *)segmentArray  frame:(CGRect)frame selectedSegmentIndex:(NSInteger )Index action:(SEL)action
{
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:segmentArray];
    segment.frame = frame;
    segment.selectedSegmentIndex = Index;
    [segment addTarget:self action:action forControlEvents:UIControlEventValueChanged];
    return segment;
}
-(void)createSegment{
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 35)];
    [self addSubview:_topView];
     NSArray *segmentHeadItem = @[@"日志",@"环境切换"];
    _segmentHead = [self addSegmentWithArray:segmentHeadItem frame:CGRectMake(10, 5, self.frame.size.width - 20, 25) selectedSegmentIndex:0 action:@selector(changeView:)];
    [_topView addSubview:_segmentHead];
}
-(void)createTableView{
    _environmentView =[[EnvironmentView alloc] initWithFrame:CGRectMake(0, _topView.frame.size.height , self.frame.size.width, self.frame.size.height - _topView.frame.size.height)];
    [self addSubview:_environmentView];
    _environmentView.hidden = YES;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, _topView.frame.size.height , self.frame.size.width, self.frame.size.height - _topView.frame.size.height ) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = self.headerView;
    _tableView.tableFooterView = [self creatFooterView];
    [self addSubview:_tableView];
}
- (void)createButton
{
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button setTitle:@"导出日志" forState:UIControlStateNormal];
    _button.frame = CGRectMake(0, ScreenHeight - 40, 60, 20);
    [_button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    _button.backgroundColor = [UIColor whiteColor];
    _button.titleLabel.font = [UIFont systemFontOfSize:12];
    _button.layer.cornerRadius=5;//设置圆角
    _button.layer.borderColor = [UIColor blueColor].CGColor;
    _button.layer.borderWidth = 1;
    _button.clipsToBounds=YES;
    [_button addTarget:self action:@selector(sendMailWithLog) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_button];    
}
-(UIView *)creatFooterView{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    return footerView;
}
//切换环境
-(void)changeView:(UISegmentedControl *)segment{
    _tableView.hidden = (segment.selectedSegmentIndex !=0);
    _environmentView.hidden = (segment.selectedSegmentIndex ==0);
}
#pragma mark ---UITableViewDataSource---
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.isSearch) {
        return _searchArray.count ;
    }else{
        return [[self selectArray] count];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DebugModel *model = nil;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Debug"];
    if (cell==nil ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Debug"];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;//设置cell点击效果
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    if (self.isSearch) {
        model =  _searchArray[indexPath.row] ;
    }else{
        model= [[self selectArray] objectAtIndex:indexPath.row];
    }
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = model.log;
    [cell layoutIfNeeded];
        return cell;
}
#pragma mark ---UITableViewDelegate---
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     DebugModel *model = nil;
    if (self.isSearch) {
        model =  _searchArray[indexPath.row] ;
    }else{
        model= [[self selectArray] objectAtIndex:indexPath.row];
    }
    if (model.isSelected) {
        return [self cellHeightWithModelLog:model.log];
    }
    return 15;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DebugModel *model = nil;
    if (self.isSearch) {
        model =  _searchArray[indexPath.row] ;
    }else{
        model= [[self selectArray] objectAtIndex:indexPath.row];
    }
    model.isSelected = !model.isSelected;
  [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}
// 允许长按菜单
- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
// 允许每一个Action
- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    // 可以支持所有Action，也可以只支持其中一种或者两种Action
    if (action == @selector(copy:) ) { // 支持复制和黏贴
        return YES;
    }
    return NO;
}
- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if (action == @selector(copy:)) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard]; // 黏贴板
        [pasteBoard setString:cell.textLabel.text];
    }
}

#pragma mark --发送邮件---
- (void)sendMailWithLog
{
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (!mailClass) {
        [self showMessage:@"当前系统版本不支持应用内发送邮件功能！"];
        return;
    }
    if (![mailClass canSendMail]) {
        [self showMessage:@"请在手机邮件app上添加账号！"];
        return;
    }
    [self displayMailPicker];
}

- (void)showMessage:(NSString *)msg{
    [self.window makeToast:msg duration:1.0 position:@"center"];
}


- (void)displayMailPicker
{
    MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];
    mailPicker.mailComposeDelegate = [StatusBar  sharedInstance];
    DDLogFileInfo *ts =[self.fileLogger currentLogFileInfo];
    NSData *logData = [NSData dataWithContentsOfFile:ts.filePath];
    [mailPicker addAttachmentData: logData mimeType: @"" fileName: @"日志.log"];
    [[self viewController] presentViewController:mailPicker animated:YES completion:nil];
}

-(UIViewController *)viewController
{
    UIResponder *next = self.nextResponder;
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        
        next = next.nextResponder;
    } while (next != nil);
    
    return nil;
}

-(CGFloat)cellHeightWithModelLog:(NSString *)log{
    
    CGSize titleSize = [log boundingRectWithSize:CGSizeMake(ScreenWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    
    return titleSize.height;
}

#pragma mark - UISearchBarDelegate----
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    return YES;
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    if (searchText.length == 0) {
        _searchText = @"";
            self.isSearch = NO;
        [self.tableView reloadData];
    }
    [self.searchArray removeAllObjects];
    
    for (DebugModel *model in [self selectArray]) {
        
        if ([model.log rangeOfString:searchText].location != NSNotFound) {
            [_searchArray addObject:model];
        }
    }
    if (_searchArray.count) {
        self.isSearch = YES;
        
        [self.tableView reloadData];
    }
}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
        _maskingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
        [_maskingView addGestureRecognizer:tap];
        [self.window addSubview:_maskingView];
}
-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer
{
    if (_maskingView) {
        [_maskingView removeFromSuperview];
    }
    [self endEditing:YES];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (_maskingView) {
      [_maskingView removeFromSuperview];
    }
    [searchBar resignFirstResponder];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    if (_maskingView) {
        [_maskingView removeFromSuperview];
    }
      [searchBar endEditing:YES];
}

-(void)changeLogWithLevel:(NSUInteger)index{
    self.isSearch = NO;
    [_headerView.seachBar endEditing:YES];
    _headerView.seachBar.text = nil;
    _isLogLevel = index;
    [_tableView reloadData];
}
-(NSArray *)selectArray{
    switch (_isLogLevel) {
        case 0:
            return self.logArray;
        case 1:
            return self.logDebugArray;
        case 2:
            return self.logInfoArray;
        case 3:
            return self.logWarningArray;
        case 4:
            return self.logErrorArray;
    }
    return nil;
}
-(void)dealloc{
    [_logger removeObserver:self forKeyPath:@"logMessageArray"];
}

@end
