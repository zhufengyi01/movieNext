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

@interface CustmoTabBarController ()<CustomTabBarDelegate>
@property (nonatomic, strong) CustomTabBar * m_tabBar;
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
    NewViewController * newVC = [[NewViewController alloc] init];
    UINavigationController * fristNav = [[UINavigationController alloc] initWithRootViewController:newVC];
    
    
    MovieViewController * movieVC = [[MovieViewController alloc] init];
    UINavigationController * secondNav = [[UINavigationController alloc] initWithRootViewController:movieVC];
    
    NotificationViewController * notVC = [[NotificationViewController alloc] init];
    UINavigationController * thirdNav = [[UINavigationController alloc] initWithRootViewController:notVC];
    
    MyViewController * myVC = [[MyViewController alloc] init];
    UINavigationController * fouthNav = [[UINavigationController alloc] initWithRootViewController:myVC];
    NSArray * controllerArr = [NSArray arrayWithObjects:fristNav, secondNav, thirdNav, fouthNav, nil];
    self.viewControllers = controllerArr;
}

-(void)createCustomTabBar
{
    
    CGRect frame = [[UIScreen mainScreen] bounds];
    self.m_tabBar = [[CustomTabBar alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 49)];
    self.m_tabBar.m_delegate = self;
    self.m_tabBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tabbar_backgroud_color.png"]]; // 设置tabar 的背景图片
    [self.tabBar addSubview:self.m_tabBar];
    
    
}
#pragma  mark ---
#pragma  mark ---   ---CustomTabBarDelegate  ----
#pragma  mark ---
- (void)buttonPresedInCustomTabBar:(NSUInteger)index
{
    self.selectedIndex = index;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
