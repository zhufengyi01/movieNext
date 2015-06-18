//
//  StageViewController.h
//  movienext
//
//  Created by 朱封毅 on 18/06/15.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "RootViewController.h"
typedef NS_ENUM(NSInteger, NSStageSourceType)
{
    NSStageSourceTypeDefault   //默认页面进入
    
    
};

@interface StageViewController : RootViewController


#pragma mark  必要传递的参数
//获取页面来源
@property(nonatomic,assign) NSStageSourceType  pageType;

//剧照数组
//@property(nonatomic,strong) NSMutableArray    *StageDataArray;

//微博数组
@property(nonatomic,strong) NSMutableArray     *WeiboDataArray;

@property(nonatomic,strong) NSMutableArray    *upWeiboArray;
//从个人页进入
//@property(nonatomic,strong) NSMutableArray     *UserAddDataArray;

//进来的下边值
@property(nonatomic, assign) NSInteger    indexOfItem;

//从列表进入页面时，上一个列表的页面下表
//@property(nonatomic,assign) NSInteger     page;



@end
