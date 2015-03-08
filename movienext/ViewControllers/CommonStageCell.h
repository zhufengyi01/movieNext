//
//  CommonStageCell.h
//  movienext
//
//  Created by 风之翼 on 15/3/3.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarkView.h"
#import "StageView.h"

typedef NS_ENUM(NSInteger, NSPageSourceType)
{
    NSPageSourceTypeMainHotController =0,
    NSPageSourceTypeMainNewController=1,
    NSPageSourceTypeMovieViewController=3,
    NSPageSourceTypeMyAddedViewController=4,
    NSPageSourceTypeMyupedViewController=5,
    
};
@interface CommonStageCell : UITableViewCell
{
    CGRect        m_frame;
    UIButton      *leftButtomButton;   //左下边按钮
    UIImageView   *MovieLogoImageView;  // 电影的小图片
    UIButton      *ScreenButton;
    UIButton      *addMarkButton;
    UIView        *BgView2;   //放分享的白色背景
    UIView        *BgView0;   //最新顶上的view
    
    //BgView0的子视图
    UIButton  *UserLogoButton;
    UILabel   *UserNameLable;
    UILabel   *TimeLable;
    UIButton  *ZanButton;
   // NSMutableArray   *_MarkMuatableArray;
 }
@property (nonatomic,strong) StageView          *BgView1;   //放图片和弹幕的黑色背景图
@property (nonatomic,strong) NSMutableArray     *WeibosArray;   //小标签的数组，在多个标签的时候使用这个
@property (nonatomic,strong) NSDictionary       *weiboDict;     //只有一个标签的时候传递这个参数
@property (nonatomic,assign) NSPageSourceType   pageType;

-(void)setCellValue:(NSDictionary  *) dict indexPath:(NSInteger) row;

@end
