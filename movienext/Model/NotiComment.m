//
//  NotiComment.m
//  movienext
//
//  Created by 杜承玖 on 1/20/15.
//  Copyright (c) 2015 redianying. All rights reserved.
//

#import "NotiComment.h"

@implementation NotiComment

- (id)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if(self){
        if (dict && [dict isKindOfClass:[NSDictionary class]]) {
            _notiId        = [dict objectForKey:@"id"];
            _userId        = [dict objectForKey:@"user_id"];
            _username      = [dict objectForKey:@"username"];
            _avatar        = [dict objectForKey:@"avatar"];
            _create_time   = [dict objectForKey:@"create_time"];
            
            _stage = [[Stage alloc] initWithDictionary:[dict valueForKey:@"stageinfo"] ];
            _weibo = [[Weibo alloc] initWithDictionary:[dict valueForKey:@"weibo"] ];
        }
    }
    return self;
}

@end
