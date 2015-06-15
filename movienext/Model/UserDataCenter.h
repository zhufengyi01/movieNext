//
//  UserDataCenter.h
//  movienext
//
//  Created by 风之翼 on 15/3/1.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDataCenter : NSObject
/**
 *  用户模型
 */
/** 用户ID */
@property (nonatomic, strong) NSString * user_id;
/** 头像 */
@property (nonatomic, strong) NSString * logo;
/** 是否+V */
@property (nonatomic, strong) NSString * verified;
/** 用户名 */
@property (nonatomic, strong) NSString * username;
/** 是否为管理员 1-管理员 0-普通用户 */
//性别
@property (nonatomic, strong) NSString * sex;

//是否是虚拟用户
@property (nonatomic, strong) NSString * fake;


@property (nonatomic, strong) NSString * is_admin;
/** 更新时间 */
//@property (nonatomic, strong) NSString * update_time;
/** 用户签名 */
@property (nonatomic, strong) NSString * signature;
/** 用户的作品被喜欢的总数 */
//@property (nonatomic, strong) NSString * like_count;
/** 用户的作品数量 */
///@property (nonatomic, strong) NSString * product_count;
/** 用户绑定的类型：sina 或 qzone */
//@property (nonatomic, strong) NSString * user_bind_type;

@property (nonatomic,strong) NSString *first_login;
@property(nonatomic,strong) NSString  *email;

@property(nonatomic,strong) NSString *Is_Check;

+(id)shareInstance;

@end
