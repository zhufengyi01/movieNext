//
//  MovieViewController.h
//  movienext
//
//  Created by 风之翼 on 15/2/27.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieViewController : UIViewController
@property(nonatomic,strong)UICollectionView  *myConllectionView;
@property(nonatomic,strong)UICollectionView  *RecommendCollectionView;  //推荐
@property(nonatomic,strong) NSMutableArray      *dataArray0;
@property(nonatomic,strong) NSMutableArray      *dataArray1;
@property(nonatomic,strong) NSMutableArray      *dataArray2;
@property(nonatomic,strong) NSMutableArray      *dataArray3;
@end
