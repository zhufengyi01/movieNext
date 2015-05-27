//
//  FindDatailViewController.h
//  movienext
//
//  Created by 风之翼 on 15/5/22.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "RootViewController.h"

#import "weiboInfoModel.h"


@interface FindDatailViewController : RootViewController

@property(nonatomic,strong) weiboInfoModel  *weiboInfo;

@property(nonatomic,strong) NSString *index;

-(void)shareButtonClick;
@end
