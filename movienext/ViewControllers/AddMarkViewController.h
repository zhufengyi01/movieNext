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

@interface AddMarkViewController : RootViewController
{
    StageView *stageView;
}
@property (nonatomic, strong) NSDictionary  *stageDict;

@end
