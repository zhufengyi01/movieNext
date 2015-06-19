//
//  ShareView.h
//  movienext
//
//  Created by 风之翼 on 15/5/19.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "stageInfoModel.h"
#import "M80AttributedLabel.h"
#import "weiboInfoModel.h"
#define KShow_ShareView_Time 0.3
typedef NS_ENUM(NSInteger, UMShareType)
{
    UMShareTypeDefult,
    UMShareTypeSuccess
};

@protocol UMShareViewDelegate <NSObject>

-(void)UMShareViewHandClick:(UIButton *) button ShareImage:(UIImage *)shareImage StageInfoModel :(stageInfoModel *) StageInfo;
//取消分享，应该返回上一页
-(void)UMCancleShareClick;

@end

@interface UMShareView : UIView
{

    UIView  *backView;
    UIView *shareView;  //分享的view
    UILabel  *logoLable;
    UIButton  *wechatSessionBtn;
    UIButton  *wechatTimelineBtn;
    UIButton  *qzoneBtn;
    UIButton  *weiboBtn;
    UIImageView *_ShareimageView;
    UILabel  *_moviewName;
    //上部的view
    //UIView  *topView;
    //底部视图
    UIView  *buttomView;
    UIImage   *shareImage;
    UIView     *logosupView;
    stageInfoModel  *_stageInfo;
    UIImage *_screenImage;
    id <UMShareViewDelegate> _delegate;
    float shareheight;
}
-(instancetype)initwithStageInfo:(stageInfoModel *) StageInfo ScreenImage:(UIImage *) screenImage delgate:(id<UMShareViewDelegate>) delegate andShareHeight:(float) Height;
//微博id
@property(nonatomic,strong) weiboInfoModel  *weiboInfo;

@property(nonatomic,assign) UMShareType  pageType;

@property(nonatomic,strong) M80AttributedLabel  *tipLable;

//分享头部视图
-(void)setShareLable;

-(void)setshareHeightwithFloat:(float) height;

//显示出来
-(void)show;
@end
