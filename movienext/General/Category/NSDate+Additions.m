//
//  NSDate+Additions.m
//  movienext
//
//  Created by 杜承玖 on 14/11/30.
//  Copyright (c) 2014年 redianying. All rights reserved.
//

#import "NSDate+Additions.h"

@implementation NSDate (Additions)

+(long long int)getCurrentTimeInterval {
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    long long int date = (long long int)time;
    return date;
}
@end
