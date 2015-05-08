//
//  DoubanService.m
//  movienext
//
//  Created by 杜承玖 on 14/9/22.
//  Copyright (c) 2014年 com.redianying. All rights reserved.
//

#import "DoubanService.h"
#import "DoubanInfo.h"
static DoubanService * manager = nil;

@implementation DoubanService

+(DoubanService *)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        if (manager==nil) {
            manager = [[DoubanService alloc]init];
        }
    });
    return manager;
    
}
-(NSMutableArray *)getDoubanInfosByResponse:(NSString *)responseString withpattern:(NSString *)patternSting type:(NServiceType)type{
     NSMutableArray      * doubanInfos = [NSMutableArray array];
    NSRegularExpression * regular = [[NSRegularExpression alloc] initWithPattern:patternSting
                                                                        options:NSRegularExpressionUseUnixLineSeparators
                                                                          error:nil];
    NSArray *array = [regular matchesInString:responseString options:0 range:NSMakeRange(0, [responseString length])];
    if (array.count<=0) {
        return doubanInfos;
    }
    
    if (type==NServiceTypeSearch) {
    for (NSTextCheckingResult* b in array)
    {
        NSLog(@"array = %@", array);

        NSString *doubanId = [responseString substringWithRange:[b rangeAtIndex:1]];
        NSString *movieName = [responseString substringWithRange:[b rangeAtIndex:3]];
        NSString *smallImage = [responseString substringWithRange:[b rangeAtIndex:2]];
        
        NSMutableDictionary *di = [NSMutableDictionary dictionary];
        [di setValue:doubanId forKey:@"doubanId"];
        [di setValue:movieName forKey:@"title"];
        [di setValue:smallImage forKey:@"smallimage"];
      
        [doubanInfos addObject:di];
    }
    }
    else if (type==NServiceTypePhoto)
    {
        for (NSTextCheckingResult* b in array)
        {
           NSString  *str1 = [responseString substringWithRange:b.range];
            str1 = [str1 stringByReplacingOccurrencesOfString:@"thumb" withString:@"photo"];//将获取的内容图片地址换成相册图标
            [doubanInfos addObject:str1];
        }
        
    }
    return doubanInfos;
}

@end
