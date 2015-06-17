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
//导入友盟
#import "MobClick.h"
#import "UserDataCenter.h"
#import "UMSocial.h"
//导入友盟微信
#import "UMSocialWechatHandler.h"
//导入友盟QQ
#import "UMSocialQQHandler.h"
//导入友盟新浪三方登陆
#import "UMSocialSinaHandler.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "Constant.h"
#import "Function.h"
#import "GiderPageViewController.h"
@interface AppDelegate ()
//是否为测试版
@property(nonatomic,strong) NSString  *IS_CHECK;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch
    //默认是审核版
    [self setupAppAppearance];
    
    self.IS_CHECK=@"1";
    //初始化友盟组件
    [self initUmeng];
    // 友盟自定义事件
    //[MobClick updateOnlineConfig];
    // NSString  *is_App_Check = [MobClick getConfigParams:@"First_Start_Image"];
    //判断是否是审核
    [self requestisReview];
    self.window.backgroundColor=[UIColor whiteColor];
    //自动显示和隐藏请求时的状态提示
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    for(NSString *fontfamilyname in [UIFont familyNames])
    {
        NSLog(@"family:'%@'",fontfamilyname);
        for(NSString *fontName in [UIFont fontNamesForFamilyName:fontfamilyname])
        {
            NSLog(@"\tfont:'%@'",fontName);
        }
        NSLog(@"-------------");
    }
    
    return YES;
}

-(void)setupAppAppearance
{
    [[UILabel appearance] setFont:[UIFont fontWithName:@"FZLTHK—GBK1-0" size:20]];
    [UIButton appearance].titleLabel.font =[UIFont fontWithName:@"FZLTHK—GBK1-0" size:20];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor grayColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor grayColor]];
//    [UINavigationBar appearance].titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor grayColor] forKey:@"NSForegroundColorAttributeName"];
    
//    [UITabBar appearance].barTintColor = [UIColor blueColor];
//    [UITabBar appearance].tintColor = [UIColor grayColor];
//    [UITabBar appearance].selectionIndicatorImage = [UIImage imageNamed:@"icon"];
}


-(void)createRootViewController:(NSString *) is_App_Check
{
    
    
#pragma mark  判断是否是审核版
    if ([is_App_Check intValue] ==1) {//是否是审核版 yes表示是非审核版，走正常的路线，审核版的话直接走非启动页
        // 不需要启动图
        UINavigationController  *loginNa=[[UINavigationController alloc]initWithRootViewController:[LoginViewController new]];
        self.window.rootViewController=loginNa;
    }
    else {
        NSDictionary  *userInfo=[[NSUserDefaults  standardUserDefaults] objectForKey:kUserKey];
        NSString      *firstlogin =[[NSUserDefaults standardUserDefaults] objectForKey:IS_FIRST_LOGIN];
        
        //firstlogin = @"NO";
        if (![firstlogin isEqualToString:@"YES"]) {//是第一次进入应用
            [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:IS_FIRST_LOGIN];
            UINavigationController  *GNa=[[UINavigationController alloc]initWithRootViewController:[GiderPageViewController new]];
            self.window.rootViewController=GNa;
            
        } else {
            if (userInfo) {  //用户已经登陆
                [Function getUserInfoWith:userInfo];
                self.window.rootViewController =[CustmoTabBarController new];
            } else {
                //用户没有登陆
                UINavigationController  *loginNa=[[UINavigationController alloc]initWithRootViewController:[LoginViewController new]];
                self.window.rootViewController=loginNa;
            }
        }
    }
}
/**
 *  初始化友盟组件, 配置SSO
 */
- (void)initUmeng {
#pragma mark 友盟统计
    //友盟统计
    //channekId 应用的推广渠道  nil或者@""默认为appstore
    [MobClick setLogEnabled:YES];
    [MobClick startWithAppkey:kUmengKey reportPolicy:BATCH channelId:@""];
    //版本标识（version）
    NSString  *version =[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    //如果@param value为YES，SDK会对日志进行加密。加密模式可以有效防止网络攻击，提高数据安全性。
    // 如果@param value为NO，SDK将按照非加密的方式来传输日志。
    //如果您没有设置加密模式，SDK的加密模式为NO（不加密）。
    [MobClick setEncryptEnabled:YES];
    
    // 您可以设置在应用切入后台时，是否进入background模式。
    //对于支持backgound模式的APP，SDK可以确保在进入后台时，完成对日志的持久化工作，保证数据的完整性。您可以通过以下方法对后台模式进行设置：
    [MobClick setBackgroundTaskEnabled:YES];
    
    [UMSocialData setAppKey:kUmengKey];
    //    BOOL isOauth = [UMSocialAccountManager isOauthWithPlatform:UMShareToSina];
    //    LOG(@"isoauth = %d", isOauth);
    
    [UMSocialData openLog:YES];
    [UMSocialConfig setSupportedInterfaceOrientations:UIInterfaceOrientationMaskPortrait];
    NSString *shareAppUrl = @"http://um0.cn/47MUuq/";
    // [UMSocialWechatHandler setWXAppId:@"wxacf55d5740f7290f" appSecret:@"d2f735f634c9933f774fab162b809943" url:shareAppUrl];
    [UMSocialWechatHandler setWXAppId:weiChatShareKey appSecret:weiChatShareSecret url:shareAppUrl];
    
    //    QQ100551660 的16进制是 05FE4BEC
    //    1103486275 41C5DD43
    [UMSocialQQHandler setQQWithAppId:@"1103486275" appKey:@"htGJ2JFqtS2GTmM2" url:@"http://www.redianying.com"];
    //  [UMSocialSinaHandler openSSOWithRedirectURL:@"https://api.weibo.com/oauth2default.html"];
    [UMSocialSinaHandler openSSOWithRedirectURL:SSOSinRedirectURL];
}
// 是否是审核版, 返回1 审核版   0 正式版
-(void)requestisReview
{
#warning 提交审核的时候需要开启
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *urlString =[NSString stringWithFormat:@"%@/user/review-mode", kApiBaseUrl];
    [manager POST:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject objectForKey:@"code"]) {
            self.IS_CHECK=[responseObject objectForKey:@"code"];
        }
        UserDataCenter  *user =[UserDataCenter shareInstance];
        user.Is_Check=self.IS_CHECK;
        
        
        [self createRootViewController:self.IS_CHECK];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [self createRootViewController:self.IS_CHECK];
    }];
    
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
