//
//  UserDataCenter.m
//  movienext
//
//  Created by 风之翼 on 15/3/1.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "UserDataCenter.h"
static UserDataCenter  *manager=nil;
@implementation UserDataCenter
+(id)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        if (manager==nil) {
            manager = [[UserDataCenter alloc]init];
        }
        
    });
    return manager;
}

@end
