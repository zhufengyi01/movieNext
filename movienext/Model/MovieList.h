//
//  MovieList.h
//  movienext
//
//  Created by 杜承玖 on 14/11/20.
//  Copyright (c) 2014年 redianying. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 首页Feed */
@interface MovieList : NSObject

@property (nonatomic, copy) NSString * feed_id;
/** 电影ID */
@property (nonatomic, copy) NSString * movie_id;
/** 图片文件名 */
@property (nonatomic, copy) NSString * img;
/** Feed标题 */
@property (nonatomic, copy) NSString * title;
/** 创建时间 */
@property (nonatomic, copy) NSString * create_time;

- (id)initWithDictionary:(NSDictionary *)dict;

@end
