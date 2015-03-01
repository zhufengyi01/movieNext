//
//  Stage.m
//  movienext
//
//  Created by 杜承玖 on 1/27/15.
//  Copyright (c) 2015 redianying. All rights reserved.
//

#import "Stage.h"

@implementation Stage

- (id)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    if(self){
        if (dict && [dict isKindOfClass:[NSDictionary class]]) {
            _stage_id    = [dict valueForKey:@"id"];
            _stage      = [dict valueForKey:@"stage"];
            _w          = [dict valueForKey:@"w"];
            _h          = [dict valueForKey:@"h"];
            _marks      = [dict valueForKey:@"marks"];
            _movie_id    = [dict valueForKey:@"movie_id"];
            _movie_name  = [dict valueForKey:@"movie_name"];
            _movie_poster = [dict valueForKey:@"movie_poster"];
        }
    }
    return self;
}
@end