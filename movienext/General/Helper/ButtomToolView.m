//
//  ButtomToolView.m
//  movienext
//
//  Created by 风之翼 on 15/3/11.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "ButtomToolView.h"
#import "Constant.h"
#import "ZCControl.h"
#import "UIButton+WebCache.h"
@implementation ButtomToolView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self =[super initWithFrame:frame]) {
        m_frame=frame;
        self.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0];
        [self createButtomView];
    }
    return self;
}
-(void)createButtomView
{
    //self.backgroundColor = VBlue_color;
    //self.userInteractionEnabled=YES;
    
   // 上面的透明背景
    _topButtom =[UIButton buttonWithType:UIButtonTypeSystem];
    _topButtom.frame=CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-50-kHeightNavigation);
    _topButtom.backgroundColor=[UIColor redColor];
    [_topButtom addTarget:self action:@selector(TouchbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
    _topButtom.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.5];
    [self addSubview:_topButtom];
    
    
    //底部的
    buttomView =[[UIView alloc]initWithFrame:CGRectMake(0, kDeviceHeight, kDeviceWidth, 50)];
    buttomView.backgroundColor=VBlue_color;
    buttomView.userInteractionEnabled=YES;
    [self addSubview:buttomView];
    
    
    headButton=[UIButton buttonWithType:UIButtonTypeCustom];
    headButton.frame=CGRectMake(0,0, kDeviceWidth/3, 50);
   
   // headButton.clipsToBounds=YES;
    [headButton addTarget:self action:@selector(dealButtomClick:) forControlEvents:UIControlEventTouchUpInside];
    headButton.tag=10000;
    headButton.titleLabel.font=[UIFont systemFontOfSize:14];
    [headButton setImage:[UIImage imageNamed:@"ic_menu_person_default.png"] forState:UIControlStateNormal];
    [headButton setBackgroundImage:[UIImage imageNamed:@"loginoutbackgroundcolor.png"] forState:UIControlStateNormal];
    [headButton setTitle:@"主页" forState:UIControlStateNormal];
    [headButton setTitleEdgeInsets:UIEdgeInsetsMake(10, 25, 10, 10)];
    [buttomView addSubview:headButton];
    

    UIView  *lineView1=[[UIView alloc]initWithFrame:CGRectMake(kDeviceWidth/3, 15, 1, 20)];
    lineView1.backgroundColor=VLight_GrayColor;
    [buttomView addSubview:lineView1];
    
    
    shareButton =[ZCControl createButtonWithFrame:CGRectMake(kDeviceWidth/3,0,kDeviceWidth/3,50) ImageName:nil Target:self Action:@selector(dealButtomClick:) Title:@"分享"];
    shareButton.backgroundColor=VBlue_color;
    shareButton.titleLabel.font=[UIFont systemFontOfSize:14];
    [shareButton setTitleEdgeInsets:UIEdgeInsetsMake(10, 25, 10, 10)];
  
    [shareButton setImage:[UIImage imageNamed:@"ic_menu_share_default.png"] forState:UIControlStateNormal];
    [shareButton setBackgroundImage:[UIImage imageNamed:@"loginoutbackgroundcolor.png"] forState:UIControlStateNormal];
    shareButton.tag=10001;
    [buttomView addSubview:shareButton];
    
    
    UIView  *lineView2=[[UIView alloc]initWithFrame:CGRectMake((kDeviceWidth/3)*2, 15,1, 20)];
    lineView2.backgroundColor=VLight_GrayColor;
    [buttomView addSubview:lineView2];
    

    zanbutton =[ZCControl createButtonWithFrame:CGRectMake((kDeviceWidth/3)*2, 0, kDeviceWidth/3, 50) ImageName:nil Target:self Action:@selector(dealButtomClick:) Title:@"点赞"];
    zanbutton.tag=10002;
    [zanbutton setImage:[UIImage imageNamed:@"ic_menu_like_default.png"] forState:UIControlStateNormal];
    [zanbutton setBackgroundImage:[UIImage imageNamed:@"loginoutbackgroundcolor.png"] forState:UIControlStateNormal];
    [zanbutton setTitle:@"已赞" forState:UIControlStateSelected];
    [zanbutton setTitleEdgeInsets:UIEdgeInsetsMake(10, 25, 10, 10)];
    zanbutton.titleLabel.font=[UIFont systemFontOfSize:14];

    //高亮显示
    [buttomView addSubview:zanbutton];

    
}
// 设置toolbar 的值
-(void)configToolBar
{
    //_weiboDict=dict;
    //_markView=markView;
    //zanNum=[self.weiboDict.ups integerValue];//[[self.weiboDict objectForKey:@"ups"]  intValue];
    //把这个字典存在了stageview 中,在代理的时候，又反悔给了controller
  //  stageInfo=[NSDictionary dictionaryWithDictionary:stageInfoDict];
    if ([self.weiboDict.uped  intValue]==0) {
        zanbutton.selected=NO;
    }
    else
    {
        zanbutton.selected=YES;
    }
    
    
}
#pragma mark
#pragma mark  －－－－底部视图的点击事件
//底部视图的点击事件
-(void)dealButtomClick:(UIButton  *) button
{
    
    if (zanbutton.selected==YES) {
        zanbutton.selected=NO;
    }
    else if (zanbutton.selected==NO)
    {
        zanbutton.selected=YES;
    }
    if (self.delegete &&[self.delegete respondsToSelector:@selector(ToolViewHandClick::weiboDict:StageInfo:)]) {
        [self.delegete ToolViewHandClick:button :_markView weiboDict:self.weiboDict StageInfo:self.StageInfoDict];
    }
}

//显示底部试图
-(void)ShowButtomView;
{
    [UIView animateWithDuration:0.5 animations:^{
        CGRect  Bframe=buttomView.frame;
        Bframe.origin.y=kDeviceHeight-kHeightNavigation-50;
        buttomView.frame=Bframe;
    } completion:^(BOOL finished) {
    }];
}
//隐藏底部试图
-(void)HidenButtomView;
{
    [UIView animateWithDuration:0.5 animations:^{
        CGRect  Bframe=buttomView.frame;
        Bframe.origin.y=kDeviceHeight-kHeightNavigation;
        buttomView.frame=Bframe;
    } completion:^(BOOL finished) {
        
    }];
}
//点击屏幕
-(void)TouchbuttonClick:(UIButton *) button
{
    if (self.delegete &&[self.delegete respondsToSelector:@selector(topViewTouchBengan)]) {
        [self.delegete topViewTouchBengan];
    }
}


@end
