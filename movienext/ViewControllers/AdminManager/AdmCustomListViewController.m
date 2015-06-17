//
//  AdmCustomListViewController.m
//  movienext
//
//  Created by 风之翼 on 15/5/21.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "AdmCustomListViewController.h"

#import "ZCControl.h"

#import "Constant.h"
@interface AdmCustomListViewController ()
{
    UIWebView *myWebView;
}
@end

@implementation AdmCustomListViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNaviagtion];
    
    myWebView=[[UIWebView alloc]initWithFrame:CGRectMake(0,0, kDeviceWidth, kDeviceHeight)];
    NSURL *url = [NSURL URLWithString:@"http://182.92.214.199/userlist.php"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [myWebView loadRequest:request];
    [self.view addSubview:myWebView];
    
}
-(void)createNaviagtion
{
    UILabel  *titleLable=[ZCControl createLabelWithFrame:CGRectMake(0, 0, 100, 20) Font:16 Text:@"用户列表"];
    titleLable.textColor=VBlue_color;
    titleLable.font=[UIFont boldSystemFontOfSize:18];
    titleLable.textAlignment=NSTextAlignmentCenter;
    self.navigationItem.titleView=titleLable;
    
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
