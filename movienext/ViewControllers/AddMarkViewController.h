//
//  添加文字页面
//  AddMarkViewController.h
//  movienext
//
//  Created by 风之翼 on 15/3/9.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "RootViewController.h"
#import "StageView.h"
#import "MarkView.h"
//#import "StageInfoModel.h"
//#import "WeiboModel.h"
#import "stageInfoModel.h"
#import "weiboInfoModel.h"
#import "ModelsModel.h"
#import "AddTagViewController.h"
typedef NS_ENUM(NSInteger,NSAddMarkPageSource)
{
    NSAddMarkPageSourceDefault,
    NSAddMarkPageSourceUploadImage,
    NSAddMarkPageSourceDoubanUploadImage
};
//添加弹幕成功后，返回刷新stageview
@protocol  AddMarkViewControllerDelegate <NSObject>
-(void)AddMarkViewControllerReturn;
@end

@interface AddMarkViewController : RootViewController <AddTagViewControllerDelegate>
{
    StageView *stageView;
}
@property(assign,nonatomic)id<AddMarkViewControllerDelegate> delegate;

@property(assign,nonatomic) NSAddMarkPageSource  pageSoureType;

//剧情信息
@property (nonatomic, strong) stageInfoModel  *stageInfo;


//所有信息
@property(nonatomic,strong) ModelsModel     *model;

//管理员编辑标签的时候必须传递weibo_id

@property(nonatomic,strong)weiboInfoModel *weiboInfo;

@end
