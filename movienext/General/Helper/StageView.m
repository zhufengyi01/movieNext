//
//  StageView.m
//  movienext
//
//  Created by 杜承玖 on 3/6/15.
//  Copyright (c) 2015 redianying. All rights reserved.
//

#import "StageView.h"
#import "MarkView.h"
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

- (void)createUI {
    self.backgroundColor = [UIColor redColor];
    _MovieImageView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 200)];
    [self addSubview:_MovieImageView];
}

- (void)setStageValue:(NSDictionary *)dict {
    //先移除所有的Mark视图
    for (UIView  *Mview in  self.subviews) {
        if ([Mview isKindOfClass:[MarkView class]]) {
            [Mview  removeFromSuperview];
        }
    }
    
    float  ImageWith=[[dict objectForKey:@"w"]  floatValue];
    float  ImgeHight=[[dict objectForKey:@"h"]  floatValue];
    float hight=0;
    if (ImageWith>ImgeHight) {
        hight= kDeviceWidth;
    }
    else if(ImgeHight>ImageWith)
    {
        hight=  (ImgeHight/ImageWith) *kDeviceWidth;
    }
    if ([dict  objectForKey:@"stage"]) {
        //计算位置
        float   y=(hight-(ImgeHight/ImageWith)*kDeviceWidth)/2;
          _MovieImageView.frame=CGRectMake(0,y, kDeviceWidth, (ImgeHight/ImageWith)*kDeviceWidth);
       [_MovieImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@!w640",kUrlStage,[dict objectForKey:@"stage"]]] placeholderImage:[UIImage imageNamed:@"loading_image_all.png"]];
     }
    
    if ( _weiboDict ) {
        MarkView *markView = [self createMarkViewWithDict:_weiboDict andIndex:2000];
        markView.alpha = 1.0;
        markView.isAnimation = NO;
       [self addSubview:markView];
    }
    
    for ( int i=0;i<_WeibosArray.count ; i++) {
        NSDictionary  *weibodict=[NSDictionary dictionaryWithDictionary:[_WeibosArray  objectAtIndex:i]];
        MarkView *markView = [self createMarkViewWithDict:weibodict andIndex:i];
        markView.isAnimation = YES;
       [self addSubview:markView];
    }
}

- (MarkView *) createMarkViewWithDict:(NSDictionary *)weibodict andIndex:(NSInteger)index{
    
            MarkView *markView=[[MarkView alloc]initWithFrame:CGRectMake(10, 10, 100, 30)];
            markView.alpha = 0;
#warning 暂时设为YES
            //markView.clipsToBounds = YES;
            markView.tag=1000+index;
            
            float  x=[[weibodict objectForKey:@"x"]floatValue ];
            float  y=[[weibodict objectForKey:@"y"]floatValue ];
            NSLog(@" ==== =mark  view  ===%f  ==== mark view =====%f",x,y);
            NSString  *weiboTitleString=[weibodict  objectForKey:@"topic"];
            NSString  *UpString=[weibodict objectForKey:@"ups"];
            NSLog(@"weibo dict ======%@",weibodict);
            
            //计算标题的size
            CGSize  Msize=[weiboTitleString boundingRectWithSize:CGSizeMake(kDeviceWidth/2,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:markView.TitleLable.font forKey:NSFontAttributeName] context:nil].size;
            // 计算赞数量的size
            CGSize Usize=[UpString boundingRectWithSize:CGSizeMake(40,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:markView.ZanNumLable.font forKey:NSFontAttributeName] context:nil].size;
          
            NSLog(@"size= %f %f", Msize.width, Msize.height);
            //计算赞数量的长度
            float  Uwidth=[UpString floatValue]==0?0:Usize.width;
            //宽度=字的宽度+左头像图片的宽度＋赞图片的宽度＋赞数量的宽度+中间两个空格2+2
            //位置=
            float markViewWidth = Msize.width+23+Uwidth+5+5+11+5;
            float markViewHeight = Msize.height+15;
            float markViewX = (x*kDeviceWidth)/100-markViewWidth;
            markViewX = MIN(MAX(markViewX, 0.0f), kDeviceWidth-markViewWidth);
            
            float markViewY = (y*kDeviceWidth)/100+(Msize.height/2);
#warning    kDeviceWidth 目前计算的是正方形的，当图片高度>屏幕的宽度的实际，需要使用图片的高度
            markViewY = MIN(MAX(markViewY, markViewHeight/2), kDeviceWidth-markViewHeight);
            
            markView.frame=CGRectMake(markViewX, markViewY, markViewWidth, markViewHeight);
          
            markView.TitleLable.text=weiboTitleString;
            ///显示标签的头像
            [ markView.LeftImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kUrlAvatar,[weibodict objectForKey:@"avatar"]]]];
            
            markView.ZanNumLable.text=[weibodict objectForKey:@"ups"];
            markView.isAnimation = YES;
    return markView;
}

#pragma  mark ----执行动画的开始和结束
//2.放大动画
- (void)scaleAnimation {
       //放大动画
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
        //结束放大动画, 同时开始循环显示动画
        [UIView animateWithDuration:0.2 delay:0.6 options:UIViewAnimationOptionCurveLinear animations:^{
            for (UIView *v in self.subviews) {
                if ([v isKindOfClass:[MarkView class]]) {
                    MarkView *mv = (MarkView *)v;
                    [mv startAnimation];
                    mv.alpha = 0.0;
                }
                //mv.hidden = YES;
            }
            _timer = [NSTimer scheduledTimerWithTimeInterval:kTimeOffset target:self selector:@selector(showAnimation) userInfo:nil repeats:YES];
        } completion:nil];
    }];
}



//1.开始执行动画, 动画入口
- (void)startAnimation {
    //开始动画之后0.5秒再开始动画
    [self performSelector:@selector(scaleAnimation) withObject:nil afterDelay:0.5];
}

//6.循环显示气泡动画
- (void)showAnimation {
    NSLog(@"index = %ld", currentMarkIndex);
    
    if (currentMarkIndex <= self.subviews.count-1) {
        UIView *v = self.subviews[currentMarkIndex];
        if ([v isKindOfClass:[MarkView class]]) {
            MarkView *mv = (MarkView *)v;
            //markview 本身的方法
            [mv startAnimation];
        }
    }
    
    currentMarkIndex ++;
    //执行完成一轮动画之后，实行，重新再动第一个执行
    if (currentMarkIndex > MAX(self.subviews.count, 10) ) {
        currentMarkIndex = 0;
    }
}

//7.停止动画
- (void)stopAnimation {
    [_timer invalidate];
    
}

@end
