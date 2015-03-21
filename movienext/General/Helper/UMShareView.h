//
//  UMShareView.h
//  movienext
//
//  Created by 风之翼 on 15/3/19.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotMovieModel.h"
@protocol UMShareViewDelegate <NSObject>
///点击屏幕的透明颜色时候，弹回上面
-(void)SharetopViewTouchBengan;

-(void)UMshareViewHandClick:(UIButton *) button MoviewModel:(HotMovieModel *) moviemodel;
@end

@interface UMShareView : UIView
{
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
}
@property(nonatomic,assign)id<UMShareViewDelegate> delegate;
//@property(nonatomic,strong) UIImageView *ShareimageView;
//@property(nonatomic,strong) UILabel      *moviewName;
//数组中的model
@property(nonatomic,strong) HotMovieModel  *model;
//截取cell 的图片
@property(nonatomic,strong)UIImage         *screenImage;
-(void)configShareView;
-(void)showShareButtomView;
-(void)HidenShareButtomView;
@end
