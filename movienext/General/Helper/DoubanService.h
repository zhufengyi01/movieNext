//
//  DoubanService.h
//  movienext
//
//  Created by 杜承玖 on 14/9/22.
//  Copyright (c) 2014年 com.redianying. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DoubanService : NSObject
+(DoubanService *)shareInstance;

//正则匹配豆瓣电影信息
- (NSMutableArray *)getDoubanInfosByResponse:(NSString *)responseString;

@end
