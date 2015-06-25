//
//  SmallImageCollectionViewCell.h
//  movienext
//
//  Created by 风之翼 on 15/3/7.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "weiboInfoModel.h"

//typedef NS_ENUM(NSInteger,NSSmallCellPage)
//{
//    NSSmallCellPageMovieDetail =100,
//    NSSmallCellPageSelectPhoto  =101,
//};

@interface SmallImageCollectionViewCell : UICollectionViewCell
{
    CGRect   m_frame;
}

@property(strong,nonatomic)UIImageView *imageView;
@property(strong,nonatomic)UILabel *titleLab;
@property(strong,nonatomic)UIImageView *ivAvatar;
@property(strong,nonatomic)UIImageView *ivLike;
@property(strong,nonatomic)UILabel *lblTime;
@property(strong,nonatomic)UILabel *lblLikeCount;
@property(strong,nonatomic)weiboInfoModel *weiboInfo;
@property(strong,nonatomic)UILabel  *platformlbl;

@end
