//
//  Movie.h
//  movienext
//
//  Created by 杜承玖 on 14/11/21.
//  Copyright (c) 2014年 redianying. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 电影模型 */
@interface Movie : NSObject
/** 电影ID */
@property (nonatomic, strong) NSString * movie_id;
/** 豆瓣ID */
@property (nonatomic, strong) NSString * douban_id;
/** 电影名称 */
@property (nonatomic, strong) NSString * name;
/** 类型 */
@property (nonatomic, strong) NSString * type;
/** 国家 */
@property (nonatomic, strong) NSString * country;
/** 电影海报 */
@property (nonatomic, strong) NSString * logo;
/** 简介 */
@property (nonatomic, strong) NSString * brief;
/** 导演 */
@property (nonatomic, strong) NSString * director;
/** 演员 */
@property (nonatomic, strong) NSString * actors;
/** 编剧 */
@property (nonatomic, strong) NSString * scriptwriter;
/** 上映时间 */
@property (nonatomic, strong) NSString * release_time;
/** 又名 */
@property (nonatomic, strong) NSString * other_name;
/** IMDB */
@property (nonatomic, strong) NSString * imdb;
/** 时长 */
@property (nonatomic, strong) NSString * duration;
/** 语言 */
@property (nonatomic, strong) NSString * language;
/** 是否为电影(1-电影 0-电视剧) */
@property (nonatomic, strong) NSString * if_movie;
/** 集数(在电视剧的时候有值) */
@property (nonatomic, strong) NSString * episodes;
/** 电影页面的壁纸 */
@property (nonatomic, strong) NSString * cover;

-(id)initWithDictionary:(NSDictionary *)dict;

@end
