//
//  DoubanInfo.h
//  immovie
//
//  Created by Michael Du on 13-10-3.
//  Copyright (c) 2013年 Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DoubanInfo : NSObject

@property (nonatomic, retain) NSString * doubanId;
@property (nonatomic, retain) NSString * smallImage;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * originalTitle;
@property (nonatomic, retain) NSString * average;
@property (nonatomic, retain) NSString * subtype;

- (id)initWithDictionary:(NSDictionary *)dict;

+(DoubanInfo *)getBeanWithDictionary:(NSDictionary *)dic;

@end
