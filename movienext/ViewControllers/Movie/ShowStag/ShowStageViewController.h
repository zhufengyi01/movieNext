//
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
@interface ShowStageViewController : RootViewController <TagViewDelegate,AddMarkViewControllerDelegate>

@property (nonatomic, strong) stageInfoModel *stageInfo;
@property(nonatomic,strong) NSMutableArray   *upweiboArray;

@property(nonatomic,strong) weiboInfoModel *weiboInfo;  //如果是从管理员入口，并且是最新的话，传递weiboInfo 

@end
