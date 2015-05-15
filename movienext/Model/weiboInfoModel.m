//
//  weiboInfoModel.m
//  movienext
//
//  Created by 风之翼 on 15/4/10.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "weiboInfoModel.h"

@implementation weiboInfoModel

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"Id" : @"id",
             @"movieInfo" : @"movie",
             @"tagArray":@"tags",
             @"uerInfo":@"user",
             };
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
@end
