//
//  MarkView.m
//  movienext
//
//  Created by 风之翼 on 15/3/4.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "MarkView.h"
#import "ZCControl.h"

@implementation MarkView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        m_frame=frame;
        [self createUI];
    }
    return self;
}
-(void)createUI
{
    //左视图
    _LeftImageView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0,20, 20)];
    _LeftImageView.layer.borderWidth=0.5;
    _LeftImageView.layer.cornerRadius=3;
    _LeftImageView.layer.masksToBounds=YES;
    _LeftImageView.layer.borderColor=[[UIColor whiteColor] CGColor];
    [self addSubview:_LeftImageView];
    
    //右视图
    _rightView=[[UIView alloc]initWithFrame:CGRectMake(23, 0,200,30)];
    _rightView.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.7];
    _rightView.layer.cornerRadius=3;
    _rightView.layer.masksToBounds=YES;
    [self addSubview:_rightView];
    
    //标题，点赞的view
    TitleLable=[ZCControl createLabelWithFrame:CGRectMake(0,0, 120, 30) Font:12 Text:@"标题"];
    //TitleLable.backgroundColor=[UIColor whiteColor];
    TitleLable.textColor=[UIColor whiteColor];
    [_rightView addSubview:TitleLable];
    
    ZanImageView=[ZCControl createImageViewWithFrame:CGRectMake(TitleLable.frame.size.width, 0, 11,11) ImageName:@"tag_like_icon.png"];
    [_rightView addSubview:TitleLable];
    
    _ZanNumLable=[ZCControl createLabelWithFrame:CGRectMake(TitleLable.frame.size.width, 0, 15, 15) Font:12 Text:@"15"];
    _ZanNumLable.textColor=[UIColor whiteColor];
    [_rightView addSubview:_ZanNumLable];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
