 //
//  weiboInfoModel.h
//  movienext
//
//  Created by 风之翼 on 15/4/10.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "weiboUserInfoModel.h"
#import "stageInfoModel.h"
#import <UIKit/UIKit.h>
#import "stageInfoModel.h"
 @interface weiboInfoModel : NSObject
@property(nonatomic,strong) NSNumber  *Id;
@property(nonatomic,strong) NSString  *stage_id;

@property(nonatomic,strong) stageInfoModel  *stageInfo;

@property(nonatomic,strong) NSString  *x_percent;


@property(nonatomic,strong) NSString  *y_percent;


@property(nonatomic,strong) NSNumber  *like_count;

@property(nonatomic,strong) NSString  *content;

@property(nonatomic,strong) NSString  *created_by;  //由谁创建

@property(nonatomic,strong) NSString  *created_at;


@property(nonatomic,strong) weiboUserInfoModel  *uerInfo;

//最新额外的数据
@property(nonatomic,strong) NSString  *updated_at;

@property(nonatomic,strong) NSString  *updated_by;
@property(nonatomic,strong) NSString  *comm_count;


@property(nonatomic,strong) NSString  *status;



@end
