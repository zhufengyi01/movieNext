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
       //右视图
    _rightView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,0,0)];
    _rightView.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.7];
    _rightView.layer.cornerRadius=MarkViewCornerRed;
    _rightView.contentMode=UIViewContentModeTop;  //设置内容上对齐方式
    _rightView.layer.masksToBounds=YES;
    [self addSubview:_rightView];
    
    //左视图
    _LeftImageView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0,20, 20)];
    _LeftImageView.layer.borderWidth=2;
    _LeftImageView.layer.cornerRadius=MarkViewCornerRed;
    _LeftImageView.layer.masksToBounds=YES;
    _LeftImageView.layer.borderColor=[[UIColor whiteColor] CGColor];
    [self addSubview:_LeftImageView];
    
    

//    //标题，点赞的view
    _TitleLable=[ZCControl createLabelWithFrame:CGRectMake(0,0, 0,0) Font:12 Text:@""];
    _TitleLable.font=[UIFont systemFontOfSize:MarkTextFont14];
    if (IsIphone6) {
        _TitleLable.font=[UIFont systemFontOfSize:MarkTextFont16];
    }
    _TitleLable.textColor=[UIColor whiteColor];
    [_rightView addSubview:_TitleLable];
    
    
    
    
    //标题
    self.contentLable =[[M80AttributedLabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.contentLable.font=[UIFont systemFontOfSize:MarkTextFont14];
    if (IsIphone6) {
        self.contentLable.font=[UIFont systemFontOfSize:MarkTextFont16];
    }
    self.contentLable.textColor=[UIColor whiteColor];
    self.contentLable.lineSpacing=5.0;
    //[_rightView addSubview:self.contentLable];
    
    
    
    _ZanImageView=[ZCControl createImageViewWithFrame:CGRectMake(0, 0, 0,0) ImageName:@"tag_like_icon.png"];
    [_rightView addSubview:_ZanImageView];
    
    _ZanNumLable=[ZCControl createLabelWithFrame:CGRectMake(0, 0, 0,0) Font:12 Text:@""];
    _ZanNumLable.textColor=[UIColor whiteColor];
    [_rightView addSubview:_ZanNumLable];
    
    UITapGestureRecognizer  *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dealTapWeiboClick:)];
    [self addGestureRecognizer:tap];
    

}
//获取weiboinfo 信息
-(void)setValueWithWeiboInfo:(weiboInfoModel *) weiboInfo
{
    //显示虚拟用户
    UserDataCenter *userCenter=[UserDataCenter shareInstance];
    for (int i=0; i<_LeftImageView.subviews.count; i++) {
        UIView  *view=(UIView*)_LeftImageView.subviews[i];
        [view removeFromSuperview];
    }
    
    if ([userCenter.is_admin intValue]>0) {
        if ( [weiboInfo.uerInfo.fake intValue]==0) {
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
//创建标签
    if (self.weiboInfo.tagArray&&self.weiboInfo.tagArray.count) {
        self.tagLable =[[M80AttributedLabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
        self.tagLable.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0];
         for (int i=0; i<self.weiboInfo.tagArray.count; i++) {
            TagView *tagview = [self createTagViewWithtagInfo:self.weiboInfo.tagArray[i] andIndex:i];
            [self.tagLable appendView:tagview margin:UIEdgeInsetsMake(0, 0, 0, 5)];
        }
         [self.rightView addSubview:self.tagLable];
    }
    
}
//创建标签的方法
-(TagView *)createTagViewWithtagInfo:(TagModel *) tagmodel andIndex:(NSInteger ) index
{
    TagView *tagview =[[TagView alloc]initWithFrame:CGRectZero];
    tagview.clipsToBounds=YES;
    tagview.tag=1000+index;
    tagview.weiboInfo=self.weiboInfo;
    NSString *titleStr = tagmodel.tagDetailInfo.title;
    tagview.titleLable.text=titleStr;
     CGSize  Tsize =[titleStr boundingRectWithSize:CGSizeMake(MAXFLOAT, TagHeight) options:(NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin) attributes:[NSDictionary dictionaryWithObject:tagview.titleLable.font forKey:NSFontAttributeName] context:nil].size;
    //纪录前面一个标签的宽度
    tagview.frame=CGRectMake(0,0, Tsize.width+10, TagHeight);
    return tagview;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    
    //布局之前先比较标签文字的长度跟标签弹幕文字的长度，这样去改变标签标签的长度
//计算标签长度文字的长度
    NSMutableString  *tagStr=[[NSMutableString alloc]init];
    for (int i=0;i<self.weiboInfo.tagArray.count;i++)
    {
        TagModel  *tagmodel =[self.weiboInfo.tagArray objectAtIndex:i];
        [ tagStr appendString:tagmodel.tagDetailInfo.title];
    }
    
    CGSize  Tagsize=[tagStr boundingRectWithSize:CGSizeMake(kDeviceWidth/2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:14] forKey:NSFontAttributeName] context:nil].size;
    
//计算文字的长度
    NSString  *weiboTitleString=self.weiboInfo.content;
   // NSString  *UpString=[NSString stringWithFormat:@"%@",self.weiboInfo.like_count];
    //计算标题的size
    CGSize  Zsize=[weiboTitleString boundingRectWithSize:CGSizeMake(kDeviceWidth/2,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:self.TitleLable.font forKey:NSFontAttributeName] context:nil].size;
    if (Tagsize.width+5>Zsize.width) {
        self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, Tagsize.width+23+5+5+11+5+10+5, self.frame.size.height);
    }
    
    
    
    //头像
    _LeftImageView.frame=CGRectMake(0, 0, 23, 23);
    if (IsIphone6) {
        _LeftImageView.frame=CGRectMake(0, 0, 28, 28);
    }
    isfakeView.frame= CGRectMake(_LeftImageView.frame.size.width-6,_LeftImageView.frame.size.height-6, 8, 8);
    
    //右视图
    _rightView.frame=CGRectMake(21, 0,self.frame.size.width-23 , self.frame.size.height);
    if (IsIphone6) {
         _rightView.frame=CGRectMake(26, 0,self.frame.size.width-28 , self.frame.size.height);
    }
   
   // 标题
    CGSize Tsize=[_TitleLable.text boundingRectWithSize:CGSizeMake(kDeviceWidth/2,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:_TitleLable.font forKey:NSFontAttributeName] context:nil].size;
    _TitleLable.frame=CGRectMake(5,3,Tsize.width, Tsize.height);
    
    //赞的图片
    _ZanImageView.frame=CGRectMake(_TitleLable.frame.origin.x + _TitleLable.frame.size.width + 5,5,11,11 );
    
    //赞的数量
    CGSize  Msize=[_ZanNumLable.text boundingRectWithSize:CGSizeMake(kDeviceWidth/2,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:_ZanNumLable.font forKey:NSFontAttributeName] context:nil].size;
    
    int zanWidth = [_ZanNumLable.text intValue]>0 ? Msize.width: 0;
    _ZanNumLable.frame=CGRectMake(_ZanImageView.frame.origin.x+_ZanImageView.frame.size.width+2, _ZanImageView.frame.origin.y-2, zanWidth+3, 15);
    if (zanWidth==0) {
        _ZanNumLable.hidden=YES;
    }
    
    
    //标签
    if (self.weiboInfo.tagArray.count!=0) {
         self.tagLable.frame=CGRectMake(self.TitleLable.frame.origin.x, self.TitleLable.frame.origin.y+self.TitleLable.frame.size.height+5,self.rightView.frame.size.width-10, TagHeight);
    }
//    if (self.tagLable.frame.size.width<self.rightView.frame.size.width) {
//        
//    }
//    
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
            [self.delegate MarkViewClick:self.weiboInfo withMarkView:self];
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
