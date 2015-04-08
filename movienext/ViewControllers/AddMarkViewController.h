//
//  AddMarkViewController.h
//  movienext
//
//  Created by 风之翼 on 15/3/9.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "RootViewController.h"
#import "StageView.h"
#import "MarkView.h"
#import "StageInfoModel.h"
#import "WeiboModel.h"
#import "HotMovieModel.h"
typedef NS_ENUM(NSInteger,NSAddMarkPageSource)
{
    NSAddMarkPageSourceDefault,
    NSAddMarkPageSourceUploadImage,
};
//添加弹幕成功后，返回刷新stageview
@protocol  AddMarkViewControllerDelegate <NSObject>
-(void)AddMarkViewControllerReturn;
@end

@interface AddMarkViewController : RootViewController
{
    StageView *stageView;
}
@property(assign,nonatomic)id<AddMarkViewControllerDelegate> delegate;

@property(assign,nonatomic) NSAddMarkPageSource  pageSoureType;
@property (nonatomic, strong) StageInfoModel  *stageInfoDict;

@property (nonatomic,strong) HotMovieModel    *model;

@end
