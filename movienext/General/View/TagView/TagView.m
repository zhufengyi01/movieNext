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
        [self createUI];
    }
    return self;
}
-(void)createUI
{
    //添加背景图片
    self.tagBgImageview =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0,self.frame.size.width , self.frame.size.height)];
    self.tagBgImageview.backgroundColor = VBlue_color;
    [self addSubview:self.tagBgImageview];
    
    //添加文字
    self.titleLable=[ZCControl createLabelWithFrame:CGRectMake(0,0, 60, 30) Font:TagTextFont14 Text:@"标签"];
    self.titleLable.textColor=[UIColor whiteColor];
    self.titleLable.font =[UIFont systemFontOfSize:TagTextFont14];
    if (IsIphone6plus) {
        self.titleLable.font=[UIFont systemFontOfSize:TagTextFont16];
    }
    self.titleLable.adjustsFontSizeToFitWidth=NO;
    [self.tagBgImageview addSubview:self.titleLable];
    
}
-(void)setTagViewIsClick:(BOOL) isCanClick;
{
 
    if (isCanClick==YES) {
        UITapGestureRecognizer  *tapself =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dealTapSelf:)];
        [self addGestureRecognizer:tapself];

    }
}

//点击本身执行跳转到具有这个标签的剧情
-(void)dealTapSelf:(UITapGestureRecognizer *) tap
{
    if (self.delegete &&[self.delegete respondsToSelector:@selector(TapViewClick:Withweibo:withTagInfo:)]) {
        [self.delegete TapViewClick:self Withweibo:self.weiboInfo withTagInfo:self.tagInfo];
    }
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.tagBgImageview.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.titleLable.frame=CGRectMake(5,0, self.frame.size.width-10,self.frame.size.height);
    
}

@end
