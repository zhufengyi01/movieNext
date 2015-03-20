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
#import "UMSocial.h"
#import "UMSocialControllerService.h"

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
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeSelf:)];
    [self addGestureRecognizer:tap];
    
    self.backgroundColor=[UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.5];
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

#pragma create four button
    wechatSessionBtn = [ZCControl createButtonWithFrame:CGRectMake(0, kDeviceHeight-80, 80, 80) ImageName:@"" Target:self Action:@selector(shareToWechatSession:) Title:@"微信"];
    [wechatSessionBtn setImage:[UIImage imageNamed:@"Wechat"] forState:UIControlStateNormal];
    //wechatSessionBtn.titleEdgeInsets = UIEdgeInsetsMake(60, 0, 0, 0);
    [self addSubview:wechatSessionBtn];
    
    wechatTimelineBtn = [ZCControl createButtonWithFrame:CGRectMake(kDeviceWidth/4, kDeviceHeight-80, 80, 80) ImageName:@"" Target:self Action:@selector(shareToWechatTimeline:) Title:@"朋友圈"];
    [wechatTimelineBtn setImage:[UIImage imageNamed:@"Moments"] forState:UIControlStateNormal];
    //wechatTimelineBtn.titleEdgeInsets = UIEdgeInsetsMake(60, 0, 0, 0);
    [self addSubview:wechatTimelineBtn];
    
    qzoneBtn = [ZCControl createButtonWithFrame:CGRectMake(kDeviceWidth/4*2, kDeviceHeight-80, 80, 80) ImageName:@"" Target:self Action:@selector(shareToQzone:) Title:@"QQ空间"];
    [qzoneBtn setImage:[UIImage imageNamed:@"Qzone"] forState:UIControlStateNormal];
    //qzoneBtn.titleEdgeInsets = UIEdgeInsetsMake(60, 0, 0, 0);
    [self addSubview:qzoneBtn];
    
    weiboBtn = [ZCControl createButtonWithFrame:CGRectMake(kDeviceWidth/4*3, kDeviceHeight-80, 80, 80) ImageName:@"" Target:self Action:@selector(shareToWeibo:) Title:@"微博"];
    [weiboBtn setImage:[UIImage imageNamed:@"Wechat"] forState:UIControlStateNormal];
    //weiboBtn.titleEdgeInsets = UIEdgeInsetsMake(60, 0, 0, 0);
    [self addSubview:weiboBtn];
}

- (void)shareToWechatSession:(UIButton *)btn {
    
}

- (void)shareToWechatTimeline:(UIButton *)btn {
    
}

- (void)shareToQzone:(UIButton *)btn {
    
}

- (void)shareToWeibo:(UIButton *)btn {
    
}

- (void)removeSelf:(UITapGestureRecognizer *)tap {
    [tap.view removeFromSuperview];
}
-(void)layoutSubviews
{
    
    //需要从新设置mshareimagview的frame
    
    _moviewName.frame=CGRectMake(10,_ShareimageView.frame.size.height-20, 200, 20);
    logoLable.frame=CGRectMake(kDeviceWidth-70, _ShareimageView.frame.size.height-20, 60, 20);

}
@end

