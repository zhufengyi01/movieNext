//
//  UploadImageViewController.h
//  movienext
//
//  Created by 风之翼 on 15/3/22.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "RootViewController.h"
#import "StageInfoModel.h"
typedef NS_ENUM(NSInteger, NSUploadImageSourceType)
{
    NSUploadImageSourceTypeDefault,
    NSUploadImageSourceTypeAddCard
};
@interface UploadImageViewController : RootViewController

@property(nonatomic,assign) NSUploadImageSourceType pageTpye;

@property (nonatomic,strong)UIImage   *upimage;
@property(nonatomic,strong) NSString *movie_Id;
@property(nonatomic,strong)NSString *movie_name;
@end
