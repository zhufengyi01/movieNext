//
//  TagDetailModel.m
//  movienext
//
//  Created by 风之翼 on 15/4/24.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "TagDetailModel.h"

@implementation TagDetailModel
//字典中的id 对应模型中的Id
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"Id" : @"id",
              };
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
@end
