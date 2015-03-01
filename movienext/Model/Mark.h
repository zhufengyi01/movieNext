//
//  Mark.h
//  movienext
//
//  Created by 杜承玖 on 14/11/26.
//  Copyright (c) 2014年 redianying. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 标签模型 */
@interface Mark : NSObject

/** 标签ID */
@property (nonatomic, strong) NSString * mark_id;
/** 用户ID */
@property (nonatomic, strong) NSString * user_id;
/** 剧情ID */
@property (nonatomic, strong) NSString * stage_id;
/** 标签的类型 */
@property (nonatomic, strong) NSString * type;
/** 标签的X位置的百分比 */
@property (nonatomic, strong) NSString * x;
/** 标签的Y位置的百分比 */
@property (nonatomic, strong) NSString * y;
/** 标签的喜欢数 */
@property (nonatomic, strong) NSString * likes;
/** 标签的评论数 */
@property (nonatomic, strong) NSString * comments;
/** 标签的标题 */
@property (nonatomic, strong) NSString * title;
/** 标签的话题ID */
@property (nonatomic, strong) NSString * external_id;
/** 标签的创建时间 */
@property (nonatomic, strong) NSString * create_time;
/** 标签的 */
@property (nonatomic, strong) NSString * content;

-(id)initWithDictionary:(NSDictionary *)dict;
-(NSDictionary *)convertToDictionary;

@end
