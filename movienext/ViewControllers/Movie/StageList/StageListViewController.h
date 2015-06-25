//
//  StageListViewController.h
//  movienext
//
//  Created by 朱封毅 on 24/06/15.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "RootViewController.h"
#import "TagModel.h"
typedef NS_ENUM(NSInteger, NSStageListpageSoureType)
{
    NSStageListpageSoureTypeDefault,
    NSStageListpageSoureTypeTagToStage, // 标签对应的剧照
    
};

@interface StageListViewController : RootViewController
@property(nonatomic,assign)NSStageListpageSoureType  pageType;
@property(nonatomic,strong)UICollectionView     *myConllectionView;
@property(nonatomic,strong) NSMutableArray      *dataArray;
@property(nonatomic,strong) NSString *movie_id;
@property(nonatomic,strong)NSString *douban_id;
@property(nonatomic,strong)NSString *movielogo;
@property(nonatomic,strong)NSString *moviename;

//标签到剧照
@property(nonatomic,strong) TagModel  *tagInfo; //标签对象，从点击标签处传入

@end
