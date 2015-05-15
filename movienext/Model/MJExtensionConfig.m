//
//  MJExtensionConfig.m
//  MJExtensionExample
//
//  Created by MJ Lee on 15/4/22.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "MJExtensionConfig.h"
#import "MJExtension.h"
#import "ModelsModel.h"
#import "movieInfoModel.h"
#import "stageInfoModel.h"
#import "TagDetailModel.h"
#import "TagModel.h"
#import "UpweiboModel.h"
#import "userAddmodel.h"
#import "weiboInfoModel.h"
#import "weiboUserInfoModel.h"

@implementation MJExtensionConfig
/**
 *  这个方法会在MJExtensionConfig加载进内存时调用一次
 */
+ (void)load
{
    // User类的只有name、icon属性参与字典转模型
//    [User setupAllowedPropertyNames:^NSArray *{
//        return @[@"name", @"icon"];
//    }];
    // 相当于在User.m中实现了+allowedPropertyNames方法
    
    // Bag类中的name属性不参与归档
//    [Bag setupIgnoredCodingPropertyNames:^NSArray *{
//        return @[@"name"];
//    }];
    // 相当于在Bag.m中实现了+ignoredCodingPropertyNames方法
    
    // Bag类中只有price属性参与归档
//    [Bag setupAllowedCodingPropertyNames:^NSArray *{
//        return @[@"price"];
//    }];
    // 相当于在Bag.m中实现了+allowedCodingPropertyNames方法
    
    // StatusResult类中的statuses数组中存放的是Status模型
    // StatusResult类中的ads数组中存放的是Ad模型
//    [StatusResult setupObjectClassInArray:^NSDictionary *{
//        return @{
//                 @"statuses" : @"Status",
//                 @"ads" : @"Ad"
//                 };
//    }];
    [stageInfoModel setupObjectClassInArray:^NSDictionary *{
        return @{
                   @"weibosArray" : @"weibos"
                 };
    }];
    [weiboInfoModel setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"tagArray" : @"tags"
                 };
    }];
    // 相当于在StatusResult.m中实现了+objectClassInArray方法
    
    // Student中的ID属性对应着字典中的id
    // ....
    
    
   /*[Student setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"ID" : @"id",
                 @"desc" : @"desciption",
                 @"oldName" : @"name.oldName",
                 @"nowName" : @"name.newName",
                 @"nameChangedTime" : @"name.info.nameChangedTime",
                 @"bag" : @"other.bag"
                 };
    }];*/
    
    // 相当于在Student.m中实现了+replacedKeyFromPropertyName方法

    //首页最新模型
    [ModelsModel setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"Id" : @"id",
                 @"stageInfo" : @"stage"
                 };
    }];
    //电影信息
    [movieInfoModel setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"Id" : @"id",
                 };
    }];
    [stageInfoModel setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"Id" : @"id",
                 @"movieInfo" : @"movie"
                 };
    }];
    
    [TagDetailModel setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"Id" : @"id"
                 };
    }];
    [TagModel setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"Id" : @"id",
                 @"tagDetailInfo" : @"tag"
                 };
    }];
    [UpweiboModel setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"Id" : @"id"
                 };
    }];
    [userAddmodel setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"Id" : @"id",
                 @"weiboInfo" : @"weibo"
                 };
    }];
    
    [weiboInfoModel setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"Id" : @"id",
                  @"uerInfo": @"user"
                  };
    }];
    
    [weiboUserInfoModel setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"Id" : @"id",
                  };
 
    }];
    
}
@end
