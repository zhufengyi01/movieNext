//
//  FindDatailViewController.m
//  movienext
//
//  Created by 风之翼 on 15/5/22.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "FindDatailViewController.h"

#import "UIButton+Block.h"
#import "Function.h"
#import "ZCControl.h"
#import "Constant.h"
#import "UserDataCenter.h"
#import "StageView.h"
#import "AFNetworking.h"
#import "Like_HUB.h"
#import "UMShareView.h"
#import "UMSocial.h"
@interface FindDatailViewController ()<StageViewDelegate,UMShareViewDelegate>
{
    StageView  *stageView;
    UILabel *markLable;
}
@end

@implementation FindDatailViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden=YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    //[self createNavigation];
    [self createUI];
    
}
//-(void)createNavigation
//{
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"tabbar_backgroud_color.png"] forBarMetrics:UIBarMetricsDefault];
//    
//    UILabel  *titleLable=[ZCControl createLabelWithFrame:CGRectMake(0, 0, 100, 20) Font:16 Text:@"发现"];
//    titleLable.textColor=VBlue_color;
//    
//    titleLable.font=[UIFont boldSystemFontOfSize:18];
//    titleLable.textAlignment=NSTextAlignmentCenter;
//    self.navigationItem.titleView=titleLable;
//    
//    UIButton  *button=[UIButton buttonWithType:UIButtonTypeCustom];
//    [button setTitle:@"设置" forState:UIControlStateNormal];
//    //[button setBackgroundImage:[UIImage imageNamed:@"setting.png"] forState:UIControlStateNormal];
//    button.frame=CGRectMake(0, 0, 40, 40);
//    [button setTitleColor:VBlue_color forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(GotoSettingClick) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem  *barButton=[[UIBarButtonItem alloc]initWithCustomView:button];
//    self.navigationItem.rightBarButtonItem=barButton;
//    
//    
//}
//-(void)GotoSettingClick
//{
//    self.tabBarController.tabBar.hidden=NO;
//    
//}

//点击了
-(void)shareButtonClick
{
    UIImage  *image=[Function getImage:stageView WithSize:CGSizeMake(kStageWidth, (kDeviceWidth-10)*(9.0/16))];
    
    UMShareView *ShareView =[[UMShareView alloc] initwithStageInfo:self.weiboInfo.stageInfo ScreenImage:image delgate:self];
    [ShareView setShareLable];
    [ShareView show];
    
}
#pragma mark  -------UMShareViewHandDelegate
-(void)UMShareViewHandClick:(UIButton *)button ShareImage:(UIImage *)shareImage StageInfoModel:(stageInfoModel *)StageInfo
{
    NSArray  *sharearray =[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQzone, UMShareToSina, nil];
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
    [[UMSocialControllerService defaultControllerService] setShareText:StageInfo.movieInfo.name shareImage:shareImage socialUIDelegate:self];
    //设置分享内容和回调对象
    
    [UMSocialSnsPlatformManager getSocialPlatformWithName:[sharearray  objectAtIndex:button.tag-10000]].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
    
}


//微博点赞请求
-(void)LikeRequstData:(weiboInfoModel  *) weiboInfo withOperation:(NSNumber *) operation
{
    UserDataCenter  *userCenter=[UserDataCenter shareInstance];
    NSNumber  *weiboId=weiboInfo.Id;
    NSString  *userId=userCenter.user_id;
    NSNumber  *author_id=weiboInfo.uerInfo.Id;
    NSDictionary *parameters=@{@"weibo_id":weiboId,@"user_id":userId,@"author_id":author_id,@"operation":operation};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *urlString = [NSString stringWithFormat:@"%@/weibo/up", kApiBaseUrl];
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject  objectForKey:@"code"]  intValue]==0) {
            NSLog(@"点赞成功========%@",responseObject);
            Like_HUB *like =[[Like_HUB alloc]initWithTitle:nil WithImage:[UIImage imageNamed:@"Like_hub"]];
            [like show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

-(void)disLikeRequstData:(weiboInfoModel  *) weiboInfo
{
    UserDataCenter  *userCenter=[UserDataCenter shareInstance];
    NSNumber  *weiboId=weiboInfo.Id;
    NSString  *userId=userCenter.user_id;
  
    NSDictionary *parameters=@{@"weibo_id":weiboId,@"user_id":userId};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *urlString = [NSString stringWithFormat:@"%@/weibo/down", kApiBaseUrl];
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject  objectForKey:@"code"]  intValue]==0) {
            NSLog(@"点踩成功========%@",responseObject);
            
            Like_HUB *like =[[Like_HUB alloc]initWithTitle:nil WithImage:[UIImage imageNamed:@"Dislike_hub"]];
            [like show];

        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

-(void)createUI
{
    UIView *bgView= [[UIView alloc]initWithFrame:CGRectMake(0, 0,kDeviceWidth,(kDeviceWidth-10)*(9.0/16)+15)];
    bgView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:bgView];
    
    
    stageView = [[StageView alloc] initWithFrame:CGRectMake(5,5,kDeviceWidth-10, (kDeviceWidth-10)*(9.0/16))];
    stageView.isAnimation = YES;
    stageView.backgroundColor=[UIColor redColor];
    stageView.delegate=self;
    stageView.stageInfo=self.weiboInfo.stageInfo;
    // stageView.weibosArray = self.stageInfo.weibosArray;
    [stageView configStageViewforStageInfoDict];
    [bgView addSubview:stageView];
    
    UIView  *_layerView =[[UIView alloc]initWithFrame:CGRectMake(0, stageView.frame.size.height-100, kDeviceWidth-10, 100)];
    [stageView addSubview:_layerView];
    
    CAGradientLayer * _gradientLayer = [CAGradientLayer layer];  // 设置渐变效果
    _gradientLayer.bounds = _layerView.bounds;
    _gradientLayer.borderWidth = 0;
    
    _gradientLayer.frame = _layerView.bounds;
    _gradientLayer.colors = [NSArray arrayWithObjects:
                             (id)[[UIColor clearColor] CGColor],
                             (id)[[UIColor blackColor] CGColor], nil, nil];
    _gradientLayer.startPoint = CGPointMake(0.5, 0.5);
    _gradientLayer.endPoint = CGPointMake(0.5, 1.0);
    [_layerView.layer insertSublayer:_gradientLayer atIndex:0];
    
    
    markLable=[ZCControl createLabelWithFrame:CGRectMake(20,40,_layerView.frame.size.width-40, 60) Font:20 Text:@"弹幕文字"];
    markLable.font =[UIFont boldSystemFontOfSize:20];
    //markLable.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.4];
    if (IsIphone6plus) {
        markLable.font=[UIFont boldSystemFontOfSize:24];
    }
    markLable.textColor=[UIColor whiteColor];
    markLable.text=self.weiboInfo.content;
    markLable.lineBreakMode=NSLineBreakByCharWrapping;
    markLable.contentMode=UIViewContentModeBottom;
    markLable.textAlignment=NSTextAlignmentCenter;
    [_layerView addSubview:markLable];

    
    
    
    
   [self createLikeBar];
    
    
    
}
-(void)createLikeBar
{
    
    UIView *_toolView =[[UIView alloc]initWithFrame:CGRectMake(0, kDeviceHeight-50-kHeightNavigation,kDeviceWidth, 50)];
    _toolView.userInteractionEnabled =YES;
    [self.view addSubview:_toolView];
    
    UIButton  *btn1=[ZCControl createButtonWithFrame:CGRectMake(0, 0, kDeviceWidth/2, 50) ImageName:nil Target:self Action:@selector(likeBtnClick:) Title:@"喜欢"];
    [btn1 setTitleColor:VGray_color forState:UIControlStateNormal];
    btn1.tag=99;
    [btn1 setBackgroundImage:[UIImage imageNamed:@"tabbar_backgroud_color.png"] forState:UIControlStateNormal];
     btn1.backgroundColor=[UIColor whiteColor];
    [_toolView addSubview:btn1];
    
    
    UIButton  *btn2=[ZCControl createButtonWithFrame:CGRectMake(kDeviceWidth/2, 0, kDeviceWidth/2, 50) ImageName:nil Target:self Action:@selector(likeBtnClick:) Title:@"没感觉"];
    btn2.tag=100;
    [btn2 setTitleColor:VGray_color forState:UIControlStateNormal];
    btn2.backgroundColor=[UIColor whiteColor];
    [btn2 setBackgroundImage:[UIImage imageNamed:@"tabbar_backgroud_color.png"] forState:UIControlStateNormal];
     [_toolView addSubview:btn2];
    
    //添加一个线
    UIView  *verline =[[UIView alloc]initWithFrame:CGRectMake(kDeviceWidth/2,12, 0.5, 26)];
    verline.backgroundColor =VLight_GrayColor;
    [_toolView addSubview:verline];

    
}
-(void)likeBtnClick:(UIButton *) btn
{
    if (btn.tag==99) {
        //喜欢
        [self LikeRequstData:self.weiboInfo withOperation:@1];
        
    }
    else if (btn.tag==100)
    {
        //没感觉
        [self disLikeRequstData:self.weiboInfo];
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
