//
//  LiWebViewController.m
//  LKPlayer
//
//  Created by libing on 2020/3/29.
//  Copyright © 2020年 LK. All rights reserved.
//

#import "LiWebViewController.h"
//添加解析的库
#import "TFHpple.h"
#import "TFHppleElement.h"
#import "XPathQuery.h"
//#import "MovieViewController.h"
#import "RegexKitLite.h"
@interface LiWebViewController ()

@property(strong,nonatomic)WKWebView *webView;
@property(strong,nonatomic)NSString *str;
@property(strong,nonatomic)NSURL *strURLrequest;
@property(strong,nonatomic)NSData *dat;
@property(strong,nonatomic)NSString *uring;
@property(strong,nonatomic)NSString *urlString;
@property(strong,nonatomic)NSString *resulturl;
@property(strong,nonatomic)NSString *playName;
@property(strong,nonatomic)UIButton *playbutton;
@property(strong,nonatomic)NSString * jsontring;
@property(strong,nonatomic)NSString *nowUrl;
@property(strong,nonatomic)NSString *jiexiUrl;

@property(strong,nonatomic)NSArray *analyzingjiexi;

//@property(strong,nonatomic)NSArray *datamovie;
@property (nonatomic,strong,readwrite) UIBarButtonItem *returnButton;
@property (nonatomic,strong,readwrite) UIBarButtonItem *closeItem;

@property (nonatomic,weak)CALayer * progressLayer;
@end

@implementation LiWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    UIButton * rightbutton=[[UIButton alloc] initWithFrame:CGRectMake(0,0, 20, 20)];
    i=0;
    [rightbutton setImage:[UIImage imageNamed:@"刷新"] forState:UIControlStateNormal];
    UIBarButtonItem *rightitem=[[UIBarButtonItem alloc]initWithCustomView:rightbutton];
    [rightbutton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [rightbutton sendActionsForControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=rightitem;
    //加载WebKIt
    self.webView=[[WKWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.webView];
    
    
   
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    // 进度条
    UIView * progress = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 3)];
    progress.backgroundColor = [UIColor clearColor];
    [self.view addSubview:progress];
    //设置视图不被遮挡
    self.navigationController.navigationBar.translucent = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    // 隐式动画
    CALayer * layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, 0, 3);
    layer.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:228.0/255.0 blue:196.0/255.0 alpha:1.0].CGColor;
    [progress.layer addSublayer:layer];
    self.progressLayer = layer;
    
    
    // 是否允许手势左滑返回上一级, 类似导航控制的左滑返回
    _webView.allowsBackForwardNavigationGestures = YES;
    
    NSURL *url=[NSURL URLWithString:self.environmentURLs];
    NSMutableURLRequest * request=[NSMutableURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    NSLog(@"------电影--------->%@%@",self.playName,self.resulturl);
    
    //设置代理是自己 WKwebview
    self.webView.UIDelegate=self;
    self.webView.navigationDelegate=self;
    self.analyzingjiexi=@[@"http://bofang.online/?url=",@"http://bofang.online/?url=",@"http://api.baiyug.vip/index.php?url=",@"http://55jx.top/?url=",@"http://mimijiexi.top/?url=",@"http://19g.top/?url=",@"http://nitian9.com/?url=",@"http://playx.top/?url=",@"http://607p.com/?url=",@"http://52088.online/?url=",@"https://jx.618g.com/?url="];
    self.jiexiUrl=self.analyzingjiexi[0];
    
}

//刷新
- (void)buttonClicked:(UIButton *)sender {
    sender.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.enabled = YES;
        if (i < self.analyzingjiexi.count){
            self.jiexiUrl=self.analyzingjiexi[i];
            [self get];
        }
        else{
            i=0;
            self.jiexiUrl=self.analyzingjiexi[i];
            [self get];
        }
        i+=1;
    });
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        NSLog(@"change == %@",change);
        self.progressLayer.opacity = 1;
        self.progressLayer.frame = CGRectMake(0, 0, self.view.bounds.size.width * [change[NSKeyValueChangeNewKey] floatValue], 3);
        if ([change[NSKeyValueChangeNewKey] floatValue] == 1) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progressLayer.opacity = 0;
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progressLayer.frame = CGRectMake(0, 0, 0, 3);
            });
        }
    }else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
-(void)moviebut{
    NSLog(@"点击了一下播放");
    NSLog(@"%@%@",self.playName,self.resulturl);
//    MovieViewController* another=[[MovieViewController alloc] init];
//
//    another.playUrl=self.resulturl;
//    another.playName=self.playName;
////    UIViewController *appViewController = [[UIViewController alloc] init];
//    another.modalPresentationStyle = UIModalPresentationFullScreen;
//    [self presentViewController:another animated:NO completion:nil] ;
    //[self presentViewController:another animated:YES completion:nil];
}
//进行解析数据get请求获取播放url
- (void)get {
    NSURL *name = self.strURLrequest;

    NSString *strUrl=[[NSString alloc] initWithFormat:@"%@%@",self.jiexiUrl,name];
    //封装成 NSURL
    NSURL* url = [NSURL URLWithString:strUrl];
    
    //初始化 请求对象
    NSURLRequest* request = [[NSURLRequest alloc] initWithURL:url];
    //也可以这样初始化对象
    //NSURLRequest* request = [NSURLRequest requestWithURL:url];
    
    //发送请求  默认为 GET 请求
    //1 、获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    // 2、第一个参数：请求对象
    //      第二个参数：completionHandler回调（请求完成【成功|失败】的回调）
    //      data：响应体信息（期望的数据）
    //      response：响应头信息，主要是对服务器端的描述
    //      error：错误信息，如果请求失败，则error有值
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(!error){
            NSLog(@"---开始进行解析---");
            //说明：（此处返回的数据是JSON格式的，因此使用NSJSONSerialization进行反序列化处理）
            // NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            //如果是字符串则直接取出
            NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            self.dat=[str dataUsingEncoding:NSUTF8StringEncoding];
//            NSLog(@"GET 请求返回的结果是：%@",str);
            //数据加载完成进行分析
            NSLog(@"---开始进行解析提取---");
            [self parehtml];
        }
    }];
    
    //执行任务
    [dataTask resume];
}
/**
 代理方法 要在.h 类里面设置 方法
 *  当网页加载完毕时调用：该方法使用最频繁
 */
-(void)webView:(WKWebView *_Nonnull)webView didStartProvisionalNavigation:( WKNavigation *_Nonnull)navigation;
{
    NSLog(@"开始加载");
   
    //self.progress.alpha  = 1;
    [self get];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
}

/**
 *  每当接收到服务器返回的数据时调用，通过该方法可以决定是否允许或取消导航
 */
- (void)webView:(WKWebView*)webView decidePolicyForNavigationResponse:(WKNavigationResponse*)navigationResponse decisionHandler:(void(^)(WKNavigationResponsePolicy))decisionHandler{
    [self getmovieurl1];
    decisionHandler(WKNavigationResponsePolicyAllow);
}

// 接收到服务器跳转请求即服务重定向时之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
//    NSString * urlStr = navigationResponse.response.URL.absoluteString;
    
}
//页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
//    NSLog(@"-----------获取url------------------");
//    NSLog(@"URL1=%@", self.webView.URL);
////    NSLog(@"URL2=%@", navigation.request.URL);
//    NSLog(@"-----------结束获取url------------------");
    [self.webView evaluateJavaScript:@"document.location.href" completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        NSLog(@"加载完成的url=%@ %@",response,error);
        self.nowUrl = response;
    }];
}
//获得电影的URL1
- (void)webView:(WKWebView*)webView decidePolicyForNavigationAction:(WKNavigationAction*)navigationAction decisionHandler:(void(^)(WKNavigationActionPolicy))decisionHandler{
    // 获得协议头(可以自定义协议头，根据协议头判断是否要执行跳转)
    NSString *scheme =  navigationAction.request.URL.scheme;
    NSLog(@"-----------获取url------------------");
    NSLog(@"scheme=%@",scheme);
    NSLog(@"URL1111=%@", self.webView.URL);
    NSLog(@"URL2222=%@", navigationAction.request.URL);
    NSLog(@"-----------结束获取url------------------");
    if ([scheme isEqualToString:@"iqiyi"]) {
        self.strURLrequest = self.webView.URL;
        NSLog(@"URL1=%@", self.webView.URL);
        decisionHandler(WKNavigationActionPolicyAllow);
    
        [self getmovieid];
        [self createPlaybutton];
    
        return;
    }
    else if ([scheme isEqualToString:@"https"]){
        NSLog(@"scheme=%@",scheme);
        
        NSLog(@"URL2=%@", navigationAction.request.URL);
        self.strURLrequest = navigationAction.request.URL;
        decisionHandler(WKNavigationActionPolicyAllow);
        [self getmovieid];
        [self createPlaybutton];
        return;
    }
    else if ([scheme isEqualToString:@"about"]){
        NSLog(@"scheme=%@",scheme);
        
        NSLog(@"URL3=%@", navigationAction.request.URL);
        self.strURLrequest = navigationAction.request.URL;
        decisionHandler(WKNavigationActionPolicyAllow);
        [self getmovieid];
        [self createPlaybutton];
        return;
    }
    

    decisionHandler(WKNavigationActionPolicyAllow);
    
//
}
//获得电影的URL1

-(void)getmovieurl1{
    [self.webView evaluateJavaScript:@"document.location.href" completionHandler:^(id _Nullable response, NSError * _Nullable error) {

        //返回解码
        self.nowUrl = [response stringByRemovingPercentEncoding];
        
        NSLog(@"获得电影的URL2===%@ %@",self.nowUrl,error);
    }];
}
//解析html获取播放url
-(void)parehtml{
    
    // 根据data创建TFHpple实例
    TFHpple *doc = [[TFHpple alloc] initWithHTMLData:self.dat];
    // 根据标签进行过滤                               @"//div[@id='player']"
    NSArray *elements = [doc searchWithXPathQuery:@"//iframe"];
    NSArray *element1 = [doc searchWithXPathQuery:@"//title"];
    for (int i=0; i<elements.count; i++) {
        // 获取单个ul节点
        TFHppleElement *ulE = [elements objectAtIndex:i];
        //获取相应的属性值
        self.uring=[ulE objectForKey:@"src"];
        //NSLog(@"节点===%@",ulE);
    }
    for (TFHppleElement *tits in element1) {
    
        //获取相应的title值
        self.playName=tits.text;
      
    }

    //将string字符串正则提取
    NSString *regularExpStr = @"[a-zA-z]+://[^\\s]*";
    NSString *htmlurl=self.uring;
    self.resulturl=[htmlurl stringByMatching:regularExpStr];
//    self.resulturl1 = [NSURL URLWithString:resu];
    
    NSLog(@"---正则提取的--->播放url：%@--->电影名称：%@",self.resulturl,self.playName);
    //添加域名解析失败
//    NSString *strUrl = [NSString stringWithFormat:@"http://bofang.online/?url=%@", self.uring];
    NSLog(@"---解析的html--->%@",self.uring);
    
}
//获取页面后创建播放按钮
-(void)createbutton{
    self.playbutton = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [self.playbutton setImage:[UIImage imageNamed:@"playBtn"] forState:UIControlStateNormal];
    self.playbutton.frame = CGRectMake((self.view.frame.size.width-50)/1.2, (self.view.frame.size.height-60)/3, 40,40 );
    [self.playbutton addTarget:self action:@selector(moviebut) forControlEvents:UIControlEventTouchUpInside];
    //切圆角和设置弧度
    self.playbutton.layer.cornerRadius = 15;//半径大小
    self.playbutton.layer.masksToBounds = YES;//是否切割
    [self.webView addSubview:self.playbutton];
}
-(void)createPlaybutton{
    NSString * srt=self.strURLrequest.absoluteString;
    if ([srt containsString:@"v_"]) {
        //iqyiyi
        [self createbutton];

    } else if ([srt containsString:@"cid="]){
        //tenxun
        [self createbutton];
    }else if ([srt containsString:@"id_"]){
        //tenxun
        [self createbutton];
    }
    
    
}
//获取tvid
-(void)getmovieid{
    NSURL* url = self.strURLrequest;

    //初始化 请求对象
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    //发送请求  默认为 GET 请求
    //1 、获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    // 2、第一个参数：请求对象
    //      第二个参数：completionHandler回调（请求完成【成功|失败】的回调）
    //      data：响应体信息（期望的数据）
    //      response：响应头信息，主要是对服务器端的描述
    //      error：错误信息，如果请求失败，则error有值
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(!error){
//            NSLog(@"无解析请求视频URL===%@",url);
            //说明：（此处返回的数据是JSON格式的，因此使用NSJSONSerialization进行反序列化处理）
//            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            //如果是字符串则直接取出
            NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            self.dat=[str dataUsingEncoding:NSUTF8StringEncoding];
//            NSLog(@"GET是否需要播放按钮 请求返回的结果是：%@",str);
            //数据加载完成进行分析
//            NSLog(@"开始分析------");
            // 根据data创建TFHpple实例
            TFHpple *doc = [[TFHpple alloc] initWithHTMLData:self.dat];
            // 根据标签进行过滤                               @"//div[@id='player']"
//            NSArray *elements = [doc searchWithXPathQuery:@"//iframe"];
            NSArray * elements=[doc searchWithXPathQuery:@"//div[@id='iqiyi-main']/div[1]"];
//            NSLog(@"%@",elements);
            for (int i=0; i<elements.count; i++) {
                // 获取单个ul节点
                TFHppleElement *ulE = [elements objectAtIndex:i];
                //获取相应的属性值//*[@id="app"]/div[2]/div[2]/div[1]/div[1]/div[1]/div[1]/section/div[8]
                NSString * jsonString=[ulE objectForKey:@":page-info"];
                //将string字符串正则提取
                NSString *regularExpStr = @"\"tvId\":[0-9]*";
                NSString *htmlurl=jsonString;
                self.jsontring=[htmlurl stringByMatching:regularExpStr];
                NSLog(@"节点===%@==%@",self.jsontring,jsonString);
            }
        }
    }];

    //执行任务
    [dataTask resume];


}
// 进度条记得取消监听
- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
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
