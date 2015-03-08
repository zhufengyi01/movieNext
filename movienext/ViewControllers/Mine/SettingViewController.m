//
//  SettingViewController.m
//  movienext
//
//  Created by 风之翼 on 15/3/1.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "SettingViewController.h"
#import "Constant.h"
#import "UserDataCenter.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
@interface SettingViewController ()
{
    AppDelegate *appdelegate;
    UIWindow  *window;
}

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationItem.title=@"设置";
    self.view.backgroundColor=View_BackGround;
    appdelegate = [[UIApplication sharedApplication]delegate ];
    window=appdelegate.window;

    [self createUI];
    [self createOutLogin];
    
}
-(void)createUI
{
 
    
    
}
-(void)createOutLogin
{
 
    UIButton  *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"退出此账号" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont systemFontOfSize:14];
    [button setBackgroundImage:[UIImage imageNamed:@"loginoutbackgroundcolor.png"] forState:UIControlStateNormal];
    button.frame=CGRectMake(50, 360, kDeviceWidth-100, 35);
    [button addTarget:self action:@selector(OutLoginClick:) forControlEvents:UIControlEventTouchUpInside];
    button.layer.cornerRadius=3;
    button.clipsToBounds=YES;
    [self.view addSubview:button];

}


//退出登录
-(void)OutLoginClick:(UIButton *)button
{
    UserDataCenter  *userCenter=[UserDataCenter shareInstance];
    userCenter.user_id=nil;
    userCenter.username=nil;
    userCenter.avatar =nil;
    userCenter.signature=nil;
    userCenter.update_time=nil;
    userCenter.user_bind_type=nil;
    NSUserDefaults  *userDefualt=[NSUserDefaults standardUserDefaults];
    [userDefualt removeObjectForKey:kUserKey];
    [userDefualt synchronize];
    window.rootViewController=[LoginViewController new];
    
    
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
