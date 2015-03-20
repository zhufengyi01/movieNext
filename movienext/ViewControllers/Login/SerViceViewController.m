//
//  SerViceViewController.m
//  movienext
//
//  Created by 风之翼 on 15/3/19.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "SerViceViewController.h"
#import "ZCControl.h"
#import "Constant.h"
@interface SerViceViewController ()
{
    UIButton  *backBtn;
    UIWebView   *myWebView;
}
@end

@implementation SerViceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
   
   backBtn=[ZCControl createButtonWithFrame:CGRectMake(10,30, 100, 30) ImageName:nil Target:self Action:@selector(backClick) Title:@""];
    //backBtn.backgroundColor =[UIColor redColor];
    backBtn.titleLabel.textColor=[UIColor redColor];
    [backBtn setTitleColor:VBlue_color forState:UIControlStateNormal];
    [backBtn setTitle:@"返 回" forState:UIControlStateNormal];
    backBtn.titleLabel.font=[UIFont boldSystemFontOfSize:16];
    [backBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -40, 0, 0)];
    [self.view addSubview:backBtn];
    
    UILabel  *label= [ZCControl createLabelWithFrame:CGRectMake((kDeviceWidth-200)/2, 30, 200, 30) Font:14 Text:@"《影弹服务使用条款》"];
    label.font=[UIFont boldSystemFontOfSize:14];
    label.textAlignment=NSTextAlignmentCenter;
    label.textColor=VBlue_color;
    [self.view addSubview:label];
    
    myWebView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 64, kDeviceWidth, kDeviceHeight-64)];
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"terms" ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [myWebView loadRequest:request];
    [self.view addSubview:myWebView];
    
}
-(void)backClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
