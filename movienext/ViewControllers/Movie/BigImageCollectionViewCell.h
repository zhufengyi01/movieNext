//
//  BigImageCollectionViewCell.h
//  movienext
//
//  Created by 风之翼 on 15/3/7.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarkView.h"
#import "StageView.h"
#import "weiboInfoModel.h"
#import "stageInfoModel.h"

@protocol  BigImageCollectionViewCellDelegate <NSObject>

-(void)BigImageCollectionViewCellToolButtonClick:(UIButton *) button Rowindex:(NSInteger) index;

@end
@interface BigImageCollectionViewCell : UICollectionViewCell
{
    CGRect        m_frame;
    UIButton   *moreButton;
    UIButton      *ScreenButton;  //分享
    UIButton      *addMarkButton;
    UIImageView        *BgView;
    UIView        *BgView2;        //放分享的白色背景
    UIView        *BgView0;
    UIButton      *_tanlogoButton;

}
@property(assign,nonatomic)id <BigImageCollectionViewCellDelegate> delegate;
@property(assign,nonatomic)NSInteger Cellindex;
@property (nonatomic,strong) StageView          *StageView;     //放图片和弹幕的黑色背景图
@property (nonatomic,strong) NSArray     *weibosArray;   //小标签的数组，在多个标签的时候使用这个
//@property (nonatomic,strong) weiboInfoModel       *weiboinfo;     //只有一个标签的时候传递这个参数

@property(nonatomic,strong) stageInfoModel   *stageInfo;
-(void)ConfigCellWithIndexPath:(NSInteger )row;

@end
