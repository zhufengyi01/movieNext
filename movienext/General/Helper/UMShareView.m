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
    self.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.5];
    
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

    
    
    
    
    UIView  *buttomView=[[UIView alloc]initWithFrame:CGRectMake(0, kDeviceHeight- (kDeviceWidth/4+40), kDeviceWidth, kDeviceWidth/4+40)];
    buttomView.backgroundColor=[UIColor whiteColor];
    [self addSubview:buttomView];
    
    UILabel  *shareLable =[ZCControl createLabelWithFrame:CGRectMake(0, 0,kDeviceWidth, 40) Font:14 Text:@"分享给好友"];
    shareLable.textAlignment=NSTextAlignmentCenter;
    shareLable.textColor=VBlue_color;
    [buttomView addSubview:shareLable];
    
    UIView  *lineView1=[[UIView alloc]initWithFrame:CGRectMake(0, 40, kDeviceWidth, 0.5)];
    lineView1.backgroundColor=VLight_GrayColor;
    [buttomView addSubview:lineView1];
    
    UIView  *lineView2=[[UIView alloc]initWithFrame:CGRectMake(0, 40+kDeviceWidth/4-1, kDeviceWidth, 0.5)];
    lineView2.backgroundColor=VLight_GrayColor;
    [buttomView addSubview:lineView2];

    
    
    UIView  *lineView3=[[UIView alloc]initWithFrame:CGRectMake(0,40 ,0.5, kDeviceWidth/4)];
    lineView3.backgroundColor=VLight_GrayColor;
    [buttomView addSubview:lineView3];
    
    UIView  *lineView4=[[UIView alloc]initWithFrame:CGRectMake(kDeviceWidth/4,40 ,0.5, kDeviceWidth/4)];
    lineView4.backgroundColor=VLight_GrayColor;
    [buttomView addSubview:lineView4];
    

    UIView  *lineView5=[[UIView alloc]initWithFrame:CGRectMake(kDeviceWidth/2,40 , 0.5, kDeviceWidth/4)];
    lineView5.backgroundColor=VLight_GrayColor;
    [buttomView addSubview:lineView5];
    
    
    UIView  *lineView6=[[UIView alloc]initWithFrame:CGRectMake((kDeviceWidth/4)*3,40 ,0.5, kDeviceWidth/4)];
    lineView6.backgroundColor=VLight_GrayColor;
    [buttomView addSubview:lineView6];
    
    


#pragma create four button
    wechatSessionBtn = [ZCControl createButtonWithFrame:CGRectMake(0, kDeviceHeight-80, kDeviceWidth/4, kDeviceWidth/4) ImageName:@"" Target:self Action:@selector(handShareButtonClick:) Title:@"微信"];
    [wechatSessionBtn setImage:[UIImage imageNamed:@"Wechat"] forState:UIControlStateNormal];
    wechatSessionBtn.titleEdgeInsets = UIEdgeInsetsMake(65, -30, 10, 10);
    wechatSessionBtn.titleLabel.font=[UIFont systemFontOfSize:12];
    [wechatSessionBtn setTitleColor:VBlue_color forState:UIControlStateNormal];
    [wechatSessionBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 20, 20, 10)];
    wechatSessionBtn.tag=10000;
    [self addSubview:wechatSessionBtn];
    
    wechatTimelineBtn = [ZCControl createButtonWithFrame:CGRectMake(kDeviceWidth/4, kDeviceHeight-80, kDeviceWidth/4, kDeviceWidth/4) ImageName:@"" Target:self Action:@selector(handShareButtonClick:) Title:@"朋友圈"];
    [wechatTimelineBtn setImage:[UIImage imageNamed:@"Moments"] forState:UIControlStateNormal];
    wechatTimelineBtn.titleEdgeInsets = UIEdgeInsetsMake(65, -30, 10, 10);
    wechatTimelineBtn.titleLabel.font=[UIFont systemFontOfSize:12];
    [wechatTimelineBtn setTitleColor:VBlue_color forState:UIControlStateNormal];
    [wechatTimelineBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 20, 20, 10)];
    wechatTimelineBtn.tag=10001;

    [self addSubview:wechatTimelineBtn];
    
    qzoneBtn = [ZCControl createButtonWithFrame:CGRectMake(kDeviceWidth/4*2, kDeviceHeight-80, kDeviceWidth/4, kDeviceWidth/4) ImageName:@"" Target:self Action:@selector(handShareButtonClick:) Title:@"QQ空间"];
    [qzoneBtn setImage:[UIImage imageNamed:@"Qzone"] forState:UIControlStateNormal];
  //  qzoneBtn.titleEdgeInsets = UIEdgeInsetsMake(60, 0, 0, 0);
    //[qzoneBtn setTitleColor:VBlue_color forState:UIControlStateNormal];
    qzoneBtn.titleEdgeInsets = UIEdgeInsetsMake(65, -30, 10, 10);
    qzoneBtn.titleLabel.font=[UIFont systemFontOfSize:12];
    [qzoneBtn setTitleColor:VBlue_color forState:UIControlStateNormal];
    [qzoneBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 20, 20, 10)];
    qzoneBtn.tag=10002;
    [self addSubview:qzoneBtn];
    
    weiboBtn = [ZCControl createButtonWithFrame:CGRectMake(kDeviceWidth/4*3, kDeviceHeight-80, kDeviceWidth/4, kDeviceWidth/4) ImageName:@"" Target:self Action:@selector(handShareButtonClick:) Title:@"微博"];
    [weiboBtn setImage:[UIImage imageNamed:@"Weibo.png"] forState:UIControlStateNormal];
    weiboBtn.titleEdgeInsets = UIEdgeInsetsMake(65, -30, 10, 10);
    weiboBtn.titleLabel.font=[UIFont systemFontOfSize:12];
    [weiboBtn setTitleColor:VBlue_color forState:UIControlStateNormal];
    [weiboBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 20, 20, 10)];
    weiboBtn.tag=10003;
    [self addSubview:weiboBtn];
}
//点击分享
-(void)handShareButtonClick:(UIButton *) button
{
    if (self.delegate &&[self.delegate respondsToSelector:@selector(UMshareViewHandClick:)]) {
        [self.delegate UMshareViewHandClick:button];
    }
    
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

