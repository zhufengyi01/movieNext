//
//  AdmListViewController.h
//  movienext
//
//  Created by 风之翼 on 15/5/21.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "RootViewController.h"


typedef NS_ENUM(NSInteger, ADM_TYPE)
{
    ADM_TYPE_USER,   //用户列表
    ADM_TYPE_EMOJ,    //表情图
    ADM_TYPE_CLOSE_STAGE,  //已屏蔽的剧照
    ADM_TYPE_CLOSE_WEIBO,  //已屏蔽的微博
    ADM_TYPE_NOT_REVIEW,      //未审核
    ADM_TYPE_NEW_ADD,      // 最新添加的微博
    ADM_TYPE_ADM_DESCORVER,   // 发现页
    ADM_TYPE_RECOMMEND,       //热门列表
    ADM_TYPE_TIMING,          //已定时
};
@interface AdmListViewController : RootViewController


@end
