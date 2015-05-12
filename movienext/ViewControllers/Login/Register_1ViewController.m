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
#import "Function.h"
#import "Register_2ViewController.h"
#import "AFNetworking.h"
@interface Register_1ViewController ()<UITextFieldDelegate,UIAlertViewDelegate>
{
    UITextField  *emailTextfield;
    UITextField  *PassworfTextfield;
    UIImageView  *bgView;

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
    //键盘将要显示
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //键盘将要隐藏
    [[NSNotificationCenter defaultCenter ]addObserver:self selector:@selector(keyboardWillHiden:) name:UIKeyboardWillHideNotification object:nil];
    

    
}

#pragma mark 键盘的通知事件
-(void)keyboardWillShow:(NSNotification * )  notification
{
    
    
    [UIView animateWithDuration:0.2 animations:^{
        bgView.frame =CGRectMake(0, -40,kDeviceWidth, kDeviceHeight);
     }];
    
}
-(void)keyboardWillHiden:(NSNotification *) notification
{
    [UIView animateWithDuration:0.2 animations:^{
        bgView.frame =CGRectMake(0, 0,kDeviceWidth,kDeviceHeight);
     }];
    
}

-(void)createNavigition
{
    UILabel  *titleLable=[ZCControl createLabelWithFrame:CGRectMake(0, 0, 100, 20) Font:16 Text:@"注册"];
    titleLable.textColor=VBlue_color;
    titleLable.font=[UIFont boldSystemFontOfSize:18];
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
    bgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    bgView.image =[ UIImage imageNamed:@"login_background.png"];
    bgView.userInteractionEnabled=YES;
    [self.view addSubview:bgView];
    
    
    UIView  *left1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 20)];
    UIView  *left2=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 20)];

    emailTextfield=[ZCControl createTextFieldWithFrame:CGRectMake((kDeviceWidth-240)/2, 125, 240,40) placeholder:@"请输入邮箱" passWord:NO leftImageView:nil rightImageView:nil Font:15];
    emailTextfield.backgroundColor=[UIColor whiteColor];
    emailTextfield.layer.cornerRadius=4;
    emailTextfield.clipsToBounds=YES;
   // emailTextfield.text=@"673229963@qq.com";
    emailTextfield.delegate=self;
    emailTextfield.leftView=left1;
    [bgView addSubview:emailTextfield];
    
    
    
    UIButton  *rightButton =[ZCControl createButtonWithFrame:CGRectMake(0,0, 24, 16) ImageName:nil Target:self Action:@selector(dealregiterClick:) Title:nil];
    //[rightButton setBackgroundImage:[UIImage imageNamed:@"login_password_close.png"] forState:UIControlStateSelected];
    [rightButton setImage:[UIImage imageNamed:@"login_password_open.png"] forState:UIControlStateNormal];
    [rightButton setImage:[UIImage imageNamed:@"login_password_close.png"] forState:UIControlStateSelected];
    rightButton.tag=100;
    
    
    
    PassworfTextfield=[ZCControl createTextFieldWithFrame:CGRectMake(emailTextfield.frame.origin.x, emailTextfield.frame.origin.y+emailTextfield.frame.size.height+20, 240,40) placeholder:@"请输入密码" passWord:YES leftImageView:nil rightImageView:nil Font:15];
    PassworfTextfield.rightView=rightButton;
    PassworfTextfield.layer.cornerRadius=4;
    PassworfTextfield.clipsToBounds=YES;
    PassworfTextfield.delegate=self;
   // PassworfTextfield.text=@"123";
    PassworfTextfield.backgroundColor=[UIColor whiteColor];
    PassworfTextfield.rightViewMode=UITextFieldViewModeAlways;
    PassworfTextfield.leftView=left2;
    [bgView addSubview:PassworfTextfield];
    
    UIButton  *loginButton =[ZCControl createButtonWithFrame:CGRectMake((kDeviceWidth-200)/2,PassworfTextfield.frame.origin.y+PassworfTextfield.frame.size.height+20, 200, 40) ImageName:@"signup_sure_press.png" Target:self Action:@selector(dealregiterClick:) Title:nil];
    loginButton.tag=101;
    [bgView addSubview:loginButton];

    
}
#pragma mark  ---------------requestData

//验证邮箱是否可用
-(void)requestemailvalidateData
{
    NSDictionary *parameters = @{@"email":emailTextfield.text};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/user/checkemailvalid", kApiBaseUrl] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
#warning  需要替换成exists
        
        if ([[responseObject  objectForKey:@"code"]  intValue]==0) {
            Register_2ViewController  *reg =[[Register_2ViewController alloc]init];
            reg.email=[emailTextfield text];
            reg.password=[PassworfTextfield text];
            [self.navigationController pushViewController:reg animated:YES];

        }
        else
        {
            UIAlertView  *Al=[[UIAlertView alloc]initWithTitle:nil message:@"对不起，该邮箱已注册" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [Al show];

        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}


-(void)dealregiterClick:(UIButton *) button
{
    if (button.tag==99) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else if (button.tag==100)
    {
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
    else if(button.tag==101)
    {
        
        
        if ([Function isBlankString:emailTextfield.text]==YES||[Function isBlankString:[PassworfTextfield text]]==YES) {
            UIAlertView  *Al=[[UIAlertView alloc]initWithTitle:nil message:@"对不起，邮箱或密码不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [Al show];
            return;

        }
        if (PassworfTextfield.text.length<6||PassworfTextfield.text.length>18) {
            
            UIAlertView  *Al=[[UIAlertView alloc]initWithTitle:nil message:@"密码长度为8～16位字符" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [Al show];
            return;

        }
        if ([Function validateEmail:emailTextfield.text]==NO) {
            
            UIAlertView  *Al=[[UIAlertView alloc]initWithTitle:nil message:@"对不起，请输入正确的邮箱" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [Al show];
            return;
            
        }
         else
        {
            [self requestemailvalidateData];
        }
    }
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //if (textField==emailTextfield) {
        [emailTextfield resignFirstResponder];
       [PassworfTextfield resignFirstResponder];
    //}
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
