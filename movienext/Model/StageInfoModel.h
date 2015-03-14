//
//  StageInfoModel.h
//  movienext
//
//  Created by 风之翼 on 15/3/14.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StageInfoModel : NSObject
/** 剧情ID */
@property (nonatomic, strong) NSNumber *Id;
/** 剧情 */
@property (nonatomic, strong) NSString * stage;
/** 图片的宽度 */
@property (nonatomic, retain) NSNumber * w;
/** 图片的高度 */
@property (nonatomic, retain) NSNumber * h;
/** 此剧情下面的标签总数 */
@property (nonatomic, strong) NSNumber * marks;
/** 电影ID */
@property (nonatomic, strong) NSString * movie_id;
/** 电影名 */
@property (nonatomic, strong) NSString * movie_name;
/** 电影海报 */
@property (nonatomic, strong) NSString * movie_poster;

@end
