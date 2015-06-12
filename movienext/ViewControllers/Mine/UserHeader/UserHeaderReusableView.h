//
//  UserHeaderReusableView.h
//  movienext
//
//  Created by 风之翼 on 15/6/2.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "weiboUserInfoModel.h"
#import "UserDataCenter.h"
@protocol UserHeaderReusableViewDelegate  <NSObject>

-(void)changeCollectionHandClick : (UIButton *) btn;


-(void)changeUserHandClick;//长按变身

@end

@interface UserHeaderReusableView : UICollectionReusableView
{
    UIImageView  *ivAvatar;  // 头像
    UserDataCenter  *userCenter;
    UILabel  *lblUsername;
    UILabel *lblCount;
    UILabel *lblZanCout;
    UILabel *lblBrief;   //简介
    NSMutableDictionary  *buttonStateDict;
    UIButton  *addButton;  
    UIButton  *zanButton;
    
}
@property(nonatomic,assign) id <UserHeaderReusableViewDelegate> delegate;
//用户信息
//@property(nonatomic,strong)  weiboUserInfoModel  *userInfomodel;

-(void)setcollectionHeaderViewValueWithUserInfo:(weiboUserInfoModel *) userInfo;

@end
