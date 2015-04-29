//
//  TagToStageViewController.h
//  movienext
//
//  Created by 风之翼 on 15/4/27.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "RootViewController.h"

#import "weiboInfoModel.h"

#import "TagView.h"
#import "TagModel.h"

@interface TagToStageViewController : RootViewController  <TagViewDelegate>
////私有的
//@property(nonatomic,strong)UICollectionView  *myConllectionView;
//@property(nonatomic,strong) NSMutableArray      *dataArray;
//
//
//
//公开的
@property (nonatomic,strong) weiboInfoModel  *weiboInfo;
@property(nonatomic,strong) TagModel   *tagInfo;

@end
