//
//  Weibo.h
//  movienext
//
//  Created by 杜承玖 on 14/11/21.
//  Copyright (c) 2014年 redianying. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/** 微博模型 */
@interface Weibo : NSObject

@property (nonatomic, strong) NSString * weibo_id;
@property (nonatomic, strong) NSString * topic;
@property (nonatomic, strong) NSString * ups;
@property (nonatomic, strong) NSString * comments;
@property (nonatomic, strong) NSString * uped;
@property (nonatomic, strong) NSString * create_time;
@property (nonatomic, strong) NSString * x;
@property (nonatomic, strong) NSString * y;
@property (nonatomic, strong) NSString * user_id;
@property (nonatomic, strong) NSString * username;
@property (nonatomic, strong) NSString * avatar;
@property (nonatomic, strong) NSString * verified;


-(id)initWithDictionary:(NSDictionary *)dict;



@end
