//
//  TagModel.h
//  movienext
//
//  Created by 风之翼 on 15/4/24.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "stageInfoModel.h"
#import "TagDetailModel.h"

@interface TagModel : NSObject

@property(nonatomic,strong) NSString  *Id;


@property(nonatomic,strong) NSString  *tag_id;


@property(nonatomic,strong) NSString  *weibo_id;


@property(nonatomic,strong) NSString  *status;


@property(nonatomic,strong) NSString  *created_at;


@property(nonatomic,strong) NSString  *updated_at;


@property (nonatomic,strong) TagDetailModel  *tagDetailInfo;


@end
