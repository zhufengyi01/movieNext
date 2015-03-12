//
//  ButtomToolView.m
//  movienext
//
//  Created by 风之翼 on 15/3/11.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "ButtomToolView.h"
#import "Constant.h"
#import "ZCControl.h"
#import "UIButton+WebCache.h"
@implementation ButtomToolView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self =[super initWithFrame:frame]) {
        [self creatUI];
    }
    return self;
}
-(void)creatUI
{
    self.backgroundColor = VBlue_color;
    self.userInteractionEnabled=YES;
    headButton=[UIButton buttonWithType:UIButtonTypeCustom];
    headButton.frame=CGRectMake(10, 7, 25, 30);
    headButton.layer.cornerRadius=5;
    headButton.clipsToBounds=YES;
    headButton.backgroundColor=[UIColor redColor];
    [headButton addTarget:self action:@selector(dealButtomClick:) forControlEvents:UIControlEventTouchDragInside];
    headButton.tag=10000;
    [self addSubview:headButton];
    
    nameLable =[ZCControl createLabelWithFrame:CGRectMake(headButton.frame.origin.x+headButton.frame.size.width+10, 10,100, 20) Font:14 Text:@"名字"];
    nameLable.textColor=[UIColor whiteColor];
    [self addSubview:nameLable];

    
    
    shareButton =[ZCControl createButtonWithFrame:CGRectMake(kDeviceWidth-125,10,60,25) ImageName:@"screen_shot share.png" Target:self Action:@selector(dealButtomClick:) Title:@""];
    shareButton.tag=10001;
    [self addSubview:shareButton];
    
    zanbutton =[ZCControl createButtonWithFrame:CGRectMake(kDeviceWidth-55, 10, 45, 25) ImageName:@"like.png" Target:self Action:@selector(dealButtomClick:) Title:@""];
    zanbutton.tag=10002;
    [zanbutton setBackgroundImage:[UIImage imageNamed:@"liked.png"] forState:UIControlStateSelected];
    [self addSubview:zanbutton];

    
}
// 设置toolbar 的值
-(void)setToolBarValue:(NSDictionary  *) dict :(id) markView;
{
    //把字典传过来，然后通过代理再传出去
    _weiboDict=dict;
    
    _markView=markView;
    [ headButton sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@!thumb", kUrlAvatar, [dict objectForKey:@"avatar"]]] forState:UIControlStateNormal placeholderImage:nil];
    nameLable.text=[NSString stringWithFormat:@"%@",[dict objectForKey:@"username"]];
    
}
-(void)dealButtomClick:(UIButton  *) button
{
    
    if (self.delegete &&[self.delegete respondsToSelector:@selector(ToolViewHandClick::weiboDict:)]) {
        [self.delegete  ToolViewHandClick:button :_markView weiboDict:_weiboDict];
    }
}
@end
