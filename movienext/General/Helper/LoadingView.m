//
//  LoadingView.m
//  movienext
//
//  Created by 风之翼 on 15/3/1.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "LoadingView.h"
#import "Constant.h"
@implementation LoadingView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        
        m_frame=frame;
        [self creatUI];
    }
    return self;
}
-(void)creatUI
{
    self.backgroundColor=View_BackGround;
    UIView  *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0,kDeviceWidth , kDeviceHeight)];
    [self addSubview:view];
    isanimal=YES;
    angle=10;
    imageView=[[UIImageView alloc]initWithFrame:CGRectMake((m_frame.size.width-30)/2, (m_frame.size.height-30)/2, 30, 30)];
    imageView.image=[UIImage imageNamed:@"loading_roll_image.png"];
    [self addSubview:imageView];
    [self startAnimation];
    
    
}
//开始动画
-(void)startAnimation
{
    isanimal=YES;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.01];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(endAnimation)];
    imageView.transform = CGAffineTransformMakeRotation(angle * (M_PI / 180.0f));
    [UIView commitAnimations];
    
}
-(void)endAnimation
{
    if (isanimal) {
        angle += 10;
        [self startAnimation];
    }
    
}
-(void)stopAnimation
{
    isanimal=NO;
}

@end
