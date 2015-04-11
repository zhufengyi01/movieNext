//
//  ModelsModel.h
//  movienext
//
//  Created by 风之翼 on 15/4/10.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "stageInfoModel.h"
@interface ModelsModel : NSObject
@property(nonatomic,strong) NSString  *Id;
@property(nonatomic,strong) NSString  *stage_id;
@property(nonatomic,strong) stageInfoModel  *stageInfo;

@end
