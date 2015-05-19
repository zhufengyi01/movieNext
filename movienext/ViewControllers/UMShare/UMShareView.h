//
//  ShareView.h
//  movienext
//
//  Created by 风之翼 on 15/5/19.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "stageInfoModel.h"
#define KShow_ShareView_Time 0.3
@protocol UMShareViewDelegate <NSObject>

-(void)UMShareViewHandClick:(UIButton *) button ShareImage:(UIImage *)shareImage StageInfoModel :(stageInfoModel *) StageInfo;

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
    
}
-(instancetype)initwithStageInfo:(stageInfoModel *) StageInfo ScreenImage:(UIImage *) screenImage delgate:(id<UMShareViewDelegate>) delegate;

//@property (nonatomic,strong)id<UMShareViewDelegate> delegate;
//@property(nonatomic,strong) stageInfoModel  *StageInfo;
//截取cell 的图片
//@property(nonatomic,strong)UIImage         *screenImage;
//显示出来
-(void)show;
@end
