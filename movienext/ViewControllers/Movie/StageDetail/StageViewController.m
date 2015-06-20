//
//  StageViewController.m
//  movienext
//
//  Created by 朱封毅 on 18/06/15.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "StageViewController.h"
#import "ZCControl.h"
#import "Constant.h"
#import "AFNetworking.h"
#import "ModelsModel.h"
#import "MovieViewController.h"
#import "UserDataCenter.h"
#import "weiboInfoModel.h"
#import "MJExtension.h"
#import "LoadingView.h"
#import "UIButton+Block.h"
#import "StageView.h"
#import "Like_HUB.h"
#import "UIImageView+WebCache.h"
#import "UMSocial.h"
#import "Function.h"
#import "UMShareView.h"
#import "StageDetailViewController.h"
#import "AddMarkViewController.h"
#import "UIButton+Block.h"
#import "UMSocial.h"
#import "SelectTimeView.h"
#import "UserDataCenter.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

#import "ScanMovieInfoViewController.h"
#define ADM_ACTION_TAG     1000   //统一管理管弹出框
#define CUSTOM_SELF_TAG    1001
#define CUSTOM_DEFATLT_TAG 1002

#define ADM_BTN_BLOCK   2000  //屏蔽
#define ADM_BTN_NEW     2001  //最新
#define ADM_BTN_NORMAL  2002  //正常
#define ADM_BTN_DISCOVER 2003 //发现
#define ADM_BTN_TIMING   2004 //定时
#define  TOOLBAR_HEIGHT  45

@interface StageViewController ()<UMShareViewDelegate,UIPageViewControllerDelegate,UIPageViewControllerDataSource,LoadingViewDelegate,SelectTimeViewDelegate,UIActionSheetDelegate,UMSocialDataDelegate,UMSocialUIDelegate>
{
    //当前的detailcontroller
    StageDetailViewController *CenterViewController;
    
    UIButton  *addMarkButton;
    UIButton  *ShareButton;
}
@property (strong, nonatomic) UIPageViewController *pageController;

//导航条的标题
@property(nonatomic,strong) UILabel             *naviTitlLable;

/*
 当前页weibo 对象
 */
@property(nonatomic,strong) weiboInfoModel     *weiboInfo;


//@property(strong,nonatomic) NSMutableArray   *indexArray; //存储每个页面的索引

@end

@implementation StageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self createNavigation];
    [self createUI];
    [self createToolBar];
    
}
-(instancetype)init
{
    if (self= [super init]) {
        
    }
    return self;
}
-(void)initData
{
    // self.weiboInfo = [self.WeiboDataArray objectAtIndex:self.indexOfItem];
    //存储页面的索引
   // self.weiboInfo = [[weiboInfoModel alloc]init];
   // self.indexArray =[[NSMutableArray alloc]init];
//    for (int i=0; i<self.WeiboDataArray.count;i++) {
//        NSString  *index =[NSString stringWithFormat:@"%d",i];
//        [self.indexArray  addObject:index];
//    }
}
-(void)createNavigation
{
    self.naviTitlLable=[ZCControl createLabelWithFrame:CGRectMake(0, 0, 100, 20) Font:16 Text:@"剧照详细页"];
    self.naviTitlLable.textColor=VGray_color;
    self.naviTitlLable.font=[UIFont fontWithName:kFontDouble size:16];
    self.naviTitlLable.textAlignment=NSTextAlignmentCenter;
    self.navigationItem.titleView=self.naviTitlLable;
    
    //两种按钮
    UserDataCenter  *usecenter =[UserDataCenter shareInstance];
    UIButton  *admOper =[UIButton buttonWithType:UIButtonTypeCustom];
    admOper.frame=CGRectMake(0, 0, 30, 25);
    admOper.imageEdgeInsets=UIEdgeInsetsMake(0, 10, 0, -10);
//    admOper.hidden=YES;
    [admOper setTitleColor:VGray_color forState:UIControlStateNormal];
    ///[admOper setTitle:@"管" forState:UIControlStateNormal];
    [admOper setImage:[UIImage imageNamed:@"guanliyuan_detail"] forState:UIControlStateNormal];
    [admOper setTitleColor:VBlue_color forState:UIControlStateNormal];
    __weak typeof(self) weakSelf = self;
    [admOper  addActionHandler:^(NSInteger tag) {
        //管理员
        UIActionSheet  *Act=[[UIActionSheet alloc]initWithTitle:nil delegate:weakSelf cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"[切换剧照到审核/正式版]",@"[编辑弹幕]",@"[点赞]",@"[点踩]",@"[发送到 “屏蔽”]",@"[发送到 “最新”]",@"[发送到 “正常”]",@"[发送到 “发现”]",@"[定时到 “热门”]",nil];
        Act.tag=ADM_ACTION_TAG;
        [Act showInView:weakSelf.view];
    }];
    UIBarButtonItem  *aditme =[[UIBarButtonItem alloc]initWithCustomView:admOper];
    //更多
    //moreButton=[ZCControl createButtonWithFrame:CGRectMake(kStageWidth-135, 9, 30, 25) ImageName:nil Target:self Action:@selector(NavigationButtonClick:) Title:@""];
   UIButton * moreButton =[UIButton buttonWithType:UIButtonTypeCustom];
    moreButton.frame=CGRectMake(0, 0, 30, 25);
    [moreButton setImage:[UIImage imageNamed:@"three_points"] forState:UIControlStateNormal];
    moreButton.imageEdgeInsets=UIEdgeInsetsMake(0, 10, 0, -10);
    [moreButton addActionHandler:^(NSInteger tag) {
        //点击了更多
        if (self.pageType==NSStageSourceTypeCustomSelfAdd) {
            UIActionSheet  *Act=[[UIActionSheet alloc]initWithTitle:nil delegate:weakSelf cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"删除卡片",nil];
            Act.tag=CUSTOM_SELF_TAG;
            [Act showInView:weakSelf.view];
        }
        else
        {
            UIActionSheet  *Act=[[UIActionSheet alloc]initWithTitle:nil delegate:weakSelf cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"内容投诉",@"版权投诉",@"图片信息",nil];
            Act.tag=CUSTOM_DEFATLT_TAG;
            [Act showInView:weakSelf.view];
        }
    }];
    
    if ([usecenter.is_admin intValue] >0) {
        admOper.hidden=NO;
        if (self.pageType==NSStagePapeTypeAdminOperation) {
            //admOper.hidden=YES;
        }
        moreButton.hidden=YES;
    }
    else
    {
        admOper.hidden=YES;
        moreButton.hidden=NO;
    }
//    //隐藏该隐藏的地方
//    if (self.pageType==NSStagePapeTypeAdmin_Close_Weibo||self.pageType==NSStagePapeTypeAdmin_Dscorver||self.pageType==NSStagePapeTypeAdmin_New_Add||self.pageType==NSStagePapeTypeAdmin_Recommed) {
//        moreButton.hidden=YES;
//    }
//    
    [moreButton setTitleColor:VGray_color forState:UIControlStateNormal];
    UIBarButtonItem  *item =[[UIBarButtonItem alloc]initWithCustomView:moreButton];
    self.navigationItem.rightBarButtonItems =@[item,aditme];
    

}
-(void)createUI
{
    // 设置UIPageViewController的配置项
    NSDictionary *options =[NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMax]
                                                       forKey: UIPageViewControllerOptionSpineLocationKey];
    // 实例化UIPageViewController对象，根据给定的属性
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                          navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                        options: options];
    // 设置UIPageViewController对象的代理
    _pageController.dataSource = self;
    _pageController.delegate=self;
    // 定义“这本书”的尺寸
    [[_pageController view] setFrame:[[self view] bounds]];
    
    // 让UIPageViewController对象，显示相应的页数据。
    // UIPageViewController对象要显示的页数据封装成为一个NSArray。
    // 因为我们定义UIPageViewController对象显示样式为显示一页（options参数指定）。
    // 如果要显示2页，NSArray中，应该有2个相应页数据。
    StageDetailViewController *initialViewController =[self viewControllerAtIndex:self.indexOfItem];// 得到第一页
    self.weiboInfo = [self.WeiboDataArray objectAtIndex:self.indexOfItem];
    self.naviTitlLable.text=self.weiboInfo.stageInfo.movieInfo.name;
    //初始化的时候记录了当前的第一个viewcontroller  以后每次都在代理里面获取当前的viewcontroller
    CenterViewController=initialViewController;
    NSArray *viewControllers =[NSArray arrayWithObject:initialViewController];
    [_pageController setViewControllers:viewControllers
                              direction:UIPageViewControllerNavigationDirectionForward
                               animated:NO
                             completion:nil];
    // 在页面上，显示UIPageViewController对象的View
    [self addChildViewController:_pageController];
    [[self view] addSubview:[_pageController view]];
}
-(void)createToolBar
{
    UIView   *ToolView = [[UIView alloc]initWithFrame:CGRectMake(0,kDeviceHeight-TOOLBAR_HEIGHT-kHeightNavigation, kDeviceWidth, TOOLBAR_HEIGHT)];
    ToolView.userInteractionEnabled=YES;
    [self.view addSubview:ToolView];
    if (self.pageType ==NSStageSourceTypeDefault) {
    __weak typeof(self)weakSelf = self;
    //__weak typeof(CenterViewController) centerVc = CenterViewController;
    addMarkButton =[UIButton buttonWithType:UIButtonTypeCustom];
    addMarkButton.frame=CGRectMake(0, 0, kDeviceWidth/2,TOOLBAR_HEIGHT);
    [addMarkButton setTitle:@"我要添加" forState:UIControlStateNormal];
    [addMarkButton addActionHandler:^(NSInteger tag) {
        AddMarkViewController  *AddMarkVC=[[AddMarkViewController alloc]init];
         AddMarkVC.stageInfo =weakSelf.weiboInfo.stageInfo;
        [weakSelf.navigationController pushViewController:AddMarkVC animated:NO];
        
    }];
    addMarkButton.titleLabel.font =[UIFont fontWithName:kFontDouble size:16];
    [addMarkButton setTitleColor:VBlue_color forState:UIControlStateNormal];
    //ShareButton.backgroundColor =[UIColor redColor];
    [addMarkButton setBackgroundImage:[UIImage imageNamed:@"tabbar_backgroud_color"] forState:UIControlStateNormal];
    [ToolView addSubview:addMarkButton];
    
    ShareButton =[UIButton buttonWithType:UIButtonTypeCustom];
    ShareButton.frame=CGRectMake(kDeviceWidth/2, 0, kDeviceWidth/2, TOOLBAR_HEIGHT);
    [ShareButton setTitle:@"我要分享" forState:UIControlStateNormal];
    /*[ShareButton addActionHandler:^(NSInteger tag) {
        float  height = CenterViewController.ShareView.frame.size.height;
        
        UIImage  *image=[Function getImage:CenterViewController.ShareView WithSize:CGSizeMake(kDeviceWidth-20,height)];
        UMShareView *shareView =[[UMShareView alloc] initwithStageInfo:weakSelf.weiboInfo.stageInfo ScreenImage:image delgate:weakSelf andShareHeight:height];
        [shareView setShareLable];
        [shareView show];
    }];*/
    [ShareButton addTarget:self action:@selector(shareButtonClick) forControlEvents:UIControlEventTouchUpInside];
    ShareButton.titleLabel.font =[UIFont fontWithName:kFontDouble size:16];
    [ShareButton setTitleColor:VBlue_color forState:UIControlStateNormal];
    [ShareButton setBackgroundImage:[UIImage imageNamed:@"tabbar_backgroud_color"] forState:UIControlStateNormal];
    [ToolView addSubview:ShareButton];
    
    //添加一个线
    UIView  *verline =[[UIView alloc]initWithFrame:CGRectMake(kDeviceWidth/2,(TOOLBAR_HEIGHT-26)/2, 0.5, 26)];
    verline.backgroundColor =VLight_GrayColor;
    [ToolView addSubview:verline];
    }
    else if(self.pageType ==NSStagePapeTypeAdminOperation)
    {
        //管理员页面进入
        NSArray *titleArray = [NSArray arrayWithObjects:@"屏蔽", @"最新", @"正常", @"发现", @"定时", nil];
        for (int i=0; i<5; i++) {
            UIButton *btnBlock =[UIButton buttonWithType:UIButtonTypeCustom];
            btnBlock.tag = 2000 + i;
            
            btnBlock.frame=CGRectMake(kDeviceWidth/5*i,0, kDeviceWidth/5, 45);
            [btnBlock setTitle:titleArray[i] forState:UIControlStateNormal];
            [btnBlock setTitleColor:VBlue_color forState:UIControlStateNormal];
            [btnBlock setBackgroundImage:[UIImage imageNamed:@"tabbar_backgroud_color"] forState:UIControlStateNormal];
            //[btnBlock setBackgroundImage:[UIImage imageNamed:@"dischoice_icon@3x.png"] forState:UIControlStateHighlighted];
            [btnBlock addTarget:self action:@selector(changeWeiboStatus:) forControlEvents:UIControlEventTouchUpInside];
            [ToolView addSubview:btnBlock];
        }

        
    }
}
#pragma mark --- User Action
#pragma mark ---
- (void)changeWeiboStatus:(UIButton *)sender{
    switch (sender.tag) {
        case ADM_BTN_BLOCK:
        {
            [self requestChangeStageStatusWithweiboId:[NSString stringWithFormat:@"%@",self.weiboInfo.Id] StatusType:@"0"];
        }
            break;
        case ADM_BTN_NEW:
        {
            [self requestChangeStageStatusWithweiboId:[NSString stringWithFormat:@"%@",self.weiboInfo.Id] StatusType:@"5"];
        }
            break;
        case ADM_BTN_NORMAL:
        {
            [self requestChangeStageStatusWithweiboId:[NSString stringWithFormat:@"%@",self.weiboInfo.Id] StatusType:@"1"];
        }
            break;
        case ADM_BTN_DISCOVER:
        {
            [self requestChangeStageStatusWithweiboId:[NSString stringWithFormat:@"%@",self.weiboInfo.Id] StatusType:@"2"];
        }
            break;
        case ADM_BTN_TIMING:
        {
            //时间
            SelectTimeView  *datepicker =[[SelectTimeView alloc]init];
            datepicker.delegate=self;
            [datepicker show];
        }
            break;
            
        default:
            break;
    }
}
#pragma mark  selected date time
-(void)DatePickerSelectedTime:(NSString *)dateString
{
    //定时到热门，伴随时间戳
    [self requesttiming:[NSString stringWithFormat:@"%@",self.weiboInfo.Id] AndTimeSp:dateString];
    
}
-(void)shareButtonClick
{
    float  height = CenterViewController.ShareView.frame.size.height;
    
    UIImage  *image=[Function getImage:CenterViewController.ShareView WithSize:CGSizeMake(kDeviceWidth-20,height)];
    UMShareView *shareView =[[UMShareView alloc] initwithStageInfo:self.weiboInfo.stageInfo ScreenImage:image delgate:self andShareHeight:height];
    shareView.weiboInfo= self.weiboInfo;
    [shareView setShareLable];
    [shareView show];

}
//根据下标值获取上一个控制器或者下一个控制器  得到相应的VC对象
- (StageDetailViewController *)viewControllerAtIndex:(NSUInteger)index {
    if (([self.WeiboDataArray count] == 0) || (index >= [self.WeiboDataArray count])) {
        return nil;
    }
    // 创建一个新的控制器类，并且分配给相应的数据
    StageDetailViewController * dataViewController =[[StageDetailViewController alloc] init];
    dataViewController.weiboInfo=[self.WeiboDataArray objectAtIndex:index];
    dataViewController.upWeiboArray=self.upWeiboArray;
    return dataViewController;
}
// 根据数组元素值，得到下标值
- (NSUInteger)indexOfViewController:(StageDetailViewController *)viewController {
    StageDetailViewController *dataViewController=(StageDetailViewController *)viewController;
    return [self.WeiboDataArray indexOfObject:dataViewController.weiboInfo];
}

// 返回上一个ViewController对象
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    //获取当前控制器
    CenterViewController =(StageDetailViewController *)viewController;
    NSUInteger index = [self indexOfViewController:(StageDetailViewController *)viewController];
    self.weiboInfo =[self.WeiboDataArray objectAtIndex:index];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.naviTitlLable.text= self.weiboInfo.stageInfo.movieInfo.name;
    });
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    index--;
    // 返回的ViewController，将被添加到相应的UIPageViewController对象上。
    // UIPageViewController对象会根据UIPageViewControllerDataSource协议方法，自动来维护次序。
    // 不用我们去操心每个ViewController的顺序问题。
    
    return [self viewControllerAtIndex:index];
}

// 返回下一个ViewController对象
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    CenterViewController =(StageDetailViewController *) viewController;
    NSUInteger index = [self indexOfViewController:(StageDetailViewController *)viewController];
    self.weiboInfo =[self.WeiboDataArray objectAtIndex:index];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.naviTitlLable.text= self.weiboInfo.stageInfo.movieInfo.name;
    });
    
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    if (index == [self.WeiboDataArray count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

-(void)UMShareViewHandClick:(UIButton *)button ShareImage:(UIImage *)shareImage StageInfoModel:(stageInfoModel *)StageInfo
{
    NSArray  *sharearray =[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline, UMShareToSina, nil];
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
    [[UMSocialControllerService defaultControllerService] setShareText:StageInfo.movieInfo.name shareImage:shareImage socialUIDelegate:self];
    //设置分享内容和回调对象
    [UMSocialSnsPlatformManager getSocialPlatformWithName:[sharearray  objectAtIndex:button.tag-10000]].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
}
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    
    NSLog(@"response ========%@",response);
}
#pragma  mark  ----RequestData
#pragma  mark  ---
//status 0 屏蔽 1 正常 2 发现/电影页 3 热门 只有到热门页的时候需要传updated_at 5 未审核
-(void)requestChangeStageStatusWithweiboId:(NSString *)weiboId StatusType:(NSString *) status
{
    UserDataCenter  *userCenter=[UserDataCenter shareInstance];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters=@{@"user_id":userCenter.user_id,@"weibo_id":weiboId,@"status":status};
    
    [manager POST:[NSString stringWithFormat:@"%@/weibo/change-status", kApiBaseUrl] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject  objectForKey:@"code"]  intValue]==0) {
            NSString  *titleString ;
             if ([status intValue]==0) {
                titleString =[NSString stringWithFormat:@"%@屏蔽成功",self.weiboInfo.content];
            }else if ([status intValue]==1)
            {
                titleString=[NSString stringWithFormat:@"%@移到正常成功",self.weiboInfo.content];
            }else if ([status intValue]==2)
            {
                titleString= [NSString stringWithFormat:@"%@移到发现成功",self.weiboInfo.content];
            }else if ([status  intValue]==3)
            {
                titleString  = [NSString stringWithFormat:@"%@移到热门成功",self.weiboInfo.content];
            }
            else if([status intValue]==5)
            {
                titleString =[NSString stringWithFormat:@"%@发布到最新成功",self.weiboInfo.content];
            }
            UIAlertView  * al =[[UIAlertView alloc]initWithTitle:nil message:titleString delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [al show];
            //请求点赞
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        UIAlertView  * al =[[UIAlertView alloc]initWithTitle:nil message:@"操作失败！！！！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [al show];
    }];
}
//定时发送到热门,发送时间戳
-(void)requesttiming:(NSString *)weiboId AndTimeSp:(NSString *)timeSp
{
    UserDataCenter  *userCenter=[UserDataCenter shareInstance];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters=@{@"user_id":userCenter.user_id,@"weibo_id":weiboId,@"status":@"3",@"updated_at":timeSp};
    [manager POST:[NSString stringWithFormat:@"%@/weibo/change-status", kApiBaseUrl] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject  objectForKey:@"code"]  intValue]==0) {
            NSString *titSting  =[NSString stringWithFormat:@"%@定时到热门成功",self.weiboInfo.content];
            UIAlertView  * al =[[UIAlertView alloc]initWithTitle:nil message:titSting delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [al show];
            //请求点赞
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}
-(void)requestmoveReviewToNormal:(NSString *) stageId
{
    UserDataCenter *usercenter=[UserDataCenter shareInstance];
    NSString  *review;
    if ([Version  isEqualToString:@"1.0.1"]) {
        //从审核版到正常
        review=@"0";
    }
    else
    {
        review=@"1";
        
    }
    NSDictionary *parameters = @{@"stage_id":stageId,@"user_id":usercenter.user_id,@"review":review};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *urlString =[NSString stringWithFormat:@"%@/stage/move-to-review", kApiBaseUrl];
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject  objectForKey:@"code"]  intValue]==0) {
            NSLog(@"移除剧照成功=======%@",responseObject);
            UIAlertView  *Al =[[UIAlertView alloc]initWithTitle:nil message:@"审核（正常）切换成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [Al show];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}
//管理员用户的点赞和点踩
-(void)requestUpAndDownWithDeretion:(NSString *)direction;
{
    
    UserDataCenter  *userCenter=[UserDataCenter shareInstance];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters=@{@"user_id":userCenter.user_id,@"stage_id":self.weiboInfo.stageInfo.Id,@"weibo_id":self.weiboInfo.Id,@"direction":direction};
    
    [manager POST:[NSString stringWithFormat:@"%@/weibo/adjust", kApiBaseUrl] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject  objectForKey:@"code"]  intValue]==0) {
            //改变likelable 的状态
            if ([direction isEqualToString:@"up"]) {//点赞
                int like =[self.weiboInfo.like_count intValue];
                like = like + 1;
                self.weiboInfo.like_count =[NSNumber numberWithInt:like];
                
            }
            else if([direction isEqualToString:@"down"]){
                int like =[self.weiboInfo.like_count intValue];
                like = like -1;
                self.weiboInfo.like_count =[NSNumber numberWithInt:like];
                
            }
            //在主线程中更新likelable 的文字
            
            //获取子线程
            // dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            //});
            dispatch_async(dispatch_get_main_queue(), ^{
               // Like_lable.text=[NSString stringWithFormat:@"%@",self.weiboInfo.like_count];
                
            });
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}
//微博举报
-(void)requestReportweibo
{
    // NSString *type=@"1";
    UserDataCenter *userCenter =[UserDataCenter shareInstance];
    NSDictionary *parameters = @{@"reported_user_id":self.weiboInfo.uerInfo.Id,@"weibo_id":self.weiboInfo.Id,@"reason":@"",@"user_id":userCenter.user_id};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/report-weibo/create", kApiBaseUrl] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject  objectForKey:@"code"]  intValue]==0) {
            NSLog(@"随机数种子请求成功=======%@",responseObject);
            UIAlertView  *Al =[[UIAlertView alloc]initWithTitle:nil message:@"你的举报已成功,我们会在24小时内处理" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [Al show];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}
- (void)sendFeedBackWithStageInfo:(stageInfoModel *)stageInfo

{
    //    [self showNativeFeedbackWithAppkey:UMENT_APP_KEY];
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (mailClass != nil)
    {
        // We must always check whether the current device is configured for sending emails
        if ([mailClass canSendMail])
        {
            [self displayComposerSheet:stageInfo];
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
-(void)displayComposerSheet:(stageInfoModel *) stageInfo

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
    NSArray *toRecipients = [NSArray arrayWithObject:@"feedback@redianying.com"];
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
    // NSString *emailBody = [NSString stringWithFormat:@"\n\n\n\n附属信息：\n\n%@ %@(%@)\n%@ / %@ / %@ IOS%@", appCurName, appCurVersion, appCurVersionNum, @"", @"", @"",  sysVersion];
    
    UserDataCenter  *usercenter=[UserDataCenter shareInstance];
    
    NSString *emailBody = [NSString stringWithFormat:@"\n您的名字：\n联系电话:\n投诉内容:\n\n\n\n\n-------\n请勿删除以下信息，并提交你拥有此版权的证明--------\n\n 电影:%@\n剧情id:%@\n投诉人id:%@\n投诉昵称:%@\n",stageInfo.movieInfo.name,stageInfo.Id,usercenter.user_id,usercenter.username];
    [picker setTitle:@"@版权问题"];
    [picker setMessageBody:emailBody isHTML:NO];
    [picker setSubject:[NSString stringWithFormat:@"版权投诉"]];/*emailpicker标题主题行*/
    
    [self presentViewController:picker animated:YES completion:nil];
    //        [self.navigationController presentViewController:picker animated:YES completion:nil];
    //        [self.navigationController pushViewController:picker animated:YES];
}
-(void)launchMailAppOnDevice
{
    NSString *recipients = @"mailto:dcj3sjt@gmail.com&subject=Pocket Truth or Dare Support";
    NSString *body = @"&body=email body!";
    NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
    email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}
// 2. Displays an email composition interface inside the application. Populates all the Mail fields.

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


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag==ADM_ACTION_TAG) {
        //管理员的
        if (buttonIndex==0) {
            //切换剧照到审核版
            NSString  *stageId;
            // stageInfoModel *model=[_dataArray objectAtIndex:Rowindex];
            stageId=[NSString stringWithFormat:@"%@",self.weiboInfo.stageInfo.Id];
            //移动到审核版或者正常
            [self requestmoveReviewToNormal:stageId];
        }
        else if (buttonIndex==1)
        {
            // 编辑弹幕
            //弹幕编辑
            AddMarkViewController  *AddMarkVC=[[AddMarkViewController alloc]init];
            AddMarkVC.stageInfo=self.weiboInfo.stageInfo;
            AddMarkVC.weiboInfo=self.weiboInfo;
           // AddMarkVC.delegate=self;
            [self.navigationController pushViewController:AddMarkVC animated:NO];
        }
        else if (buttonIndex==2)
        {
            //点赞
            [self requestUpAndDownWithDeretion:@"up"];
            
        }
        else if (buttonIndex==3)
        {
            // 踩
            [self requestUpAndDownWithDeretion:@"down"];
        }
        else if (buttonIndex==4)
        {
            // 屏蔽
            NSString *weibo_id =[NSString stringWithFormat:@"%@",self.weiboInfo.Id];
            [self requestChangeStageStatusWithweiboId:weibo_id StatusType:@"0"];
        }
        else if (buttonIndex==5)
        {
            //最新
            NSString *weibo_id =[NSString stringWithFormat:@"%@",self.weiboInfo.Id];
            [self requestChangeStageStatusWithweiboId:weibo_id StatusType:@"5"];
        }
        else if (buttonIndex==6)
        {
            //正常
            NSString *weibo_id =[NSString stringWithFormat:@"%@",self.weiboInfo.Id];
            [self requestChangeStageStatusWithweiboId:weibo_id StatusType:@"1"];
        }
        else if (buttonIndex==7)
        {
            //发现
            NSString *weibo_id =[NSString stringWithFormat:@"%@",self.weiboInfo.Id];
            [self requestChangeStageStatusWithweiboId:weibo_id StatusType:@"2"];
        }
        else if (buttonIndex==8)
        {
            //定时到热门
            SelectTimeView  *datepicker =[[SelectTimeView alloc]init];
            datepicker.delegate=self;
            [datepicker show];
        }
    }
    else if (actionSheet.tag==CUSTOM_DEFATLT_TAG)
    {
        //普通用户
        if (buttonIndex==0) {
            //确认举报
            [self requestReportweibo];
        }else if (buttonIndex==1)
        {
            //版权投诉
            [self sendFeedBackWithStageInfo:self.weiboInfo.stageInfo];
            
        }else if(buttonIndex==2)
        {
            //图片信息
            ScanMovieInfoViewController * scanvc =[ScanMovieInfoViewController new];
            scanvc.stageInfo=self.weiboInfo.stageInfo;
            [self presentViewController:scanvc animated:YES completion:nil];
        }
    }
    else if (actionSheet.tag==CUSTOM_SELF_TAG)
    {
        //普通用户自己删除
        if(buttonIndex==0)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"确认删除吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = 3001;
            [alert show];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
