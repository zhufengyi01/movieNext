//
//  MarkView.m
//  movienext
//
//  Created by 风之翼 on 15/3/4.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "MarkView.h"
#import "ZCControl.h"
#import "Constant.h"
#import "Function.h"
#import "UserDataCenter.h"
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
    //使用手势给本身添加一个点击事件,表示可以点击
    self.userInteractionEnabled=YES;
    //默认最开始没有选中
    self.isSelected=NO;
    //左视图
    _LeftImageView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0,20, 20)];
    _LeftImageView.layer.borderWidth=2;
    _LeftImageView.layer.cornerRadius=MarkViewCornerRed;
    _LeftImageView.layer.masksToBounds=YES;
    _LeftImageView.layer.borderColor=[[UIColor whiteColor] CGColor];
    [self addSubview:_LeftImageView];
   
    
    //右视图
    _rightView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,0,0)];
    _rightView.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.7];
    _rightView.layer.cornerRadius=MarkViewCornerRed;
    _rightView.contentMode=UIViewContentModeTop;  //设置内容上对齐方式
    _rightView.layer.masksToBounds=YES;
    [self addSubview:_rightView];
    
    //标题，点赞的view
    _TitleLable=[ZCControl createLabelWithFrame:CGRectMake(0,0, 0,0) Font:12 Text:@""];
    _TitleLable.font=[UIFont systemFontOfSize:MarkTextFont14];
    if (IsIphone6) {
        _TitleLable.font=[UIFont systemFontOfSize:MarkTextFont16];
    }
    _TitleLable.textColor=[UIColor whiteColor];
    [_rightView addSubview:_TitleLable];
    
    _ZanImageView=[ZCControl createImageViewWithFrame:CGRectMake(0, 0, 0,0) ImageName:@"tag_like_icon.png"];
    [_rightView addSubview:_ZanImageView];
    
    _ZanNumLable=[ZCControl createLabelWithFrame:CGRectMake(0, 0, 0,0) Font:12 Text:@""];
    _ZanNumLable.textColor=[UIColor whiteColor];
    [_rightView addSubview:_ZanNumLable];
    
    
        UITapGestureRecognizer  *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dealTapWeiboClick:)];
        [self addGestureRecognizer:tap];
}
//获取weiboinfo 信息
-(void)setValueWithWeiboInfo:(WeiboModel *) weiboInfo
{
    //显示虚拟用户
    UserDataCenter *userCenter=[UserDataCenter shareInstance];
    
    for (UIView *v in  _LeftImageView.subviews) {
        if ([v isKindOfClass:[UIImageView class]]) {
            [v removeFromSuperview];
        }
    }
    if ([userCenter.is_admin intValue]>0) {
        if ( [self.weiboDict.fake intValue]==0) {
            //虚拟用户
            isfakeView=[[UIImageView alloc]initWithFrame:CGRectMake(_LeftImageView.frame.size.width-6,_LeftImageView.frame.size.height-6, 8, 8)];
            isfakeView.layer.cornerRadius=4;
            isfakeView.clipsToBounds=YES;
            isfakeView.layer.borderColor=[UIColor whiteColor].CGColor;
            isfakeView.backgroundColor=VBlue_color;
            isfakeView.layer.borderWidth=1;
            [_LeftImageView addSubview:isfakeView];
        }
        
    }

}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    //头像
    _LeftImageView.frame=CGRectMake(0, 0, 23, 23);
    if (IsIphone6) {
        _LeftImageView.frame=CGRectMake(0, 0, 28, 28);
    }
    isfakeView.frame= CGRectMake(_LeftImageView.frame.size.width-6,_LeftImageView.frame.size.height-6, 8, 8);
    
    
    //右视图
    _rightView.frame=CGRectMake(23, 0,self.frame.size.width-23 , self.frame.size.height);
    if (IsIphone6) {
         _rightView.frame=CGRectMake(28, 0,self.frame.size.width-28 , self.frame.size.height);
    }
    
    //标题
    CGSize Tsize=[_TitleLable.text boundingRectWithSize:CGSizeMake(kDeviceWidth/2,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:_TitleLable.font forKey:NSFontAttributeName] context:nil].size;
    _TitleLable.frame=CGRectMake(5,0,Tsize.width, self.frame.size.height);
    
    //赞的图片
    _ZanImageView.frame=CGRectMake(_TitleLable.frame.origin.x + _TitleLable.frame.size.width + 5, (self.frame.size.height-11)/2,11,11 );
    
    //赞的数量
    CGSize  Msize=[_ZanNumLable.text boundingRectWithSize:CGSizeMake(kDeviceWidth/2,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:_ZanNumLable.font forKey:NSFontAttributeName] context:nil].size;
    
    int zanWidth = [_ZanNumLable.text intValue]>0 ? Msize.width: 0;
    _ZanNumLable.frame=CGRectMake(_ZanImageView.frame.origin.x+_ZanImageView.frame.size.width+2, _ZanImageView.frame.origin.y-2, zanWidth, 15);
    
    //如果是静态的, 则将边框描一下
    if (!_isAnimation) {
        _LeftImageView.layer.borderColor = kAppTintColor.CGColor;
        _LeftImageView.layer.borderWidth = 1;
        _rightView.layer.borderColor = kAppTintColor.CGColor;
        _rightView.layer.borderWidth = 1;
    }
}

//子视图本身的动画
//  ------0.7出现 -------|-----------------5.7停留--－－－－｜--------1.0动画淡出------------|
-(void)startAnimation
{
    if (self.isAnimation==YES) {
        [UIView animateWithDuration:kShowTimeOffset delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.alpha=1.0;
        } completion:^(BOOL finished) {
            //淡入之后过5.7秒再调用淡出动画
            [self performSelector:@selector(easeOut) withObject:nil afterDelay:kStaticTimeOffset];
        }];
    }
}

//淡出动画
- (void)easeOut {
    if ( self.isAnimation==YES ) {
        [UIView animateWithDuration:kHidenTimeOffset delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.alpha=0;
        } completion:^(BOOL finished) {
        }];
    }
}



/*
-(void)startAnimation
{
    if (self.isAnimation==YES) {
    CAKeyframeAnimation *keyAnima=[CAKeyframeAnimation animation];
    keyAnima.keyPath=@"opacity";
    
    NSValue  *value1=@0;
    NSValue  *value2=@1;
    NSValue  *value3=@1;
    NSValue  *value4=@1;
    NSValue  *value5=@1;
    NSValue  *value6=@1;
    NSValue  *value7=@0;
    
    keyAnima.values=@[value1,value2,value3,value4,value5,value6,value7];
    //   keyAnima.keyTimes=@[@0.9,@0.9,@0.9,@0.9,@0.9,@0.9,@0.9];
    //keyAnima.keyTimes=[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.9],[NSNumber numberWithFloat:0.9],[NSNumber numberWithFloat:0.9],[NSNumber numberWithFloat:0.9],[NSNumber numberWithFloat:0.9],[NSNumber numberWithFloat:0.9],[NSNumber numberWithFloat:0.9], nil];
    //1.2设置动画执行完毕后，不删除动画
    keyAnima.removedOnCompletion=NO;
    //1.3设置保存动画的最新状态
    keyAnima.autoreverses=NO;
    keyAnima.repeatCount=1;
    keyAnima.fillMode=kCAFillModeForwards;
    //1.4设置动画执行的时间
    keyAnima.duration=7.0;
    //1.5设置动画的节奏
    //   keyAnima.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //设置代理，开始—结束
    keyAnima.delegate=self;
    //2.添加核心动画
    [self.layer addAnimation:keyAnima forKey:nil];
    }

}*/





#pragma mark 处理气泡的点击事件
-(void)dealTapWeiboClick:(UITapGestureRecognizer  *) tap
{
    if (self.isSelected==YES) {  //是选中的状态,则把它变成没有选中的状态
        NSLog(@" 取消选中 markview 的微博事件");
        // 设置可以自身动画了
        [self CancelMarksetSelect];
    }
    else if(self.isSelected==NO)  //是没有选中的状态，则把其中变成选中的状态
    {
        // 设置不能自身动画了
        [self setMaskViewSelected];
       if (self.delegate &&[self.delegate respondsToSelector:@selector(MarkViewClick:withMarkView:)]) {
            // 传递markview  当前的字典数据和的指针到了stageview。在stagview 中再传递到controller
            [self.delegate MarkViewClick:self.weiboDict withMarkView:self];
        }
    }
}


#pragma mark  开始闪现动作
-(void)StartShowAndhiden;
{
    //最新页面的饿动画
    if (self.isShowansHiden==YES) {
    [self.layer addAnimation:[self opacityForver_animation:KappearTime] forKey:nil];
    }
}
-(CABasicAnimation *)opacityForver_animation:(float)time
{
    CABasicAnimation  *animation=[CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue=[NSNumber numberWithFloat:0.3f];
    animation.toValue=[NSNumber numberWithFloat:0.7f];
    animation.autoreverses=YES;
    animation.duration=time;
    animation.repeatCount=MAXFLOAT;
    animation.delegate=self;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];  //默认均匀的动画
    return animation;
}


#pragma mark   -------
#pragma mark   ------ 设置selected 和没有选中的两种状态
#pragma mark   ------
//选中的状态的状态
-(void)setMaskViewSelected
{
    self.isAnimation=NO;
    self.isSelected=YES;
    self.isShowansHiden=NO;
    NSLog(@"  在 markview   中执行了markview 的  setMaskViewSelected");
    _LeftImageView.layer.borderColor=VBlue_color.CGColor;
    _rightView.layer.backgroundColor=VBlue_color.CGColor;
}

-(void)CancelMarksetSelect;
{
    NSLog(@"在markview 中  执行了markview 的  CancelMarksetSelect");
    self.isSelected=NO;
    self.isAnimation=YES;
    self.isShowansHiden=YES;
    _LeftImageView.layer.backgroundColor=[UIColor whiteColor].CGColor;
    _rightView.layer.borderColor=[UIColor clearColor].CGColor;
    _LeftImageView.layer.borderColor=[UIColor whiteColor].CGColor;
     _rightView.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.7];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
