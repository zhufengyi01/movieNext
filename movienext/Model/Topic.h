//
//  Topic.h
//  movienext
//
//  Created by 杜承玖 on 14/11/21.
//  Copyright (c) 2014年 redianying. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  主题模型
 */
@interface Topic : NSObject
/** 主题ID */
@property (nonatomic, strong) NSString * topic_id;
/** 类型(暂时只分影人类型和其他类型) */
@property (nonatomic, strong) NSString * type;
/** 主题的标题 */
@property (nonatomic, strong) NSString * title;
/** 主题的LOGO */
@property (nonatomic, strong) NSString * logo;
/** 主题的简介描述 */
@property (nonatomic, strong) NSString * desc;

- (id)initWithDictionary:(NSDictionary *)dict;

@end
