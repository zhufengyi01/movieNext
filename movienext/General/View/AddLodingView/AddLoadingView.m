//
//  AddLoadingView.m
//  movienext
//
//  Created by 风之翼 on 15/6/5.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "AddLoadingView.h"
#import "ZCControl.h"
#import "Constant.h"

@implementation AddLoadingView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
-(instancetype)initWithtitle:(NSString *) title;
{
    if (self =[super init]) {
        self.frame=CGRectMake(0, 0, kDeviceWidth, kDeviceHeight);
        _title=title;
        self.backgroundColor =[[UIColor blackColor] colorWithAlphaComponent:0.2];
        [self createUI];
        
    }
    return self;
}
// 内容视图
-(void)createUI
{
    
    UIView  *bgView =[[UIView alloc]initWithFrame:CGRectMake((kDeviceWidth-160)/2, (kDeviceHeight-50)/2, 160, 50)];
    bgView.backgroundColor =[UIColor whiteColor];
    bgView.layer.cornerRadius=4;
    [self addSubview:bgView];
    
    activitiView =[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activitiView.frame=CGRectMake(15, 15, 20, 20);
    [activitiView startAnimating];
    [bgView addSubview:activitiView];
    
    self.titleLable =[ZCControl createLabelWithFrame:CGRectMake(30, 10, 120, 30) Font:14 Text:_title];
    self.titleLable.textColor=VGray_color;
    self.titleLable.textAlignment=NSTextAlignmentCenter;
    self.titleLable.backgroundColor =[UIColor clearColor];
    [bgView addSubview:self.titleLable];
    
}
-(void)show;
{
    [AppView addSubview:self];
}
-(void)remove
{
    [self removeFromSuperview];
    
}

@end
