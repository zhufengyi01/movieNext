//
//  AppDelegate.m
//  movienext
//
//  Created by 风之翼 on 15/3/1.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "AppDelegate.h"
#import "CustmoTabBarController.h"
#import "LoginViewController.h"
//导入网络框架
#import "AFNetworking.h"
//导入HUD框架
//#import "SVProgressHUD.h"
//导入友盟
//#import  "User.h"
#import "UserDataCenter.h"
#import "UMSocial.h"
//导入友盟微信
#import "UMSocialWechatHandler.h"
//导入友盟QQ
#import "UMSocialQQHandler.h"
//导入友盟新浪三方登陆
#import "UMSocialSinaHandler.h"

#import "Constant.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    NSDictionary  *userInfo=[[NSUserDefaults  standardUserDefaults] objectForKey:kUserKey];
    NSLog(@"app delegate  userInfo  =====%@",userInfo);
    UserDataCenter  *userCenter=[UserDataCenter shareInstance];
    if (userInfo) {  //用户已经登陆
        if ([userInfo objectForKey:@"id"]) {
             userCenter.user_id=[userInfo objectForKey:@"id"];
        }
        if ([userInfo objectForKey:@"username"]) {
               userCenter.username=[userInfo objectForKey:@"username"];
        }
        if ([userInfo objectForKey:@"level"]) {
             userCenter.is_admin =[userInfo objectForKey:@"level"];
        }
        if ([userInfo objectForKey:@"logo"]) {
            userCenter.avatar =[userInfo objectForKey:@"logo"];
        }
        if ([userInfo objectForKey:@"wallpaper"]) {
            userCenter.wallpaper=[userInfo objectForKey:@"wallpaper"];
        }
        if ([userInfo objectForKey:@"brief"]) {
            userCenter.signature=[userInfo objectForKey:@"brief"];
        }
        if ([userInfo objectForKey:@"update_time"]) {
            userCenter.update_time=[userInfo objectForKey:@"update_time"];
        }
        if ([userInfo  objectForKey:@"bind_type"]) {
            userCenter.user_bind_type=[userInfo objectForKey:@"bind_type"];
        }
        self.window.rootViewController =[CustmoTabBarController new];
        
    }
    else {
        //用户没有登陆
        self.window.rootViewController=[LoginViewController new];
    }
    self.window.backgroundColor=[UIColor whiteColor];
    //初始化友盟组件
    [self initUmeng];

    return YES;
}
/**
 *  初始化友盟组件, 配置SSO
 */
- (void)initUmeng {
    [UMSocialData setAppKey:kUmengKey];
    //    BOOL isOauth = [UMSocialAccountManager isOauthWithPlatform:UMShareToSina];
    //    LOG(@"isoauth = %d", isOauth);
    
    [UMSocialData openLog:NO];
    [UMSocialConfig setSupportedInterfaceOrientations:UIInterfaceOrientationMaskPortrait];
    NSString *shareAppUrl = @"http://um0.cn/47MUuq/";
    [UMSocialWechatHandler setWXAppId:@"wxacf55d5740f7290f" appSecret:@"d2f735f634c9933f774fab162b809943" url:shareAppUrl];
    
    //    QQ100551660 的16进制是 05FE4BEC
    //    1103486275 41C5DD43
    [UMSocialQQHandler setQQWithAppId:@"1103486275" appKey:@"htGJ2JFqtS2GTmM2" url:@"http://www.redianying.com"];
    //[UMSocialSinaHandler openSSOWithRedirectURL:@"https://api.weibo.com/oauth2default.html"];
    [UMSocialSinaHandler openSSOWithRedirectURL:SSOSinRedirectURL];
}

/*
 友盟sso 在APPdelegate中实现下面的回调方法
 */
-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    /**
     *  为了SSO能够正常跳转
     */
    return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
