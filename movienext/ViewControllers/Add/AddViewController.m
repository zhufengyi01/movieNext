//
//  AddViewController.m
//  movienext
//
//  Created by 风之翼 on 15/5/22.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "AddViewController.h"
#import "ZCControl.h"
#import "AFNetworking.h"
#import "Constant.h"

@interface AddViewController ()

@end

@implementation AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=View_BackGround;
    [self createNavigation];
}

-(void)createNavigation
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"tabbar_backgroud_color.png"] forBarMetrics:UIBarMetricsDefault];
    
    UILabel  *titleLable=[ZCControl createLabelWithFrame:CGRectMake(0, 0, 100, 20) Font:16 Text:@"添加"];
    titleLable.textColor=VBlue_color;
    
    titleLable.font=[UIFont boldSystemFontOfSize:18];
    titleLable.textAlignment=NSTextAlignmentCenter;
    self.navigationItem.titleView=titleLable;
    
    UIButton  *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"返回" forState:UIControlStateNormal];
    //[button setBackgroundImage:[UIImage imageNamed:@"setting.png"] forState:UIControlStateNormal];
    button.frame=CGRectMake(0, 0, 40, 40);
    [button setTitleColor:VBlue_color forState:UIControlStateNormal];
    [button addTarget:self action:@selector(GotoSettingClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem  *barButton=[[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem=barButton;
}
-(void)GotoSettingClick
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
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
