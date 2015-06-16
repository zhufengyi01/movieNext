//
//  剧照/截图页面
//  ShowSelectPhotoViewController.h
//  movienext
//
//  Created by 风之翼 on 15/5/7.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "RootViewController.h"
typedef NS_ENUM(NSInteger,NSShowSelectViewSoureType)
{
    NSShowSelectViewSoureTypeDefualt,//默认页面进来
    NSShowSelectViewSoureTypeAddCard  // 卡片页面进来
};
@interface ShowSelectPhotoViewController : RootViewController

@property(nonatomic,assign) NSShowSelectViewSoureType  pageType;

@property (nonatomic,strong) NSString  *douban_id;

@property(nonatomic,strong) NSString  *movie_id;

@property(nonatomic,strong)NSString   *movie_name;

@end
