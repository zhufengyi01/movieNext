//
//  movieInfoModel.m
//  movienext
//
//  Created by 风之翼 on 15/4/10.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "movieInfoModel.h"

@implementation movieInfoModel
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"Id" : @"id",
            };
}


-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
@end
