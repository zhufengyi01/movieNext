//
//  Topic.m
//  movienext
//
//  Created by 杜承玖 on 14/11/21.
//  Copyright (c) 2014年 redianying. All rights reserved.
//

#import "Topic.h"

@implementation Topic

- (id)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    if(self){
        if (dict && [dict isKindOfClass:[NSDictionary class]]) {
            _topic_id    = [dict valueForKey:@"id"];
            _type       = [dict valueForKey:@"type"];
            _title      = [dict valueForKey:@"title"];
            _logo       = [dict valueForKey:@"logo"];
            _desc       = [dict valueForKey:@"desc"];
        }
    }
    return self;
}

@end
