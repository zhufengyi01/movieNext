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
    _topButtom.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.2];
    [self addSubview:_topButtom];
    
    
    //底部的
    buttomView =[[UIView alloc]initWithFrame:CGRectMake(0, kDeviceHeight, kDeviceWidth, 50)];
    buttomView.backgroundColor=VBlue_color;
    buttomView.userInteractionEnabled=YES;
    [self addSubview:buttomView];
    
    
    headButton=[UIButton buttonWithType:UIButtonTypeCustom];
    headButton.frame=CGRectMake(0,0, kDeviceWidth/3, 50);
    headButton.backgroundColor=VBlue_color;
    headButton.clipsToBounds=YES;
    [headButton addTarget:self action:@selector(dealButtomClick:) forControlEvents:UIControlEventTouchDragInside];
    headButton.tag=10000;
    headButton.titleLabel.font=[UIFont systemFontOfSize:14];
    [headButton setImage:[UIImage imageNamed:@"ic_menu_person_default.png"] forState:UIControlStateNormal];
    [headButton setTitle:@"主页" forState:UIControlStateNormal];
    [buttomView addSubview:headButton];
    
   // nameLable =[ZCControl createLabelWithFrame:CGRectMake(headButton.frame.origin.x+headButton.frame.size.width+10, 10,100, 20) Font:14 Text:@"名字"];
    //nameLable.textColor=[UIColor whiteColor];
    //[buttomView addSubview:nameLable];

    UIView  *lineView1=[[UIView alloc]initWithFrame:CGRectMake(kDeviceWidth/3, 10, 1, 30)];
    lineView1.backgroundColor=VLight_GrayColor;
    [buttomView addSubview:lineView1];
    
    
    shareButton =[ZCControl createButtonWithFrame:CGRectMake(kDeviceWidth/3,0,kDeviceWidth/3,50) ImageName:nil Target:self Action:@selector(dealButtomClick:) Title:@"分享"];
    shareButton.titleLabel.font=[UIFont systemFontOfSize:14];

    [shareButton setImage:[UIImage imageNamed:@"ic_menu_share_default.png"] forState:UIControlStateNormal];
    shareButton.tag=10001;
    [buttomView addSubview:shareButton];
    
    
    UIView  *lineView2=[[UIView alloc]initWithFrame:CGRectMake((kDeviceWidth/3)*2, 10,1, 30)];
    lineView2.backgroundColor=VLight_GrayColor;
    [buttomView addSubview:lineView2];
    

    zanbutton =[ZCControl createButtonWithFrame:CGRectMake((kDeviceWidth/3)*2, 0, kDeviceWidth/2, 50) ImageName:nil Target:self Action:@selector(dealButtomClick:) Title:@"点赞"];
    zanbutton.tag=10002;
   //[ zanbutton setImage:[UIImage imageNamed:@"ic_menu_like_default.png""] f
    [zanbutton setImage:[UIImage imageNamed:@"ic_menu_like_default.png"] forState:UIControlStateNormal];
    [zanbutton setTitle:@"已赞" forState:UIControlStateSelected];
    zanbutton.titleLabel.font=[UIFont systemFontOfSize:14];

    //高亮显示
    [buttomView addSubview:zanbutton];

    
}
// 设置toolbar 的值
-(void)setToolBarValue:(NSDictionary *)dict :(id)markView WithStageInfo:(NSDictionary *)stageInfoDict
//-(void)setToolBarValue:(NSDictionary  *) dict :(id) markView;
{
    //把字典传过来，然后通过代理再传出去
    _weiboDict=dict;
    _markView=markView;
    zanNum=[[dict objectForKey:@"ups"]  intValue];
    //把这个字典存在了stageview 中,在代理的时候，又反悔给了controller
    stageInfo=[NSDictionary dictionaryWithDictionary:stageInfoDict];
    if ([[dict  objectForKey:@"uped"]  intValue]==0) {
        zanbutton.selected=NO;
    }
    else
    {
        zanbutton.selected=YES;
    }
    
    //[ headButton sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@!thumb", kUrlAvatar, [dict objectForKey:@"avatar"]]] forState:UIControlStateNormal placeholderImage:nil];
    //nameLable.text=[NSString stringWithFormat:@"%@",[dict objectForKey:@"username"]];
    
}
#pragma mark
#pragma mark  －－－－底部视图的点击事件
//底部视图的点击事件
-(void)dealButtomClick:(UIButton  *) button
{
    

    if (self.delegete &&[self.delegete respondsToSelector:@selector(ToolViewHandClick::weiboDict:StageInfo:)]) {
        [self.delegete ToolViewHandClick:button :_markView weiboDict:_weiboDict StageInfo:stageInfo];
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


//设置赞的状态为选中
-(void)SetZanButtonSelected
{
    if (zanbutton.selected==YES) {
        zanbutton.selected=NO;
        _markView.ZanNumLable.text=[NSString stringWithFormat:@"%d",zanNum-1];
        //如果原来ups＝1 .减到了0
        if (zanNum==0) {
            _markView.ZanNumLable.hidden=YES;
        }

    }
    else if (zanbutton.selected==NO)
    {
        zanbutton.selected=YES;
        _markView.ZanNumLable.text=[NSString stringWithFormat:@"%d",zanNum+1];
        //如果原来是0 增到了1
        if (zanNum==1) {
            CGRect   frame=_markView.frame;
            frame.size.width+=8;
            _markView.frame=frame;
            
        }

    }
    
}

@end
