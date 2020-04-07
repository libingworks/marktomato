//
//  MovieViewController.m
//  marktomato
//
//  Created by libing on 2020/4/6.
//  Copyright © 2020 libing. All rights reserved.
//

#import "LMovieViewController.h"



@interface MovieViewController ()<PLPlayerDelegate>
@property(strong,nonatomic)PLPlayer *Player;
@property(strong,nonatomic)NSURL *URL;
@end

@implementation MovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 初始化 PLPlayerOption 对象
    PLPlayerOption *option = [PLPlayerOption defaultOption];

    // 更改需要修改的 option 属性键所对应的值
    [option setOptionValue:@15 forKey:PLPlayerOptionKeyTimeoutIntervalForMediaPackets];
    [option setOptionValue:@2000 forKey:PLPlayerOptionKeyMaxL1BufferDuration];
    [option setOptionValue:@1000 forKey:PLPlayerOptionKeyMaxL2BufferDuration];
    [option setOptionValue:@(NO) forKey:PLPlayerOptionKeyVideoToolbox];
    [option setOptionValue:@(kPLLogInfo) forKey:PLPlayerOptionKeyLogLevel];
    
    // 初始化 PLPlayer
    self.URL=[NSURL URLWithString:@"https://jx.618g.com/m3u8-dp.php?url=https://youku.cdn2-okzy.com/20200401/8661_fafefc37/index.m3u8"];
    self.Player = [PLPlayer playerWithURL:self.URL option:option];

    // 设定代理 (optional)
    self.Player.delegate = self;
    
    //获取视频输出视图并添加为到当前 UIView 对象的 Subview
    [self.view addSubview:_Player.playerView];
    
    [self.Player play];
}
-(void)getw{
    //初始化 请求对象
//        NSURLRequest* request = [NSURLRequest requestWithURL:@""];
//        //发送请求  默认为 GET 请求
//        //1 、获得会话对象
//        NSURLSession *session = [NSURLSession sharedSession];
//        // 2、第一个参数：请求对象
//        //      第二个参数：completionHandler回调（请求完成【成功|失败】的回调）
//        //      data：响应体信息（期望的数据）
//        //      response：响应头信息，主要是对服务器端的描述
//        //      error：错误信息，如果请求失败，则error有值
//        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//            if(!error){
//    //            NSLog(@"无解析请求视频URL===%@",url);
//                //说明：（此处返回的数据是JSON格式的，因此使用NSJSONSerialization进行反序列化处理）
//    //            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
//                //如果是字符串则直接取出
//                NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//                self.dat=[str dataUsingEncoding:NSUTF8StringEncoding];
//    //            NSLog(@"GET是否需要播放按钮 请求返回的结果是：%@",str);
//                //数据加载完成进行分析
//    //            NSLog(@"开始分析------");
//                // 根据data创建TFHpple实例
//                TFHpple *doc = [[TFHpple alloc] initWithHTMLData:self.dat];
//                // 根据标签进行过滤                               @"//div[@id='player']"
//    //            NSArray *elements = [doc searchWithXPathQuery:@"//iframe"];
//                NSArray * elements=[doc searchWithXPathQuery:@"//div[@id='iqiyi-main']/div[1]"];
//    //            NSLog(@"%@",elements);
//                for (int i=0; i<elements.count; i++) {
//                    // 获取单个ul节点
//                    TFHppleElement *ulE = [elements objectAtIndex:i];
//                    //获取相应的属性值//*[@id="app"]/div[2]/div[2]/div[1]/div[1]/div[1]/div[1]/section/div[8]
//                    NSString * jsonString=[ulE objectForKey:@":page-info"];
//                    //将string字符串正则提取
//                    NSString *regularExpStr = @"\"tvId\":[0-9]*";
//                    NSString *htmlurl=jsonString;
//                    self.jsontring=[htmlurl stringByMatching:regularExpStr];
//                    NSLog(@"节点===%@==%@",self.jsontring,jsonString);
//                }
//            }
//        }];
//
//        //执行任务
//        [dataTask resume];

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
