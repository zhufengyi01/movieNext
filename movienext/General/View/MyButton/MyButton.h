//
//  MyButton.h
//  movienext
//
//  Created by 杜承玖 on 6/3/15.
//  Copyright (c) 2015 redianying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyButton : UIButton

-(void)setFrame:(CGRect)frame ImageName:(NSString*)imageName Target:(id)target Action:(SEL)action Title:(NSString*)title Font:(CGFloat)font;

@end
