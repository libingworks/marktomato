//
//  AbloutViewController.m
//  LKPlayer
//
//  Created by xiaoyezi on 2020/4/3.
//  Copyright © 2020年 LK. All rights reserved.
//

#import "AbloutViewController.h"

@interface AbloutViewController ()

@end

@implementation AbloutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width)/3, (self.view.frame.size.height-60)/2, 200,60 )];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.font = [UIFont systemFontOfSize:13];
    label1.textColor = [UIColor orangeColor];
    label1.numberOfLines = 2;
    label1.text=@"番茄云签记录你的思想词";
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width-85)/3, (self.view.frame.size.height-10)/2, 200,60 )];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.font = [UIFont systemFontOfSize:13];
    label2.textColor = [UIColor orangeColor];
    label2.numberOfLines = 2;
    label2.text = @"飞雪连天射白鹿，笑书神侠倚碧鸳";
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width-50)/3, (self.view.frame.size.height-10)/1.5, 200,60 )];
    label3.textAlignment = NSTextAlignmentCenter;
    label3.font = [UIFont systemFontOfSize:13];
    label3.textColor = [UIColor orangeColor];
    label3.numberOfLines = 2;
    label3.text = @"信息反馈：helpwiki@163.com";

    [self.view addSubview:label1];
    [self.view addSubview:label2];
    [self.view addSubview:label3];
    [label3 sizeToFit];
    [label1 sizeToFit];
    [label2 sizeToFit];
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
