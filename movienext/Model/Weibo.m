//
//  Weibo.m
//  movienext
//
//  Created by 杜承玖 on 14/11/21.
//  Copyright (c) 2014年 redianying. All rights reserved.
//

#import "Weibo.h"

@implementation Weibo

- (id)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if(self){
        if (dict && [dict isKindOfClass:[NSDictionary class]]) {
            _weibo_id           = [dict objectForKey:@"id"];
            _topic              = [dict objectForKey:@"topic"];
            _ups                = [dict objectForKey:@"ups"];
            _comments           = [dict objectForKey:@"comments"];
            _uped               = [dict objectForKey:@"uped"];
            _create_time        = [dict objectForKey:@"create_time"];
            _x            = [dict objectForKey:@"x"];
            _y            = [dict objectForKey:@"y"];
            _user_id            = [dict objectForKey:@"user_id"];
            _username            = [dict objectForKey:@"username"];
            _avatar            = [dict objectForKey:@"avatar"];
            _verified            = [dict objectForKey:@"verified"];
        }
    }
    return self;
}



@end
