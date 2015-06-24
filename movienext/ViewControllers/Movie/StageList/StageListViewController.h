//
//  StageListViewController.h
//  movienext
//
//  Created by 朱封毅 on 24/06/15.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "RootViewController.h"

typedef NS_ENUM(NSInteger, NSStageListpageSoureType)
{
    NSStageListpageSoureTypeDefault,
    
};

@interface StageListViewController : RootViewController
@property(nonatomic,strong)UICollectionView     *myConllectionView;
@property(nonatomic,strong) NSMutableArray      *dataArray;
@property(nonatomic,strong) NSString *movie_id;
@property(nonatomic,strong)NSString *douban_id;
@property(nonatomic,strong)NSString *movielogo;
@property(nonatomic,strong)NSString *moviename;
@end
