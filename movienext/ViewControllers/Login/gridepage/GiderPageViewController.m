//
//  GiderPageViewController.m
//  movienext
//
//  Created by 风之翼 on 15/6/2.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "GiderPageViewController.h"

#import "ZCControl.h"

#import "LoginViewController.h"

#import "UIButton+Block.h"

#import "Constant.h"


#define  PAGE_SIZE  3

@interface GiderPageViewController () < UIScrollViewDelegate>

@property(nonatomic,strong) UIScrollView  *myScorllerView;

@property(nonatomic,strong) UIPageControl  *pageControl;
@end


@implementation GiderPageViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden=YES;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    
}
-(void)createUI
{
    self.myScorllerView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, -20,kDeviceWidth, kDeviceHeight+20)];
    self.myScorllerView.contentSize=CGSizeMake(kDeviceWidth*3, kDeviceHeight);
    self.myScorllerView.pagingEnabled=YES;
    self.myScorllerView.bounces=NO;
    self.myScorllerView.showsHorizontalScrollIndicator=NO;
    self.myScorllerView.showsVerticalScrollIndicator=NO;
    self.myScorllerView.delegate=self;
    //self.myScorllerView.backgroundColor =[UIColor redColor];
    [self.view addSubview:self.myScorllerView];
    
    self.pageControl =[[UIPageControl alloc]initWithFrame:CGRectMake((kDeviceWidth-120)/2, kDeviceHeight-80, 120, 40)];
    //self.pageControl.tintColor=VBlue_color;
    self.pageControl.pageIndicatorTintColor=VLight_GrayColor;
    self.pageControl.currentPageIndicatorTintColor=VBlue_color;
    self.pageControl.numberOfPages=3;
    self.pageControl.currentPage=0;
    [self.view addSubview:self.pageControl];
    
    
    NSArray  *imageArr =@[@"page_01.png",@"page_02.png",@"page_03.png"];
    for (int i=0; i<3; i++) {
        double x=i*kDeviceWidth;
        UIImageView  *imageview=[[UIImageView alloc]initWithFrame:CGRectMake(x, 0, kDeviceWidth, kDeviceHeight-0)];
        imageview.backgroundColor =[UIColor blueColor];
        imageview.image =[UIImage imageNamed:imageArr[i]];
        [self.myScorllerView addSubview:imageview];
        
        if (i==2) {
            imageview.userInteractionEnabled=YES;
            UIButton  *btn =[UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame=CGRectMake((kDeviceWidth-140)/2, kDeviceHeight-140, 140, 42);
            
            [btn addTarget:self action:@selector(goLogin) forControlEvents:UIControlEventTouchUpInside];
            
            [btn setBackgroundImage:[UIImage imageNamed:@"come_in.png"] forState:UIControlStateNormal];
            [imageview addSubview:btn];
            
        }
        
    }
    
    
}
-(void)goLogin
{
    
    [self.navigationController pushViewController:[LoginViewController new] animated:YES];
    
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    NSInteger   index =scrollView.contentOffset.x/kDeviceWidth;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.pageControl.currentPage=index;
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
