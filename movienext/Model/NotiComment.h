//
//  NotiComment.h
//  movienext
//
//  Created by 杜承玖 on 1/20/15.
//  Copyright (c) 2015 redianying. All rights reserved.
//

#import <Foundation/Foundation.h>
//导入微博对象
#import "Weibo.h"
//导入剧情对象
#import "Stage.h"

/**
 *  评论通知模型
 */
@interface NotiComment : NSObject

/**
 *  通知的ID
 */
@property (nonatomic, strong) NSString * notiId;
/** 操作时间 */
@property (nonatomic, strong) NSString * create_time;
@property (nonatomic, strong) NSString * userId;
@property (nonatomic, strong) NSString * username;
@property (nonatomic, strong) NSString * avatar;
/**
 *  剧情对象
 */
@property (nonatomic, strong) Stage * stage;
/**
 *  微博对象
 */
@property (nonatomic, strong) Weibo * weibo;

-(id)initWithDictionary:(NSDictionary *)dict;

@end