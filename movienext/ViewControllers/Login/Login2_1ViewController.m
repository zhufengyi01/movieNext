//
//  Login2_1ViewController.m
//  movienext
//
//  Created by 风之翼 on 15/4/14.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "Login2_1ViewController.h"
#import "ZCControl.h"
#import "Constant.h"
#import "AFNetworking.h"
@interface Login2_1ViewController ()
{
    UITextField  *emailTextfield;
    UITextField  *PassworfTextfield;

}
@end

@implementation Login2_1ViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden=YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    [self createNavgaition];
    [self createUI];
}
-(void)createNavgaition
{
    
    UIButton  *dismissButton =[ZCControl createButtonWithFrame:CGRectMake(10,20, 40, 40) ImageName:nil Target:self Action:@selector(loginClick:) Title:nil];
    dismissButton.tag=98;
    [dismissButton setImage:[UIImage imageNamed:@"close_icon.png"] forState:UIControlStateNormal];
    [self.view addSubview:dismissButton];

    
}
-(void)createUI
{
    UIImageView  *inputView=[[UIImageView alloc]initWithFrame:CGRectMake((kDeviceWidth-250)/2, 200, 250, 79)];
    inputView.userInteractionEnabled=YES;
    inputView.image =[UIImage imageNamed:@"login_email_password.png"];
    [self.view addSubview:inputView];
    
    emailTextfield=[ZCControl createTextFieldWithFrame:CGRectMake(10, 2, 220,37) placeholder:@"请输入邮箱" passWord:NO leftImageView:nil rightImageView:nil Font:15];
    [inputView addSubview:emailTextfield];
    
    
    
    UIButton  *rightButton =[ZCControl createButtonWithFrame:CGRectMake(0,0, 24, 16) ImageName:nil Target:self Action:@selector(loginClick:) Title:nil];
    //[rightButton setBackgroundImage:[UIImage imageNamed:@"login_password_close.png"] forState:UIControlStateSelected];
    [rightButton setImage:[UIImage imageNamed:@"login_password_open@2x.png"] forState:UIControlStateNormal];
    [rightButton setImage:[UIImage imageNamed:@"ogin_password_close.png"] forState:UIControlStateSelected];

    rightButton.tag=99;
 

    
    PassworfTextfield=[ZCControl createTextFieldWithFrame:CGRectMake(10, 39, 230,39) placeholder:@"请输入密码" passWord:YES leftImageView:nil rightImageView:nil Font:15];
    PassworfTextfield.rightView=rightButton;
    PassworfTextfield.rightViewMode=UITextFieldViewModeAlways;
    [inputView addSubview:PassworfTextfield];
    
    UIButton  *loginButton =[ZCControl createButtonWithFrame:CGRectMake((kDeviceWidth-230)/2, inputView.frame.origin.y+inputView.frame.size.height+20, 230, 40) ImageName:@"login_normal.png" Target:self Action:@selector(loginClick:) Title:nil];
    loginButton.tag=100;
    [self.view addSubview:loginButton];
    
    UIButton  *forgetButton =[ZCControl createButtonWithFrame:CGRectMake((kDeviceWidth-100)/2, loginButton.frame.origin.y+loginButton.frame.size.height+20, 100, 40) ImageName:nil Target:self Action:@selector(loginClick:) Title:@"忘记密码"];
    forgetButton.tag=101;
    forgetButton.titleLabel.font =[UIFont boldSystemFontOfSize:16];
    [self.view addSubview:forgetButton];

}
-(void)loginClick:(UIButton *) button
{
    if (button.tag==98) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    if (button.tag==99) {
        //显示密码隐藏密码
    }
    if (button.tag==100) {
        //登陆,登陆完成后设置根视图控制器
        
    }
    else if (button.tag==101)
    {
        //忘记密码
    }
    
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
