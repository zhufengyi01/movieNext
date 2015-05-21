//
//  TagModel.m
//  movienext
//
//  Created by 风之翼 on 15/4/24.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "TagModel.h"

#import "MJExtension.h"
@implementation TagModel
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"Id" : @"id",
             @"tagDetailInfo" : @"tag",
             };
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
@end
