//
//  ChangeUsernameViewController.h
//  movienext
//
//  Created by 风之翼 on 15/4/3.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol changeUserNameDelegate <NSObject>

-(void)changeUserName:(NSString *) userName;

@end
@interface ChangeUsernameViewController : UIViewController
@property (assign,nonatomic)id <changeUserNameDelegate> delegate;
@end
