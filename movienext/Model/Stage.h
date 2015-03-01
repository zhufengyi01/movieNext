//
//  Stage.h
//  movienext
//
//  Created by 杜承玖 on 1/27/15.
//  Copyright (c) 2015 redianying. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Stage : NSObject

/** 剧情ID */
@property (nonatomic, strong) NSString * stage_id;
/** 剧情 */
@property (nonatomic, strong) NSString * stage;
/** 图片的宽度 */
@property (nonatomic, retain) NSString * w;
/** 图片的高度 */
@property (nonatomic, retain) NSString * h;
/** 此剧情下面的标签总数 */
@property (nonatomic, strong) NSString * marks;
/** 电影ID */
@property (nonatomic, strong) NSString * movie_id;
/** 电影名 */
@property (nonatomic, strong) NSString * movie_name;
/** 电影海报 */
@property (nonatomic, strong) NSString * movie_poster;

-(id)initWithDictionary:(NSDictionary *)dict;

@end
