//
//  FinderViewController.m
//  movienext
//
//  Created by 风之翼 on 15/5/22.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "FinderViewController.h"
#import "ZCControl.h"
#import "Constant.h"
#import "AFNetworking.h"
#import "FindDatailViewController.h"
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

#define  USER_TOOL_HEIGHT  45

#define  LIKE_BAR_HEIGHT  50

@interface FinderViewController ()<UIPageViewControllerDataSource,UIPageViewControllerDelegate,LoadingViewDelegate,UIGestureRecognizerDelegate,UMSocialDataDelegate,UMShareViewDelegate>
{
    LoadingView         *loadView;
    //当前的detailcontroller
    FindDatailViewController *CenterViewController;
    
    // int  pageIndex;
    
    //StageView  *stageView;
    
    UILabel  *markLable;
    
    UIButton  *sharebtn;
    
    UIImageView  *headLogoImageView;//头像
    UILabel  *userNameLable;  //名字
    UIImageView *starImageView;  //红心
    UILabel *Like_lable;
    UIButton  *leftButtomButton;
}
@property (strong, nonatomic) UIPageViewController *pageController;

@property (strong, nonatomic) NSMutableArray *pageContent;

@property(strong,nonatomic) NSMutableArray   *indexArray; //存储每个页面的索引

@property(strong,nonatomic) UIImageView      *stageImageView;

@property(nonatomic,assign) int pageIndex;


@property(nonatomic,strong) UIView  *bgView;

@property(nonatomic,strong) UIView  *ShareView;


@property(nonatomic,strong) UIView  *UserView;

@property(nonatomic,strong) UIScrollView  *myScrollerView;


@property(nonatomic,strong) UILabel  *naviTitlLable ;

@property(nonatomic,strong) UIView  *layerView;

@end

@implementation FinderViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden=NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =View_BackGround;
    // Do any additional setup after loading the view.
    [self createNavigation];
    [self initData];
    [self requestData];// 初始化所有数据
    [self creatLoadView];
    
}

-(void)creatLoadView
{
    loadView =[[LoadingView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    loadView.delegate=self;
    [self.view addSubview:loadView];
    
}

-(void)createNavigation
{
    
    __weak typeof(self) weakSealf = self;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"tabbar_backgroud_color.png"] forBarMetrics:UIBarMetricsDefault];
    
    self.naviTitlLable=[ZCControl createLabelWithFrame:CGRectMake(0, 0, 100, 20) Font:16 Text:@""];
    self.naviTitlLable.textColor=VGray_color;
    self.naviTitlLable.font=[UIFont boldSystemFontOfSize:16];
    self.naviTitlLable.textAlignment=NSTextAlignmentCenter;
    self.navigationItem.titleView=self.naviTitlLable;
    
    
    UIButton  *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"返回" forState:UIControlStateNormal];
    button.titleEdgeInsets=UIEdgeInsetsMake(0,-10, 0, 10);
    [button addActionHandler:^(NSInteger tag) {
        [weakSealf dismissViewControllerAnimated:YES completion:^{
        }];
        
    }];
    button.frame=CGRectMake(0, 0, 40, 40);
    button.tag=1000;
    button.titleLabel.font =[UIFont systemFontOfSize:16];
    [button setTitleColor:VGray_color forState:UIControlStateNormal];
    //[button addTarget:self action:@selector(naviagetionItemClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem  *barButton=[[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem=barButton;
    //
    sharebtn=[UIButton buttonWithType:UIButtonTypeCustom];
    
    sharebtn.frame=CGRectMake(0, 0, 40, 25);
    sharebtn.tag=1001;
    [sharebtn addActionHandler:^(NSInteger tag) {
        //分享
        weiboInfoModel   *weiboInfo =[weakSealf.pageContent objectAtIndex:weakSealf.pageIndex];
        
        UIImage  *image=[Function getImage:weakSealf.ShareView WithSize:CGSizeMake(kDeviceWidth-20, weakSealf.ShareView.frame.size.height)];
        UMShareView *ShareView =[[UMShareView alloc] initwithStageInfo:weiboInfo.stageInfo ScreenImage:image delgate:weakSealf andShareHeight:weakSealf.ShareView.frame.size.height];
        [ShareView setShareLable];
        [ShareView show];
        
    }];
    [sharebtn setTitle:@"分享" forState:UIControlStateNormal];
    [sharebtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, -10)];
    sharebtn.titleLabel.font =[UIFont systemFontOfSize:16];
    [sharebtn setTitleColor:VGray_color forState:UIControlStateNormal];
    UIBarButtonItem  *rigthbarButton=[[UIBarButtonItem alloc]initWithCustomView:sharebtn];
    self.navigationItem.rightBarButtonItem=rigthbarButton;
    
    
}

#pragma mark  -------UMShareViewHandDelegate
-(void)UMShareViewHandClick:(UIButton *)button ShareImage:(UIImage *)shareImage StageInfoModel:(stageInfoModel *)StageInfo
{
    NSArray  *sharearray =[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline, UMShareToSina, nil];
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
    [[UMSocialControllerService defaultControllerService] setShareText:StageInfo.movieInfo.name shareImage:shareImage socialUIDelegate:self];
    //设置分享内容和回调对象
    
    [UMSocialSnsPlatformManager getSocialPlatformWithName:[sharearray  objectAtIndex:button.tag-10000]].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
}

-(void)initData
{
    self.pageIndex=0;
    self.pageContent =[[NSMutableArray alloc]init];
    self.indexArray =[[NSMutableArray alloc]init];
}
#pragma  mark   ------------requestData -------
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
            self.pageIndex++;
            if (self.pageContent.count>self.pageIndex) {
                [self performSelector:@selector(changeStageViewImageAndmarkLable) withObject:nil afterDelay:1];
            }
            
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
            self.pageIndex++;
            if (self.pageContent.count>self.pageIndex) {
                [self performSelector:@selector(changeStageViewImageAndmarkLable) withObject:nil afterDelay:1];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

//在主线程中更新UI
-(void)changeStageViewImageAndmarkLable
{
    weiboInfoModel   *weiboInfo =[self.pageContent objectAtIndex:self.pageIndex];
    self.naviTitlLable.text=weiboInfo.stageInfo.movieInfo.name;
    
    CGRect  frame = [Function getImageFrameWithwidth:[weiboInfo.stageInfo.width intValue] height:[weiboInfo.stageInfo.height intValue] inset:20];
    
    self.stageImageView.frame=frame;
    
    self.layerView.frame= CGRectMake(0, self.stageImageView.frame.size.height-60, kDeviceWidth-10, 60);
    
    markLable.text=weiboInfo.content;
    CGSize  Msize = [markLable.text boundingRectWithSize:CGSizeMake(kDeviceWidth-40, MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:[NSDictionary dictionaryWithObject:markLable.font forKey:NSFontAttributeName] context:nil].size;
    self.ShareView.frame=CGRectMake(self.ShareView.frame.origin.x, self.ShareView.frame.origin.y, self.ShareView.frame.size.width, self.stageImageView.frame.size.height+Msize.height-27);
    self.bgView.frame=CGRectMake(0, 0, kDeviceWidth, self.ShareView.frame.size.height+20);
    markLable.frame=CGRectMake(10, self.ShareView.frame.size.height-Msize.height-5 ,self.ShareView.frame.size.width-20,Msize.height);
    self.UserView.frame=CGRectMake(0, self.ShareView.frame.origin.y+self.ShareView.frame.size.height+10, kDeviceWidth, USER_TOOL_HEIGHT);
    
    
    
    NSString *photostring=[NSString stringWithFormat:@"%@%@!w640",kUrlStage,weiboInfo.stageInfo.photo];
    [self.stageImageView   sd_setImageWithURL:[NSURL URLWithString:photostring] placeholderImage:nil options:(SDWebImageLowPriority|SDWebImageRetryFailed)];
    
    
    NSString  *uselogoString =[NSString stringWithFormat:@"%@%@!thumb",kUrlAvatar,weiboInfo.uerInfo.logo];
    [headLogoImageView sd_setImageWithURL:[NSURL URLWithString:uselogoString] placeholderImage:[UIImage imageNamed:@"user_normal.png"]];
    
    NSString  *nameStr =weiboInfo.uerInfo.username;
    //用户名
    CGSize  Nsize =[nameStr boundingRectWithSize:CGSizeMake(100, 27) options:(NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin) attributes:[NSDictionary dictionaryWithObject:userNameLable.font forKey:NSFontAttributeName] context:nil].size;
    userNameLable.frame=CGRectMake(35,0, Nsize.width+4, 30);
    leftButtomButton.frame=CGRectMake(10,5, 30+5+userNameLable.frame.size.width, 27);
    userNameLable.text=[NSString stringWithFormat:@"%@",nameStr];
    Like_lable.text=[NSString stringWithFormat:@"%@",weiboInfo.like_count];
    
}

// 初始化所有数据
- (void)requestData {
    UserDataCenter  *userCenter=[UserDataCenter shareInstance];
    NSString *userId=userCenter.user_id;
    NSDictionary *parameters= @{@"user_id":userId,@"Version":Version};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *urlString=[NSString stringWithFormat:@"%@/weibo/discover", kApiBaseUrl];
    
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"code"] intValue]==0) {
            
            // NSMutableArray  *Array =[[NSMutableArray alloc]initWithArray:[responseObject objectForKey:@"models"]];
            self.pageContent= [[NSMutableArray alloc] initWithArray:[weiboInfoModel objectArrayWithKeyValuesArray:[responseObject objectForKey:@"models"]]];
            
            if (self.pageContent.count==0) {
                sharebtn.hidden=YES;
                [loadView showNullView:@"没有发现了..."];
            }
            else
            {
                [loadView stopAnimation];
                [loadView removeFromSuperview];
                [self createUI];
            }
            
            //            //存储页面的索引
            //            for (int i=0; i<self.pageContent.count;i++) {
            //                NSString  *index =[NSString stringWithFormat:@"%d",i];
            //                [self.indexArray  addObject:index];
            //            }
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        sharebtn.hidden=YES;
        [loadView showFailLoadData];
        
        NSLog(@"Error: %@", error);
    }];
}

-(void)reloadDataClick
{
    [self requestData];
    [loadView hidenFailLoadAndShowAnimation];
}
-(void)createUI
{
    // 设置UIPageViewController的配置项
    /*NSDictionary *options =[NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMax]
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
     FindDatailViewController *initialViewController =[self viewControllerAtIndex:0];// 得到第一页
     
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
     
     */
    
    
    self.myScrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-LIKE_BAR_HEIGHT)];
    self.myScrollerView.backgroundColor =View_BackGround;
    self.myScrollerView.contentSize = CGSizeMake(kDeviceWidth, kDeviceHeight);
    [self.view addSubview:self.myScrollerView];
    
    self.bgView= [[UIView alloc]initWithFrame:CGRectMake(0, 0,kDeviceWidth,(kDeviceWidth-10)*(9.0/16)+15+35)];
    self.bgView.backgroundColor=[UIColor whiteColor];
    [self.myScrollerView addSubview:self.bgView];
    
    
    
    //创建分享的视图
    //最后要分享出去的图
    self.ShareView =[[UIView alloc]initWithFrame:CGRectMake(10,10, kDeviceWidth-20, (kDeviceWidth-20)*(9.0/16))];
    self.ShareView.userInteractionEnabled=YES;
    self.ShareView.backgroundColor=[UIColor blackColor];
    [self.bgView addSubview:self.ShareView];
    
    weiboInfoModel   *weiboInfo =[self.pageContent objectAtIndex:0];
    
    self.naviTitlLable.text=weiboInfo.stageInfo.movieInfo.name;
    
    
    CGRect  frame = [Function getImageFrameWithwidth:[weiboInfo.stageInfo.width intValue] height:[weiboInfo.stageInfo.height intValue] inset:20];
    
    
    
    //    //计算图片的宽高比
    //    float width = [weiboInfo.stageInfo.width intValue];
    //    float heigth =[weiboInfo.stageInfo.height intValue];
    //    float x;
    //    float y=0;
    //    float w;
    //    float h;
    //    if (heigth/width>KImageWidth_Height&&(heigth/width<1)) { //
    //        x=0;
    //        y=0;
    //        w=kDeviceWidth-20;
    //        h=(kDeviceWidth-20)*(heigth/width);
    //    }
    //    else if (heigth/width<KImageWidth_Height)
    //    {
    //        x=0;
    //        y=0;
    //        w=kDeviceWidth-20;
    //        h=(kDeviceWidth-20)*KImageWidth_Height;
    //    }
    //    else if (heigth/width>1) //高大于宽度的时候  成正方形
    //    {
    //        y =0;
    //        h= kDeviceWidth-20;
    //        w=(kDeviceWidth-20)*(width/heigth);
    //        x=((kDeviceWidth-20)-w)/2;
    //    }
    //    else
    //    {
    //        x=0;
    //        y=0;
    //        w=kDeviceWidth-20;
    //        h=w*(9.0/16);
    //    }
    //
    self.stageImageView =[[UIImageView alloc]initWithFrame:frame];
    weiboInfoModel *Weibo =[self.pageContent objectAtIndex:0];
    self.stageImageView.contentMode=UIViewContentModeScaleAspectFill;
    self.stageImageView.clipsToBounds=YES;
    NSString *photostring=[NSString stringWithFormat:@"%@%@!w640",kUrlStage,Weibo.stageInfo.photo];
    [self.stageImageView   sd_setImageWithURL:[NSURL URLWithString:photostring] placeholderImage:nil options:(SDWebImageLowPriority|SDWebImageRetryFailed)];
    [self.ShareView addSubview:self.stageImageView];
    
    
    // self.stageImageView.image
    
    /*  stageView = [[StageView alloc] initWithFrame:CGRectMake(5,5,kDeviceWidth-10, (kDeviceWidth-10)*(9.0/16))];
     stageView.isAnimation = YES;
     stageView.backgroundColor=[UIColor redColor];
     //stageView.delegate=self;
     // stageView.stageInfo=self.weiboInfo.stageInfo;
     // stageView.weibosArray = self.stageInfo.weibosArray;
     [stageView configStageViewforStageInfoDict];
     
     [bgView addSubview:stageView];*/
    
    
    
    _layerView =[[UIView alloc]initWithFrame:CGRectMake(0, self.stageImageView.frame.size.height-60, kDeviceWidth-10, 60)];
    [self.stageImageView addSubview:_layerView];
    
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
    if (IsIphone6) {
        markLable.frame=CGRectMake(20, 30, _layerView.frame.size.width-40, 65);
        markLable.font =[UIFont boldSystemFontOfSize:25];
    }
    if (IsIphone6plus) {
        markLable.frame=CGRectMake(20, 20,_layerView.frame.size.width-40, 70);
        markLable.font=[UIFont boldSystemFontOfSize:28];
    }
    
    markLable.textColor=[UIColor whiteColor];
    markLable.text=Weibo.content;
    markLable.lineBreakMode=NSLineBreakByCharWrapping;
    markLable.contentMode=UIViewContentModeBottom;
    markLable.textAlignment=NSTextAlignmentCenter;
    [self.ShareView addSubview:markLable];
    
    CGSize  Msize = [markLable.text boundingRectWithSize:CGSizeMake(kDeviceWidth-40, MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:[NSDictionary dictionaryWithObject:markLable.font forKey:NSFontAttributeName] context:nil].size;
    self.ShareView.frame=CGRectMake(self.ShareView.frame.origin.x, self.ShareView.frame.origin.y, self.ShareView.frame.size.width, self.stageImageView.frame.size.height+Msize.height-27);
    
    self.bgView.frame=CGRectMake(0, 0, kDeviceWidth, self.ShareView.frame.size.height+10);
    markLable.frame=CGRectMake(10, self.ShareView.frame.size.height-Msize.height-5 ,self.ShareView.frame.size.width-20,Msize.height);
    
    // 中间的视图
    [self createUserView];
    
    [self createLikeBar];
    
    
    
    
}
//创建中间的用户视图
-(void)createUserView
{
    //创建中部的view
    self.UserView =[[UIView alloc]initWithFrame:CGRectMake(0,self.ShareView.frame.origin.y+self.ShareView.frame.size.height+10, kDeviceWidth, USER_TOOL_HEIGHT)];
    self.UserView.backgroundColor =[UIColor whiteColor];
    [self.bgView addSubview:self.UserView];
    
    self.bgView.frame=CGRectMake(0, 0,kDeviceWidth, self.UserView.frame.origin.y+self.UserView.frame.size.height+0);
    
    //创建头像按钮
    leftButtomButton=[UIButton buttonWithType:UIButtonTypeCustom];
    leftButtomButton.frame=CGRectMake(10, 5,5, 35);
    //[leftButtomButton addTarget:self action:@selector(userHeadClick:) forControlEvents:UIControlEventTouchUpInside];
    //leftButtomButton.backgroundColor =[UIColor redColor];
    [self.UserView addSubview:leftButtomButton];
    
    weiboInfoModel   *weiboInfo =[self.pageContent objectAtIndex:self.pageIndex];
    headLogoImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,30, 30)];
    headLogoImageView.layer.cornerRadius=15;
    NSString  *uselogoString =[NSString stringWithFormat:@"%@%@!thumb",kUrlAvatar,weiboInfo.uerInfo.logo];
    [headLogoImageView sd_setImageWithURL:[NSURL URLWithString:uselogoString] placeholderImage:[UIImage imageNamed:@"user_normal.png"]];
    headLogoImageView.layer.masksToBounds = YES;
    [leftButtomButton addSubview:headLogoImageView];
    
    userNameLable =[[UILabel alloc]initWithFrame:CGRectMake(35,12,5, 30)];
    userNameLable.font=[UIFont systemFontOfSize:16];
    userNameLable.textColor=VGray_color;
    //movieNameLable.text=self.stageInfo.movieInfo.name;
    // movieNameLable.numberOfLines=1;
    userNameLable.lineBreakMode=NSLineBreakByTruncatingTail;
    [leftButtomButton addSubview:userNameLable];
    
    
    NSString  *nameStr=weiboInfo.uerInfo.username;
    CGSize  Nsize =[nameStr boundingRectWithSize:CGSizeMake(100, 27) options:(NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin) attributes:[NSDictionary dictionaryWithObject:userNameLable.font forKey:NSFontAttributeName] context:nil].size;
    userNameLable.frame=CGRectMake(35,0, Nsize.width+4, 30);
    leftButtomButton.frame=CGRectMake(10,5, 30+5+userNameLable.frame.size.width, 27);
    userNameLable.text=[NSString stringWithFormat:@"%@",nameStr];
    
    //喜欢的按钮
    UIButton * like_btn =[ZCControl createButtonWithFrame:CGRectMake(kStageWidth-70,5,70,25) ImageName:nil Target:self Action:nil Title:@""];
    like_btn.backgroundColor=View_BackGround;
    [self.UserView addSubview:like_btn];
    
    starImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 8, 14,12)];
    starImageView.image =[UIImage imageNamed:@"like_nomoal.png"];
    [like_btn addSubview:starImageView];
    
    Like_lable =[ZCControl createLabelWithFrame:CGRectMake(20,0,40, 25) Font:14 Text:@""];
    Like_lable.textColor=VGray_color;
    Like_lable.textAlignment=NSTextAlignmentCenter;
    if ([weiboInfo.like_count intValue]==0) {
        Like_lable.text=[NSString stringWithFormat:@"喜欢"];
    }
    else
    {
        Like_lable.text=[NSString stringWithFormat:@"%@",weiboInfo.like_count];
    }
    [like_btn addSubview:Like_lable];
    
}
#pragma  mark 创建底部的点击喜欢和不喜欢的按钮----
-(void)createLikeBar
{
    
    UIView *_toolView =[[UIView alloc]initWithFrame:CGRectMake(0, kDeviceHeight-LIKE_BAR_HEIGHT-kHeightNavigation,kDeviceWidth, LIKE_BAR_HEIGHT)];
    _toolView.userInteractionEnabled =YES;
    [self.view addSubview:_toolView];
    
    //UIButton  *btn1=[ZCControl createButtonWithFrame:CGRectMake(0, 0, kDeviceWidth/2, 50) ImageName:nil Target:self Action:@selector(likeBtnClick:) Title:@"喜欢"];
    UIButton  *btn1 =[UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame=CGRectMake(0, 0, kDeviceWidth/2, LIKE_BAR_HEIGHT);
    [btn1 setTitle:@"喜欢" forState:UIControlStateNormal];
    [btn1 setTitleColor:VGray_color forState:UIControlStateNormal];
    btn1.tag=99;
    [btn1 addActionHandler:^(NSInteger tag) {
        
        if (self.pageContent.count>self.pageIndex) {
            weiboInfoModel   *weiboInfo =[self.pageContent objectAtIndex:self.pageIndex];
            [self LikeRequstData:weiboInfo withOperation:@1];
        }
        else
        {
            [self.view addSubview:loadView];
            sharebtn.hidden=YES;
            [loadView showNullView:@"已经开完了..."];
        }
        
    }];
    [btn1 setBackgroundImage:[UIImage imageNamed:@"tabbar_backgroud_color.png"] forState:UIControlStateNormal];
    btn1.backgroundColor=[UIColor whiteColor];
    [_toolView addSubview:btn1];
    
    
    // UIButton  *btn2=[ZCControl createButtonWithFrame:CGRectMake(kDeviceWidth/2, 0, kDeviceWidth/2, 50) ImageName:nil Target:self Action:@selector(likeBtnClick:) Title:@"没感觉"];
    UIButton  *btn2 =[UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame=CGRectMake(kDeviceWidth/2, 0, kDeviceWidth/2, LIKE_BAR_HEIGHT);
    [btn2 setTitle:@"没感觉" forState:UIControlStateNormal];
    btn2.tag=100;
    [btn2 addActionHandler:^(NSInteger tag) {
        
        if (self.pageContent.count>self.pageIndex) {
            weiboInfoModel   *weiboInfo =[self.pageContent objectAtIndex:self.pageIndex];
            //没感觉
            [self disLikeRequstData:weiboInfo];
        }
        else
        {
            [self.view addSubview:loadView];
            sharebtn.hidden=YES;
            [loadView showNullView:@"已经开完了..."];
        }
        
    }];
    [btn2 setTitleColor:VGray_color forState:UIControlStateNormal];
    btn2.backgroundColor=[UIColor whiteColor];
    [btn2 setBackgroundImage:[UIImage imageNamed:@"tabbar_backgroud_color.png"] forState:UIControlStateNormal];
    [_toolView addSubview:btn2];
    
    //添加一个线
    UIView  *verline =[[UIView alloc]initWithFrame:CGRectMake(kDeviceWidth/2,12, 0.5, 26)];
    verline.backgroundColor =VLight_GrayColor;
    [_toolView addSubview:verline];
    
}
/*
 -(void)likeBtnClick:(UIButton *) btn
 {
 
 if (self.pageContent.count>self.pageIndex) {
 weiboInfoModel   *weiboInfo =[self.pageContent objectAtIndex:self.pageIndex];
 
 if (btn.tag==99) {
 //喜欢
 [self LikeRequstData:weiboInfo withOperation:@1];
 
 }
 else if (btn.tag==100)
 {
 //没感觉
 [self disLikeRequstData:weiboInfo];
 }
 }
 else
 {
 [self.view addSubview:loadView];
 sharebtn.hidden=YES;
 [loadView showNullView:@"已经开完了..."];
 }
 
 
 }*/


//根据下标值获取上一个控制器或者下一个控制器  得到相应的VC对象
/*- (FindDatailViewController *)viewControllerAtIndex:(NSUInteger)index {
 if (([self.pageContent count] == 0) || (index >= [self.pageContent count])) {
 return nil;
 }
 // 创建一个新的控制器类，并且分配给相应的数据
 FindDatailViewController * dataViewController =[[FindDatailViewController alloc] init];
 dataViewController.weiboInfo=[self.pageContent objectAtIndex:index];
 dataViewController.index=[self.indexArray objectAtIndex:index];
 return dataViewController;
 }
 // 根据数组元素值，得到下标值
 - (NSUInteger)indexOfViewController:(FindDatailViewController *)viewController {
 FindDatailViewController *dataViewController=(FindDatailViewController *)viewController;
 
 
 return [self.indexArray indexOfObject:dataViewController.index];
 }
 */

// 返回上一个ViewController对象
/*- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
 //获取当前控制器
 
 CenterViewController =(FindDatailViewController *)viewController;
 
 NSUInteger index = [self indexOfViewController:(FindDatailViewController *)viewController];
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
 
 CenterViewController =(FindDatailViewController *)viewController;
 NSUInteger index = [self indexOfViewController:(FindDatailViewController *)viewController];
 
 if (index == NSNotFound) {
 return nil;
 }
 index++;
 if (index == [self.pageContent count]) {
 return nil;
 }
 return [self viewControllerAtIndex:index];
 
 
 }
 */
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
