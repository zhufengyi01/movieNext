//
//  CommonStageCell.h
//  movienext
//
//  Created by 风之翼 on 15/3/3.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarkView.h"
#import "StageView.h"
//#import "StageInfoModel.h"
//#import "HotMovieModel.h"
//#import "WeiboModel.h"
#import "ModelsModel.h"
#import "stageInfoModel.h"
#import "weiboInfoModel.h"
#import "movieInfoModel.h"
#import "weiboUserInfoModel.h"
#import "UpweiboModel.h"


//页面来源，区分使用哪种类型的cell
typedef NS_ENUM(NSInteger, NSPageSourceType)
{
    NSPageSourceTypeMainHotController =0,
    NSPageSourceTypeMainNewController=1,
    NSPageSourceTypeMovieViewController=3,
    NSPageSourceTypeMyAddedViewController=4,
    NSPageSourceTypeMyupedViewController=5,
    
};
//个人页面来源，区分于那个
typedef NS_ENUM(NSInteger,NSUserPageType)
{
    NSUserPageTypeMySelfController=100,
    NSUserPageTypeOthersController=101,
};
@protocol CommonStageCellDelegate <NSObject>
//工具条的点击事件
-(void)commonStageCellToolButtonClick:(UIButton *) button Rowindex:(NSInteger) index;
//点击长按手势的事件
-(void)commonStageCellLoogPressClickindex:(NSInteger )indexrow;

@end
@interface CommonStageCell : UITableViewCell <StageViewDelegate>
{
    CGRect        m_frame;
    UIView        *BgView0;   //最新顶上的view
    //BgView0的子视图
    UIButton  *UserLogoButton;
    UILabel   *UserNameLable;
    UILabel   *TimeLable;
    UIButton   *deletButton;
    UIButton   *moreButton;
   // UIButton  *ZanButton;
   // NSMutableArray   *_MarkMuatableArray;
    
    //下面工具的子视图
    UIView        *BgView2;   //放分享的白色背景
    UIButton      *leftButtomButton;   //左下边按钮
    UILabel       *movieNameLable;
    UIImageView   *MovieLogoImageView;  // 电影的小图片
    UIButton      *ScreenButton;
    UIButton      *addMarkButton;
    UIView  *pressview;
 }
@property (assign,nonatomic)id <CommonStageCellDelegate>  delegate;
@property(assign,nonatomic) NSInteger   Cellindex;
@property(nonatomic,strong)StageView    *stageView;

@property (nonatomic,assign) NSPageSourceType    pageType;      //页面来源
@property(nonatomic,assign) NSUserPageType       userPage;  //  是自己的首页还是别人的首页
@property(nonatomic,strong) ModelsModel          *cellModel;
@property(nonatomic,strong) stageInfoModel       *stageInfo;
@property(nonatomic,strong) NSMutableArray       *weibosArray;
@property(nonatomic,strong) weiboInfoModel       *weiboInfo;
@property(nonatomic,strong)NSMutableArray        *upweibosArray;   //微博点赞
//设置stageview的背景图片
-(void)ConfigsetCellindexPath:(NSInteger) row;

@end
