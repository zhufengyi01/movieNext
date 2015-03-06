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
    _rightView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,0,0)];
    _rightView.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.7];
    _rightView.layer.cornerRadius=3;
    _rightView.contentMode=UIViewContentModeTop;  //设置内容上对齐方式
    _rightView.layer.masksToBounds=YES;
    [self addSubview:_rightView];
    
    //标题，点赞的view
    _TitleLable=[ZCControl createLabelWithFrame:CGRectMake(0,0, 0,0) Font:12 Text:@""];
    _TitleLable.textColor=[UIColor whiteColor];
    [_rightView addSubview:_TitleLable];
    
    _ZanImageView=[ZCControl createImageViewWithFrame:CGRectMake(0, 0, 0,0) ImageName:@"tag_like_icon.png"];
    [_rightView addSubview:_ZanImageView];
    
    _ZanNumLable=[ZCControl createLabelWithFrame:CGRectMake(0, 0, 0,0) Font:12 Text:@""];
    _ZanNumLable.textColor=[UIColor whiteColor];
    [_rightView addSubview:_ZanNumLable];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    //头像
    _LeftImageView.frame=CGRectMake(0, 0,20, 20);
    
    //右视图
    _rightView.frame=CGRectMake(23, 0,self.frame.size.width-23 , self.frame.size.height);
    
    //标题
    CGSize Tsize=[_TitleLable.text boundingRectWithSize:CGSizeMake(kDeviceWidth/2,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:_TitleLable.font forKey:NSFontAttributeName] context:nil].size;
    _TitleLable.frame=CGRectMake(5,0,Tsize.width, self.frame.size.height);
    NSLog(@"==========title label ============%@",_TitleLable.text);
    
    //赞的图片
    _ZanImageView.frame=CGRectMake(_TitleLable.frame.origin.x + _TitleLable.frame.size.width + 5, (self.frame.size.height-11)/2,11,11 );
    
    //赞的数量
    NSLog(@"==========zanLableText ============%@",_ZanNumLable.text);
    CGSize  Msize=[_ZanNumLable.text boundingRectWithSize:CGSizeMake(kDeviceWidth/2,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:_ZanNumLable.font forKey:NSFontAttributeName] context:nil].size;
    
    int zanWidth = [_ZanNumLable.text intValue]>0 ? Msize.width: 0;
    _ZanNumLable.frame=CGRectMake(_ZanImageView.frame.origin.x+_ZanImageView.frame.size.width+2, _ZanImageView.frame.origin.y, zanWidth, 15);
    
    //设置子view的frame
}

//子视图本身的动画
-(void)startAnimation
{
    if (self.isAnimation==YES) {  //可以动
        [UIView animateWithDuration:kShowTimeOffset delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.alpha=1.0;
        } completion:^(BOOL finished) {
            //淡入之后过5秒再调用淡出动画
            [self performSelector:@selector(easeOut) withObject:nil afterDelay:kStaticTimeOffset];
        }];
    }
}

//淡出动画
- (void)easeOut {
    [UIView animateWithDuration:kHidenTimeOffset delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.alpha=0;
    } completion:^(BOOL finished) {
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
