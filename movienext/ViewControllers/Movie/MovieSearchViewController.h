//
//  搜索电影
//  MovieSearchViewController.h
//  movienext
//
//  Created by 风之翼 on 15/3/2.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "RootViewController.h"
typedef NS_ENUM(NSInteger,NSSearchSourceType)
{
    NSSearchSourceTypeMovieList,
    NSSearchSourceTypeAddCard
};

@interface MovieSearchViewController : RootViewController

@property(nonatomic,assign) NSSearchSourceType  pageType;

@end
