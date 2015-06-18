//
//  StageDetailViewController.h
//  movienext
//
//  Created by 朱封毅 on 18/06/15.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "RootViewController.h"
#import "weiboInfoModel.h"

@interface StageDetailViewController : RootViewController

@property(nonatomic,strong) weiboInfoModel     *weiboInfo;  // 初始化的时候，需要把weiboinfo设置成数组的第几个

@property(nonatomic,strong) NSString *index;                //页的下标


@end
