//
//  BaseViewController.m
//  LKPlayer
//
//  Created by ck on 16/6/24.
//  Copyright © 2016年 LK. All rights reserved.
//

#import "BaseViewController.h"
#import "LMovieViewController.h"
#import "LiWebViewController.h"
#import "pyayerViewController.h"
#import "MenuView.h"
#import "LeftMenuViewDemo.h"
#import "AbloutViewController.h"

@interface BaseViewController ()<UIAlertViewDelegate,UITableViewDelegate,UITableViewDataSource,HomeMenuViewDelegate>

@property (nonatomic, strong) UITableView *mainTableView;

@property (nonatomic, strong) UIBarButtonItem *rightButton;
@property (nonatomic, strong) UIBarButtonItem *liftButton;
@property (nonatomic, strong) NSIndexPath *previousIndex;

/// 数据源-地址字典
@property (nonatomic, strong) NSDictionary *environmentURLs;
@property (nonatomic, strong) NSDictionary *savironmentURL;
/// 数据源-名称
@property (nonatomic, strong) NSString *environmentName;

/// 响应回调-选择
@property (nonatomic, copy) void (^environmentSelected)(NSString *name);
/// 响应回调-选择后
@property (nonatomic, copy) void (^environmentDismiss)(void);
@property (nonatomic, assign) BOOL isExitApp;

@property (nonatomic ,strong)MenuView   * menu;
@property (nonatomic)NSString* isalert;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"首页";

//    UINavigationBar * bar = self.navigationController.navigationBar;
//    bar.backgroundColor = [UIColor redColor];
    //服务条款
    
    [self alerta];
    
    
    
    //添加侧边栏
    LeftMenuViewDemo *demo = [[LeftMenuViewDemo alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width * 0.8, [[UIScreen mainScreen] bounds].size.height)];
    demo.customDelegate = self;
    UIButton * liftbutton=[[UIButton alloc] initWithFrame:CGRectMake(0,0, 20, 20)];
    [liftbutton setImage:[UIImage imageNamed:@"目录"] forState:UIControlStateNormal];
    UIBarButtonItem *lifttitem=[[UIBarButtonItem alloc]initWithCustomView:liftbutton];
    [liftbutton addTarget:self action:@selector(leftNavAction:) forControlEvents:UIControlEventTouchUpInside];
    [liftbutton sendActionsForControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=lifttitem;
    
    self.menu = [[MenuView alloc]initWithDependencyView:self.view MenuView:demo isShowCoverView:YES];
    NSLog(@"视图加载");

    //取出本地

    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES)[0];

    NSString *filePath = [path stringByAppendingPathComponent:@"data.plist"];//arrayWithContentsOfFile

    self.savironmentURL = [NSDictionary dictionaryWithContentsOfFile:filePath];

    if (self.savironmentURL != nil && ![self.savironmentURL isKindOfClass:[NSNull class]] && self.savironmentURL.count != 0){

        self.environmentURLs=self.savironmentURL;
    }
    else{
            self.environmentURLs=@{@"展示":@"https://www.apple.com.cn/safari"};
    }

    self.mainTableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    [self.view addSubview:self.mainTableView];
    
    self.mainTableView.tableFooterView = [UIView new];

    
    self.rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAddress:)];
    self.navigationItem.rightBarButtonItem = self.rightButton;

    self.edgesForExtendedLayout = UIRectEdgeNone;

}
-(void)alerta{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES)[0];
    
    NSString *filePath = [path stringByAppendingPathComponent:@"alert.plist"];
    NSLog(@"%@",filePath);
    NSDictionary* ale = [NSDictionary dictionaryWithContentsOfFile:filePath];
    NSString *appVersion = ale[@"key"];
    if ([appVersion isEqualToString:@"yes"] ){

    }
    else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"服务协议" message:@"欢迎使用番茄云签！\n 1.本应用不授权获取用户个人信息\n2.本应用存储数据为本地,并不会在服务器存储;\n3.用户明确同意其使用本应用网络服务所存在的风险及一切后果将完全由用户本人承担,本应用对此不承担任何责任。" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"取消");
            [self presentViewController:alertController animated:YES completion:nil];
        }];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"确定");
            self.isalert=@"yes";
            NSDictionary *dic=@{@"key":self.isalert};
            NSMutableDictionary * muDic2 = [[NSMutableDictionary alloc] initWithDictionary:dic];
            //保存在本地
            NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES)[0];
            //拼接文件全路径
            NSString *filePath = [path stringByAppendingPathComponent:@"alert.plist"];
            [muDic2 writeToFile:filePath atomically:YES];
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        //    alertController.view.userInteractionEnabled = NO;
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
}
- (void)addAddress:(UISegmentedControl *)segment
{
    // 1.实例化UIAlertController对象
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"添加地址"
                                                                   message:@"信息"
                                                            preferredStyle:UIAlertControllerStyleAlert];

    // 2.1添加输入文本框
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"网络名称";
        textField.secureTextEntry = NO;
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"https:开头的网络地址";
        textField.secureTextEntry = NO;
    }];

    // 2.2实例化UIAlertAction按钮:确定按钮
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定"
      style:UIAlertActionStyleDefault
    handler:^(UIAlertAction * _Nonnull action) {
        UITextField *passwordTextField = alert.textFields[0];
        UITextField *valueTextField = alert.textFields[1];
        NSLog(@"确定按钮被按下");
        
        NSString *name = passwordTextField.text;
        NSString *value = valueTextField.text;
        NSLog(@"name = %@vale=%@",name,value);
        if ((name && 0 < name.length) && ((value && 0 < value.length && ([value hasPrefix:@"http://"] || [value hasPrefix:@"https://"]))))
        {
            //

            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            if (dict == nil)
            {
                dict = [[NSMutableDictionary alloc] init];
            }
            [dict setValue:value forKey:name];


            // 属性设置
            for (NSString *key in self.environmentURLs.allKeys)
            {
                NSString *value = [self.environmentURLs objectForKey:key];
                [dict setValue:value forKey:key];
            }
            self.environmentURLs = dict;

            [self.mainTableView reloadData];
            //保存在本地
            NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES)[0];
            //拼接文件全路径
            NSString *filePath = [path stringByAppendingPathComponent:@"data.plist"];
            [self.environmentURLs writeToFile:filePath atomically:YES];
            NSLog(@"%@",filePath);
        }
    }];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"取消"
                                                            style:UIAlertActionStyleDefault
                                                          handler:nil];
    [alert addAction:confirmAction];
    [alert addAction:cancelAction];

    //  3.显示alertController
    [self presentViewController:alert animated:YES completion:nil];
    
}
//键盘
- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"停止编辑");
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self.mainTableView  = [[UITableView alloc] initWithFrame:frame style:style];
    if (self)
    {
        self.mainTableView .autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.mainTableView .tableFooterView = [UIView new];
        
        self.mainTableView .delegate = self;
        self.mainTableView .dataSource = self;
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.environmentURLs.allKeys.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCell"];
        
        cell.detailTextLabel.font = [UIFont systemFontOfSize:10.0];
        // 字体颜色
        cell.textLabel.textColor = [UIColor blackColor];
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    }
    
    NSString *name = self.environmentURLs.allKeys[indexPath.row];
    cell.textLabel.text = name;
    NSString *url = [self.environmentURLs objectForKey:name];
    cell.detailTextLabel.text = url;
    // 字体颜色
    cell.textLabel.textColor = [UIColor blackColor];
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    if ([self.environmentName isEqualToString:name])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        // 字体高亮颜色
        cell.textLabel.textColor = [UIColor blueColor];
        cell.detailTextLabel.textColor = [UIColor blueColor];
        
        self.previousIndex = indexPath;
    }
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // 当前选择回调
    NSString *name = self.environmentURLs.allKeys[indexPath.row];
    NSString *url = [self.environmentURLs objectForKey:name];
    NSLog(@"%@%@",name,url);
    LiWebViewController * web=[[LiWebViewController alloc] init];
    web.environmentURLs=url;
    [self.navigationController pushViewController:web animated:YES];
//    [self presentViewController:web animated:YES completion:nil];
//    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:self];
//    [self presentViewController:nav animated:YES completion:^{
//        LiWebViewController * web=[[LiWebViewController alloc] init];
//        web.environmentURLs=url;
//        [self.navigationController pushViewController:web animated:YES];
//    }];
    self.previousIndex = indexPath;
}

-(void)LeftMenuViewClick:(NSInteger)tag{
    [self.menu hidenWithAnimation];
    
    NSLog(@"tag = %ld",(long)tag);
    
    if (tag == 1) {
        [self.navigationController pushViewController:[pyayerViewController new] animated:YES];
    }
    else if (tag ==0){
        [self.navigationController pushViewController:[AbloutViewController new] animated:YES];
    }
    
}
- (IBAction)leftNavAction:(id)sender {
    [self.menu show];
}
//- (void)webAction
////跳转web页面
//{
//    LiWebViewController *movie = [[LiWebViewController alloc]init];
//    [self presentViewController:movie animated:YES completion:nil];
//}
- (void)buttonAction
{
    MovieViewController *movie = [[MovieViewController alloc]init];
    //    MovieViewController* another=[[MovieViewController alloc] init];
    //
    //    another.playUrl=self.resulturl;
    //    another.playName=self.playName;
        
    movie.modalPresentationStyle = UIModalPresentationFullScreen;
    //    [self presentViewController:another animated:NO completion:nil] ;
    [self presentViewController:movie animated:YES completion:nil];
}

@end
