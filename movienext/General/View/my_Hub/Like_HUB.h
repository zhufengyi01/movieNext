//
//  Like_HUB.h
//  movienext
//
//  Created by 风之翼 on 15/5/27.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Like_HUB : UIView
{
    NSString *_message;
    UIImage  *_image;
}

@property(nonatomic,strong) UIImageView  *hubimageView;
-(instancetype)initWithTitle:(NSString *)message WithImage:(UIImage *) image;


-(void)show;

@end
