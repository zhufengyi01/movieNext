//
//  Comment.m
//  movienext
//
//  Created by 杜承玖 on 14/11/27.
//  Copyright (c) 2014年 redianying. All rights reserved.
//

#import "Comment.h"

@implementation Comment

- (id)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if(self){
        if (dict && [dict isKindOfClass:[NSDictionary class]]) {
            _comment_id         = [dict objectForKey:@"id"];
            _weibo_id           = [dict objectForKey:@"weibo_id"];
            _user_id            = [dict objectForKey:@"user_id"];
            _ups                = [dict objectForKey:@"ups"];
            _body               = [dict objectForKey:@"body"];
            _create_time        = [dict objectForKey:@"create_time"];
            _status             = [dict objectForKey:@"status"];
            _user               = [[User alloc] initWithDictionary:[dict objectForKey:@"userinfo"]];
        }
        
        if ( [_comment_id intValue]<0 ) {
            _comment_id = @"0";
        }
    }
    return self;
}

@end
