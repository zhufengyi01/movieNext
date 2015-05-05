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
    float height =kStageWidth;
    _MovieImageView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kStageWidth, height*(9.0/16))];
    _MovieImageView.contentMode=UIViewContentModeScaleAspectFit;
    _MovieImageView.clipsToBounds=YES;
    [self addSubview:_MovieImageView];

}
#pragma mark    设置stageview的值  ，主要是给stagview 添加markview  和添加一张图片
-(void)configStageViewforStageInfoDict{
    
    //先移除所有的Mark视图
    [self removeStageViewSubView];
//    float  ImageWith=[self.stageInfo.width intValue];
//    float  ImgeHight=[self.stageInfo.height intValue];
//    if (ImageWith==0) {
//        ImageWith=kDeviceWidth;
//    }
//    if (ImgeHight==0) {
//        ImgeHight=kDeviceWidth;
//    }
//    float x=0;
//    float y=0;
//    float width=0;
//    float hight=0;
//    if (ImageWith>ImgeHight) {
//          x=0;
//          width=kDeviceWidth;
//          hight=(ImgeHight/ImageWith)*kDeviceWidth;
//          y=(kDeviceWidth-hight)/2;
//    }
//    else
//    {
//        y=0;
//          hight=kDeviceWidth;
//        width=(ImageWith/ImgeHight)*kDeviceWidth;
//        x=(kDeviceWidth-width)/2;
//     }
//  
//        _MovieImageView.frame=CGRectMake(x, y,width,hight);
    
   // _MovieImageView.frame=CGRectMake(0, 0, kStageWidth, kStageWidth*9/16);
    
    _MovieImageView.backgroundColor =VStageView_color;
    NSString *photostring=[NSString stringWithFormat:@"%@%@!w640",kUrlStage,self.stageInfo.photo];
    //可监视下载进入的方法

    [_MovieImageView sd_setImageWithURL:[NSURL URLWithString:photostring] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
#pragma  mark  是静态的, 气泡是不动的
     /*    if ( self.weiboinfo) {
         MarkView *markView = [self createMarkViewWithDict:self.weiboinfo andIndex:2000];
         markView.alpha = 1.0;
         //设置是否markview 不可以动画
         markView.isAnimation =YES;
         //设置单条微博的参数信息
         markView.weiboInfo=self.weiboinfo;
        //[markView setValueWithWeiboInfo:self.weiboinfo];
         //遵守markView 的协议
         markView.delegate=self;
        //单个气泡的时候，隐约显示的参数
         markView.isShowansHiden=YES;
         [markView StartShowAndhiden];
         [self addSubview:markView];
         
         }
#pragma  mark  有很多气泡，气泡循环播放
         if (self.weibosArray&&self.weibosArray.count>0) {
         for ( int i=0;i<self.weibosArray.count ; i++) {
         MarkView *markView = [self createMarkViewWithDict:self.weibosArray[i] andIndex:i];
         // 设置markview 可以动画
         markView.isAnimation = YES;
         markView.alpha=0;
         //设置单条微博的参数信息
         markView.weiboInfo=self.weibosArray[i];
             [markView setValueWithWeiboInfo:self.weibosArray[i]];
         //遵守markView 的协议
         markView.isShowansHiden=NO;
         markView.delegate=self;
         [self addSubview:markView];
         }
         }*/
    }];

}
#pragma mark 内部创建气泡的方法
- (MarkView *) createMarkViewWithDict:(weiboInfoModel *)weibodict andIndex:(NSInteger)index{
            MarkView *markView=[[MarkView alloc]initWithFrame:CGRectZero];
            markView.alpha = 0;
          //设置tag 值为了在下面去取出来循环轮播
            markView.tag=1000+index;
             float  x=[weibodict.x_percent floatValue];   //位置的百分比
             float  y=[weibodict.y_percent floatValue];
             NSString  *weiboTitleString=weibodict.content;
             NSString  *UpString=[NSString stringWithFormat:@"%@",weibodict.like_count];//weibodict.ups;
            //计算标题的size
            CGSize  Msize=[weiboTitleString boundingRectWithSize:CGSizeMake(kDeviceWidth/2,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:markView.TitleLable.font forKey:NSFontAttributeName] context:nil].size;
    
            // 计算赞数量的size
            CGSize Usize=[UpString boundingRectWithSize:CGSizeMake(40,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:markView.ZanNumLable.font forKey:NSFontAttributeName] context:nil].size;
            float hight=kStageWidth;
            //计算赞数量的长度
            float  Uwidth=[UpString floatValue]==0?0:Usize.width;
            //宽度=字的宽度+左头像图片的宽度＋赞图片的宽度＋赞数量的宽度+中间两个空格2+2
            float markViewWidth = Msize.width+23+Uwidth+5+5+11+5;
            float markViewHeight = Msize.height+6;
            if (weibodict.tagArray.count>0) {
                markViewHeight=markViewHeight+25;}
           if(IsIphone6plus)
           {
               markViewWidth=markViewWidth+10;
               markViewHeight=markViewHeight+4;
           }
            float markViewX = (x*kStageWidth)/100-markViewWidth;
            markViewX = MIN(MAX(markViewX, 5.0f), kStageWidth-markViewWidth-5);
            
            float markViewY = (y*hight)/100 - markViewHeight/2;
            markViewY = MIN(MAX(markViewY, 5.0f), hight-markViewHeight-5);
#pragma mark 设置气泡的大小和位置
            markView.frame=CGRectMake(markViewX, markViewY, markViewWidth, markViewHeight);
    
          //[markView.contentLable appendText:weiboTitleString];
         // [markView.contentLable appendImage:[UIImage imageNamed:@"tag_like_icon.png"] maxSize:CGSizeMake(11, 11) margin:UIEdgeInsetsMake(0, 0, 0, 0) alignment:M80ImageAlignmentBottom];
        // [markView.contentLable appendText:[NSString stringWithFormat:@"%@",weibodict.like_count]];
    
            markView.TitleLable.text=weiboTitleString;
        
          NSString   *headurl =[NSString stringWithFormat:@"%@%@",kUrlAvatar,weibodict.uerInfo.logo];
            [markView.LeftImageView sd_setImageWithURL:[NSURL URLWithString:headurl] placeholderImage:[UIImage imageNamed:@"user_normal"]];
           markView.ZanNumLable.text=[NSString stringWithFormat:@"%@",weibodict.like_count];
    
       //设置标签
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
    [UIView animateWithDuration:kalpaOneTime animations:^{
        for (id v in self.subviews) {
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
            for (id v in self.subviews) {
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
          // [self CircleshowAnimation];
            _timer = [NSTimer scheduledTimerWithTimeInterval:kTimeInterval target:self selector:@selector(CircleshowAnimation) userInfo:nil repeats:YES];
        }];
    }];
    
}

//6.循环显示气泡动画
//每次去控制一个动画的显示
//在markview 中只做一件事,就是自身的现实和隐藏，不管外部对他怎么操作
- (void)CircleshowAnimation {
     if (!_isAnimation) {
         return;
    }
    if (currentMarkIndex<self.weibosArray.count) {
        MarkView  *markView=(MarkView *)[self viewWithTag:1000+currentMarkIndex];
        markView.userInteractionEnabled=YES;
        [markView startAnimation];
    }
    currentMarkIndex =currentMarkIndex +1;
//#warning  疑点，为什么是13  的最大值
    //执行完成一轮动画之后，实行，重新再动第一个执行
    
   if (currentMarkIndex > MAX(self.subviews.count,6) ) {
        currentMarkIndex = 0;
   }
}

//7.停止动画
- (void)stopAnimation {
    
    [_timer invalidate];
    _timer=nil;
}





#pragma mark  ----
#pragma mark   ---markView   Delegate
#pragma  mark -----
//实现markview 的代理
-(void)MarkViewClick:(weiboInfoModel *)weiboDict withMarkView:(id)markView
{
    
   // NSLog(@"点击了 stageview 的微博操作 ＝＝＝%@   %@",weiboDict,self.stage);
    if (self.delegate &&[self.delegate respondsToSelector:@selector(StageViewHandClickMark:withmarkView:StageInfoDict:)]) {
        [self.delegate StageViewHandClickMark:weiboDict withmarkView:markView StageInfoDict:self.stageInfo];
    }

}


@end
