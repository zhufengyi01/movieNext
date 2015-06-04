//
//  MyViewController.h
//  movienext
//
//  Created by 风之翼 on 15/2/27.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonStageCell.h"
/*typedef NS_ENUM(NSInteger,NSUserCente)
{
    NSUserPageTypeMySelfController=100,
    NSUserPageTypeOthersController=101,
};
*/
@interface MyViewController : UIViewController

@property (nonatomic, strong) NSString * author_id;//当前正在查看的作者ID


@property(nonatomic,strong)UICollectionView  *myConllectionView;

@property(nonatomic,strong)     NSMutableArray    *addedDataArray;

@property(nonatomic,strong)     NSMutableArray    *upedDataArray;

@property(nonatomic,strong) NSMutableDictionary  *buttonStateDict;

@end
