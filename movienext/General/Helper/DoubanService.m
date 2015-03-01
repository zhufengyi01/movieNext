//
//  DoubanService.m
//  movienext
//
//  Created by 杜承玖 on 14/9/22.
//  Copyright (c) 2014年 com.redianying. All rights reserved.
//

#import "DoubanService.h"
#import "DoubanInfo.h"
static DoubanService * doubanService = nil;

@implementation DoubanService

+(DoubanService *)shareInstance{
    if (!doubanService) {
        doubanService = [[DoubanService alloc] init];
    }
    return doubanService;
}

- (NSMutableArray *)getDoubanInfosByResponse:(NSString *)responseString {
    NSString            * pattern = @"<a class=\"nbg\" href=\"http://movie\\.douban\\.com/subject/(\\d+)/\".*>\n.*<img src=\"(.*)\" alt=\"(.*?)\".*?/>";
    NSMutableArray      * doubanInfos = [NSMutableArray array];
    NSRegularExpression * regular = [[NSRegularExpression alloc] initWithPattern:pattern
                                                                        options:NSRegularExpressionUseUnixLineSeparators
                                                                          error:nil];
    NSArray *array = [regular matchesInString:responseString options:0 range:NSMakeRange(0, [responseString length])];
    if (array.count<=0) {
        return doubanInfos;
    }
    
    for (NSTextCheckingResult* b in array)
    {
        NSString *doubanId = [responseString substringWithRange:[b rangeAtIndex:1]];
        NSString *movieName = [responseString substringWithRange:[b rangeAtIndex:3]];
        NSString *smallImage = [responseString substringWithRange:[b rangeAtIndex:2]];
        
        DoubanInfo * di = [[DoubanInfo alloc] init];
        di.doubanId     = doubanId;
        di.title        = movieName;
        di.smallImage   = smallImage;
      
        [doubanInfos addObject:di];
    }
    return doubanInfos;
}

@end
