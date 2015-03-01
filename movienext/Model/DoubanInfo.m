//
//  DoubanInfo.m
//  immovie
//
//  Created by Michael Du on 13-10-3.
//  Copyright (c) 2013年 Zhang. All rights reserved.
//

#import "DoubanInfo.h"

@implementation DoubanInfo

- (id)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    if(self){
        if ([dict isKindOfClass:[NSDictionary class]]) {
            _smallImage  = [ [dict valueForKey:@"images"] valueForKey:@"small"];
            _average     = [ [dict valueForKey:@"rating"] valueForKey:@"average"];
          _originalTitle = [ dict valueForKey:@"original_title"];
            _subtype     = [dict valueForKey:@"subtype"];
            _title       = [dict valueForKey:@"title"];
            _doubanId    = [dict valueForKey:@"id"];
          
            if (!_smallImage)
                _smallImage = @"";
            if (!_title)
                _title = @"";
            if (!_originalTitle)
                _originalTitle = @"";
            if (!_average)
                _average = @"0";
            if (!_doubanId)
                _doubanId = @"0";
            if (!_subtype)
                _subtype = @"movie";
        }
    }
    return self;
}

+(DoubanInfo *)getBeanWithDictionary:(NSDictionary *)dic{
    DoubanInfo* bean = [[DoubanInfo alloc] initWithDictionary:dic];
    return bean;
}
- (NSString *)description
{
    return [NSString stringWithFormat:@"title = %@, origin_title = %@, average = %@, doubanid = %@, subtype = %@",
            _title,
            _originalTitle,
            _average,
            _doubanId,
            _subtype];
}

@end
