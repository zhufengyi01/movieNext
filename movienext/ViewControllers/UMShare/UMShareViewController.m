//
//  UMShareViewController.m
//  movienext
//
//  Created by 风之翼 on 15/4/7.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "UMShareViewController.h"
#import "ZCControl.h"
#import "Constant.h"
#import "NewViewController.h"
#import "Function.h"
@interface UMShareViewController ()
{
    UIView  *shareView;
}
@end

@implementation UMShareViewController
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    [self createNavigation];
    [self createButtomView];
    [self createStageView];
    
}
-(void)createNavigation
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"tabbar_backgroud_color.png"] forBarMetrics:UIBarMetricsDefault];
    
    UILabel  *titleLable=[ZCControl createLabelWithFrame:CGRectMake(0, 0, 100, 20) Font:16 Text:@"分享"];
    titleLable.textColor=VBlue_color;
    titleLable.font=[UIFont boldSystemFontOfSize:18];
    titleLable.textAlignment=NSTextAlignmentCenter;
    self.navigationItem.titleView=titleLable;
    
    UIButton  *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"取消" forState:UIControlStateNormal];
    [button setTitleColor:VBlue_color forState:UIControlStateNormal];
    button.frame=CGRectMake(10, 10, 40, 30);
    button.titleLabel.font =[UIFont boldSystemFontOfSize:18];
    [button addTarget:self action:@selector(CancleShareClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem  *barButton=[[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem=barButton;

}
-(void)CancleShareClick:(UIButton *) button
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)createButtomView
{
    
    buttomView=[[UIView alloc]initWithFrame:CGRectMake(0, kDeviceHeight-kDeviceWidth/4-kHeightNavigation, kDeviceWidth, kDeviceWidth/4)];
    buttomView.backgroundColor=[UIColor whiteColor];
    buttomView.userInteractionEnabled=YES;
    [self.view addSubview:buttomView];
#pragma create four button
    NSArray  *imageArray=[NSArray arrayWithObjects:@"wechat_share_icon.png",@"moments_share_icon.png",@"qzone_share_icon.png",@"weibo_share_icon.png", nil];
    
    for (int i=0; i<4; i++) {
        double   x=(kDeviceWidth/4)*i;
        double   y=0;
        UIButton  *    btn = [ZCControl createButtonWithFrame:CGRectMake(x,y, kDeviceWidth/4, kDeviceWidth/4) ImageName:imageArray[i] Target:self Action:@selector(handShareButtonClick:) Title:nil];
        btn.tag=10000+i;
        btn.backgroundColor=[UIColor whiteColor];
        [buttomView addSubview:btn];
        
    }

    
}
-(void)createStageView
{
    //self.view.backgroundColor=VStageView_color;
    shareView =[[UIView alloc]initWithFrame:CGRectMake(0,(kDeviceHeight-(kDeviceWidth/4)-kDeviceWidth-20-kHeightNavigation)/2, kDeviceWidth, kDeviceWidth+20)];
    shareView.userInteractionEnabled=YES;
    shareView.backgroundColor=VStageView_color;
    [self.view addSubview:shareView];
    
    _ShareimageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth,kDeviceWidth)];
    _ShareimageView.backgroundColor=[UIColor whiteColor];
    _ShareimageView.image=self.screenImage;
    [shareView addSubview:_ShareimageView];
    
    //放置电影名和标签的view
    logosupView=[[UIView alloc]initWithFrame:CGRectMake(0,kDeviceWidth, kDeviceWidth, 20)];
    logosupView.backgroundColor=VStageView_color;
    logosupView.hidden=YES;
    [shareView addSubview:logosupView];
    
    _moviewName= [ZCControl createLabelWithFrame:CGRectMake(10,0,180, 20) Font:12 Text:@""];
    _moviewName.textColor=VLight_GrayColor;
    _moviewName.numberOfLines=0;
    _moviewName.text=self.StageInfo.movieInfo.name;
    _moviewName.adjustsFontSizeToFitWidth=NO;
    _moviewName.lineBreakMode=NSLineBreakByTruncatingTail;
    [logosupView addSubview:_moviewName];
    
    logoLable=[ZCControl createLabelWithFrame:CGRectMake(kDeviceWidth-60,0, 50, 20) Font:12 Text:@"影弹App"];
    logoLable.textAlignment=NSTextAlignmentRight;
    logoLable.textColor=VLight_GrayColor;
    [logosupView addSubview:logoLable];
    
}
//点击分享
-(void)handShareButtonClick:(UIButton *) button
{
    logosupView.hidden=NO;
    [self dismissViewControllerAnimated:YES completion:^{
        shareImage=[Function getImage:shareView WithSize:CGSizeMake(kDeviceWidth, kDeviceWidth+20)];
        if (self.delegate &&[self.delegate respondsToSelector:@selector(UMShareViewControllerHandClick:ShareImage:StageInfoModel:)]) {
            [self.delegate UMShareViewControllerHandClick:button ShareImage:shareImage StageInfoModel:self.StageInfo];
        }

    }];
    
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
