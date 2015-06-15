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
    //UIButton  *backBtn;
    UIWebView   *myWebView;
}
@end

@implementation SerViceViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden=NO;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//
    UILabel  *label= [ZCControl createLabelWithFrame:CGRectMake((kDeviceWidth-200)/2, 30, 200, 30) Font:16 Text:@"《电影卡片服务使用条款》"];
    label.font=[UIFont boldSystemFontOfSize:16];
    label.textAlignment=NSTextAlignmentCenter;
    label.textColor=VBlue_color;
    self.navigationItem.titleView=label;
    
    myWebView=[[UIWebView alloc]initWithFrame:CGRectMake(0,0, kDeviceWidth, kDeviceHeight)];
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
