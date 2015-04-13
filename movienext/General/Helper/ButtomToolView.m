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
#import "Function.h"
#import "UserDataCenter.h"
#import "UpweiboModel.h"
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
    _topButtom.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0];
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
    
    
    
    shareButton =[ZCControl createButtonWithFrame:CGRectMake(kDeviceWidth/3,0,kDeviceWidth/3,50) ImageName:nil Target:self Action:@selector(dealButtomClick:) Title:@"分享"];
    shareButton.backgroundColor=VBlue_color;
    shareButton.titleLabel.font=[UIFont systemFontOfSize:14];
    [shareButton setTitleEdgeInsets:UIEdgeInsetsMake(10, 25, 10, 10)];
  
    [shareButton setImage:[UIImage imageNamed:@"ic_menu_share_default.png"] forState:UIControlStateNormal];
    [shareButton setBackgroundImage:[UIImage imageNamed:@"loginoutbackgroundcolor.png"] forState:UIControlStateNormal];
    shareButton.tag=10001;
    [buttomView addSubview:shareButton];
    
    

    zanbutton =[ZCControl createButtonWithFrame:CGRectMake((kDeviceWidth/3)*2, 0, kDeviceWidth/3, 50) ImageName:nil Target:self Action:@selector(dealButtomClick:) Title:@"点赞"];
    zanbutton.tag=10002;
    //[zanbutton setImage:[UIImage imageNamed:@"ic_menu_like_default.png"] forState:UIControlStateNormal];
    [zanbutton setBackgroundImage:[UIImage imageNamed:@"loginoutbackgroundcolor.png"] forState:UIControlStateNormal];
    [zanbutton setTitle:@"已赞" forState:UIControlStateSelected];
    [zanbutton setTitleEdgeInsets:UIEdgeInsetsMake(10, 25, 10, 10)];
    zanbutton.titleLabel.font=[UIFont systemFontOfSize:14];
    
    // 在赞上面添加一个大拇指
    likeimageview=[[UIImageView alloc]initWithFrame:CGRectMake((zanbutton.frame.size.width)/2 -13-15, zanbutton.frame.size.height/2 -14/2, 15, 14)];
    likeimageview.image=[UIImage imageNamed:@"ic_menu_like_default.png"];
    [zanbutton addSubview:likeimageview];
    //高亮显示
    [buttomView addSubview:zanbutton];
    
    UIView  *lineView1=[[UIView alloc]initWithFrame:CGRectMake(kDeviceWidth/3, 15, 1, 20)];
    lineView1.backgroundColor=VLight_GrayColor;
    [buttomView addSubview:lineView1];
    
    UIView  *lineView2=[[UIView alloc]initWithFrame:CGRectMake((kDeviceWidth/3)*2, 15,1, 20)];
    lineView2.backgroundColor=VLight_GrayColor;
    [buttomView addSubview:lineView2];
  
    UserDataCenter  *userCenter =[UserDataCenter shareInstance];
  //  if ([userCenter.is_admin  intValue]>0) {
    morebuton=[ZCControl createButtonWithFrame:CGRectMake(0, 0, 30, 50) ImageName:@"loginoutbackgroundcolor.png" Target:self Action:@selector(dealButtomClick:) Title:@""];
    [morebuton setImage:[UIImage imageNamed:@"single_switch(gray).png"] forState:UIControlStateNormal];
    morebuton.tag=10003;
    [buttomView addSubview:morebuton];
    //}


    
}
// 设置toolbar 的值
-(void)configToolBar
{
//    if ([self.weiboInfo.uped  intValue]==0) {
//        //没有赞的时候
//         zanbutton.selected=NO;
//        likeimageview.image=[UIImage imageNamed:@"ic_menu_like_default.png"];
//    }
//    else
//    {
//        zanbutton.selected=YES;
//        likeimageview.image=[UIImage imageNamed:@"liked_icon_light"];
//      
//    }
    //获取了当前微博对象，如果当前的微博对象在数组中有的话，那就需要显示为已赞
    
    for (int i=0; i<self.upweiboArray.count; i++) {
        UpweiboModel *upmodel=self.upweiboArray[i];
        if ([upmodel.weibo_id intValue]==[self.weiboInfo.Id intValue]) {
            zanbutton.selected=YES;
            likeimageview.image=[UIImage imageNamed:@"liked_icon_light"];
            break;
        }
        else{
            zanbutton.selected=NO;
            likeimageview.image=[UIImage imageNamed:@"ic_menu_like_default.png"];

        }
    }
    
}
#pragma mark
#pragma mark  －－－－底部视图的点击事件
//底部视图的点击事件
-(void)dealButtomClick:(UIButton  *) button
{
    
    if (button.tag==10002) {
        
      if (zanbutton.selected==YES) {
        zanbutton.selected=NO;
        likeimageview.image=[UIImage imageNamed:@"ic_menu_like_default.png"];
      }
      else if (zanbutton.selected==NO)
    {
        zanbutton.selected=YES;
        //如果按钮点击的是赞的话
        if (button==zanbutton) {
        //执行放大动画又缩小回去
           likeimageview.image=[UIImage imageNamed:@"liked_icon_light@2x.png"];
            [Function BasicAnimationwithkey:@"transform.scale" Duration:0.25 repeatcont:1 autoresverses:YES fromValue:1.0 toValue:1.5 View:likeimageview];
        }
        
    }
    }
    if (self.delegete &&[self.delegete respondsToSelector:@selector(ToolViewHandClick::weiboDict:StageInfo:)]) {
        [self.delegete ToolViewHandClick:button :_markView weiboDict:self.weiboInfo StageInfo:self.stageInfo];
    }
}


//显示底部试图
-(void)ShowButtomView;
{
    [UIView animateWithDuration:0.5 animations:^{
        CGRect  Bframe=buttomView.frame;
        Bframe.origin.y=m_frame.size.height-kHeightNavigation-50;
        buttomView.frame=Bframe;
    } completion:^(BOOL finished) {
    }];
}
//隐藏底部试图
-(void)HidenButtomView;
{
    [UIView animateWithDuration:0.5 animations:^{
        CGRect  Bframe=buttomView.frame;
        Bframe.origin.y=m_frame.size.height-kHeightNavigation;
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
