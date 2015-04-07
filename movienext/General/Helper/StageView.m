//
//  StageView.m
//  movienext
//
//  Created by 杜承玖 on 3/6/15.
//  Copyright (c) 2015 redianying. All rights reserved.
//

#import "StageView.h"
#import "Constant.h"
#import "Function.h"
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
        //最开始设置为0
       // currentMarkIndex=0;
        [self createUI];
    }
    return self;
}

#pragma  mark 创建基本ui
- (void)createUI {
    [self removeStageViewSubView];
    self.userInteractionEnabled=YES;
    self.backgroundColor =VStageView_color;
    _MovieImageView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 200)];
    [self addSubview:_MovieImageView];

}
#pragma mark    设置stageview的值  ，主要是给stagview 添加markview  和添加一张图片
-(void)configStageViewforStageInfoDict{
    
    if (tanimageView) {
        tanimageView.hidden=YES;
        [tanimageView removeFromSuperview];
        tanimageView=nil;
    }
    tanimageView=[[UIImageView alloc]initWithFrame:CGRectMake(kDeviceWidth-30, 10, 20, 20)];
        tanimageView.image=[UIImage imageNamed:@"dan_closed@2x.png"];
        tanimageView.hidden=YES;
        [self addSubview:tanimageView];

    //先移除所有的Mark视图
    [self removeStageViewSubView];
    
    float  ImageWith=[_StageInfoDict.w intValue];
    float  ImgeHight=[_StageInfoDict.h intValue];
    float hight=0;
     hight= kDeviceWidth;
     if(ImgeHight>ImageWith)
    {
        hight=  (ImgeHight/ImageWith) *kDeviceWidth;
    }
  //  if (self.StageInfoDict.stage)
    //{//计算位置
#warning 这里如果宽高为0的话会崩溃
        
        float   y=(hight-(ImgeHight/ImageWith)*kDeviceWidth)/2;
        if (ImageWith==0 && ImgeHight>0) {
            ImageWith=ImgeHight;
        }
        ImgeHight = ImgeHight>0 ? ImgeHight : 1;
        ImageWith = ImageWith>0 ? ImageWith : 1;
        y = y > 0 ? y : 0;
        _MovieImageView.frame=CGRectMake(0, y, kDeviceWidth, (ImgeHight/ImageWith)*kDeviceWidth);
    _MovieImageView.backgroundColor =VStageView_color;
    [_MovieImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@!w640",kUrlStage,self.StageInfoDict.stage]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
#pragma  mark  是静态的, 气泡是不动的
         if ( _weiboDict) {
         MarkView *markView = [self createMarkViewWithDict:_weiboDict andIndex:2000];
         markView.alpha = 1.0;
         //设置是否markview 不可以动画
         markView.isAnimation =YES;
         //设置单条微博的参数信息
         markView.weiboDict=self.weiboDict;
         //遵守markView 的协议
         markView.delegate=self;
        //单个气泡的时候，隐约显示的参数
         markView.isShowansHiden=YES;
         [markView StartShowAndhiden];
         [self addSubview:markView];
         
         }
#pragma  mark  有很多气泡，气泡循环播放
         if (self.WeibosArray&&self.WeibosArray.count>0) {
         for ( int i=0;i<self.WeibosArray.count ; i++) {
         MarkView *markView = [self createMarkViewWithDict:self.WeibosArray[i] andIndex:i];
         // 设置markview 可以动画
         markView.isAnimation = YES;
         markView.alpha=0;
             //markView.hidden = YES;
         //设置单条微博的参数信息
         markView.weiboDict=self.WeibosArray[i];
         //遵守markView 的协议
         markView.isShowansHiden=NO;
         markView.delegate=self;
         [self addSubview:markView];
         }
         }
    }];

}
#pragma mark 内部创建气泡的方法
- (MarkView *) createMarkViewWithDict:(WeiboModel *)weibodict andIndex:(NSInteger)index{
            MarkView *markView=[[MarkView alloc]initWithFrame:CGRectZero];
            markView.alpha = 0;
          //设置tag 值为了在下面去取出来循环轮播
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
           if(IsIphone6)
           {
               markViewWidth=markViewWidth+10;
               markViewHeight=markViewHeight+4;
           }
            float markViewX = (x*kDeviceWidth)/100-markViewWidth;
            markViewX = MIN(MAX(markViewX, 1.0f), kDeviceWidth-markViewWidth-1);
            
            float markViewY = (y*hight)/100 - markViewHeight/2;
#warning    kDeviceWidth 目前计算的是正方形的，当图片高度>屏幕的宽度的实际，需要使用图片的高度
      
            markViewY = MIN(MAX(markViewY, 1.0f), hight-markViewHeight-1);
#pragma mark 设置气泡的大小和位置
            markView.frame=CGRectMake(markViewX, markViewY, markViewWidth, markViewHeight);
#pragma mark 设置标签的内容
            markView.TitleLable.text=weiboTitleString;
            ///显示标签的头像
            [ markView.LeftImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kUrlAvatar,weibodict.avatar]]];
    markView.ZanNumLable.text=[NSString stringWithFormat:@"%@",weibodict.ups];
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


//1.开始执行动画, 动画入口
- (void)startAnimation {
    //开始动画之后0.5秒再开始动画
    [self performSelector:@selector(scaleAnimation) withObject:nil afterDelay:kdisplayTime];
}

#pragma mark  ------
#pragma mark ----执行动画的开始和结束
#pragma mark ------
//2.放大动画
- (void)scaleAnimation {
       //执行放大动画
  /*  for (UIView *v in self.subviews) {
              if ([v isKindOfClass:[MarkView class]]) {
                MarkView *mv = (MarkView *)v;
                  self.userInteractionEnabled=YES;
                  mv.userInteractionEnabled=YES;
                 CABasicAnimation  *opacityanimation=[CABasicAnimation animationWithKeyPath:@"opacity"];
                 opacityanimation.fromValue=[NSNumber numberWithFloat:0.0f];
                 opacityanimation.toValue=[NSNumber numberWithFloat:1.0f];
                  //opacityanimation.autoreverses=YES;
                 //opacityanimation.repeatCount=1;
                 //opacityanimation.delegate=self;
                 //opacityanimation.removedOnCompletion=NO;
                 opacityanimation.fillMode=kCAFillModeForwards;
                 opacityanimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];  //默认均匀
                  
                CABasicAnimation  *scaleanimation=[CABasicAnimation animationWithKeyPath:@"ransform.scale"];
                 // scaleanimation.repeatCount = 1; // 重复次数
                  //scaleanimation.autoreverses =YES; // 动画结束时执行逆动画
                  // 缩放倍数
                  scaleanimation.fromValue = [NSNumber numberWithFloat:1]; // 开始时的倍率
                  scaleanimation.toValue = [NSNumber numberWithFloat:1.05]; // 结束时的倍率
                  // 添加动画
                  //scaleanimation.delegate=self;
                  //scaleanimation.fillMode=kCAFillModeForwards;
                 // scaleanimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
                  
                  CAAnimationGroup *animGroup = [CAAnimationGroup animation];
                  animGroup.animations = [NSArray arrayWithObjects: opacityanimation, scaleanimation, nil];
                  animGroup.duration =16;
                  animGroup.repeatCount=1;
                  animGroup.delegate=self;
                  animGroup.fillMode=kCAFillModeForwards;
                  opacityanimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
                  [mv.layer addAnimation:animGroup forKey:nil];
              }
    }*/
    //1.6代表动画弹出到小时的那消失的那段时间
    [UIView animateWithDuration:kalpaOneTime animations:^{
        for (UIView *v in self.subviews) {
            if ([v isKindOfClass:[MarkView class]]) {
                MarkView *mv = (MarkView *)v;
                self.userInteractionEnabled=YES;
                mv.userInteractionEnabled=YES;
                 mv.alpha = 1.0;
                 [Function BasicAnimationwithkey:@"transform.scale" Duration:0.25 repeatcont:1 autoresverses:YES fromValue:1.0 toValue:1.05 View:mv];
            }
        }
    } completion:^(BOOL finished) {
        //，放大动画执行完成后，结束放大动画, 同时开始循环显示动画
        //动画延时小时5s,消失动画显示
        [UIView animateWithDuration:kalpaZeroTime delay:0.6 options:UIViewAnimationOptionCurveLinear animations:^{
            // 先把所有的气泡的透明度都设置成了 0
            for (UIView *v in self.subviews) {
                if ([v isKindOfClass:[MarkView class]]) {
                    MarkView *mv = (MarkView *)v;
                    mv.alpha = 0;
                }
            }
        } completion:^(BOOL finished) {
            //每隔kTimeInterval时间显示一个动画
            if (_timer) {
                [_timer invalidate];
                _timer=nil;
            }
            //完成了全部显示后，立马显示第一个
            currentMarkIndex=0;

           [self CircleshowAnimation];
            _timer = [NSTimer scheduledTimerWithTimeInterval:kTimeInterval target:self selector:@selector(CircleshowAnimation) userInfo:nil repeats:YES];
        }];
    }];
    
    
}

//6.循环显示气泡动画
//每次去控制一个动画的显示
//在markview 中只做一件事,就是自身的现实和隐藏，不管外部对他怎么操作
- (void)CircleshowAnimation {

   // NSLog(@"currentMarkIndex   = %ld", currentMarkIndex);
     if (!_isAnimation) {
        return;
    }
    if (currentMarkIndex<self.WeibosArray.count) {
        MarkView  *markView=(MarkView *)[self viewWithTag:1000+currentMarkIndex];
        markView.userInteractionEnabled=YES;
        [markView startAnimation];
    }
    currentMarkIndex =currentMarkIndex +1;
#warning  疑点，为什么是13  的最大值
    //执行完成一轮动画之后，实行，重新再动第一个执行
    
   if (currentMarkIndex > MAX(self.subviews.count,6) ) {
        currentMarkIndex = 0;
   }
//    if (self.WeibosArray.count-currentMarkIndex) {
//        <#statements#>
//    }
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
