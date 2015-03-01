//
//  Mark.m
//  movienext
//
//  Created by 杜承玖 on 14/11/26.
//  Copyright (c) 2014年 redianying. All rights reserved.
//

#import "Mark.h"

@implementation Mark

- (id)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if(self){
        if (dict && [dict isKindOfClass:[NSDictionary class]]) {
            _mark_id    = [dict objectForKey:@"id"];
            _user_id    = [dict objectForKey:@"user_id"];
            _stage_id   = [dict objectForKey:@"stage_id"];
            _type       = [dict objectForKey:@"type"];
            _x          = [dict objectForKey:@"x"];
            _y          = [dict objectForKey:@"y"];
            _likes      = [dict objectForKey:@"likes"];
            _comments   = [dict objectForKey:@"comments"];
            _title      = [dict objectForKey:@"title"];
            _external_id    = [dict objectForKey:@"external_id"];
            _create_time    = [dict objectForKey:@"create_time"];
            _content    = [dict objectForKey:@"content"];
        }
    }
    return self;
}

- (NSDictionary *)convertToDictionary{
    return @{
             @"id":_mark_id,
             @"user_id":_user_id,
             @"stage_id":_stage_id,
             @"type":_type,
             @"x":_x,
             @"y":_y,
             @"likes":_likes,
             @"comments":_comments,
             @"title":_title,
             @"external_id":_external_id,
             @"create_time":_create_time,
             @"content":_content
             };
}

@end
