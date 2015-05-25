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
#pragma mark --------等待中
    // 等待的.......
    CircleImageView=[[UIImageView alloc]initWithFrame:CGRectMake((m_frame.size.width-30)/2, (m_frame.size.height-30)/2, 30, 30)];
    CircleImageView.image=[UIImage imageNamed:@"loading_roll_image.png"];
    CircleImageView.center=CGPointMake((kDeviceWidth)/2, (kDeviceHeight-kHeightNavigation)/2);
    [self addSubview:CircleImageView];
    [self startAnimation];
    
    
    
    
    
#pragma mark ------数据加载失败的view
    //数据加载失败
    failLoadView =[[UIView alloc]initWithFrame:CGRectMake(0, (kDeviceWidth-100)/2, kDeviceWidth, 100)];
    failLoadView.hidden=YES;
    failLoadView.backgroundColor=View_BackGround;
    failLoadView.userInteractionEnabled=YES;
    [self addSubview:failLoadView];
    
    self.failTitle=[ZCControl createLabelWithFrame:CGRectMake(0, 10, kDeviceWidth, 20) Font:16 Text:@"加载失败，请重新加载!"];
    self.failTitle.textAlignment=NSTextAlignmentCenter;
    self.failTitle.textColor=VGray_color;
    [failLoadView addSubview:self.failTitle];
    
    self.failBtn=[ZCControl createButtonWithFrame:CGRectMake((kDeviceWidth-80)/2, 40, 80, 40) ImageName:@"loginoutbackgroundcolor.png" Target:self Action:@selector(reloadDataClick:) Title:@"重试"];
    self.failBtn.layer.cornerRadius=4;
    self.failBtn.clipsToBounds=YES;
    [failLoadView addSubview:self.failBtn];
    

#pragma mark 数据为空的view
    //没有数据的时候显示这个笑脸的
    NullDataView =[[UIView alloc]initWithFrame:CGRectMake(0, (kDeviceWidth-100)/2, kDeviceWidth, 100)];
    NullDataView.hidden=YES;
    //NullDataView.backgroundColor=[UIColor yellowColor];
    NullDataView.userInteractionEnabled=YES;
    [self addSubview:NullDataView];
    
     self.nullImageView=[[UIImageView alloc]initWithFrame:CGRectMake((kDeviceWidth-25)/2, 20, 25, 25)];
    self.nullImageView.image=[UIImage imageNamed:@"notice_icon.png"];
    [NullDataView addSubview:self.nullImageView];
    
    self.nullTitle=[ZCControl createLabelWithFrame:CGRectMake(0, 60, kDeviceWidth, 20) Font:16 Text:@"亲，没有数据"];
    self.nullTitle.textAlignment=NSTextAlignmentCenter;
    self.nullTitle.textColor=VGray_color;
    [NullDataView addSubview:self.nullTitle];
    
    
    
}
//开始动画
-(void)startAnimation
{
    isanimal=YES;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.01];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(endAnimation)];
    CircleImageView.transform = CGAffineTransformMakeRotation(angle * (M_PI / 180.0f));
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
    CircleImageView.hidden=YES;
    
}
-(void)showNullView:(NSString *) failString;
{
     NullDataView.hidden=NO;
    [self stopAnimation];
    CircleImageView.hidden=YES;
    self.nullTitle.text=failString;
}


//隐藏加载失败
-(void)hidenFailLoadAndShowAnimation;
{
    failLoadView.hidden=YES;
    [self startAnimation];
    CircleImageView.hidden=NO;
    
}


@end
