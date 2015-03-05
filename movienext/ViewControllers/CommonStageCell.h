//
//  CommonStageCell.h
//  movienext
//
//  Created by 风之翼 on 15/3/3.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarkView.h"
typedef NS_ENUM(NSInteger, NSPageSourceType)
{
    NSPageSourceTypeMainHotController =0,
    NSPageSourceTypeMainNewController=1,
    NSPageSourceTypeMovieViewController=3,
    
};
@interface CommonStageCell : UITableViewCell
{
    UIImageView   *_MovieImageView;
    CGRect        m_frame;
    UIButton      *leftButtomButton;   //左下边按钮
    UIImageView   *MovieLogoImageView;  // 电影的小图片
    UIButton      *ScreenButton;
    UIButton      *addMarkButton;
    UIView        *BgView1;  // 放图片和弹幕的黑色背景图
    UIView        *BgView2;   //放分享的白色背景
    UIView        *BgView0;   //最新顶上的view
    
    //BgView0的子视图
    UIButton  *UserLogoButton;
    UILabel   *UserNameLable;
    UILabel   *TimeLable;
    UIButton  *ZanButton;
 }
@property (nonatomic,strong ) NSMutableArray   *WeibosArray;   //小标签的数组，在多个标签的时候使用这个
@property (nonatomic,strong )NSDictionary      *weiboDict;     //只有一个标签的时候传递这个参数
-(void)setCellValue:(NSDictionary  *) dict indexPath:(NSInteger) row;
@property (nonatomic,assign) NSPageSourceType   pageType;

@end
