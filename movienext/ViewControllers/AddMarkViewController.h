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
typedef NS_ENUM(NSInteger,NSAddMarkPageSource)
{
    NSAddMarkPageSourceDefault,
    NSAddMarkPageSourceUploadImage,
};

@interface AddMarkViewController : RootViewController
{
    StageView *stageView;
}
@property(assign,nonatomic) NSAddMarkPageSource  pageSoureType;
@property (nonatomic, strong) StageInfoModel  *stageInfoDict;

@end
