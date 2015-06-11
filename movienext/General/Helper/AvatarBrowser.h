//
//  AvatarBrowser.h
//  movienext
//
//  Created by 杜承玖 on 6/11/15.
//  Copyright (c) 2015 redianying. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AvatarBrowser : NSObject
+(void)showImage:(UIImageView *)avatarImageView;
+(void)hideImage:(UITapGestureRecognizer*)tap;
@end
