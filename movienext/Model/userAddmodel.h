//
//  userAddmodel.h
//  movienext
//
//  Created by 风之翼 on 15/4/13.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "weiboInfoModel.h"
@interface userAddmodel : NSObject
@property(nonatomic,strong) NSNumber  *Id;

@property(nonatomic,strong) NSString  *author_id;

@property(nonatomic,strong) NSString  *created_at;

@property(nonatomic,strong) NSString  *updated_at;

@property(nonatomic,strong)NSString  *created_by;

@property(nonatomic,strong) NSNumber  *weibo_id;

@property(nonatomic,strong) weiboUserInfoModel  *userInfo;

@property(nonatomic,strong)  weiboInfoModel  *weiboInfo;

@end
