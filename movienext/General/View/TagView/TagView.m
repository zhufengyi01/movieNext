//
//  TagView.m
//  movienext
//
//  Created by 风之翼 on 15/4/26.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "TagView.h"
#import "ZCControl.h"
#import "Constant.h"
@implementation TagView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame
{
    if ([super  initWithFrame:frame]) {
        self.layer.cornerRadius=TagViewConrnerRed;
        self.clipsToBounds=YES;
        self.backgroundColor =VBlue_color;
        [self createUI];
    }
    return self;
}
-(void)createUI
{
    self.titleLable=[ZCControl createLabelWithFrame:CGRectMake(0,0, 60, 30) Font:TagTextFont14 Text:@"标签"];
    self.titleLable.textColor=[UIColor whiteColor];
    self.titleLable.adjustsFontSizeToFitWidth=NO;
    [self addSubview:self.titleLable];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.titleLable.frame=CGRectMake(5, 5, self.frame.size.width-10, 20);
    
}

@end
