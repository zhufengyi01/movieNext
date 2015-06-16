//
//  预览图片
//  DoubanUpImageViewController.h
//  movienext
//
//  Created by 风之翼 on 15/5/7.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "RootViewController.h"
typedef NS_ENUM(NSInteger,NSDoubanSourceType)
{
    
    NSDoubanSourceTypeDefault,
    NSDoubanSourceTypeAddCard
};

@interface DoubanUpImageViewController : RootViewController

@property(nonatomic,assign) NSDoubanSourceType  pageType;

@property (nonatomic,strong) NSString   *movie_id;

@property(nonatomic,strong) NSString  *movie_name;

@property(nonatomic,strong) UIImage     *upimage;

@property(nonatomic,strong) NSString  *photourl;
@end
