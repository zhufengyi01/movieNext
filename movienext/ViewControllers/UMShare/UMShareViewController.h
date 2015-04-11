//
//  UMShareViewController.h
//  movienext
//
//  Created by 风之翼 on 15/4/7.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "StageInfoModel.h"
#import "stageInfoModel.h"
@protocol UMShareViewControllerDelegate <NSObject>

-(void)UMShareViewControllerHandClick:(UIButton *) button ShareImage:(UIImage *)shareImage StageInfoModel :(stageInfoModel *) StageInfo;

@end
@interface UMShareViewController : UIViewController
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
    //UIView  *topView;
    //底部视图
    UIView  *buttomView;
    UIImage   *shareImage;
    UIView     *logosupView;
}
@property(nonatomic,assign)id<UMShareViewControllerDelegate> delegate;
@property(nonatomic,strong) stageInfoModel  *StageInfo;
//截取cell 的图片
@property(nonatomic,strong)UIImage         *screenImage;
@end
