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
#import "Function.h"
#import "AppDelegate.h"
#import "CustmoTabBarController.h"

@interface Login2_1ViewController ()<UITextFieldDelegate>
{
    AppDelegate  *appdelegate;
    UIWindow     *window;
    UIImageView  *inputView;
    UIButton    *loginButton;
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

-(void)viewDidLoad {
    [super viewDidLoad];
    appdelegate = [[UIApplication sharedApplication]delegate];
    window=appdelegate.window;
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    [self createNavgaition];
    [self createUI];
    
    //键盘将要显示
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //键盘将要隐藏
    [[NSNotificationCenter defaultCenter ]addObserver:self selector:@selector(keyboardWillHiden:) name:UIKeyboardWillHideNotification object:nil];
    
}
#pragma mark 键盘的通知事件
-(void)keyboardWillShow:(NSNotification * )  notification
{
    [UIView animateWithDuration:0.2 animations:^{
        inputView.frame =CGRectMake(inputView.frame.origin.x, 120, inputView.frame.size.width, inputView.frame.size.height);
        loginButton.frame=CGRectMake(loginButton.frame.origin.x,120+79+20, loginButton.frame.size.width, loginButton.frame.size.height);
    }];
    
}
-(void)keyboardWillHiden:(NSNotification *) notification
{
    [UIView animateWithDuration:0.2 animations:^{
        inputView.frame =CGRectMake(inputView.frame.origin.x, 200, inputView.frame.size.width, inputView.frame.size.height);
        loginButton.frame=CGRectMake(loginButton.frame.origin.x,200+79+20, loginButton.frame.size.width, loginButton.frame.size.height);
    }];
    
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
    
    
    inputView=[[UIImageView alloc]initWithFrame:CGRectMake((kDeviceWidth-250)/2, 200, 250, 79)];
    inputView.userInteractionEnabled=YES;
    inputView.image =[UIImage imageNamed:@"login_email_password.png"];
    [self.view addSubview:inputView];
    
    emailTextfield=[ZCControl createTextFieldWithFrame:CGRectMake(10, 2, 230,37) placeholder:@"请输入邮箱" passWord:NO leftImageView:nil rightImageView:nil Font:15];
    emailTextfield.delegate=self;
    //emailTextfield.text=@"673229963@qq.com";
    [inputView addSubview:emailTextfield];
    
    
    
    UIButton  *rightButton =[ZCControl createButtonWithFrame:CGRectMake(0,0, 24, 16) ImageName:nil Target:self Action:@selector(loginClick:) Title:nil];
    //[rightButton setBackgroundImage:[UIImage imageNamed:@"login_password_close.png"] forState:UIControlStateSelected];
    [rightButton setImage:[UIImage imageNamed:@"login_password_open.png"] forState:UIControlStateNormal];
    [rightButton setImage:[UIImage imageNamed:@"login_password_close.png"] forState:UIControlStateSelected];
    
    rightButton.tag=99;
    
    
    PassworfTextfield=[ZCControl createTextFieldWithFrame:CGRectMake(10, 39, 230,39) placeholder:@"请输入密码" passWord:YES leftImageView:nil rightImageView:nil Font:15];
    PassworfTextfield.rightView=rightButton;
    PassworfTextfield.delegate=self;
    //PassworfTextfield.text=@"123";
    PassworfTextfield.rightViewMode=UITextFieldViewModeAlways;
    [inputView addSubview:PassworfTextfield];
    
    loginButton =[ZCControl createButtonWithFrame:CGRectMake((kDeviceWidth-230)/2, inputView.frame.origin.y+inputView.frame.size.height+20, 230, 40) ImageName:@"login_normal.png" Target:self Action:@selector(loginClick:) Title:nil];
    loginButton.tag=100;
    [self.view addSubview:loginButton];
    
    UIButton  *forgetButton =[ZCControl createButtonWithFrame:CGRectMake((kDeviceWidth-100)/2, loginButton.frame.origin.y+loginButton.frame.size.height+20, 100, 40) ImageName:nil Target:self Action:@selector(loginClick:) Title:@"忘记密码"];
    forgetButton.tag=101;
    forgetButton.titleLabel.font =[UIFont fontWithName:kFontDouble size:16];
    [self.view addSubview:forgetButton];
    
}


//用户登录
-(void)requesteLogin
{
    NSString *urlString = [NSString stringWithFormat:@"%@/user/login-with-email", kApiBaseUrl];
    NSString *tokenString =[Function getURLtokenWithURLString:urlString];
    NSString  *email=[[emailTextfield text]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *password =[[PassworfTextfield text] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString  *passstr=[NSString stringWithFormat:@"%@movienext%@",email,password];
    NSString  *pass_hash=[Function  md5:passstr];
    //NSString  *abc=[Function md5:@"abc@qq.commovienext123456"];
    NSDictionary *parameters = @{@"email":email,@"password_hash":pass_hash,KURLTOKEN:tokenString};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"esdksdhhsd=====%@",responseObject);
        if ([[responseObject  objectForKey:@"code"]  intValue]==0) {
            //登陆成功
            window.rootViewController=[CustmoTabBarController new];
            NSDictionary *detail    = [responseObject objectForKey:@"model"];
            
            UserDataCenter  *userCenter=[UserDataCenter shareInstance];
            userCenter.user_id=[detail objectForKey:@"id"];
            userCenter.username=[detail objectForKey:@"username"];
            userCenter.logo =[detail objectForKey:@"logo"];
            userCenter.is_admin =[detail objectForKey:@"role_id"];
            userCenter.verified=[detail objectForKey:@"verified"];
            userCenter.sex=[detail objectForKey:@"sex"];
            userCenter.signature=[detail objectForKey:@"brief"];
            userCenter.email=[detail objectForKey:@"email"];
            userCenter.fake=[detail objectForKey:@"fake"];
            [Function saveUser:userCenter];
            
        }
        else
        {
            UIAlertView  *Al=[[UIAlertView alloc]initWithTitle:nil message:@"对不起，用户名或密码错误，请重新输入" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [Al show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}


-(void)loginClick:(UIButton *) button
{
    if (button.tag==98) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    if (button.tag==99) {
        //显示密码隐藏密码
        if (button.selected==YES) {
            button.selected=NO;
            PassworfTextfield.secureTextEntry=YES;
            
        }
        else
        {
            button.selected=YES;
            PassworfTextfield.secureTextEntry=NO;
        }
    }
    if (button.tag==100) {
        //登陆,登陆完成后设置根视图控制器
        [emailTextfield resignFirstResponder];
        [PassworfTextfield resignFirstResponder];
        if ([Function isBlankString:emailTextfield.text]==YES||[Function isBlankString:[PassworfTextfield text]]==YES) {
            UIAlertView  *Al=[[UIAlertView alloc]initWithTitle:nil message:@"对不起，邮箱或密码不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [Al show];
            return;
        }
        else
        {
            
            [self requesteLogin];
            
        }
        
        
        
    }
    else if (button.tag==101)
    {
        //忘记密码
        
        
        
    }
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [emailTextfield resignFirstResponder];
    [PassworfTextfield resignFirstResponder];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [emailTextfield resignFirstResponder];
    [PassworfTextfield resignFirstResponder];
    return YES;
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
