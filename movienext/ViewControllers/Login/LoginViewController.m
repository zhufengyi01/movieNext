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

#define kSegueLoginToIndex @"LoginToIndex"

@interface LoginViewController ()<UMSocialUIDelegate>
{
    AppDelegate  *appdelegate;
    UIWindow     *window;
    NSString     *ssoName;
    
}
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    appdelegate = [[UIApplication sharedApplication]delegate ];
    window=appdelegate.window;
    self.view.backgroundColor=[UIColor whiteColor];
    [self creatUI];
}
-(void)creatUI
{
   /* UILabel  *TitleLable=[[UILabel alloc] init];//initWithFrame:CGRectMake(100, 150, 100, 80)]
    TitleLable.frame=CGRectMake((kDeviceWidth-100)/2, 60, 100, 80);
    TitleLable.text=@"影记";
    TitleLable.textColor=[UIColor redColor];
    TitleLable.textAlignment=NSTextAlignmentCenter;
    TitleLable.font=[UIFont boldSystemFontOfSize:24];
    [self.view addSubview:TitleLable];    
    //[TitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.centerX.equalTo(self.view.mas_centerX);  //水平居中
        //make.size.mas_equalTo(CGSizeMake(100, 100));  //宽高
      //  make.top.equalTo(self.view).width.offset(150);  //设置距离最上面高度
        //make.edges.equalTo(self.view).width.insets(UIEdgeInsetsMake(kDeviceHeight-100, 0, 0, 0));
      //  make.centerX.equalTo(self.view.mas_centerX);  //水平居中

    //}];
    
    UILabel  *DetailTitleLable=[[UILabel alloc]initWithFrame:CGRectMake((kDeviceWidth-100)/2, 100, 100, 60)];
    DetailTitleLable.text=@"看完电影上影记";
    DetailTitleLable.textColor=[UIColor redColor];
    DetailTitleLable.textAlignment=NSTextAlignmentCenter;
    DetailTitleLable.font=[UIFont boldSystemFontOfSize:14];
    [self.view addSubview:DetailTitleLable];
    */
    
    UIImageView   *logoImageView=[[UIImageView alloc]initWithFrame:CGRectMake((kDeviceWidth-180)/2, 125, 180, 125)];
    logoImageView.image=[UIImage imageNamed:@"first_screen_slogan.png"];
    [self.view addSubview:logoImageView];
    
    
    UIButton  *qqButton=[UIButton buttonWithType:UIButtonTypeCustom];
    qqButton.frame=CGRectMake(50, kDeviceHeight-220, kDeviceWidth-100, 40);
    [qqButton setBackgroundImage:[UIImage imageNamed:@"login_button_qq －in.png"] forState:UIControlStateNormal];
    [qqButton setBackgroundImage:[UIImage imageNamed:@"login_button_qq.png"] forState:UIControlStateHighlighted];
 
    [qqButton addTarget:self action:@selector(dealloginClick:) forControlEvents:UIControlEventTouchUpInside];
    qqButton.tag=1000;
    //[self.view addSubview:qqButton];
    
    UIButton  *weiboButton=[UIButton buttonWithType:UIButtonTypeCustom];
    weiboButton.frame=CGRectMake((kDeviceWidth-231)/2, kDeviceHeight-160, 231, 40);
    [weiboButton setBackgroundImage:[UIImage imageNamed:@"login_button_sina.png"] forState:UIControlStateNormal];
    [weiboButton setBackgroundImage:[UIImage imageNamed:@"login_button_sina －in.png"] forState:UIControlStateHighlighted];
    [weiboButton addTarget:self action:@selector(dealloginClick:) forControlEvents:UIControlEventTouchUpInside];
    weiboButton.tag=1001;

    [self.view addSubview:weiboButton];
    
    
    
    UIButton  *weiChateButton=[UIButton buttonWithType:UIButtonTypeCustom];
    weiChateButton.frame=CGRectMake((kDeviceWidth-231)/2, kDeviceHeight-110, 231, 40);
    [weiChateButton setBackgroundImage:[UIImage imageNamed:@"login_button_wechat.png"] forState:UIControlStateNormal];
    [weiChateButton setBackgroundImage:[UIImage imageNamed:@"login_button_wechat_press.png"] forState:UIControlStateHighlighted];
    //[weiChateButton setTitle:@"登陆" forState:UIControlStateNormal];
    [weiChateButton addTarget:self action:@selector(dealloginClick:) forControlEvents:UIControlEventTouchUpInside];
    weiChateButton.tag=1002;
    
    [self.view addSubview:weiChateButton];

    
}
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
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],NO,^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            [[UMSocialDataService defaultDataService] requestSnsInformation:ssoName completion:^(UMSocialResponseEntity *response) {
                if (response.responseCode == UMSResponseCodeSuccess) {
                   // NSLog(@"====  weixxin  =response ======%@",[response valueForKey:@"data"]);
                    NSDictionary *data = [response valueForKey:@"data"];
                    NSString * uid            = [data valueForKey:@"uid"];

                    NSString *description    = [data valueForKey:@"description"];
                    NSString *profile_image_url = [data valueForKey:@"profile_image_url"];
                    NSString *screen_name    = [data valueForKey:@"screen_name"];
                    NSString *access_token   = [data valueForKey:@"access_token"];
                    NSString *gender = [[data valueForKeyPath:@"gender"] isKindOfClass:[NSString class]] ? [data valueForKey:@"gender"] : [[data valueForKey:@"gender"] stringValue];
                    gender = [gender isEqualToString:@"男"] ? @"1" : ([gender isEqualToString:@"女"] ? @"0" : gender);
                    NSString *verified = [data valueForKeyPath:@"verified"];
                     if ([ssoName isEqualToString:UMShareToWechatSession]) {
                       uid =[data valueForKey:@"openid"];
                         
                    }

                    
                    
                    NSMutableDictionary * parameters = [NSMutableDictionary dictionaryWithCapacity:0];
                    [parameters setObject:screen_name ? screen_name : @""  forKey:@"username"];
                    [parameters setObject:uid ? uid : @"" forKey:@"weiboId"];
                    if ([ssoName isEqualToString:UMShareToWechatSession]) {
                        [parameters setObject:[data objectForKey:@"openid"] forKey:@"weiboId"];
                    }
                    [parameters setObject:profile_image_url ? profile_image_url : @"" forKey:@"profile_image_url"];
                    [parameters setObject:access_token ? access_token : @"" forKey:@"accessToKen"];
                    if (![ssoName isEqualToString:UMShareToWechatSession]) {
                    [parameters setObject:description forKey:@"description"];
                    }
                    [parameters setObject:ssoName forKey:@"bindtype"];
                    [parameters setObject:gender forKey:@"gender"];
                    if (![ssoName isEqualToString:UMShareToWechatSession]) {
                        [parameters setObject:verified forKey:@"verified"];

                    }
                  //  NSLog(@"打印参数=== weixin =======%@",parameters);
                    
                    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                    [manager POST:[NSString stringWithFormat:@"%@/user/login", kApiBaseUrl] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        NSLog(@"登陆完成后的     JSON: %@", responseObject);
                        NSDictionary *detail    = [responseObject objectForKey:@"detail"];
                        if (![detail isEqual:@""]) {
                            UserDataCenter  *userCenter=[UserDataCenter shareInstance];
                            if([detail objectForKey:@"id"])
                            {
                                userCenter.user_id=[detail objectForKey:@"id"];
                            }
                            userCenter.username=[detail objectForKey:@"username"];
                            userCenter.avatar =[detail objectForKey:@"avatar"];
                            userCenter.is_admin =[detail objectForKey:@"level"];
                            userCenter.verified=[detail objectForKey:@"verified"];
                            userCenter.signature=[detail objectForKey:@"brief"];
                            userCenter.update_time=[detail objectForKey:@"update_time"];
                            userCenter.user_bind_type=[detail objectForKey:@"bind_type"];

                            NSLog(@"usercenter.avatar = %@", userCenter.avatar);
                            [Function saveUser:userCenter];
                            window.rootViewController=[CustmoTabBarController new];
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
