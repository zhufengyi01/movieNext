//
//  UMShareView.h
//  movienext
//
//  Created by 风之翼 on 15/3/19.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotMovieModel.h"
#import "StageInfoModel.h"
@protocol UMShareViewDelegate <NSObject>
///点击屏幕的透明颜色时候，弹回上面
-(void)SharetopViewTouchBengan;

-(void)UMshareViewHandClick:(UIButton *) button  ShareImage:(UIImage *) shareImage MoviewModel:(StageInfoModel *) StageInfo ;
@end

@interface UMShareView : UIView
{
    CGRect  m_frame;
    UILabel  *logoLable;
    UIButton  *wechatSessionBtn;
    UIButton  *wechatTimelineBtn;
    UIButton  *qzoneBtn;
    UIButton  *weiboBtn;
    UIImageView *_ShareimageView;
    UILabel  *_moviewName;
   //上部的view
    UIView  *topView;
    //底部视图
    UIView  *buttomView;
    UIImage   *shareImage;
    UIView     *logosupView;
    //UIScrollView  *_myScrollerView;
}
@property(nonatomic,assign)id<UMShareViewDelegate> delegate;
//@property(nonatomic,strong) UIImageView *ShareimageView;
//@property(nonatomic,strong) UILabel      *moviewName;
//数组中的model
@property(nonatomic,strong) StageInfoModel  *StageInfo;
//截取cell 的图片
@property(nonatomic,strong)UIImage         *screenImage;
-(void)configShareView;
-(void)showShareButtomView;
-(void)HidenShareButtomView;
@end
