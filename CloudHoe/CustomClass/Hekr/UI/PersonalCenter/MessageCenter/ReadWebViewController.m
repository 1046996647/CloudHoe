//
//  ReadWebViewController.m
//  HekrSDKAPP
//
//  Created by 叶文博 on 2017/9/19.
//  Copyright © 2017年 Mike. All rights reserved.
//

#import "ReadWebViewController.h"
#import "GiFHUD.h"
#import <WebKit/WebKit.h>
#import "Tool.h"

@interface ReadWebViewController ()<WKNavigationDelegate>

@property(nonatomic ,copy)NSString *getDataUrl;
@property(nonatomic ,copy)NSString *navTitle;
@property (nonatomic ,strong) WKWebView *webMessage;

@end

@implementation ReadWebViewController

- (instancetype)initWithTitle:(NSString *)title url:(NSString *)url
{
    self = [super init];
    if (self) {
        _navTitle = title;
        _getDataUrl = url;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNavView];

    self.view.backgroundColor = getViewBackgroundColor();
    //    _dataArray = [NSArray new];
    // Do any additional setup after loading the view.
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    // 设置偏好设置
    config.preferences = [[WKPreferences alloc] init];
    // 默认为0
    config.preferences.minimumFontSize = 10;
    // 默认认为YES
    config.preferences.javaScriptEnabled = YES;
    // 在iOS上默认为NO，表示不能自动通过窗口打开
    config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    // web内容处理池
    config.processPool = [[WKProcessPool alloc] init];
    // 通过JS与webview内容交互
    config.userContentController = [[WKUserContentController alloc] init];
    
    _webMessage = [[WKWebView alloc] initWithFrame:CGRectZero];
    _webMessage.scrollView.backgroundColor = [UIColor whiteColor];
    _webMessage.navigationDelegate = self;
    _webMessage.scrollView.showsHorizontalScrollIndicator = NO;
    _webMessage.scrollView.showsVerticalScrollIndicator = NO;
    _webMessage.scrollView.alwaysBounceHorizontal = NO;
    _webMessage.scrollView.alwaysBounceVertical = NO;
    _webMessage.scrollView.bounces = NO;
    _webMessage.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_webMessage];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[web]|" options:NSLayoutFormatAlignAllTop metrics:nil views:@{@"web":_webMessage}]];    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-h1-[web]|" options:NSLayoutFormatAlignAllLeading metrics:@{@"h1":@(StatusBarAndNavBarHeight)} views:@{@"web":_webMessage}]];
    
    if (@available(iOS 11.0, *)) {
        _webMessage.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    NSURL *url =[NSURL URLWithString:_getDataUrl];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [_webMessage loadRequest:request];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initNavView{
    WS(weakSelf);
    HekrNavigationBarView *nav = [[HekrNavigationBarView alloc]initWithFrame:BarViewRectMake withTitle:_navTitle leftBarButtonAction:^{
        [weakSelf popView];
    } withRightTitle:nil leftBarButtonAction:nil];
    [self.view addSubview:nav];
}

-(void)popView{
    if ([_webMessage canGoBack]) {
        [_webMessage goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    [GiFHUD showWithOverlay];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    [GiFHUD dismiss];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    [GiFHUD dismiss];
}

@end
