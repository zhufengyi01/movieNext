//
//  Function.m
//  movienext
//
//  Created by 杜承玖 on 14/11/21.
//  Copyright (c) 2014年 redianying. All rights reserved.
//

#import "Function.h"
//导入用户模型
#import "User.h"
#import "UserDataCenter.h"
//导入微博模型
#import "Weibo.h"
//导入标签模型
#import "Mark.h"
//导入图片加载框架
#import "UIImageView+WebCache.h"
//导入常量头文件
#import "Constant.h"


@implementation Function

+ (void) saveUser:(UserDataCenter *)user
{

    NSDictionary *dict = @{
                           @"id":user.user_id,
                           @"username":user.username,
                           @"level":user.is_admin,
                           @"avatar":user.avatar,
                           @"brief":user.signature,
                           @"update_time":user.update_time,
                           @"bind_type":user.user_bind_type
                           };
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserKey];
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:kUserKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
+ (void) logoutUser {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (CGRect)getCenterRectFromImage:(UIImage *)image{
    int w = image.size.width;
    int h = image.size.height;
    int x = 0;
    int y = 0;
    int width = 0;
    if ( w>h ) {
        width = h;
        x = (w - h ) / 2;
        y = 0;
    } else if( h>w ) {
        width = w;
        x = 0;
        y = (h - w) / 2;
    } else {
        width = w;
        x = 0;
        y = 0;
    }
    return CGRectMake(x, y, width, width);
}

+ (UIImage *)getImageFromImage:(UIImage*) superImage andRect:(CGRect)rect {
    CGSize subImageSize = CGSizeMake(rect.size.width, rect.size.height); //定义裁剪的区域相对于原图片的位置
    CGRect subImageRect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    CGImageRef imageRef = superImage.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, subImageRect);
    UIGraphicsBeginImageContext(subImageSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, subImageRect, subImageRef);
    UIImage* subImage = [UIImage imageWithCGImage:subImageRef]; UIGraphicsEndImageContext(); //返回裁剪的部分图像
    return subImage;
}

+ (NSString *)friendlyTime:(NSString *)datetime {
    time_t current_time = time(NULL);
    [NSTimeZone setDefaultTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC+8"]];
    static NSDateFormatter *dateFormatter =nil;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    }
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[datetime intValue]];
    
    time_t this_time = [date timeIntervalSince1970];
    
    time_t delta = current_time - this_time;
    
    if (delta <= 0) {
        return @"刚刚";
    }
    else if (delta <60)
        return [NSString stringWithFormat:@"%ld秒前", delta];
    else if (delta <3600)
        return [NSString stringWithFormat:@"%ld分前", delta /60];
    else if (delta < 86400)
        return [NSString stringWithFormat:@"%ld时前", delta / 60 / 60];
    else if (delta < 518400)
        return [NSString stringWithFormat:@"%ld天前", delta / 60 / 60 / 24];
    else {
        struct tm tm_now, tm_in;
        localtime_r(&current_time, &tm_now);
        localtime_r(&this_time, &tm_in);
        NSString *format = nil;
        
        format = @"%m-%-d";
        
        char buf[256] = {0};
        strftime(buf, sizeof(buf), [format UTF8String], &tm_in);
        return [NSString stringWithUTF8String:buf];
    }
}


/**
 *  标签视图
 *
 *  @param mi 标签信息
 *  @param x  标签的x位置
 *  @param y  标签的y位置
 *
 *  @return 带有背影图片的标签内容
 */
+ (UIImageView *)getBgvMarkInfo:(Weibo *)weibo x:(CGFloat)x y:(CGFloat)y{
    int wordLimit   = 10;
    int widthLimit  = wordLimit*19;
    int margin      = 8;
    int marginHead  = 12;
    int height      = 20;
    int logoWidth   = height;
    BOOL isLong;
    
    UIFont *font = [UIFont systemFontOfSize:12];
    NSString *aString = weibo.topic.length > wordLimit ? [weibo.topic substringToIndex:wordLimit] : weibo.topic;
    aString = [aString length]>0 ? [NSString stringWithFormat:@"    %@  ", aString] : @"";
    
    if ( aString.length>0 ) {
        CGSize titleSize = [aString sizeWithFont:font constrainedToSize:CGSizeMake(MAXFLOAT, height)];
        int width = titleSize.width;
        if ( width>=widthLimit ) {
            width = widthLimit;
            isLong = YES;
        } else {
            isLong = NO;
        }
        int imgWidth = width + margin + marginHead + logoWidth;
        
        CGRect bgvFrame;
        CGRect lblFrame;
        UIViewContentMode mode;
        //判断点的位置
        if ( x<(width+margin+marginHead) ) {//显示在右边的
            //x -= 5;
            bgvFrame = CGRectMake(x+imgWidth, y, imgWidth, height);
            lblFrame = CGRectMake(logoWidth-10, 0, width, height);
            mode = UIViewContentModeLeft;
        } else {//显示在左边的
            //x += 5;
            bgvFrame = CGRectMake(x - width - margin - marginHead, y, imgWidth, height);
            lblFrame = CGRectMake(logoWidth-10, 0, width, height);
            mode = UIViewContentModeRight;
        }
        
        UIImageView *bgv = [[UIImageView alloc] init];
        bgv.frame = bgvFrame;
        bgv.contentMode = mode;
        bgv.layer.masksToBounds = YES;
        bgv.layer.cornerRadius = 5;
        
        UILabel *lbl = [[UILabel alloc] initWithFrame:lblFrame];
        lbl.lineBreakMode = isLong ? NSLineBreakByTruncatingTail : NSLineBreakByCharWrapping;
        lbl.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.5];
        lbl.layer.masksToBounds = YES;
        lbl.layer.cornerRadius = height*0.5;
        [lbl setFont:font];
        [lbl setText:aString];
        [lbl setTextColor:[UIColor whiteColor]];
        [bgv addSubview:lbl];
        
        UIImageView *ivLogo = [[UIImageView alloc] init];
        ivLogo.frame = CGRectMake(0, 0, logoWidth, logoWidth);
        ivLogo.layer.masksToBounds = YES;
        ivLogo.layer.cornerRadius = logoWidth*0.5;
        ivLogo.alpha = 0.8;
        [ivLogo sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kUrlAvatar, weibo.avatar]]];
        [bgv addSubview:ivLogo];
        
        int ivVerifiedHeight = 8;
        UIImageView *ivVerified = [[UIImageView alloc] initWithFrame:CGRectMake(logoWidth-ivVerifiedHeight, logoWidth-ivVerifiedHeight, ivVerifiedHeight, ivVerifiedHeight)];
        ivVerified.image = [UIImage imageNamed:@"verified"];
        ivVerified.hidden = [weibo.verified intValue]==0;
        ivVerified.alpha = 0.8;
        [bgv addSubview:ivVerified];
        
        return bgv;
    }
    return nil;
}

+ (NSInteger)countWord:(NSString*)s
{
    NSInteger i,n=[s length],l=0,a=0,b=0;
    unichar c;
    
    for(i=0;i<n;i++){
        c=[s characterAtIndex:i];
        if(isblank(c)){
            b++;
        }else if(isascii(c)){
            a++;
        }else{
            l++;
        }
    }
    
    if(a==0 && l==0) return 0;
    
    return l+(NSInteger)ceilf((CGFloat)(a+b)/2.0);
}

+ (NSString *)getUpYunExpirationTime {
    long long int currentTime = [[NSDate date] timeIntervalSince1970] + 5*60;
    return [NSString stringWithFormat:@"%lld", currentTime];
}

//字符串相关的函数

+ (NSString *)getNoSpaceAndNewLineString:(NSString *)string{
    NSRegularExpression *regular = [[NSRegularExpression alloc] initWithPattern:@"\r\n{1,}"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];
    string = [regular stringByReplacingMatchesInString:string options:NSRegularExpressionCaseInsensitive  range:NSMakeRange(0, [string length]) withTemplate:@""];
    regular = [[NSRegularExpression alloc] initWithPattern:@"[ 　]{2,}"
                                                   options:NSRegularExpressionCaseInsensitive
                                                     error:nil];
    string = [regular stringByReplacingMatchesInString:string options:NSRegularExpressionCaseInsensitive  range:NSMakeRange(0, [string length]) withTemplate:@" / "];
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
        return string;
}
+ (NSString *)getNoSpace:(NSString *)string{
    NSRegularExpression * regular = [[NSRegularExpression alloc] initWithPattern:@"[ 　]{1,}"
                                                   options:NSRegularExpressionCaseInsensitive
                                                     error:nil];
    string = [regular stringByReplacingMatchesInString:string options:NSRegularExpressionCaseInsensitive  range:NSMakeRange(0, [string length]) withTemplate:@""];
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
    return string;
}
+ (NSString *)getNoNewLine:(NSString *)string{
    NSRegularExpression * regular = [[NSRegularExpression alloc] initWithPattern:@"[ 　]{2,}"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil];
    string = [regular stringByReplacingMatchesInString:string options:NSRegularExpressionCaseInsensitive  range:NSMakeRange(0, [string length]) withTemplate:@""];
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
    return string;
}
//计算字符串高度

-(CGFloat)heightWithString:(NSString *)string width:(CGFloat)width  fontsize:(CGFloat)fontsize
{
    
    CGRect Rect=[string boundingRectWithSize:CGSizeMake(width, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontsize]} context:nil];
    
    //float imageSmallHight=0;
    return Rect.size.height;
}
+(CGFloat)widthWithString:(NSString *)string hight:(CGFloat)hight  fontsize:(CGFloat)fontsize;
{
    CGRect Rect=[string boundingRectWithSize:CGSizeMake(hight, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontsize]} context:nil];
    
    //float imageSmallHight=0;
    return Rect.size.width;
}
#pragma mark  图片的处理方法

//根据view 把view 变成一张图片
+(UIImage *)getImage:(UIImageView *) imageview
{
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(kDeviceWidth, kDeviceWidth), YES, 1.0);  //NO，YES 控制是否透明
    [imageview.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    // 生成后的image
    
    return image;
}

// 根据给定得图片，从其指定区域截取一张新得图片
+(UIImage *)getImageFromImage:(UIImage *) BigImage
{
    //大图bigImage
    //定义myImageRect，截图的区域
    CGRect myImageRect = CGRectMake(70, 10, 150, 150);
    UIImage* bigImage=BigImage; //[UIImage imageNamed:@"mm.jpg"];
    CGImageRef imageRef = bigImage.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, myImageRect);
    CGSize size;
    size.width = 150;
    size.height = 150;
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, myImageRect, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    return smallImage;
}


@end
