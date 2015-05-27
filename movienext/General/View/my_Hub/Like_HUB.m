//
//  Like_HUB.m
//  movienext
//
//  Created by 风之翼 on 15/5/27.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "Like_HUB.h"
#import "ZCControl.h"
#import "Constant.h"
@implementation Like_HUB

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithTitle:(NSString *)message WithImage:(UIImage *) image
{
 
    if (self=[super init]) {
        self.frame=CGRectMake(0, 0, kDeviceWidth, kDeviceHeight);
        self.backgroundColor =[[UIColor blackColor] colorWithAlphaComponent:0.01];
        _message=message;
        _image=image;
        [self  createUI];
    }
    return self;
}
-(void)createUI
{
    
    self.hubimageView =[[UIImageView alloc]initWithFrame:CGRectMake((kDeviceWidth-100)/2, (kDeviceHeight-100)/2, 100, 100)];
    self.hubimageView.image = _image;
    self.hubimageView.alpha=0.4;
    [self addSubview:self.hubimageView];
}
-(void)show
{
     [AppView addSubview:self];
    
     [UIView animateWithDuration:0.2 animations:^{
        self.hubimageView.alpha=1;

    } completion:^(BOOL finished) {
        [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.6];
    }];
    
}



@end
