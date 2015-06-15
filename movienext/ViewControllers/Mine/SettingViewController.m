//
//  SettingViewController.m
//  movienext
//
//  Created by 风之翼 on 15/3/1.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "SettingViewController.h"
#import "Constant.h"
#import "UserDataCenter.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "UMSocial.h"
#import "ZCControl.h"
#import <MessageUI/MessageUI.h>
#import "UserHeadChangeViewController.h"
#import "ThanksViewController.h"
#import "UserDataCenter.h"
#import "AdmListViewController.h"
#import <MessageUI/MFMailComposeViewController.h>
#import "SDImageCache.h"
@interface SettingViewController ()<UITableViewDataSource,UITableViewDelegate,UMSocialUIDelegate>
{
    AppDelegate *appdelegate;
    UIWindow  *window;
    UITableView   *_myTableView;
    NSMutableArray   *_dataArray;
}

@end

@implementation SettingViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden=YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel  *titleLable=[ZCControl createLabelWithFrame:CGRectMake(0, 0, 100, 20) Font:16 Text:@"设置"];
    titleLable.textColor=VGray_color;
    
    titleLable.font=[UIFont boldSystemFontOfSize:16];
    titleLable.textAlignment=NSTextAlignmentCenter;
    self.navigationItem.titleView=titleLable;

    UserDataCenter  *userCenter =[UserDataCenter shareInstance];
   if ([userCenter.is_admin intValue ]>0) {
    UIButton  *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"管理员" forState:UIControlStateNormal];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, -10)];
   // [button setBackgroundImage:[UIImage imageNamed:@"setting.png"] forState:UIControlStateNormal];
    [button setTitleColor:VBlue_color forState:UIControlStateNormal];
    button.frame=CGRectMake(0, 0, 60, 40);
    [button addTarget:self action:@selector(adminClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem  *barButton=[[UIBarButtonItem alloc]initWithCustomView:button];
   // self.navigationItem.rightBarButtonItem=barButton;
    }
    self.view.backgroundColor=View_BackGround;
    appdelegate = [[UIApplication sharedApplication]delegate ];
    window=appdelegate.window;
    [self createUI];
    [self createOutLogin];
}
-(void)adminClick:(UIButton *) btn
{
    UIBarButtonItem  *item =[[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem=item;
    [self.navigationController pushViewController:[AdmListViewController new] animated:YES];
}
-(void)createUI
{
    _dataArray =[[NSMutableArray alloc]initWithObjects:@"修改个人资料",@"分享给小伙伴",@"清空缓存",@"意见反馈",@"特别感谢",nil];
    _myTableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 220) style:UITableViewStylePlain];
    _myTableView.delegate=self;
    _myTableView.dataSource=self;
    _myTableView.bounces=NO;
    _myTableView.scrollEnabled=NO;
    _myTableView.separatorColor = VLight_GrayColor;
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:_myTableView];
}
-(void)createOutLogin
{
 
    UIButton  *button=[UIButton buttonWithType:UIButtonTypeCustom];
  //  [button setTitle:@"退出此账号" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont systemFontOfSize:14];
    [button setBackgroundImage:[UIImage imageNamed:@"login out.png"] forState:UIControlStateNormal];
    button.frame=CGRectMake((kDeviceWidth-233)/2, 280, 233, 43);
    [button addTarget:self action:@selector(OutLoginClick:) forControlEvents:UIControlEventTouchUpInside];
    button.layer.cornerRadius=3;
    button.clipsToBounds=YES;
    [self.view addSubview:button];

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55.0f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString  *cellID=@"cell";
    UITableViewCell   *cell=(UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.font =[UIFont systemFontOfSize:14];
  //  cell.textColor =VGray_color;
    cell.textLabel.textColor=VGray_color;
    cell.textLabel.text=[_dataArray  objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==0) {
        UserHeadChangeViewController  *vc =[UserHeadChangeViewController new];
        vc.pageType=NSHeadChangePageTypeSetting;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
     else if (indexPath.row==1) {
          [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeApp;
          [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:kUmengKey
                                          shareText:@"电影卡片"
                                         shareImage:[UIImage imageNamed:@"movieCard_icon.png"]
 
                                    shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQzone, UMShareToSina, nil]
                                           delegate:self];
    } else if (indexPath.row==2) {
        float tmpSize = [[SDImageCache sharedImageCache] getSize];
        NSLog(@"tmpSize = %lfM", tmpSize / 1024 / 1024);
        
        [[SDImageCache sharedImageCache] clearDisk];
        [[SDImageCache sharedImageCache] clearMemory];
        UIAlertView  *Al =[[UIAlertView alloc]initWithTitle:nil message:@"恭喜你，缓存清理成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [Al show];
    } else if (indexPath.row==3) {
        [self sendFeedBack];
    }
    else if (indexPath.row==4)
    {
        [self.navigationController pushViewController:[ThanksViewController new] animated:YES];
        
    }
}

//退出登录
-(void)OutLoginClick:(UIButton *)button
{
    UserDataCenter  *userCenter=[UserDataCenter shareInstance];
    userCenter.user_id=nil;
    userCenter.username=nil;
    userCenter.logo =nil;
    userCenter.signature=nil;
     NSUserDefaults  *userDefualt=[NSUserDefaults standardUserDefaults];
    [userDefualt removeObjectForKey:kUserKey];
    [userDefualt synchronize];
    
    //window.rootViewController=[LoginViewController new];
    UINavigationController  *loginNa=[[UINavigationController alloc]initWithRootViewController:[LoginViewController new]];
    window.rootViewController=loginNa;

    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)sendFeedBack
{
    //    [self showNativeFeedbackWithAppkey:UMENT_APP_KEY];
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (mailClass != nil)
    {
        // We must always check whether the current device is configured for sending emails
        if ([mailClass canSendMail])
        {
            [self displayComposerSheet];
        }
        else
        {
            [self launchMailAppOnDevice];
        }
    }
    else
    {
        [self launchMailAppOnDevice];
    }
    
}

#pragma mark - tool Methods
// 1.  Launches the Mail application on the device.

-(void)launchMailAppOnDevice
{
    NSString *recipients = @"mailto:dcj3sjt@gmail.com&subject=Pocket Truth or Dare Support";
    NSString *body = @"&body=email body!";
    NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
    email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}
// 2. Displays an email composition interface inside the application. Populates all the Mail fields.
-(void)displayComposerSheet
{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];/*MFMailComposeViewController邮件发送选择器*/
    picker.mailComposeDelegate = self;
    
    // Custom NavgationBar background And set the backgroup picture
    picker.navigationBar.tintColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.5];
    //    picker.navigationBar.tintColor = [UIColor colorWithRed:178.0/255 green:173.0/255 blue:170.0/255 alpha:1.0]; //    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0) {
    //        [picker.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg.png"] forBarMetrics:UIBarMetricsDefault];
    //    }
    //    NSArray *ccRecipients = [NSArray arrayWithObjects:@"dcj3sjt@gmail.com", nil];
    //    NSArray *bccRecipients = [NSArray arrayWithObjects:@"dcj3sjt@163.com", nil];
    //    [picker setCcRecipients:ccRecipients];
    //    [picker setBccRecipients:bccRecipients];
    
    // Set up recipients
    NSArray *toRecipients = [NSArray arrayWithObject:@"feedback@immovie.me"];
    [picker setToRecipients:toRecipients];
    // Fill out the email body text
    //struct utsname device_info;
    //uname(&device_info);
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appCurName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *appCurVersionNum = [infoDictionary objectForKey:@"CFBundleVersion"];
    
    UIDevice * myDevice = [UIDevice currentDevice];
    NSString * sysVersion = [myDevice systemVersion];
    NSString *emailBody = [NSString stringWithFormat:@"\n\n\n\n附属信息：\n\n%@ %@(%@)\n%@ / %@ / %@ IOS%@", appCurName, appCurVersion, appCurVersionNum, @"", @"", @"",  sysVersion];
    [picker setMessageBody:emailBody isHTML:NO];
    [picker setSubject:[NSString stringWithFormat:@"反馈：电影卡片%@(%@)", appCurVersion, appCurVersionNum]];/*emailpicker标题主题行*/
    
    [self presentViewController:picker animated:YES completion:nil];
    //        [self.navigationController presentViewController:picker animated:YES completion:nil];
    //        [self.navigationController pushViewController:picker animated:YES];
}

#pragma mark - 协议的委托方法
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    NSString *msg;
    switch (result)
    {
        case MFMailComposeResultCancelled:
            msg = @"邮件发送取消";//@"邮件发送取消";
            break;
        case MFMailComposeResultSaved:
            msg = @"邮件保存成功";//@"邮件保存成功";
            break;
        case MFMailComposeResultSent:
            msg = @"邮件发送成功";//@"邮件发送成功";
            break;
        case MFMailComposeResultFailed:
            msg = @"邮件发送失败";//@"邮件发送失败";
            break;
        default:
            msg = @"邮件未发送";
            break;
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
