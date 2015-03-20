//
//  StageView.m
//  movienext
//
//  Created by 杜承玖 on 3/6/15.
//  Copyright (c) 2015 redianying. All rights reserved.
//

#import "StageView.h"
//#import "MarkView.h"
#import "Constant.h"
#import "UIImageView+WebCache.h"

@implementation StageView 

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

#pragma  mark 创建基本ui
- (void)createUI {
    [self removeStageViewSubView];
    self.backgroundColor = [UIColor blackColor];
    _MovieImageView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 200)];
    [self addSubview:_MovieImageView];
    
    //加一个弹的图片,弹幕出来隐藏，弹幕进去显示
    tanimageView=[[UIImageView alloc]initWithFrame:CGRectMake(kDeviceWidth-30, 10, 20, 20)];
    tanimageView.image=[UIImage imageNamed:@"tan.png"];
    tanimageView.hidden=YES;
    [self addSubview:tanimageView];
}
#pragma mark    设置stageview的值  ，主要是给stagview 添加markview  和添加一张图片
-(void)configStageViewforStageInfoDict{
    //先移除所有的Mark视图
    [self removeStageViewSubView];
    
    float  ImageWith=[_StageInfoDict.w intValue]; //[[self.StageInfoDict objectForKey:@"w"]  floatValue];
    float  ImgeHight=[_StageInfoDict.h intValue];//[[self.StageInfoDict objectForKey:@"h"]  floatValue];
    float hight=0;
     hight= kDeviceWidth;
     if(ImgeHight>ImageWith)
    {
        hight=  (ImgeHight/ImageWith) *kDeviceWidth;
    }
    if (self.StageInfoDict.stage)
    {//计算位置
#warning 这里如果宽高为0的话会崩溃
        
        float   y=(hight-(ImgeHight/ImageWith)*kDeviceWidth)/2;
        if (ImageWith==0) {
//          _MovieImageView.frame=CGRectMake(0,y, kDeviceWidth, (ImgeHight/ImageWith)*kDeviceWidth);
            ImageWith=ImgeHight;
            
        }
        _MovieImageView.frame=CGRectMake(0,y, kDeviceWidth, (ImgeHight/ImageWith)*kDeviceWidth);
        [_MovieImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@!w640",kUrlStage,self.StageInfoDict.stage]] placeholderImage:[UIImage imageNamed:@"loading_image_all.png"]];
                                            
                            }
#pragma  mark  是静态的, 气泡是不动的
    if ( _weiboDict) {
        //WeiboModel  *weibodict=self.weiboDict;
        MarkView *markView = [self createMarkViewWithDict:_weiboDict andIndex:2000];
        markView.alpha = 1.0;
        //设置是否markview 不可以动画
        markView.isAnimation =YES;
        //设置单条微博的参数信息
        markView.weiboDict=self.weiboDict;
       //遵守markView 的协议
        markView.delegate=self;
        markView.isShowansHiden=YES;
        [markView StartShowAndhiden];
       [self addSubview:markView];
        
        //改变透明度
        //闪烁动画
        
        
    }
#pragma  mark  有很多气泡，气泡循环播放
    
    if (self.WeibosArray&&self.WeibosArray.count>0) {
        
      for ( int i=0;i<_WeibosArray.count ; i++) {
        MarkView *markView = [self createMarkViewWithDict:self.WeibosArray[i] andIndex:i];
        // 设置markview 可以动画
        markView.isAnimation = YES;
        //设置单条微博的参数信息
        markView.weiboDict=self.WeibosArray[i];
        //遵守markView 的协议
          markView.isShowansHiden=NO;
        markView.delegate=self;

       [self addSubview:markView];
     }
    }
}
#pragma mark 内部创建气泡的方法
- (MarkView *) createMarkViewWithDict:(WeiboModel *)weibodict andIndex:(NSInteger)index{
    
            MarkView *markView=[[MarkView alloc]initWithFrame:CGRectMake(10, 10, 100, 30)];
            markView.alpha = 0;
            markView.tag=1000+index;
    
    NSLog(@"stageview  ＝＝=====weiboDict====%@",weibodict);
             float  x=[weibodict.x floatValue];   //位置的百分比
             float  y=[weibodict.y floatValue];
             NSString  *weiboTitleString=weibodict.topic;
             NSString  *UpString=[NSString stringWithFormat:@"%@",weibodict.ups];//weibodict.ups;
            //计算标题的size
            CGSize  Msize=[weiboTitleString boundingRectWithSize:CGSizeMake(kDeviceWidth/2,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:markView.TitleLable.font forKey:NSFontAttributeName] context:nil].size;
            // 计算赞数量的size
            CGSize Usize=[UpString boundingRectWithSize:CGSizeMake(40,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:markView.ZanNumLable.font forKey:NSFontAttributeName] context:nil].size;
          
           // NSLog(@"size= %f %f", Msize.width, Msize.height);
              float  ImageWith=[self.StageInfoDict.w floatValue];
              float  ImgeHight=[self.StageInfoDict.h floatValue];
             float hight=0;
              hight= kDeviceWidth;  // 计算的事bgview1的高度
             if(ImgeHight>ImageWith)
             {
              hight=  (ImgeHight/ImageWith) *kDeviceWidth;
             }

            //计算赞数量的长度
            float  Uwidth=[UpString floatValue]==0?0:Usize.width;
            //宽度=字的宽度+左头像图片的宽度＋赞图片的宽度＋赞数量的宽度+中间两个空格2+2
            float markViewWidth = Msize.width+23+Uwidth+5+5+11+5;
            float markViewHeight = Msize.height+6;
            float markViewX = (x*kDeviceWidth)/100-markViewWidth;
            markViewX = MIN(MAX(markViewX, 1.0f), kDeviceWidth-markViewWidth-1);
            
            float markViewY = (y*hight)/100;
#warning    kDeviceWidth 目前计算的是正方形的，当图片高度>屏幕的宽度的实际，需要使用图片的高度
      
            markViewY = MIN(MAX(markViewY, 1.0f), hight-markViewHeight-1);
#pragma mark 设置气泡的大小和位置
            markView.frame=CGRectMake(markViewX, markViewY, markViewWidth, markViewHeight);
#pragma mark 设置标签的内容
            markView.TitleLable.text=weiboTitleString;
            ///显示标签的头像
            [ markView.LeftImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kUrlAvatar,weibodict.avatar]]];
    markView.ZanNumLable.text=[NSString stringWithFormat:@"%@",weibodict.ups];//weibodict.ups; //[weibodict objectForKey:@"ups"];
           // markView.isAnimation = YES;
    return markView;
}
//防止cell服用导致的原来的内容存在,移除原来的markview
-(void)removeStageViewSubView
{
    for (UIView  *Mview in  self.subviews) {
        if ([Mview isKindOfClass:[MarkView class]]) {
            MarkView  *mv =(MarkView  *) Mview;
            [mv  removeFromSuperview];
            mv=nil;
            
        }
    }
    
}
#pragma mark  ------
#pragma  mark ----执行动画的开始和结束
#pragma  mark ------
//2.放大动画
- (void)scaleAnimation {
       //执行放大动画
    [UIView animateWithDuration:0.5 animations:^{
        for (UIView *v in self.subviews) {
            if ([v isKindOfClass:[MarkView class]]) {
                MarkView *mv = (MarkView *)v;
                mv.alpha = 1.0;
                mv.hidden = NO;
                // 设定为缩放
                CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
                // 动画选项设定
                animation.duration = 0.15; // 动画持续时间
                animation.repeatCount = 1; // 重复次数
                animation.autoreverses = YES; // 动画结束时执行逆动画
                // 缩放倍数
                animation.fromValue = [NSNumber numberWithFloat:1.0]; // 开始时的倍率
                animation.toValue = [NSNumber numberWithFloat:1.05]; // 结束时的倍率
                // 添加动画
                [mv.layer addAnimation:animation forKey:@"scale-layer"];
            }
        }
    } completion:^(BOOL finished) {
        //，放大动画执行完成后，结束放大动画, 同时开始循环显示动画
        [UIView animateWithDuration:0.2 delay:0.6 options:UIViewAnimationOptionCurveLinear animations:^{
            // 先把所有的气泡的透明度都设置成了 0
            for (UIView *v in self.subviews) {
                if ([v isKindOfClass:[MarkView class]]) {
                    MarkView *mv = (MarkView *)v;
                    mv.alpha = 0.0;
                }
                            }
            //每隔kTimeInterval时间显示一个动画
            if (_timer) {
                [_timer invalidate];
            }
            _timer = [NSTimer scheduledTimerWithTimeInterval:kTimeInterval target:self selector:@selector( CircleshowAnimation) userInfo:nil repeats:YES];
        } completion:nil];
    }];
}



//1.开始执行动画, 动画入口
- (void)startAnimation {
    //开始动画之后0.5秒再开始动画
    [self performSelector:@selector(scaleAnimation) withObject:nil afterDelay:0.5];
}

//6.循环显示气泡动画
- (void)CircleshowAnimation {
    //NSLog(@"index = %ld", currentMarkIndex);
    
    if (!_isAnimation) {
        return;
    }
    
    if (currentMarkIndex <= self.subviews.count-1) {
        UIView *v = self.subviews[currentMarkIndex];
        if ([v isKindOfClass:[MarkView class]]) {
            MarkView *mv = (MarkView *)v;
            [mv startAnimation];
        }
    }
    currentMarkIndex ++;
    //执行完成一轮动画之后，实行，重新再动第一个执行
    if (currentMarkIndex > MAX(self.subviews.count, 13) ) {
        currentMarkIndex = 0;
    }
}

//7.停止动画
- (void)stopAnimation {
    
    [_timer invalidate];
    _timer=nil;
}





#pragma mark 点击屏幕显示和隐藏marview
//显示隐藏markview
-(void)hidenAndShowMarkView:(BOOL) isShow;
{
    if (isShow==NO) {
        NSLog(@"执行了隐藏 view ");
        for (UIView  *view  in self.subviews) {
            if  ([view isKindOfClass:[MarkView class]]) {
                MarkView  *mv =(MarkView *)view;
                mv.hidden=YES;
                 tanimageView.hidden=NO;
            }
        }
    }
    else if (isShow==YES)
    {
        NSLog(@"执行了显示view ");
        for (UIView  *view  in self.subviews) {
            if  ([view isKindOfClass:[MarkView class]]) {
                MarkView  *mv =(MarkView *)view;
                mv.hidden=NO;
                tanimageView.hidden=YES;
            }
        }
    }

}

#pragma mark  ----
#pragma mark   ---markView   Delegate
#pragma  mark -----
//实现markview 的代理
-(void)MarkViewClick:(WeiboModel *)weiboDict withMarkView:(id)markView
{
    
    NSLog(@"点击了 stageview 的微博操作 ＝＝＝%@   %@",weiboDict,self.StageInfoDict);
    if (self.delegate &&[self.delegate respondsToSelector:@selector(StageViewHandClickMark:withmarkView:StageInfoDict:)]) {
        [self.delegate StageViewHandClickMark:weiboDict withmarkView:markView StageInfoDict:self.StageInfoDict];
    }

}


@end
