//
//  WeiboModel.h
//  movienext
//
//  Created by 风之翼 on 15/3/14.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeiboModel : NSObject
@property (nonatomic, strong) NSNumber * Id;
@property (nonatomic, strong) NSString * topic;
@property (nonatomic, strong) NSNumber * ups;
@property (nonatomic, strong) NSNumber * comments;
@property (nonatomic, strong) NSNumber * uped;
@property (nonatomic, strong) NSString * create_time;
@property (nonatomic, strong) NSNumber * x;
@property (nonatomic, strong) NSNumber * y;
@property (nonatomic, strong) NSString * user_id;
@property (nonatomic, strong) NSString * username;
@property (nonatomic, strong) NSString * avatar;
@property (nonatomic, strong) NSNumber * verified;
@property(nonatomic,strong) NSNumber  *fake; //是不是虚拟用户

@end
