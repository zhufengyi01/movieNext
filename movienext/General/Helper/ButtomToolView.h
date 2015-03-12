//
//  ButtomToolView.h
//  movienext
//
//  Created by 风之翼 on 15/3/11.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarkView.h"
@protocol ButtomToolViewDelegate <NSObject>
//点击底部视图的方法，根据tag值判断是点击了那一个按钮
//button.tag=10000; 头像
//button.tag=10001;  分享
//button.tag=10002  赞
-(void)ToolViewHandClick:(UIButton  *) button :(MarkView *) markView weiboDict:(NSDictionary *) weiboDict StageInfo:(NSDictionary *)stageInfoDict;

///点击屏幕的透明颜色时候，弹回上面
-(void)topViewTouchBengan;

@end
@interface ButtomToolView : UIView
{
    UIButton  *headButton;
    UILabel   *nameLable;
    UIButton  *shareButton;
    UIButton  *zanbutton;
    //当前气泡视图
    MarkView  *_markView;
    //当前weibo的字典数据
    NSDictionary  *_weiboDict;
    //整个透明背景的图大小
    CGRect    m_frame;
    //上面的透明的试图，点击的按钮
    UIButton   *_topButtom;
    //底部的弹出视图
    UIView   *buttomView;
    NSDictionary  *stageInfo;
}
#pragma mark  ------外部方法
//设置buttomview 的值
-(void)setToolBarValue:(NSDictionary  *) dict :(id) markView WithStageInfo:(NSDictionary *)stageInfoDict;
//显示底部试图
-(void)ShowButtomView;
//隐藏底部试图
-(void)HidenButtomView;

#pragma  mark 点赞的方法
//设置赞的状态为选中
-(void)SetZanButtonSelected;
//设置代理
@property (nonatomic,strong) id<ButtomToolViewDelegate> delegete;

@end
