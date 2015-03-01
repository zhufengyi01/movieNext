//
//  Movie.m
//  movienext
//
//  Created by 杜承玖 on 14/11/21.
//  Copyright (c) 2014年 redianying. All rights reserved.
//

#import "Movie.h"

@implementation Movie

- (id)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if(self){
        if (dict && [dict isKindOfClass:[NSDictionary class]]) {
            _movie_id            = [dict objectForKey:@"id"];
            _douban_id           = [dict objectForKey:@"douban_id"];
            _name                = [dict objectForKey:@"name"];
            _type                = [dict objectForKey:@"type"];
            _country             = [dict objectForKey:@"country"];
            _logo                = [dict objectForKey:@"logo"];
            _brief               = [dict objectForKey:@"brief"];
            _director            = [dict objectForKey:@"director"];
            _actors              = [dict objectForKey:@"actors"];
            _scriptwriter        = [dict objectForKey:@"scriptwriter"];
            _release_time        = [dict objectForKey:@"release_time"];
            _other_name          = [dict objectForKey:@"other_name"];
            _imdb                = [dict objectForKey:@"imdb"];
            _duration            = [dict objectForKey:@"duration"];
            _language            = [dict objectForKey:@"language"];
            _if_movie            = [dict objectForKey:@"if_movie"];
            _episodes            = [dict objectForKey:@"episodes"];
            _cover               = [dict objectForKey:@"cover"];
        }
    }
    return self;
}

@end
