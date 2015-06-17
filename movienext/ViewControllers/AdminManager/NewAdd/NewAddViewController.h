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
    NSNewAddPageSoureTypeNewList,  //最新添加
    NSNewAddPageSoureTypeCloseWeiboList,  //已屏蔽的微博列表
    NSNewAddPageSoureTypeDecorver,   //发现
    NSNewAddPageSoureTypeRecommed,   //推荐列表
    NSNewAddPageSoureTypeTiming,    //已定时
    NSNewAddPageSoureTypeNotReview, //未审核
};



@interface NewAddViewController : RootViewController

@property(nonatomic,strong)UICollectionView  *myConllectionView;

@property(nonatomic,strong) NSMutableArray  *dataArray;


@property(nonatomic,assign) NSNewAddPageSoureType   pageType;  //是最新还是屏蔽列表



@end
