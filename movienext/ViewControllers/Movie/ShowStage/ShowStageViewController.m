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

@implementation ShowStageViewController
{
    UIScrollView *scrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createScrollView];
    [self createTopView];
    [self createStageView];
}

-(void)createScrollView
{
    scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    scrollView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:scrollView];
}
-(void)createTopView
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(kDeviceWidth-100, 0, 100, 44);
    [btn setTitle:@"完成" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(handleComplete) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:btn];
}

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
}

- (void)handleComplete {
    [self dismissViewControllerAnimated:NO completion:^{ }];
}

@end
