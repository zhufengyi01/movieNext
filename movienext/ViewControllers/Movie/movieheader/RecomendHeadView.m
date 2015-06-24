//
//  RecomendHeadView.m
//  movienext
//
//  Created by 朱封毅 on 23/06/15.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "RecomendHeadView.h"
#import "ZCControl.h"
#import "Constant.h"
@implementation RecomendHeadView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self= [super initWithFrame:frame]) {
       // self.backgroundColor =[UIColor redColor];
        [self createUI];
    }
    return self;
}
-(void)createUI
{
  
    self.timeLable =[ZCControl createLabelWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) Font:14 Text:@"2015-06-24"];
    self.timeLable.textColor=VBlue_color;
    self.timeLable.textAlignment=NSTextAlignmentCenter;
    [self addSubview:self.timeLable];
}
@end
