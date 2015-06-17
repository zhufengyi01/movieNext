//
//  MyButton.m
//  movienext
//
//  Created by 杜承玖 on 6/3/15.
//  Copyright (c) 2015 redianying. All rights reserved.
//

#import "MyButton.h"
#import "Constant.h"

@interface MyButton ()
{
    CGRect boundingRect;
}
@end

@implementation MyButton

-(void)setFrame:(CGRect)frame ImageName:(NSString*)imageName Target:(id)target Action:(SEL)action Title:(NSString*)title Font:(CGFloat)font
{
    self.frame = frame;
    [self setTitle:title forState:UIControlStateNormal];
    //设置背景图片，可以使文字与图片共存
    [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [self.titleLabel setFont:[UIFont systemFontOfSize:font]];
    boundingRect=[self.titleLabel.text boundingRectWithSize:CGSizeMake(frame.size.width, font) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGFloat width = IsIphone6plus || IsIphone6 ? 40 : 30;
    CGFloat imageX=(self.frame.size.width-width)/2;
    CGFloat imageY=0;
    CGFloat height=width;
    return CGRectMake(imageX, imageY, width, height);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGFloat imageX=(self.frame.size.width-boundingRect.size.width)/2;
    CGFloat imageY=contentRect.origin.y+self.imageView.bounds.size.height;
    CGFloat width=self.frame.size.width;
    CGFloat height=25;
    return CGRectMake(imageX, imageY, width, height);
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
