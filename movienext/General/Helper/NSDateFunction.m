//
//  NSDateFunction.m
//  movienext
//
//  Created by 杜承玖 on 14/11/29.
//  Copyright (c) 2014年 redianying. All rights reserved.
//

#import "NSDateFunction.h"

@implementation NSDateFunction

+ (NSTimeInterval)getCurrentTime{
    return [[NSDate date] timeIntervalSince1970];
}

@end
