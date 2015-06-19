//
//  ShareModel.h
//  movienext
//
//  Created by 朱封毅 on 19/06/15.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import <Foundation/Foundation.h>
//分享的model
#import "weiboUserInfoModel.h"
#import "weiboInfoModel.h"

@interface ShareModel : NSObject
@property(nonatomic,strong) NSString  *Id;

@property(nonatomic,strong) NSString  *weibo_id;

@property(nonatomic,strong) NSString  *method;

@property(nonatomic,strong) NSString  *platform;

@property(nonatomic,strong) NSString  *created_by;

@property(nonatomic,strong) NSString  *created_at;

@property(nonatomic,strong) weiboInfoModel  *weiboInfo;

@property(nonatomic,strong)weiboUserInfoModel  *userInfo;

@end
