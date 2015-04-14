//
//  stageInfoModel.h
//  movienext
//
//  Created by 风之翼 on 15/4/10.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//#import "weiboInfoModel.h"
#import "movieInfoModel.h"
@interface stageInfoModel : NSObject
@property(nonatomic,strong) NSNumber  *Id;
@property(nonatomic,strong) NSString  *movie_id;
@property(nonatomic,strong) NSString  *weibo_count;
@property(nonatomic,strong) NSString  *url;

@property(nonatomic,strong) NSString  *photo;
@property(nonatomic,strong) NSString  *width;
@property(nonatomic,strong) NSString  *height;
@property(nonatomic,strong) NSString  *created_at;
@property(nonatomic,strong) NSString  *updated_at;
@property(nonatomic,strong) NSString  *created_by;
@property(nonatomic,strong) NSString  *updated_by;
@property(nonatomic,strong) NSString  *status;

@property(nonatomic,strong) NSMutableArray  *weibosArray;
@property(nonatomic,strong) movieInfoModel  *movieInfo;

@end
