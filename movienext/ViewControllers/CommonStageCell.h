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
#import "StageInfoModel.h"
#import "HotMovieModel.h"
#import "WeiboModel.h"

typedef NS_ENUM(NSInteger, NSPageSourceType)
{
    NSPageSourceTypeMainHotController =0,
    NSPageSourceTypeMainNewController=1,
    NSPageSourceTypeMovieViewController=3,
    NSPageSourceTypeMyAddedViewController=4,
    NSPageSourceTypeMyupedViewController=5,
    
};
@interface CommonStageCell : UITableViewCell <StageViewDelegate>
{
    CGRect        m_frame;
    UIView        *BgView0;   //最新顶上的view
    //BgView0的子视图
    UIButton  *UserLogoButton;
    UILabel   *UserNameLable;
    UILabel   *TimeLable;
    UIButton  *ZanButton;
   // NSMutableArray   *_MarkMuatableArray;
    
    //下面工具的子视图
    UIView        *BgView2;   //放分享的白色背景
    UIButton      *leftButtomButton;   //左下边按钮
    UIImageView   *MovieLogoImageView;  // 电影的小图片
    UIButton      *ScreenButton;
    UIButton      *addMarkButton;
    

 }
///@property (nonatomic,strong) StageView          *BgView1;   //放图片和弹幕的黑色背景图
@property(nonatomic,strong)StageView    *stageView;

@property(nonatomic,strong) StageInfoModel   *StageInfoDict;
@property (nonatomic,strong) NSArray       *WeibosArray;   //小标签的数组，在多个标签的时候使用这个
@property (nonatomic,strong) WeiboModel       *weiboDict;     //只有一个标签的时候传递这个参数
@property (nonatomic,assign) NSPageSourceType   pageType;
//设置stageview的背景图片
-(void)ConfigsetCellindexPath:(NSInteger) row;

@end
