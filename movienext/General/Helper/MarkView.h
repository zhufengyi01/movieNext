//
//  MarkView.h
//  movienext
//
//  Created by 风之翼 on 15/3/4.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboModel.h"
#import "StageInfoModel.h"
@protocol MarkViewDelegate <NSObject> 
//标签的点击事件，对stageview 提供接口，传递微博对象
-(void)MarkViewClick:(WeiboModel  *) weiboDict withMarkView:(id) markView;
@end
@interface MarkView : UIView
{
    CGRect  m_frame;
}

@property (nonatomic,strong) UIImageView    *LeftImageView;
@property (nonatomic,strong) UIView         *rightView;  //又视图.包含titlelable 和赞的图片，赞的个数。
@property (nonatomic,strong) UILabel        *TitleLable;
@property (nonatomic,strong) UILabel        *ZanNumLable;
@property (nonatomic,strong) UIImageView    *ZanImageView;
//点击的状态
@property (nonatomic,assign) BOOL  isSelected;   // 是否被选中

//从stagview传递过来的微博字典对象，这个对象中包含微博的详细信息
@property (nonatomic,strong)WeiboModel  *weiboDict;

@property (nonatomic,assign) id <MarkViewDelegate> delegate;
@property (nonatomic,assign) BOOL isAnimation;   //是否是可以动的动画
@property(nonatomic,assign) BOOL  isShowansHiden;  //是否可以闪现

//最新页面的markview 闪现
-(void)StartShowAndhiden;
//在controller 里面实现的方法，点击屏幕，让当前的的气泡取消选中
#warning  唯一一个外部和内部都会调用的方法
//外部和内部都会调用的方法
-(void)CancelMarksetSelect;
//markview 自身的动画
-(void)startAnimation;

@end
