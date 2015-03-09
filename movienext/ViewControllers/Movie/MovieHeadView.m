//
//  MovieHeadView.m
//  movienext
//
//  Created by 风之翼 on 15/3/7.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "MovieHeadView.h"
#import "ZCControl.h"
#import "UIImageView+WebCache.h"
#import "Constant.h"
@implementation MovieHeadView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self= [super initWithFrame:frame]) {
        m_frame=frame;
        [self createUI];
    }
    return self;
}
-(void)createUI
{
    movieLogoImageView  =[[UIImageView alloc]initWithFrame:CGRectMake(30, 30, 40, 60)];
    [self addSubview:movieLogoImageView];
    
    titleLable=[ZCControl createLabelWithFrame:CGRectMake(0, 0,100 ,30) Font:16 Text:@"电影标题"];
    
    [self addSubview:titleLable];
    
    //导演
    derectorLable=[ZCControl createLabelWithFrame:CGRectMake(0,30,100,30) Font:12 Text:@"导演"];
    [self addSubview:titleLable];
    //演员
    performerLable=[ZCControl createLabelWithFrame:CGRectMake(0, 60, 100, 30) Font:12 Text:@"演员"];
    [self addSubview:performerLable];
    
    UIView  *btnBg =[[UIView  alloc] initWithFrame:CGRectMake(0, kDeviceHeight/3-45, kDeviceWidth, 45)];
    btnBg.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.7];
    [self addSubview:btnBg];
    
    //UIButton  *btn1=[ZCControl createButtonWithFrame:CGRectMake(0,0, kDeviceWidth/2, 45) ImageName:@"" Target:self Action:@selector(dealChangeModelClick:) Title:@""];
    UIButton  *btn1=[UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame=CGRectMake(0, 0, kDeviceWidth/2, 45);
    [btn1 setImage:[UIImage imageNamed:@"single_switch@2x"] forState:UIControlStateNormal];
    
    btn1.tag=1000;
    [btnBg addSubview:btn1];
    
    //UIButton  *btn2=[ZCControl createButtonWithFrame:CGRectMake(kDeviceWidth/2,0, kDeviceWidth/2, 45) ImageName:@"" Target:self Action:@selector(dealChangeModelClick:) Title:@""];
    UIButton  *btn2=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn2 setImage:[UIImage imageNamed:@"three switch@2x"] forState:UIControlStateNormal];
    btn2.tag=1001;
    [self addSubview:btn2];

    
}
-(void)setCollectionHeaderValue:(NSDictionary *)dict
{
    
}
-(void)dealChangeModelClick:(UIButton *) button
{
    if (self.delegate&& [self.delegate respondsToSelector:@selector(ChangeCollectionModel:)]) {
        [self.delegate ChangeCollectionModel:button.tag];
    }

}
//自动布局self.view的子类
-(void)layoutSubviews
{
    
}
@end
