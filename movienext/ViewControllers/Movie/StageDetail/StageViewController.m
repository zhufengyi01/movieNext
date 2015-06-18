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
#define  TOOLBAR_HEIGHT  160

@interface StageViewController ()<UMShareViewDelegate,UIPageViewControllerDelegate,UIPageViewControllerDataSource,LoadingViewDelegate>
{
    //当前的detailcontroller
    StageDetailViewController *CenterViewController;
}
@property (strong, nonatomic) UIPageViewController *pageController;

//导航条的标题
@property(nonatomic,strong) UILabel             *naviTitlLable;


//@property(nonatomic,strong) weiboInfoModel     *weiboInfo;  // 初始化的时候，需要把weiboinfo设置成数组的第几个


@property(strong,nonatomic) NSMutableArray   *indexArray; //存储每个页面的索引


@end

@implementation StageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self createNavigation];
    [self createUI];
    
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
    self.indexArray =[[NSMutableArray alloc]init];
    for (int i=0; i<self.WeiboDataArray.count;i++) {
        NSString  *index =[NSString stringWithFormat:@"%d",i];
        [self.indexArray  addObject:index];
    }
}
-(void)createNavigation
{
    self.naviTitlLable=[ZCControl createLabelWithFrame:CGRectMake(0, 0, 100, 20) Font:16 Text:@"剧照详细页"];
    self.naviTitlLable.textColor=VGray_color;
    self.naviTitlLable.font=[UIFont fontWithName:kFontDouble size:16];
    self.naviTitlLable.textAlignment=NSTextAlignmentCenter;
    self.navigationItem.titleView=self.naviTitlLable;
    
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

//根据下标值获取上一个控制器或者下一个控制器  得到相应的VC对象
- (StageDetailViewController *)viewControllerAtIndex:(NSUInteger)index {
    if (([self.WeiboDataArray count] == 0) || (index >= [self.WeiboDataArray count])) {
        return nil;
    }
    // 创建一个新的控制器类，并且分配给相应的数据
    StageDetailViewController * dataViewController =[[StageDetailViewController alloc] init];
    dataViewController.weiboInfo=[self.WeiboDataArray objectAtIndex:index];
    dataViewController.index=[self.indexArray objectAtIndex:index];
    return dataViewController;
}
// 根据数组元素值，得到下标值
- (NSUInteger)indexOfViewController:(StageDetailViewController *)viewController {
    StageDetailViewController *dataViewController=(StageDetailViewController *)viewController;
    return [self.indexArray indexOfObject:dataViewController.index];
}

// 返回上一个ViewController对象
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    //获取当前控制器
    CenterViewController =(StageDetailViewController *)viewController;
    NSUInteger index = [self indexOfViewController:(StageDetailViewController *)viewController];
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
    
    CenterViewController =(StageDetailViewController *)viewController;
    NSUInteger index = [self indexOfViewController:(StageDetailViewController *)viewController];
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
