//
//  剧情详细页
//  ShowStageViewController.h
//  movienext
//
//  Created by 杜承玖 on 3/19/15.
//  Copyright (c) 2015 redianying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
//#import "HotMovieModel.h"
#import "stageInfoModel.h"
#import "TagView.h"
#import "TagToStageViewController.h"
#import "AddMarkViewController.h"

typedef  NS_ENUM(NSInteger,NSStagePapeType)
{
    NSStagePapeTypeDefult,
    NSStagePapeTypeMyAdd,     //个人页面进来的，可以删除
    NSStagePapeTypeOthersAdd,  //从别人的个人页进去
    NSStagePapeTypeStageList,  //电影列表页
    
    //首页热门
    NSStagePapeTypeHotStageList, //首页热门列表 
    
    //管理管功能列表页
    NSStagePapeTypeAdmin_New_Add,  //最新添加
    NSStagePapeTypeAdmin_Dscorver,  //发现
    NSStagePapeTypeAdmin_Close_Weibo,  //屏蔽列表
    NSStagePapeTypeAdmin_Recommed  //推荐列表
    
    
    
    
};
@protocol ShowStageviewControllerDelegate <NSObject>

//删除完成返回刷新
-(void)reloadMyAddCollectionView;

@end

@interface ShowStageViewController : RootViewController <TagViewDelegate,AddMarkViewControllerDelegate>

@property (nonatomic, strong) stageInfoModel *stageInfo;
@property(nonatomic,strong) NSMutableArray   *upweiboArray;
@property(nonatomic,assign) NSStagePapeType  pageType;
@property(nonatomic,strong) weiboInfoModel *weiboInfo;  //如果是从管理员入口，并且是最新的话，传递weiboInfo

#warning 个人添加
@property(nonatomic,strong) NSMutableArray  *addWeiboArray;  //个人页进来的，传递整个数组，删除完成后，移除数组内容，并且刷新
@end
