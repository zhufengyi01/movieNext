//
//  netRequest.h
//  movienext
//
//  Created by 风之翼 on 15/4/17.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
@interface netRequest : NSObject
//举报剧情
-(int )requestReportSatgeWithParametes:(NSDictionary *)parameters;
@end
