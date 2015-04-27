//
//  TagView.h
//  movienext
//
//  Created by 风之翼 on 15/4/26.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "weiboInfoModel.h"
#import "TagModel.h"


@protocol TagViewDelegate <NSObject>

-(void)handTapViewClick:(weiboInfoModel *) weiboInfo withTagInfo:(TagModel *) tagInfo;

@end
@interface TagView : UIView

@property (nonatomic,strong) UILabel  *titleLable;
@property(nonatomic,strong) weiboInfoModel  *weiboInfo;
@property(nonatomic,strong) TagModel   *tagInfo;


@property(nonatomic,strong) id<TagViewDelegate> delegete;
@end
