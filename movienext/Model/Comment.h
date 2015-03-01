//
//  Comment.h
//  movienext
//
//  Created by 杜承玖 on 14/11/27.
//  Copyright (c) 2014年 redianying. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

/**
 *  评论对象
 */
@interface Comment : NSObject

/**
 *  微博ID
 */
@property (nonatomic, strong) NSString * weibo_id;
/**
 *  用户ID
 */
@property (nonatomic, strong) NSString * user_id;
/**
 *  评论ID
 */
@property (nonatomic, strong) NSString * comment_id;
/**
 *  评论内容
 */
@property (nonatomic, strong) NSString * body;
/**
 *  赞的数量
 */
@property (nonatomic, strong) NSString * ups;
/**
 *  评论的状态 1-正常 0-删除
 */
@property (nonatomic, strong) NSString * status;
/**
 *  创建时间 是时间戳
 */
@property (nonatomic, strong) NSString * create_time;
/**
 *  评论的作者
 */
@property (nonatomic, strong) User * user;

/**
 *  初始化评论对象
 *
 *  @param dict 评论的字典
 *
 *  @return 返回评论对象
 */
-(id)initWithDictionary:(NSDictionary *)dict;

@end
