//
//  Register_1ViewController.m
//  movienext
//
//  Created by 风之翼 on 15/4/14.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "Register_1ViewController.h"
#import "ZCControl.h"
#import "Constant.h"
#import "Register_2ViewController.h"
@interface Register_1ViewController ()<UITextFieldDelegate>
{
    UITextField  *emailTextfield;
    UITextField  *PassworfTextfield;

}
@end

@implementation Register_1ViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden=NO;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor =[UIColor whiteColor];
    [self createNavigition];
    [self createUI];
    
}
-(void)createNavigition
{
    UILabel  *titleLable=[ZCControl createLabelWithFrame:CGRectMake(0, 0, 100, 20) Font:16 Text:@"注册"];
    titleLable.textColor=VBlue_color;
    titleLable.font=[UIFont boldSystemFontOfSize:16];
    titleLable.textAlignment=NSTextAlignmentCenter;
    self.navigationItem.titleView=titleLable;
    
    
    UIButton  *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"取消" forState:UIControlStateNormal];
    button.titleLabel.font =[UIFont boldSystemFontOfSize:16];
    [button setTitleColor:VBlue_color forState:UIControlStateNormal];
    //[button setBackgroundImage:[UIImage imageNamed:@"setting.png"] forState:UIControlStateNormal];
    button.frame=CGRectMake(10, 5, 40, 40);
    [button addTarget:self action:@selector(dealregiterClick:) forControlEvents:UIControlEventTouchUpInside];
    button.tag=99;
    UIBarButtonItem  *barButton=[[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem=barButton;

}
-(void)createUI
{
    UIImageView  *bgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    bgView.image =[ UIImage imageNamed:@"login_background.png"];
    bgView.userInteractionEnabled=YES;
    [self.view addSubview:bgView];
    
    
    UIView  *left1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 20)];
    UIView  *left2=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 20)];

    emailTextfield=[ZCControl createTextFieldWithFrame:CGRectMake((kDeviceWidth-240)/2, 125, 240,40) placeholder:@"请输入邮箱" passWord:NO leftImageView:nil rightImageView:nil Font:15];
    emailTextfield.backgroundColor=[UIColor whiteColor];
    emailTextfield.layer.cornerRadius=4;
    emailTextfield.clipsToBounds=YES;
    emailTextfield.delegate=self;
    emailTextfield.leftView=left1;
    [self.view addSubview:emailTextfield];
    
    
    
    UIButton  *rightButton =[ZCControl createButtonWithFrame:CGRectMake(0,0, 24, 16) ImageName:nil Target:self Action:@selector(dealregiterClick:) Title:nil];
    //[rightButton setBackgroundImage:[UIImage imageNamed:@"login_password_close.png"] forState:UIControlStateSelected];
    [rightButton setImage:[UIImage imageNamed:@"login_password_open@2x.png"] forState:UIControlStateNormal];
    [rightButton setImage:[UIImage imageNamed:@"ogin_password_close.png"] forState:UIControlStateSelected];
    rightButton.tag=100;
    
    
    
    PassworfTextfield=[ZCControl createTextFieldWithFrame:CGRectMake(emailTextfield.frame.origin.x, emailTextfield.frame.origin.y+emailTextfield.frame.size.height+20, 240,40) placeholder:@"请输入密码" passWord:YES leftImageView:nil rightImageView:nil Font:15];
    PassworfTextfield.rightView=rightButton;
    PassworfTextfield.layer.cornerRadius=4;
    PassworfTextfield.clipsToBounds=YES;
    PassworfTextfield.delegate=self;
    PassworfTextfield.backgroundColor=[UIColor whiteColor];
    PassworfTextfield.rightViewMode=UITextFieldViewModeAlways;
    PassworfTextfield.leftView=left2;
    [self.view addSubview:PassworfTextfield];
    
    UIButton  *loginButton =[ZCControl createButtonWithFrame:CGRectMake((kDeviceWidth-200)/2,PassworfTextfield.frame.origin.y+PassworfTextfield.frame.size.height+20, 200, 40) ImageName:@"signup_sure_press.png" Target:self Action:@selector(dealregiterClick:) Title:nil];
    loginButton.tag=101;
    [self.view addSubview:loginButton];

    
}
-(void)dealregiterClick:(UIButton *) button
{
    if (button.tag==99) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else if (button.tag==100)
    {
        
    }
    else if(button.tag==101)
    {
      
        Register_2ViewController  *reg =[[Register_2ViewController alloc]init];
        [self.navigationController pushViewController:reg animated:YES];
    }
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField==emailTextfield) {
        [emailTextfield resignFirstResponder];
        [PassworfTextfield becomeFirstResponder];
    }
    return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [emailTextfield resignFirstResponder];
    [PassworfTextfield resignFirstResponder];
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
