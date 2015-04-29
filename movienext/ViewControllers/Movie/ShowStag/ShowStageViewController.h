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
@interface ShowStageViewController : RootViewController <TagViewDelegate>

@property (nonatomic, strong) stageInfoModel *stageInfo;
@property(nonatomic,strong) NSMutableArray   *upweiboArray;

@end
