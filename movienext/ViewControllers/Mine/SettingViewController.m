//
//  SettingViewController.m
//  movienext
//
//  Created by 风之翼 on 15/3/1.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "SettingViewController.h"
#import "Constant.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationItem.title=@"设置";
    self.view.backgroundColor=View_BackGround;
    [self createUI];
    [self createOutLogin];
    
}
-(void)createUI
{
 
    
    
}
-(void)createOutLogin
{
 
    UIButton  *button=[UIButton buttonWithType:UIButtonTypeCustom];
    //[button setTitle:@"设置" forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"setting.png"] forState:UIControlStateNormal];
    button.frame=CGRectMake(50, 360, kDeviceWidth-200, 30);
    [button addTarget:self action:@selector(OutLoginClick:) forControlEvents:UIControlEventTouchUpInside];

}


//退出登录
-(void)OutLoginClick:(UIButton *)button
{
    
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
