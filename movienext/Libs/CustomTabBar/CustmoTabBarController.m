//
//  CustmoTabBarController.m
//  CustomTabBar
//
//  Created by qianfeng on 14-8-30.
//  Copyright (c) 2014年 qianfeng. All rights reserved.
//

#import "CustmoTabBarController.h"
#import "NewViewController.h" 
#import "MovieViewController.h"
#import "NotificationViewController.h"
#import "MyViewController.h"
#import "CustomTabBar.h"
#import "ZCControl.h"
#import "FinderViewController.h"
#import "AddViewController.h"
#import "UIImage+ImageWithColor.h"
#import "Constant.h"
#import "FindBeforeViewController.h"
#import "FinderViewController.h"
#import "MainNavigationViewController.h"
#import "AppDelegate.h"

@interface CustmoTabBarController ()<CustomTabBarDelegate>
@property (nonatomic, strong) CustomTabBar * m_tabBar;
@property(nonatomic) NSUInteger previousSelectedIndex;//上一个选择的是
@end

@implementation CustmoTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createControllers];
    [self createCustomTabBar];
    
}
- (void)createControllers
{
   // NewViewController * newVC = [[NewViewController alloc] init];
    //UINavigationController * fristNav = [[UINavigationController alloc] initWithRootViewController:newVC];
    
    MovieViewController * mvc = [[MovieViewController alloc] init];
    MainNavigationViewController * mvcNav = [[MainNavigationViewController alloc] initWithRootViewController:mvc];
    mvc.hidesBottomBarWhenPushed=YES;
    
    //添加一个发现页
    /*FindBeforeViewController  *fvc =[[FindBeforeViewController alloc]init];
    UINavigationController *fvcNav =[[UINavigationController alloc]initWithRootViewController:fvc];
    
    
    //添加页
    AddViewController *add =[[AddViewController alloc]init];
    UINavigationController *addNav =[[UINavigationController alloc]initWithRootViewController:add];
    */
    
    NotificationViewController * notVC = [[NotificationViewController alloc] init];
    UINavigationController *notNav = [[UINavigationController alloc] initWithRootViewController:notVC];
    
    MyViewController * myVC = [[MyViewController alloc] init];
    UINavigationController *myNav = [[UINavigationController alloc] initWithRootViewController:myVC];
    
   
    NSArray * controllerArr = [NSArray arrayWithObjects:mvcNav, notNav, myNav, nil];
    self.viewControllers = controllerArr;
     // 设置navigationbar的阴影
    [[UINavigationBar appearance] setShadowImage:[UIImage imageWithColor:tabBar_line size:CGSizeMake(kDeviceWidth, 1)]];
    
}
-(void)createCustomTabBar
{
    
    CGRect frame = [[UIScreen mainScreen] bounds];
    self.m_tabBar = [[CustomTabBar alloc] initWithFrame:CGRectMake(0, 1, frame.size.width, 48)];
    self.m_tabBar.m_delegate = self;
    self.m_tabBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tabbar_backgroud_color.png"]]; // 设置tabar 的背景图片
    [self.tabBar addSubview:self.m_tabBar];
    
    
}
#pragma  mark ---
#pragma  mark ---   ---CustomTabBarDelegate  ----
#pragma  mark ---
- (void)buttonPresedInCustomTabBar:(NSUInteger)index
{
    
     if (index==0) {
         self.selectedIndex=0;
         
         if (_previousSelectedIndex == 0) {
             [[NSNotificationCenter defaultCenter] postNotificationName:@"requestRecommendData" object:nil];
         }
         _previousSelectedIndex = 0;
     }
    else if(index==1)
    {
        //发现
 
    }
    else if (index==2)
    {
        //添加
    }
    else if(index==3)
    {
        self.selectedIndex=1;
        _previousSelectedIndex = 1;
    }
    else if (index==4)
    {
        self.selectedIndex=2;
        _previousSelectedIndex = 2;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
