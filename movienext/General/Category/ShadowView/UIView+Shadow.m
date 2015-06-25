//
//  UIView+Shadow.m
//  movienext
//
//  Created by 朱封毅 on 19/06/15.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "UIView+Shadow.h"

@implementation UIView (Shadow)

-(void)setShadow;
{
     UIView  *_layerView =self;
    CAGradientLayer * _gradientLayer = [CAGradientLayer layer];  // 设置渐变效果
    _gradientLayer.bounds = _layerView.bounds;
    _gradientLayer.borderWidth = 0;
    _gradientLayer.frame = _layerView.bounds;
    _gradientLayer.colors = [NSArray arrayWithObjects:
                             (id)[[UIColor clearColor] CGColor],
                             (id)[[UIColor blackColor] CGColor], nil, nil];
    _gradientLayer.startPoint = CGPointMake(0.5, 0.5);
    _gradientLayer.endPoint = CGPointMake(0.5, 1.0);
    [_layerView.layer insertSublayer:_gradientLayer atIndex:0];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
