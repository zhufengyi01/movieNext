//
//  UserHeadChangeViewController.h
//  movienext
//
//  Created by 风之翼 on 15/4/3.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,NSHeadChangePageType)
{
    NSHeadChangePageTypeSetting =100,
    NSHeadChangePageTypeFirstLogin =101
};


@interface UserHeadChangeViewController : UIViewController
@property(nonatomic,assign) NSHeadChangePageType   pageType;
@end
