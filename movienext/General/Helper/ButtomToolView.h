//
//  ButtomToolView.h
//  movienext
//
//  Created by 风之翼 on 15/3/11.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarkView.h"
//#import "WeiboModel.h"
//#import "StageInfoModel.h"
#import "weiboInfoModel.h"
#import "stageInfoModel.h"
#import "M80AttributedLabel.h"
#import "TagView.h"

@protocol ButtomToolViewDelegate <NSObject>
//点击底部视图的方法，根据tag值判断是点击了那一个按钮
//button.tag=10000; 头像
//button.tag=10001;  分享
//button.tag=10002  赞
-(void)ToolViewHandClick:(UIButton  *) button :(MarkView *) markView weiboDict:(weiboInfoModel*) weiboDict StageInfo:(stageInfoModel *)stageInfoDict;

///点击屏幕的透明颜色时候，弹回上面
//-(void)topViewTouchBengan;

//点击标签，跳转到含有标签的剧情列表
-(void)ToolViewTagHandClickTagView:(TagView*)tagView  withweiboinfo:(weiboInfoModel *) weiboInfo WithTagInfo:(TagModel *) tagInfo;


@end
@interface ButtomToolView : UIView  <TagViewDelegate>
{
    UIButton  *headButton;
    //UILabel   *nameLable;
    UIButton  *shareButton;
    UIButton  *zanbutton;
    UIButton    *morebuton;
    
    //整个透明背景的图大小
    CGRect    m_frame;
    //上面的透明的试图，点击的按钮
    UIButton   *_topButtom;
    //底部的弹出视图
    //UIView   *alertView;
    UILabel  *userNamelabel;
    UILabel  *timelabel;
    UIButton  *closealertView;
    UILabel  *contentLable;
    UIView *tagFatherView;
    M80AttributedLabel *tagLable;
    
    //前面标签的宽度
    double  leadWidth;

    UIView *buttomShareView;
    int  zanNum;
    UIImageView  *likeimageview;
    
}
#pragma mark  ------外部方法
@property(nonatomic,strong) weiboInfoModel   *weiboInfo;
@property(nonatomic,strong) stageInfoModel   *stageInfo;
@property(nonatomic,strong) id markView;
@property(nonatomic,strong) NSMutableArray   *upweiboArray;

@property(nonatomic,strong) UIView  *alertView;
-(void)configToolBar;
//显示底部试图.用于动画
-(void)ShowButtomView;
//隐藏底部试图
-(void)HidenButtomView;



#pragma  mark 点赞的方法
//设置赞的状态为选中
//-(void)SetZanButtonSelected;
//设置代理
@property (nonatomic,strong) id<ButtomToolViewDelegate> delegete;

@end
