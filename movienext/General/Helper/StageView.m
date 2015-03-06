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
    _MovieImageView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 200)];
    [self addSubview:_MovieImageView];
}

- (void)setStageValue:(NSDictionary *)dict {
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
    
        for ( int i=0;i<_WeibosArray.count ; i++) {
        
            MarkView *markView=[[MarkView alloc]initWithFrame:CGRectMake(10, 10, 100, 30)];

#warning 暂时设为YES
            //markView.clipsToBounds = YES;
            markView.tag=1000+i;
           [self addSubview:markView];
                    
            NSDictionary  *weibodict=[NSDictionary dictionaryWithDictionary:[_WeibosArray  objectAtIndex:i]];
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
        }
}

@end
