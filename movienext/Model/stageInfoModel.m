//
//  stageInfoModel.m
//  movienext
//
//  Created by 风之翼 on 15/4/10.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "stageInfoModel.h"

@implementation stageInfoModel
//字典中的id 对应模型中的Id
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"Id" : @"id",
             @"movieInfo" : @"movie",
             @"weibosArray":@"weibos"
             };
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
@end
