//
//  pyayerViewController.m
//  LKPlayer
//
//  Created by libing on 2020/3/29.
//  Copyright © 2020年 LK. All rights reserved.
//

#import "pyayerViewController.h"

#import "SKTagView.h"
#import "HexColors.h"
@interface pyayerViewController ()<UIAlertViewDelegate>

@property (strong, nonatomic) SKTagView *tagView;
@property (strong, nonatomic) NSArray *colors;
@property (strong, nonatomic) NSMutableArray*array;
@property (strong, nonatomic) NSMutableArray *tagsArray;
@property(nonatomic,assign)NSUInteger originalButtonCount;
-(void)dl_setupTagView;
-(void)dl_configTag:(SKTag*)tag withIndex:(NSUInteger)index;

@end

@implementation pyayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.colors = @[@"#f7acbc", @"#84ccc9", @"#b2d235", @"#aa363d", @"#ef5b9c", @"#f47920", @"#f391a9",@"#6f599c"];
    [self dl_setupTagView];
    self.edgesForExtendedLayout = UIRectEdgeNone;
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
#pragma mark - 按钮关联方法-压栈
- (void)btnPushClick
{
    //看到的是栈顶视图，想看下一个必需把它压进来
//    LiWebViewController *firstVC = [[LiWebViewController alloc] init];
//    [self.navigationController pushViewController:firstVC animated:YES];
}

#pragma mark - Private
- (void)dl_setupTagView {
    self.tagView = ({
        SKTagView *view = [SKTagView new];
        view.backgroundColor = [UIColor whiteColor];
        view.padding = UIEdgeInsetsMake(40, 20, 40, 20);
        view.interitemSpacing = 15;
        view.lineSpacing = 10;
        view.didTapTagAtIndex = ^(NSUInteger index){
            if (index == 0) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"添加词语"
                                                                               message:@""
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                
                // 2.1添加输入文本框
                [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                    textField.placeholder = @"";
                    textField.secureTextEntry = NO;
                }];
                
                // 2.2实例化UIAlertAction按钮:确定按钮
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定"
                                                                       style:UIAlertActionStyleDefault
                                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                            
                                                                         UITextField *valueTextField = alert.textFields[0];
                                                                         NSLog(@"确定按钮被按下");
                                                                         
                                                                         NSString *value = valueTextField.text;
                                                                         [self.tagsArray insertObject:value atIndex:1];
                                                                         SKTag *tag = [SKTag tagWithText:value];
                                                                         [self dl_configTag:tag withIndex:self.originalButtonCount];
                                                                         [self.tagView insertTag:tag atIndex:1];
                                                                         self.originalButtonCount ++ ;
                                                                         //TODO
                                                                         NSLog(@"最新%@",self.tagsArray);
                                                                         //保存在本地
                                                                         NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES)[0];
                                                                         //拼接文件全路径
                                                                         NSString *filePath = [path stringByAppendingPathComponent:@"data.plist"];
                                                                         [self.tagsArray writeToFile:filePath atomically:YES];
                                                                         NSLog(@"%@",filePath);
                                                                         
                                                                         
                                                                     }];
                                               
                
                UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"取消"
                                                                        style:UIAlertActionStyleDefault
                                                                      handler:nil];
                [alert addAction:confirmAction];
                [alert addAction:cancelAction];
                
                //  3.显示alertController
                [self presentViewController:alert animated:YES completion:nil];
            }
            //            NSLog(@"点击了第%lu个",(unsigned long)index);
        };
        view;
    });
    self.tagView.frame = self.view.bounds;
    [self.view addSubview:self.tagView];

    //取出本地
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES)[0];

    NSString *filePath = [path stringByAppendingPathComponent:@"data.plist"];

    self.array = [NSMutableArray arrayWithContentsOfFile:filePath];

    if (self.array != nil && ![self.array isKindOfClass:[NSNull class]] && self.array.count != 0){

        self.tagsArray=self.array;
    }
    else{
        self.tagsArray=[NSMutableArray arrayWithObjects:@" 添加词语",@"soul mate 灵魂伴侣", @"Eternity 永恒", @"Limerence 纯爱", @"Aestheticism 唯美", @"Freedom 自由", @"Sunshine 阳光", @"Grace 优美", @"Silhouette剪影", @"dillydally girl 浪女", @"certificate maniac 哈证族", @"Mo Maek 莫陌", nil];
    }


    NSLog(@"%@",self.tagsArray);
    self.originalButtonCount = self.tagsArray.count;
    [self.tagsArray enumerateObjectsUsingBlock: ^(NSString *text, NSUInteger idx, BOOL *stop) {
        SKTag *tag = [SKTag tagWithText: text];
        if (idx == 0) {
            tag.textColor = [UIColor hx_colorWithHexString: self.colors[idx % self.colors.count]];
            tag.borderColor = tag.textColor;
            tag.borderWidth = 1;
            tag.fontSize = 15;
            tag.padding = UIEdgeInsetsMake(13.5, 12.5, 13.5, 12.5);
            tag.nrmColor = [UIColor clearColor];
            tag.cornerRadius = 5;

        }else{
            [self dl_configTag:tag withIndex:idx];
        }
        [self.tagView addTag:tag];
    }];
}
//键盘响应
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    return YES;
}
-(void)dl_configTag:(SKTag *)tag withIndex:(NSUInteger)index
{
    tag.textColor = [UIColor whiteColor];
    tag.fontSize = 15;
    tag.padding = UIEdgeInsetsMake(13.5, 12.5, 13.5, 12.5);
    tag.nrmColor = [UIColor hx_colorWithHexString: self.colors[index % self.colors.count]];
    tag.cornerRadius = 5;
}

#pragma mark - UIAlertViewDelegate
//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex == 1) {
//        SKTag *tag = [SKTag tagWithText: [alertView textFieldAtIndex:0].text];
//        [self dl_configTag:tag withIndex:self.originalButtonCount];
//        [self.tagView insertTag:tag atIndex:1];
//        self.originalButtonCount ++ ;
//    }
//}

//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    if (buttonIndex == 1) {
//        //        UITextField *nameField = [alertView textFieldAtIndex:0];
//        //        UITextField *urlField = [alertView textFieldAtIndex:1];
//        [self.tagsArray insertObject:[alertView textFieldAtIndex:0].text atIndex:1];
//        SKTag *tag = [SKTag tagWithText:[alertView textFieldAtIndex:0].text];
//        [self dl_configTag:tag withIndex:self.originalButtonCount];
//        [self.tagView insertTag:tag atIndex:1];
//        self.originalButtonCount ++ ;
//        //TODO
//        NSLog(@"最新%@",self.tagsArray);
//        //保存在本地
//        NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES)[0];
//        //拼接文件全路径
//        NSString *filePath = [path stringByAppendingPathComponent:@"data.plist"];
//        [self.tagsArray writeToFile:filePath atomically:YES];
//        NSLog(@"%@",filePath);
//    }
//    NSLog(@"点击了%ld",(long)buttonIndex);
//}
//-(void)myAdd{
//    if (_customAlertView==nil) {
//        _customAlertView = [[UIAlertView alloc] initWithTitle:@"观看地址" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    }
//    [_customAlertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
//    //    UITextField *nameField = [_customAlertView textFieldAtIndex:0];
//    //    nameField.placeholder = @"请输入一个名称";
//    UITextField *urlField = [_customAlertView textFieldAtIndex:0];
//    [urlField setSecureTextEntry:NO];
//    urlField.placeholder = @"请输入一个URL";
//    urlField.text = @"https://";
//    [_customAlertView show];
//}

@end
