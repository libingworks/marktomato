//
//  LiWebViewController.h
//  LKPlayer
//
//  Created by libing on 2020/3/29.
//  Copyright © 2020年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <WebKit/WebKit.h>
//导入视频的库
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
/// 数据源-地址字典
static NSInteger i;
@interface LiWebViewController : UIViewController <WKNavigationDelegate,WKUIDelegate>

//添加代理监听属性变化
//-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context;
//- (void)addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void*)context;
//
- (void)webView:(WKWebView *_Nullable)webView decidePolicyForNavigationAction:(WKNavigationAction*_Nonnull)navigationAction decisionHandler:(void(^_Nullable)(WKNavigationActionPolicy))decisionHandler;

-(void)webView:(WKWebView *_Nonnull)webView didStartProvisionalNavigation:( WKNavigation *_Nonnull)navigation;



@property (nonatomic, strong) NSString * _Nullable environmentURLs;

/// 数据源-名称
@property (nonatomic, strong) NSString * _Nullable environmentName;
@end
