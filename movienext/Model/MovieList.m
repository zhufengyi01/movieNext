//
//  MovieList.m
//  movienext
//
//  Created by 杜承玖 on 14/11/20.
//  Copyright (c) 2014年 redianying. All rights reserved.
//

#import "MovieList.h"

@implementation MovieList

- (id)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    if(self){
        if (dict && [dict isKindOfClass:[NSDictionary class]]) {
            _feed_id           = [dict valueForKey:@"id"];
            _movie_id          = [dict valueForKey:@"movie_id"];
            _img               = [dict valueForKey:@"picture"];
            _title             = [dict valueForKey:@"title"];
            _create_time       = [dict valueForKey:@"create_time"];
        }
    }

    
    return self;
}
@end
