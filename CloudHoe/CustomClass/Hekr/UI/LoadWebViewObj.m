//
//  LoadWebViewObj.m
//  HekrSDKAPP
//
//  Created by 叶文博 on 2017/7/21.
//  Copyright © 2017年 Mike. All rights reserved.
//

#import "LoadWebViewObj.h"
#import <WebKit/WebKit.h>
#import "AppDelegate.h"
#import <HekrWebView.h>
#import "Tool.h"

@interface LoadWebViewObj ()<WKNavigationDelegate>
@property(nonatomic,strong)NSMutableArray *arrLoads;
@property (nonatomic,strong) WKWebView * webView;
@end

@implementation LoadWebViewObj

+(void)loadRequsetWebView:(NSArray *)arr{
    
}

-(void)loadRequsetWebView:(NSArray *)arr{
    
//    LoadReqWebVC *webVC = [[LoadReqWebVC alloc] initLoadReqWeb:arr];
//    webVC.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
//    [[TheAPPDelegate.rootNav viewControllers].firstObject.view addSubview:webVC.view];
//    [[TheAPPDelegate.rootNav viewControllers].firstObject.navigationController pushViewController:webVC animated:YES];
    
    if (self.arrLoads) {
        NSMutableArray *a = [NSMutableArray arrayWithArray:arr];
        [a addObjectsFromArray:self.arrLoads];
        self.arrLoads = a;
    }else{
        self.arrLoads  = [NSMutableArray arrayWithArray:arr];
    }
    if (self.webView) {
        return;
    }
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
    
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) configuration:config];
    self.webView.alpha = 0;
//    NSURL *path = [NSURL URLWithString:@"https://allinone-ufile.hekr.me/h5page/adb8101a-79b3-4a0c-8a30-aa7e75389da7/index.html?devTid=ESP_2M_600194264A5A&ctrlKey=91d18ecabbde49239fe8cadb45dbb141&ppk=k0wfHypbzGlO8L8Vq9+J3fUrPBQoOW6sKNUDJSDZ5PmcVPeJKi+4OoB6bovQHE60i5&lang=en-US&appId=6E7F83B2-7E6B-491A-86AC-E69402AA242Bweb"];
//    [self.webView loadRequest:[NSURLRequest requestWithURL:path]];
    
    [[TheAPPDelegate.rootNav viewControllers].firstObject.view addSubview:self.webView];
    // 导航代理
    self.webView.navigationDelegate = self;
    
    NSLog(@"loadWebView ：开始");
    [self loadWebView];
}

-(void)loadWebView{
    if (self.arrLoads.count>0) {
        NSURL *url = [NSURL URLWithString:[self.arrLoads.lastObject objectForKey:@"iosH5Page"]];
        [self.arrLoads removeLastObject];
        [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    }else{
        NSLog(@"loadWebView ：结束");
        self.arrLoads = nil;
        [self.webView removeFromSuperview];
        self.webView = nil;
    }
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSString *hostname = navigationAction.request.URL.host.lowercaseString;
    if (navigationAction.navigationType == WKNavigationTypeLinkActivated
        && ![hostname containsString:@".baidu.com"]) {
        // 对于跨域，需要手动跳转
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
        
        // 不允许web内跳转
        decisionHandler(WKNavigationActionPolicyCancel);
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    decisionHandler(WKNavigationResponsePolicyAllow);
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    [self loadWebView];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *__nullable credential))completionHandler {
    
    completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
}

@end
