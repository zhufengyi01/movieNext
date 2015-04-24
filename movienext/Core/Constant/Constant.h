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
//#define kApiBaseUrl @"http://182.92.214.199"
#define kApiBaseUrl  @"http://api.ying233.com"
 
#define kUrlWeibo @"http://next-weibo.b0.upaiyun.com/"
#define kUrlAvatar @"http://next-avatar.b0.upaiyun.com/"   
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
#define IsIphone6            [UIScreen mainScreen].bounds.size.height>700

#define kHeightNavigation 64
#define kHeigthTabBar     49
#define kMarkWidth 22
#define BUTTON_HEIGHT 50
#define MARGIN_BOTTOM 30

#pragma  mark  三方平台key  设置
#define kUmengKey @"53e9e548fd98c5e4a90017c6"
#define SSOSinRedirectURL  @"http://sns.whalecloud.com/sina2/callback"
#define weiChatShareKey  @"wxf2ee2163c0aceaa0"
#define weiChatShareSecret @"ce1e16a6fa8b594e614eda18903cd22c"


#define   Review   0   ///上传appstore版本  1 为审核
#pragma  mark 颜色设置
#define kAppTintColor [UIColor colorWithRed:0.0/255.0 green:146.0/255.0 blue:255.0/255.0 alpha:1]
//项目背景颜色
#define View_BackGround [UIColor colorWithRed:231.0/255 green:231.0/255 blue:231.0/255 alpha:1]
#define View_ToolBar   [UIColor colorWithRed:250.0/255 green:250.0/255 blue:250.0/255 alpha:1]
//tabbar 上面的一根线
#define tabBar_line   [UIColor colorWithRed:220.0/255 green:220.0/255 blue:220.0/255 alpha:1]

//字体浅灰色
#define VLight_GrayColor [UIColor colorWithRed:188.0/255 green:188.0/255 blue:188.0/255 alpha:1]
//字体深灰色
#define VGray_color      [UIColor colorWithRed:127.0/255 green:127.0/255 blue:139.0/255 alpha:1]
//字体蓝色
#define VBlue_color [UIColor colorWithRed:0/255 green:146.0/255 blue:255.0/255 alpha:1]
#define VStageView_color [UIColor colorWithRed:23.0/255 green:23.0/255 blue:23.0/255 alpha:1]
//头像占位图片
#define HeadImagePlaceholder  [UIImage imageNamed:@"notice_image headloading.png"]

#define GetAppDelegate()   ((AppDelegate*)[[UIApplication sharedApplication] delegate])

#define AppView  [UIApplication sharedApplication].delegate.window.rootViewController.view

//动画定义
#define  kTimeInterval  1.1   //  气泡和气泡之间动画出现的时间间隔
#define kStaticTimeOffset  5.7  //动画的停留时间
#define kShowTimeOffset 0.5  // 淡入时间
#define kHidenTimeOffset 0.7  //淡出时间
#define KappearTime    3     //最新页面的自身闪烁动画时间
#define kdisplayTime   1.0     //滑动cell 动画延时的时间
#define kalpaOneTime 0.6      //动画全部弹出透明度变成1的那段时间
#define kalpaZeroTime  0.3    //动画全部弹出后然后变成透明度为0的那段时间

#define kUserKey @"userinfo"  ///用户信息

#define  kWeiChatKey  wxf2ee2163c0aceaa0
#define  kWeiChatSecret ce1e16a6fa8b594e614eda18903cd22c
//weibo  MarkView大小控制
//坐标图片的大小控制

//右边字体的大小控制
#define MarkTextFont14  14
#define MarkTextFont16  16
#define MarkViewCornerRed 6
#endif
