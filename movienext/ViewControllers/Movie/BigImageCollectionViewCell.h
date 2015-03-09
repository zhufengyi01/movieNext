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

@interface BigImageCollectionViewCell : UICollectionViewCell
{
    CGRect        m_frame;
    UIButton      *ScreenButton;  //分享
    UIButton      *addMarkButton;
    UIView        *BgView2;        //放分享的白色背景
    

}
@property (nonatomic,strong) StageView          *StageView;     //放图片和弹幕的黑色背景图
@property (nonatomic,strong) NSMutableArray     *WeibosArray;   //小标签的数组，在多个标签的时候使用这个
@property (nonatomic,strong) NSDictionary       *weiboDict;     //只有一个标签的时候传递这个参数

-(void)setCellValue:(NSDictionary  *) dict indexPath:(NSInteger) row;


@end
