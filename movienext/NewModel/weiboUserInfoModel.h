//
//  weiboUserInfoModel.h
//  movienext
//
//  Created by 风之翼 on 15/4/10.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface weiboUserInfoModel : NSObject
@property(nonatomic,strong) NSNumber  *Id;

@property(nonatomic,strong) NSString  *username;

@property(nonatomic,strong) NSString  *logo;

@property(nonatomic,strong) NSString  *verified;

@property(nonatomic,strong) NSNumber  *fake;

@property(nonatomic,strong) NSString  *role_id;

@property(nonatomic,strong) NSString  *brief;

@property(nonatomic,strong) NSString  *weibo_count;

@property(nonatomic,strong) NSString  *liked_count;

@property(nonatomic,strong) NSString  *auth_key;


@property(nonatomic,strong) NSString  *password_hash;


@property(nonatomic,strong) NSString  *password_reset_token;


@property(nonatomic,strong) NSString  *email;


@property(nonatomic,strong) NSString  *created_at;


@property(nonatomic,strong) NSString  *updated_at;


@property(nonatomic,strong) NSString  *status;








@end
