//
//  MyViewController.h
//  movienext
//
//  Created by 风之翼 on 15/2/27.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonStageCell.h"
typedef NS_ENUM(NSInteger,NSMyPageType)
{
    NSMyPageTypeMySelfController,  //自己的中心进来
    NSMyPageTypeOthersController   ///别人的页面进来
};

@interface MyViewController : UIViewController

@property(nonatomic,assign) NSMyPageType   pageType; //区别自己还是别人

@property (nonatomic, strong) NSString * author_id;//当前正在查看的作者ID


@property(nonatomic,strong)UICollectionView  *myConllectionView;

@property(nonatomic,strong)     NSMutableArray    *addedDataArray;

@property(nonatomic,strong)     NSMutableArray    *upedDataArray;

@property(nonatomic,strong) NSMutableDictionary  *buttonStateDict;

@end
