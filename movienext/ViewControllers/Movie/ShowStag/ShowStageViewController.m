//
//  ShowStageViewController.m
//  movienext
//
//  Created by 杜承玖 on 3/19/15.
//  Copyright (c) 2015 redianying. All rights reserved.
//

#import "ShowStageViewController.h"
#import "StageView.h"
#import "StageInfoModel.h"
#import "WeiboModel.h"
#import "ZCControl.h"
#import "Constant.h"
#import "AddMarkViewController.h"

@implementation ShowStageViewController
{
    UIScrollView *scrollView;
    UIView *BgView2;
    UIButton  *ScreenButton;
    UIButton  *addMarkButton;
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.alpha=1;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createScrollView];
    //[self createTopView];
    [self createStageView];
    //创建底部的分享
    [self createButtonView1];
}

-(void)createScrollView
{
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-45)];
    scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:scrollView];
}
//-(void)createTopView
//{
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.frame = CGRectMake(kDeviceWidth-100, 0, 100, 44);
//    [btn setTitle:@"完成" forState:UIControlStateNormal];
//    [btn addTarget:self action:@selector(handleComplete) forControlEvents:UIControlEventTouchUpInside];
//    [scrollView addSubview:btn];
//}

-(void)createStageView
{
    float  ImageWith=[self.movieModel.stageinfo.w floatValue];
    float  ImgeHight=[self.movieModel.stageinfo.h floatValue];
    float hight=0;
    hight= kDeviceWidth;  // 计算的事bgview1的高度
    if(ImgeHight>ImageWith)
    {
        hight=  (ImgeHight/ImageWith) *kDeviceWidth;
    }
    float y = hight >= kDeviceHeight ? 0 : (kDeviceHeight - hight)/2;
    scrollView.contentSize = CGSizeMake(kDeviceWidth, MAX(kDeviceHeight, hight));

    StageView *stageView = [[StageView alloc] initWithFrame:CGRectMake(0, y, kDeviceWidth, hight)];
    stageView.StageInfoDict=self.movieModel.stageinfo;
    stageView.WeibosArray = self.movieModel.weibos;
    [stageView configStageViewforStageInfoDict];
     [scrollView addSubview:stageView];
    [stageView startAnimation];
    
    //创建分享和添加弹幕的的底部试图
}
-(void)createButtonView1
{
    BgView2=[[UIView alloc]initWithFrame:CGRectMake(0, kDeviceHeight-kHeightNavigation-45, kDeviceWidth, 45)];
    //改变toolar 的颜色
    
    BgView2.backgroundColor=View_ToolBar;
    [self.view bringSubviewToFront:BgView2];
    [self.view addSubview:BgView2];

    ScreenButton =[ZCControl createButtonWithFrame:CGRectMake(kDeviceWidth-140,10,60,26) ImageName:@"btn_share_default.png" Target:self Action:@selector(ScreenButtonClick:) Title:@""];
    [ScreenButton setBackgroundImage:[UIImage imageNamed:@"btn_share_select.png"] forState:UIControlStateHighlighted];
    [BgView2 addSubview:ScreenButton];
    
    addMarkButton =[ZCControl createButtonWithFrame:CGRectMake(kDeviceWidth-70,10,60,26) ImageName:@"btn_add_default.png" Target:self Action:@selector(addMarkButtonClick:) Title:@""];
    [addMarkButton setBackgroundImage:[UIImage imageNamed:@"btn_add_select.png"] forState:UIControlStateHighlighted];
    [BgView2 addSubview:addMarkButton];
    
}
// 分享
-(void)ScreenButtonClick:(UIButton  *) button
{
    
}
//添加弹幕
-(void)addMarkButtonClick:(UIButton  *) button
{
    
    
    NSLog(@" ==addMarkButtonClick  ====%ld",button.tag);
    AddMarkViewController  *AddMarkVC=[[AddMarkViewController alloc]init];
    //HotMovieModel  *hotmovie=[[HotMovieModel alloc]init];
   
    AddMarkVC.stageInfoDict=self.movieModel.stageinfo;
    NSLog(@"dict.stageinfo = %@", AddMarkVC.stageInfoDict);
    [self.navigationController pushViewController:AddMarkVC animated:NO];

}

//- (void)handleComplete {
//    [self dismissViewControllerAnimated:NO completion:^{ }];
//}

@end
