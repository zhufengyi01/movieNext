//
//  HotMovieModel.h
//  movienext
//
//  Created by 风之翼 on 15/3/14.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StageInfoModel.h"
#import "WeiboModel.h"


@interface HotMovieModel : NSObject
@property(nonatomic,strong)  NSString  *hot_id;
@property(nonatomic,strong) StageInfoModel  *stageinfo;
@property(nonatomic,strong) WeiboModel  *weibo;
@property(nonatomic,strong) NSArray    *weibos;
@property(nonatomic,strong) NSString  *exists_new;
@property(nonatomic,strong) NSString  *return_code;
@property(nonatomic,strong) NSString  *return_desc;
@end
