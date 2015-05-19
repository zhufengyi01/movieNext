//
//  Function.h
//  movienext
//
//  Created by 杜承玖 on 14/11/21.
//  Copyright (c) 2014年 redianying. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserDataCenter.h"
#import <UIKit/UIKit.h>

@class User;
@class Weibo;

/*
float getHeightByWidthAndHeight(float width, float height){
    if ( width>0 && height>0 ) {
    }
    return 0.0;
}
 */

/**
 *  功能类
 */
@interface Function : NSObject

/**
 *  保存登录用户
 *
 *  @param user 当前登录成功的用户对象
 */
+ (void) saveUser:(UserDataCenter *)user;

/**
 *  注销用户
 */
+ (void) logoutUser;

/**
 *  得到图片的中间区域的Rect
 *
 *  @param image 图片对象
 *
 *  @return rect
 */
+ (CGRect)getCenterRectFromImage:(UIImage *)image;

/**
 *  得到中间方块的图片
 *
 *  @param superImage 原始图
 *  @param rect       需要裁剪的区域
 *
 *  @return 裁剪后的图片
 */
+ (UIImage *)getImageFromImage:(UIImage*) superImage andRect:(CGRect)rect;

/**
 *  得到友好的时间
 *
 *  @param datetime 需要转换的时间戳
 *
 *  @return 返回友好的时间,例如:刚刚,3分钟前
 */
+ (NSString *)friendlyTime:(NSString *)datetime;

//根据服务器返回的时间戳，返回年月日
+(NSString *)getTimewithInterval:(NSString *)timeIneterval;
//根据传进来的时间戳,返回距离当前时间天，时，分，秒

+(NSString  *)getTimeIntervalfromInerterval:(NSString *) timeInerval;
//返回时分秒
+(NSString *)getHourMinuteTime:(NSString *)timeIneterval;

/**
 *  获取一个微博标签图像,根据标签信息以及位置信息
 *
 *  @param weibo 标签对象
 *  @param x    标签的x坐标
 *  @param y    标签的y坐标
 *
 *  @return 返回生成的标签图片
 */
+ (UIImageView *)getBgvMarkInfo:(Weibo *)weibo x:(CGFloat)x y:(CGFloat)y;

/**
 *  计算字符串的个数,中文算两个,英文算1个
 *
 *  @param s 需要计算文字个数的字符串
 *
 *  @return 返回字符串个数
 */
+ (NSInteger)countWord:(NSString*)s;

/**
 *  获取又拍云图片上传的过期时间
 *
 *  @return 过期时间值,为当前时间+5分钟
 */
+ (NSString *)getUpYunExpirationTime;


+ (NSString *)getNoSpaceAndNewLineString:(NSString *)string;
+ (NSString *)getNoSpace:(NSString *)string;
+ (NSString *)getNoNewLine:(NSString *)string;
//计算字符串高度
//+(CGFloat)heightWithString:(NSString *)string width:(CGFloat)width  fontsize:(CGFloat)fontsize;
//计算字符串的长度
+(CGFloat)widthWithString:(NSString *)string hight:(CGFloat)hight  fontsize:(CGFloat)fontsize;


//根据图片一个view 把这个view按照指定的大小绘画出来
+(UIImage *)getImage:(UIView *) imageview WithSize:(CGSize) size;


//根据一张大的图片，把这个大的图片截取成一张小的图片
+(UIImage *)getImageFromImage:(UIImage *) BigImage;
//进入appdelegate页面时候，根据磁盘信息把磁盘信息复制给usercenter
+(void)getUserInfoWith:(NSDictionary  *) userInfo;
//判断一个字符串为空，或者只有空格的情况
+(BOOL)isBlankString:(NSString *)string;
//动画效果，根据传递进来的view 初始值，时间
+(void)BasicAnimationwithkey:(NSString *)string  Duration:(float) duration repeatcont:(int )repeat autoresverses:(BOOL) resverse fromValue:(float)fromValue toValue:(float)toValue View:(UIView *) view;

//弹出框的动画形式
+(CAKeyframeAnimation *)getKeyframeAni;

//验证输入的是否是邮箱
+(BOOL) validateEmail: (NSString *) candidate;

+(NSString *)htmlString:(NSString *) htmlstring;
//时间转化为当前字符串
+(NSString *)dateToString:(NSDate *)date;
// MD5 加密
+(NSString *)md5:(NSString *)str;
//得到中英文字符混合长度
+(int)getToInt:(NSString*)strtemp;


@end
