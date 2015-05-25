//
//  FindDatailViewController.m
//  movienext
//
//  Created by 风之翼 on 15/5/22.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "FindDatailViewController.h"

#import "ZCControl.h"
#import "Constant.h"

#import "StageView.h"


@interface FindDatailViewController ()<StageViewDelegate>
{
    StageView  *stageView;
}
@end

@implementation FindDatailViewController

-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden=YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //[self createNavigation];
    [self createUI];
    
}
-(void)createNavigation
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"tabbar_backgroud_color.png"] forBarMetrics:UIBarMetricsDefault];
    
    UILabel  *titleLable=[ZCControl createLabelWithFrame:CGRectMake(0, 0, 100, 20) Font:16 Text:@"发现详细"];
    titleLable.textColor=VBlue_color;
    
    titleLable.font=[UIFont boldSystemFontOfSize:18];
    titleLable.textAlignment=NSTextAlignmentCenter;
    self.navigationItem.titleView=titleLable;
    
    UIButton  *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"设置" forState:UIControlStateNormal];
    //[button setBackgroundImage:[UIImage imageNamed:@"setting.png"] forState:UIControlStateNormal];
    button.frame=CGRectMake(0, 0, 40, 40);
    [button setTitleColor:VBlue_color forState:UIControlStateNormal];
    [button addTarget:self action:@selector(GotoSettingClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem  *barButton=[[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem=barButton;
    
    
}
-(void)GotoSettingClick
{
    self.tabBarController.tabBar.hidden=NO;
    
}
-(void)createUI
{
    UIView *bgView= [[UIView alloc]initWithFrame:CGRectMake(0, 0,kDeviceWidth,(kDeviceWidth-10)*(9.0/16)+15)];
    bgView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:bgView];
    
    
    stageView = [[StageView alloc] initWithFrame:CGRectMake(5,5,kDeviceWidth-10, (kDeviceWidth-10)*(9.0/16))];
    stageView.isAnimation = YES;
    stageView.delegate=self;
    stageView.stageInfo=self.stageInfo;
    // stageView.weibosArray = self.stageInfo.weibosArray;
    [stageView configStageViewforStageInfoDict];
    [bgView addSubview:stageView];

    [self createLikeBar];
    
    
    
}
-(void)createLikeBar
{
    
    UIView *_toolView =[[UIView alloc]initWithFrame:CGRectMake(0, kDeviceHeight-50-kHeightNavigation,kDeviceWidth, 50)];
    _toolView.userInteractionEnabled =YES;
    [self.view addSubview:_toolView];
    
    UIButton  *btn1=[ZCControl createButtonWithFrame:CGRectMake(0, 0, kDeviceWidth/2, 50) ImageName:nil Target:self Action:@selector(likeBtnClick:) Title:@"喜欢"];
    btn1.tag=99;
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn1.backgroundColor=[UIColor whiteColor];
    [_toolView addSubview:btn1];
    
    UIButton  *btn2=[ZCControl createButtonWithFrame:CGRectMake(kDeviceWidth/2, 0, kDeviceWidth/2, 50) ImageName:nil Target:self Action:@selector(likeBtnClick:) Title:@"没感觉"];
    btn2.tag=100;
    btn2.backgroundColor=[UIColor whiteColor];
    [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_toolView addSubview:btn2];
    
}
-(void)likeBtnClick:(UIButton *) btn
{
    
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
