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
    
    UIButton  *btn1=[ZCControl createButtonWithFrame:CGRectMake(0, 100, kDeviceWidth/2, 35) ImageName:nil Target:self Action:@selector(dealChangeModelClick:) Title:@"大图"];
    btn1.backgroundColor = [UIColor greenColor];
    btn1.tag=1000;
    [self addSubview:btn1];
    
    UIButton  *btn2=[ZCControl createButtonWithFrame:CGRectMake(kDeviceWidth/2, 100, kDeviceWidth/2, 35) ImageName:nil Target:self Action:@selector(dealChangeModelClick:) Title:@"小图"];
    btn2.backgroundColor = [UIColor blueColor];
    btn2.tag=1001;
    [self addSubview:btn2];

    
}
-(void)setCollectionHeaderValue:(NSDictionary *)dict
{
    
}
-(void)dealChangeModelClick:(UIButton *) button
{
//    if (button.tag==1000) {
//        //切换大图
//        
//    }
//     else if(button.tag==1001)
//     {
//         //切换小图
//     }
    
    if (self.delegate&& [self.delegate respondsToSelector:@selector(ChangeCollectionModel:)]) {
        [self.delegate ChangeCollectionModel:button.tag];
    }

}
//自动布局self.view的子类
-(void)layoutSubviews
{
    
}
@end
