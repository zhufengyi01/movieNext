//
//  User.m
//  movienext
//
//  Created by 杜承玖 on 14/11/22.
//  Copyright (c) 2014年 redianying. All rights reserved.
//

#import "User.h"
static User   *manager=nil;
@implementation User
+(id)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        if (manager==nil) {
            manager = [[User alloc]init];
        }
        
    });
    return self;
}
- (id)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    if(self){
        if (dict && [dict isKindOfClass:[NSDictionary class]]) {
            _user_id         = [dict valueForKey:@"id"];
            _username       = [dict valueForKey:@"username"];
            _is_admin        = [dict valueForKey:@"level"];
            _avatar         = [dict valueForKey:@"avatar"];
            _verified       = [dict valueForKey:@"verified"];
            _signature      = [dict valueForKey:@"brief"];
            _user_bind_type = [dict valueForKey:@"bind_type"];
            _update_time      = [dict valueForKey:@"update_time"];
            _product_count      = [dict valueForKey:@"product_count"];
            _like_count      = [dict valueForKey:@"uped_count"];
        }
    }
    
    return self;
}

-(NSDictionary *)convertToDictionary{
    NSDictionary *dict = @{
                           @"id":_user_id,
                           @"username":_username,
                           @"level":_is_admin,
                           @"logo":_avatar,
                           @"verified":_verified,
                           @"brief": _signature,
                           @"bind_type":_user_bind_type,
                           @"update_time":_update_time
                           };
    return dict;
}

- (NSString *)description{
    return [NSString stringWithFormat:@"user_id = %@, username = %@, is_admin = %@, avatar = %@, signature = %@, user_bind_type = %@, update_time = %@", _user_id, _username, _is_admin, _avatar, _signature, _user_bind_type, _update_time];
}


@end
