//
//  TapStageCollectionViewCell.h
//  movienext
//
//  Created by 风之翼 on 15/4/27.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "stageInfoModel.h"
#import "weiboInfoModel.h"

@interface TapStageCollectionViewCell : UICollectionViewCell
 {
   CGRect   m_frame;
 }
@property(strong,nonatomic)UIImageView *imageView;
@property(strong,nonatomic)UILabel *titleLab;

@end
