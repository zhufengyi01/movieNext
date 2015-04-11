//
//  LoginViewController.m
//  movienext
//
//  Created by 风之翼 on 15/2/27.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "LoginViewController.h"
#import "Masonry.h"
#import "AppDelegate.h"
//#import "MASConstraint.h"
#import "MASConstraintMaker.h"
#import "CustmoTabBarController.h"
#import "Constant.h"
//#import "User.h"       //用户模型
#import "UMSocial.h"
#import "UMSocialControllerService.h"
#import "AFNetworking.h"
#import "Function.h"
#import "UserDataCenter.h"
#import "UMSocialWechatHandler.h"
#import "ZCControl.h"
#import "SerViceViewController.h"
#import "UserHeadChangeViewController.h"
//#define kSegueLoginToIndex @"LoginToIndex"

@interface LoginViewController ()<UMSocialUIDelegate>
{
    AppDelegate  *appdelegate;
    UIWindow     *window;
    NSString     *ssoName;
    
    UIButton  *weiChateButton;
    UIButton  *weiboButton;
    UIButton  *checkBtn;
    UIButton  *checkBtn2;
    
}
@end

@implementation LoginViewController
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden=YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden=NO;
    appdelegate = [[UIApplication sharedApplication]delegate];
    window=appdelegate.window;
    self.view.backgroundColor=[UIColor whiteColor];
    [self creatUI];
}
-(void)creatUI
{
    UIImageView   *logoImageView=[[UIImageView alloc]initWithFrame:CGRectMake((kDeviceWidth-180)/2, 125, 180, 125)];
    logoImageView.image=[UIImage imageNamed:@"first_screen_slogan.png"];
    [self.view addSubview:logoImageView];
    
    
    
    checkBtn=[ZCControl createButtonWithFrame:CGRectMake((kDeviceWidth-140)/2,kDeviceHeight-40, 140, 30) ImageName:nil Target:self Action:@selector(checkClick:) Title:@""];
  //   checkBtn.backgroundColor=[UIColor redColor];
    [checkBtn setImage:[UIImage imageNamed:@"unselect_icon.png"] forState:UIControlStateNormal];
    [checkBtn setImage:[UIImage imageNamed:@"selected_icon.png"] forState:UIControlStateSelected];
    //默认勾选状态
    checkBtn.selected=YES;
    checkBtn.tag=100;
    [checkBtn setTitleColor:VGray_color forState:UIControlStateNormal];
    [checkBtn setTitle:@"登录注册成功，即接受" forState:UIControlStateNormal];
    [checkBtn setTitleEdgeInsets:UIEdgeInsetsMake(5, 5, 0, 0)];
   // checkBtn.backgroundColor=[UIColor redColor];
    [checkBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 0, 0, 0)];
    checkBtn.titleLabel.font=[UIFont systemFontOfSize:12];
    [self.view addSubview:checkBtn];
    
    
    checkBtn2=[ZCControl createButtonWithFrame:CGRectMake(checkBtn.frame.origin.x+checkBtn.frame.size.width,checkBtn.frame.origin.y, 120, 30) ImageName:nil Target:self Action:@selector(checkClick:) Title:@""];
    [checkBtn2 setTitleEdgeInsets:UIEdgeInsetsMake(5, 0, 0, 0)];
     //checkBtn2.backgroundColor=[UIColor blackColor];
    [checkBtn2 setTitle:@"《影弹服务使用条款》" forState:UIControlStateNormal];
    [checkBtn2 setTitleColor:VGray_color forState:UIControlStateNormal];
    checkBtn2.tag=101;
    
    checkBtn2.titleLabel.font=[UIFont systemFontOfSize:12];
    [self.view addSubview:checkBtn2];
    checkBtn.frame=CGRectMake((kDeviceWidth-checkBtn.frame.size.width-checkBtn2.frame.size.width)/2, checkBtn.frame.origin.y, checkBtn.frame.size.width, checkBtn.frame.size.height);
    checkBtn2.frame=CGRectMake(checkBtn.frame.origin.x+checkBtn.frame.size.width, checkBtn.frame.origin.y, checkBtn2.frame.size.width, checkBtn2.frame.size.height);
    


//    
//    UIButton  *qqButton=[UIButton buttonWithType:UIButtonTypeCustom];
//    qqButton.frame=CGRectMake(50, kDeviceHeight-220, kDeviceWidth-100, 40);
//    [qqButton setBackgroundImage:[UIImage imageNamed:@"login_button_qq －in.png"] forState:UIControlStateNormal];
//    [qqButton setBackgroundImage:[UIImage imageNamed:@"login_button_qq.png"] forState:UIControlStateHighlighted];
// 
//    [qqButton addTarget:self action:@selector(dealloginClick:) forControlEvents:UIControlEventTouchUpInside];
//    qqButton.tag=1000;
//    //[self.view addSubview:qqButton];
//    
    weiboButton=[UIButton buttonWithType:UIButtonTypeCustom];
    weiboButton.frame=CGRectMake((kDeviceWidth-231)/2, kDeviceHeight-170, 231, 40);
    [weiboButton setBackgroundImage:[UIImage imageNamed:@"login_button_sina.png"] forState:UIControlStateNormal];
    [weiboButton setBackgroundImage:[UIImage imageNamed:@"login_button_sina_press@2x.png"] forState:UIControlStateHighlighted];
    [weiboButton addTarget:self action:@selector(dealloginClick:) forControlEvents:UIControlEventTouchUpInside];
    weiboButton.tag=1001;
   // weiboButton.userInteractionEnabled=NO;
   // if (checkBtn.selected==YES) {
        weiboButton.userInteractionEnabled=YES;
    //}
    [self.view addSubview:weiboButton];
    
    
    
    weiChateButton=[UIButton buttonWithType:UIButtonTypeCustom];
    weiChateButton.frame=CGRectMake((kDeviceWidth-231)/2, kDeviceHeight-120, 231, 40);
    [weiChateButton setBackgroundImage:[UIImage imageNamed:@"login_button_wechat.png"] forState:UIControlStateNormal];
    [weiChateButton setBackgroundImage:[UIImage imageNamed:@"login_button_wechat_press.png"] forState:UIControlStateHighlighted];
   // weiChateButton.userInteractionEnabled=NO;
    //if (checkBtn.selected==YES) {
        weiChateButton.userInteractionEnabled=YES;
    //}
    //[weiChateButton setTitle:@"登陆" forState:UIControlStateNormal];
    [weiChateButton addTarget:self action:@selector(dealloginClick:) forControlEvents:UIControlEventTouchUpInside];
    weiChateButton.tag=1002;
    
    [self.view addSubview:weiChateButton];

    
    
    
    

}
//服务条款按钮
-(void)checkClick:(UIButton *) button
{
    if (button==checkBtn) {
        if (checkBtn.selected==YES) {
            weiboButton.userInteractionEnabled=NO;
            weiChateButton.userInteractionEnabled=NO;
            button.selected=NO;
        }
        else if (checkBtn.selected==NO)
        {
            weiChateButton.userInteractionEnabled=YES;
            weiboButton.userInteractionEnabled=YES;
            button.selected=YES;
        }
    }
    else if(button==checkBtn2)
    {
        
       [self.navigationController pushViewController:[SerViceViewController new] animated:YES];
     }
    
}
//登陆按钮
-(void)dealloginClick:(UIButton *) btn
{
    if (btn.tag==1000) {
        //qq  登陆
        //window.rootViewController=[CustmoTabBarController new];
        ssoName =UMShareToQzone;
        NSLog(@"  点击了登陆qq");
        [self loginSocialPlatformWithName];
        }
    else if (btn.tag==1001)
    {
        //微博登陆
        ssoName = UMShareToSina;
        NSLog(@"  点击了登陆sina");

        [self loginSocialPlatformWithName];
    }
    else if (btn.tag==1002)
    {
        ssoName=UMShareToWechatSession;
        [self loginSocialPlatformWithName];
    }
}
/**
 *  用SOS登录
 */
- (void)loginSocialPlatformWithName
{
    [UMSocialControllerService defaultControllerService].socialUIDelegate = self;
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:ssoName];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            [[UMSocialDataService defaultDataService] requestSnsInformation:ssoName completion:^(UMSocialResponseEntity *response) {
                if (response.responseCode == UMSResponseCodeSuccess) {
                    NSLog(@"====  login sucess  =response ======%@",[response valueForKey:@"data"]);
                    NSDictionary *data = [response valueForKey:@"data"];
                   //openid
                    NSString  *openid;
                    if ([ssoName isEqualToString:UMShareToSina]) {
                         openid   = [data valueForKey:@"uid"];

                    }
                    else{
                        openid =[data valueForKey:@"openid"];

                    }
                    //token
                    NSString *access_token   = [data valueForKey:@"access_token"];
                   //username
                    NSString *screen_name    = [data valueForKey:@"screen_name"];
                  //brief
                    NSString *brief=@"";
                    if ([ssoName isEqualToString:UMShareToSina]) {
                        brief= [data valueForKey:@"description"];
                    }
                    //sex
                    NSString  *sex=[data objectForKey:@"gender"];
                    NSString  *verified=@"0";
                    NSString *bingdtype=ssoName;
                    //logo
                    NSString  *logo=[data objectForKey:@"profile_image_url"];
                    
                    
                    
//                    NSString *profile_image_url = [data valueForKey:@"profile_image_url"];
//                    NSString *gender = [[data valueForKeyPath:@"gender"] isKindOfClass:[NSString class]] ? [data valueForKey:@"gender"] : [[data valueForKey:@"gender"] stringValue];
//                    gender = [gender isEqualToString:@"男"] ? @"1" : ([gender isEqualToString:@"女"] ? @"0" : gender);
//                    NSString *verified = [data valueForKeyPath:@"verified"];
//                    
//                    
//                    NSMutableDictionary * parameters = [NSMutableDictionary dictionaryWithCapacity:0];
//                    //用户名
//                    [parameters setObject:screen_name ? screen_name : @""  forKey:@"username"];
//                    //openid
//                    [parameters setObject:uid ? uid : @"" forKey:@"openid"];
//                    
//                    if ([ssoName isEqualToString:UMShareToWechatSession]) {
//                        [parameters setObject:[data objectForKey:@"openid"] forKey:@"openid"];
//                    }
//                    //头像
//                    [parameters setObject:profile_image_url ? profile_image_url : @"" forKey:@"logo"];
//                    
//                    //token
//                    [parameters setObject:access_token ? access_token : @"" forKey:@"token"];
//                    
//                 
//                    if (![ssoName isEqualToString:UMShareToWechatSession]) {
//                    [parameters setObject:description forKey:@"brief"];
//                    }
//                    
//                    //绑定类型
//                    [parameters setObject:ssoName forKey:@"bindtype"];
//                    ///性别
//                    [parameters setObject:gender forKey:@"gender"];
//                    
//                    if (![ssoName isEqualToString:UMShareToWechatSession]) {
//                        [parameters setObject:verified forKey:@"verified"];
//
//                    }
                  //  NSLog(@"打印参数=== weixin =======%@",parameters);
                    NSDictionary  *parameters=@{@"openid":openid,@"token":access_token,@"username":screen_name,@"brief":brief,@"sex":sex,@"verified":verified,@"bindtype":bingdtype,@"logo":logo};
                    
                    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                    [manager POST:[NSString stringWithFormat:@"%@/user/login", kApiBaseUrl] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        NSLog(@"登陆完成后的     JSON: %@", responseObject);
                        NSDictionary *detail    = [responseObject objectForKey:@"model"];
                        if (![detail isEqual:@""]) {
                            UserDataCenter  *userCenter=[UserDataCenter shareInstance];
                            userCenter.user_id=[detail objectForKey:@"id"];
                            userCenter.username=[detail objectForKey:@"username"];
                            userCenter.logo =[detail objectForKey:@"logo"];
                            userCenter.is_admin =[detail objectForKey:@"role_id"];
                            userCenter.verified=[detail objectForKey:@"verified"];
                            userCenter.sex=[detail objectForKey:@"sex"];
                            userCenter.signature=[detail objectForKey:@"brief"];
                            userCenter.fake=[detail objectForKey:@"fake"];
                            
                            [Function saveUser:userCenter];
                            //登陆成功后把根
                            [self.navigationController pushViewController:[UserHeadChangeViewController new] animated:YES];
                          //  [self presentViewController:[UserHeadChangeViewController new ] animated:YES completion:nil];
                           // window.rootViewController=[CustmoTabBarController new];
                        }
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        NSLog(@"Error: %@", error);
                        
                    }];
                    
                } else {
                    //                    [self dealErrorCase];
                }
            }];
        } else {
            //            [self dealErrorCase];
        }
    });
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
