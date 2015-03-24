//
//  LoadingView.m
//  movienext
//
//  Created by 风之翼 on 15/3/1.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "LoadingView.h"
#import "Constant.h"
#import "ZCControl.h"
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
    imageView.center=CGPointMake((kDeviceWidth)/2, (kDeviceHeight-kHeightNavigation)/2);
    [self addSubview:imageView];
    [self startAnimation];
    
    
    
    failLoadView =[[UIView alloc]initWithFrame:CGRectMake(0, (kDeviceWidth-100)/2, kDeviceWidth, 100)];
    failLoadView.hidden=YES;
    failLoadView.backgroundColor=View_BackGround;
    failLoadView.userInteractionEnabled=YES;
    [self addSubview:failLoadView];
    
    UILabel * failTitle=[ZCControl createLabelWithFrame:CGRectMake(0, 10, kDeviceWidth, 20) Font:14 Text:@"糟糕，网络连接失败"];
    failTitle.textAlignment=NSTextAlignmentCenter;
    failTitle.textColor=VGray_color;
    [failLoadView addSubview:failTitle];
    
    UIButton  *failBtn=[ZCControl createButtonWithFrame:CGRectMake((kDeviceWidth-80)/2, 40, 60, 40) ImageName:@"loginoutbackgroundcolor.png" Target:self Action:@selector(reloadDataClick:) Title:@"重试"];
    failBtn.layer.cornerRadius=4;
    failBtn.clipsToBounds=YES;
    [failLoadView addSubview:failBtn];
    
    
    
    
    NullDataView =[[UIView alloc]initWithFrame:CGRectMake(0, (kDeviceWidth-100)/2, kDeviceWidth, 100)];
    NullDataView.hidden=YES;
    NullDataView.backgroundColor=[UIColor yellowColor];
    NullDataView.userInteractionEnabled=YES;
    [self addSubview:NullDataView];
    
    UIImageView *smailview=[[UIImageView alloc]initWithFrame:CGRectMake((kDeviceWidth-50)/2, 20, 50, 50)];
    smailview.image=[UIImage imageNamed:@"notice_icon@2x .png!"];
    [NullDataView addSubview:smailview];
    
    UILabel * failTitle2=[ZCControl createLabelWithFrame:CGRectMake(0, 10, kDeviceWidth, 20) Font:14 Text:@"亲，没有数据"];
    failTitle2.textAlignment=NSTextAlignmentCenter;
    failTitle2.textColor=VGray_color;
    [NullDataView addSubview:failTitle2];
    
    
    
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
#pragma mark  加载失败的时候执行
//重新加载数据
-(void)reloadDataClick:(UIButton *)button
{
 
    if (self.delegate &&[self.delegate respondsToSelector:@selector(reloadDataClick)]) {
        [self.delegate reloadDataClick];
    }
    
}
//加载失败的时候执行这个
-(void)showFailLoadData;
{
    failLoadView.hidden=NO;
    [self stopAnimation];
    imageView.hidden=YES;
    
}
//隐藏加载失败
-(void)hidenFailLoadAndShowAnimation;
{
    failLoadView.hidden=YES;
    [self startAnimation];
    imageView.hidden=NO;
    
}
-(void)showNullView;
{
    NullDataView.hidden=NO;
    [self stopAnimation];
    imageView.hidden=YES;
}


@end
