//
//  ChangeUsernameViewController.m
//  movienext
//
//  Created by 风之翼 on 15/4/3.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "ChangeUsernameViewController.h"
#import "ZCControl.h"
#import "Constant.h"
@interface ChangeUsernameViewController ()<UITextFieldDelegate>
{
    UITextField  *nanmeText;
}
@end

@implementation ChangeUsernameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=View_BackGround;
    UILabel  *label= [ZCControl createLabelWithFrame:CGRectMake((kDeviceWidth-200)/2, 30, 200, 40) Font:16 Text:@"修改昵称"];
    label.font=[UIFont boldSystemFontOfSize:16];
    label.textAlignment=NSTextAlignmentCenter;
    label.textColor=VBlue_color;
    self.navigationItem.titleView=label;
    
    
    UIButton  *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"确定" forState:UIControlStateNormal];
    //[button setBackgroundImage:[UIImage imageNamed:@"setting.png"] forState:UIControlStateNormal];
    button.frame=CGRectMake(kDeviceWidth-50, 10, 40,40);
    [button setTitleColor:VBlue_color forState:UIControlStateNormal];
    [button addTarget:self action:@selector(ChangeUserNameClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem  *barButton=[[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem=barButton;
    
    [self createTextField];

}
//点击确定
-(void)ChangeUserNameClick
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(changeUserName:)]) {
        [self.delegate changeUserName:nanmeText.text];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
-(void)createTextField
{
    nanmeText =[[UITextField alloc]initWithFrame:CGRectMake(0, 64, kDeviceWidth, 40)];
    nanmeText.placeholder=@"输入新的昵称";
    nanmeText.delegate=self;
    [nanmeText  becomeFirstResponder];
    nanmeText.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:nanmeText];
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
