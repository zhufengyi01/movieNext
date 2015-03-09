//
//  Constant.h
//  movienext
//
//  Created by 杜承玖 on 14/11/25.
//  Copyright (c) 2014年 redianying. All rights reserved.
//

#ifndef movienext_Constant_h
#define movienext_Constant_h

#pragma mark   服务器设置
#define kApiBaseUrl @"http://182.92.214.199"

#define kUrlWeibo @"http://next-weibo.b0.upaiyun.com/"
#define kUrlAvatar @"http://next-avatar.b0.upaiyun.com"   
#define kUrlFeed @"http://next-feed.b0.upaiyun.com/"
#define kUrlStage @"http://next-stage.b0.upaiyun.com/"
#define kUrlMoviePoster @"http://next-movieposter.b0.upaiyun.com/"

#define kBucketWeibo @"next-weibo"
#define kBucketStage @"next-stage"
#define kBucketFeed @"next-feed"
#define kBucketAvatar @"next-avatar"

#define kPassCodeWeibo @"QdthYmI7sp/5CsaqdTpYU5t0UrI="


#pragma  mark    宽高设置
#define kDeviceWidth        [UIScreen mainScreen].bounds.size.width
#define kDeviceHeight       [UIScreen mainScreen].bounds.size.height
#define kHeightNavigation 64
#define kHeigthTabBar     49
#define kMarkWidth 22
#define BUTTON_HEIGHT 50
#define MARGIN_BOTTOM 30

#pragma  mark  三方平台key  设置
#define kUmengKey @"53e9e548fd98c5e4a90017c6"
#define SSOSinRedirectURL  @"http://sns.whalecloud.com/sina2/callback"

#pragma  mark 颜色设置
#define kAppTintColor [UIColor colorWithRed:0.0/255.0 green:146.0/255.0 blue:255.0/255.0 alpha:1]
//项目背景颜色
#define View_BackGround [UIColor colorWithRed:231.0/255 green:231.0/255 blue:231.0/255 alpha:1]
#define View_ToolBar   [UIColor colorWithRed:247.0/255 green:247.0/255 blue:247.0/255 alpha:1]


//字体浅灰色
#define VLight_GrayColor [UIColor colorWithRed:188.0/255 green:188.0/255 blue:188.0/255 alpha:1]
//字体深灰色
#define VGray_color      [UIColor colorWithRed:127.0/255 green:127.0/255 blue:139.0/255 alpha:1]
//字体蓝色
#define VBlue_color [UIColor colorWithRed:0/255 green:146.0/255 blue:255.0/255 alpha:1]

#define GetAppDelegate()   ((AppDelegate*)[[UIApplication sharedApplication] delegate])


#define kUserKey @"userinfo"  ///用户信息

#endif
