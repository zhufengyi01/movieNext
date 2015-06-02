//
//  NewAddViewController.h
//  movienext
//
//  Created by 风之翼 on 15/5/29.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "RootViewController.h"

typedef NS_ENUM(NSInteger, NSNewAddPageSoureType)
{
    NSNewAddPageSoureTypeNewList,
    NSNewAddPageSoureTypeCloseWeiboList
};



@interface NewAddViewController : RootViewController

@property(nonatomic,strong)UICollectionView  *myConllectionView;

@property(nonatomic,strong) NSMutableArray  *dataArray;


@property(nonatomic,assign) NSNewAddPageSoureType   pageType;  //是最新还是屏蔽列表



@end
