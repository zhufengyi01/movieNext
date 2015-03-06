//
//  MarkView.h
//  movienext
//
//  Created by 风之翼 on 15/3/4.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kShowTimeOffset 0.7  // 淡入时间
#define kStaticTimeOffset 5.7  //静态显示时间
#define kHidenTimeOffset 0.7  //淡出时间
@protocol MarkViewDelegate <NSObject>
 -(void)MarkViewClick;
@end

@interface MarkView : UIView
{
    CGRect  m_frame;
    //UIView  *rightView;  //又视图
    //UILabel  *TitleLable;
    ///UIImageView  *ZanImageView;
}

@property (nonatomic,strong) UIImageView  *LeftImageView;
@property(nonatomic,strong)UIView    *rightView;  //又视图.包含titlelable 和赞的图片，赞的个数。
@property (nonatomic,strong) UILabel      *TitleLable;
@property (nonatomic,strong) UILabel      *ZanNumLable;
@property(nonatomic,strong )UIImageView  *ZanImageView;
@property (nonatomic,assign) id <MarkViewDelegate> delegate;
@property(nonatomic,assign) BOOL isAnimation;   //是否是可以动的动画
//markview 自身的动画
-(void)startAnimation;
@end
