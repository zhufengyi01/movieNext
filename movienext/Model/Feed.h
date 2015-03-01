//
//  Feed.h
//  movienext
//
//  Created by 杜承玖 on 14/11/21.
//  Copyright (c) 2014年 redianying. All rights reserved.
//

#import <Foundation/Foundation.h>
//导入微博对象
#import "Weibo.h"
//导入剧情对象
#import "Stage.h"

/** 剧情模型 */
@interface Feed : NSObject

/**
 *  剧情对象
 */
@property (nonatomic, strong) Stage * stage;
/**
 *  微博对象
 */
@property (nonatomic, strong) Weibo * weibo;
/**
 *  微博列表
 */
@property (nonatomic, strong) NSMutableArray  * arrayWeibo;

-(id)initWithDictionary:(NSDictionary *)dict;

@end
