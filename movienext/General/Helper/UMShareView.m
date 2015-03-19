//
//  UMShareView.m
//  movienext
//
//  Created by 风之翼 on 15/3/19.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "UMShareView.h"
#import "ZCControl.h"
#import "Constant.h"
@implementation UMShareView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self= [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}
-(void)createUI
{
    self.backgroundColor=[UIColor blackColor];
    _ShareimageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth,300)];
  //  _ShareimageView.backgroundColor=[UIColor redColor];
    [self addSubview:_ShareimageView];
    
     _moviewName= [ZCControl createLabelWithFrame:CGRectMake(10,_ShareimageView.frame.size.height-20, 200, 20) Font:12 Text:@""];

    _moviewName.textColor=VGray_color;
    [_ShareimageView addSubview:_moviewName];
    
    logoLable=[ZCControl createLabelWithFrame:CGRectMake(kDeviceWidth-70,_ShareimageView.frame.size.height-20, 60, 20) Font:12 Text:@"影弹App"];
    logoLable.textAlignment=NSTextAlignmentRight;
    logoLable.textColor=VGray_color;
    [_ShareimageView addSubview:logoLable];

}
-(void)layoutSubviews
{
    
    //需要从新设置mshareimagview的frame
    
    _moviewName.frame=CGRectMake(10,_ShareimageView.frame.size.height-20, 200, 20);
    logoLable.frame=CGRectMake(kDeviceWidth-70, _ShareimageView.frame.size.height-20, 60, 20);

}
@end

