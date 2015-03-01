//
//  Feed.m
//  movienext
//
//  Created by 杜承玖 on 14/11/21.
//  Copyright (c) 2014年 redianying. All rights reserved.
//

#import "Feed.h"

@implementation Feed

- (id)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    if(self){
        if (dict && [dict isKindOfClass:[NSDictionary class]]) {
            _stage = [[Stage alloc] initWithDictionary:[dict valueForKey:@"stageinfo"] ];
            
            _weibo = [[Weibo alloc] initWithDictionary:[dict valueForKey:@"weibo"] ];
            
            _arrayWeibo = [NSMutableArray array];
            NSDictionary *markList = [dict valueForKey:@"weibos"];
            for (NSDictionary *dic in markList) {
                Weibo *mi = [[Weibo alloc] initWithDictionary:dic];
                [_arrayWeibo addObject:mi];
            }
        }
    }
    return self;
}
@end
