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
#import "Function.h"

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
        //初始化的大小
        m_frame=frame;
        [self createUI];
    }
    return self;
}
-(void)createUI
{     //创建底部试图
    //创建上部视图
    self.backgroundColor=VStageView_color;
   
     topView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kHeightNavigation)];
      topView.userInteractionEnabled=YES;
     topView.backgroundColor=VStageView_color;
      [self addSubview:topView];
     
    // 上面的透明背景
    UIButton    *_topButtom =[UIButton buttonWithType:UIButtonTypeSystem];
    _topButtom.frame=CGRectMake(0, 0, kDeviceWidth, m_frame.size.height-kHeightNavigation-(kDeviceWidth/4)-40);
    [_topButtom addTarget:self action:@selector(TouchbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
     [topView addSubview:_topButtom];
  
    _ShareimageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth,0)];
    _ShareimageView.backgroundColor=[UIColor whiteColor];
     [topView addSubview:_ShareimageView];
    
    //放置电影名和标签的view
    logosupView=[[UIView alloc]initWithFrame:CGRectMake(0, _ShareimageView.frame.origin.y+_ShareimageView.frame.size.height, kDeviceWidth, 20)];
    logosupView.backgroundColor=VStageView_color;
    [topView addSubview:logosupView];
    
    
     _moviewName= [ZCControl createLabelWithFrame:CGRectMake(10,0, kDeviceWidth-70, 20) Font:12 Text:@""];
    _moviewName.textColor=VLight_GrayColor;
    _moviewName.numberOfLines=0;
    //_moviewName.lineBreakMode=NSLineBreakByTruncatingTail;

    [logosupView addSubview:_moviewName];
    
    logoLable=[ZCControl createLabelWithFrame:CGRectMake(kDeviceWidth-60,0, 50, 20) Font:12 Text:@"影弹App"];
    logoLable.textAlignment=NSTextAlignmentRight;
    logoLable.textColor=VLight_GrayColor;
    [logosupView addSubview:logoLable];
    
    //创建下部视图
    [ self createButtomView];


}
//配置view
-(void)configShareView;
{
      _ShareimageView.image =self.screenImage;
     _moviewName.text=self.StageInfo.movie_name;
//    float hight= kDeviceWidth;
//    float  ImageWith=[self.StageInfo.w intValue];
//    float  ImgeHight=[self.StageInfo.h intValue];
//    if (ImageWith>ImgeHight) {
//        //宽大于高的时候
//        hight=kDeviceWidth;
//    }
//    else
//    {
//        hight=  (ImgeHight/ImageWith) *kDeviceWidth;
//    }
    _ShareimageView.frame=CGRectMake(0, 0,kDeviceWidth, kDeviceWidth);
    logosupView.frame=CGRectMake(0, _ShareimageView.frame.origin.y+_ShareimageView.frame.size.height,kDeviceWidth,20);
    
}

-(void)createButtomView
{

    buttomView=[[UIView alloc]initWithFrame:CGRectMake(0, kDeviceHeight, kDeviceWidth, kDeviceWidth/4+40)];
    buttomView.backgroundColor=[UIColor whiteColor];
    buttomView.userInteractionEnabled=YES;
    [self addSubview:buttomView];
#pragma create four button
    
    NSArray  *imageArray=[NSArray arrayWithObjects:@"wechat_share_icon@2x.png",@"moments_share_icon@2x.png",@"qzone_share_icon@2x.png",@"weibo_share_icon@2x.png", nil];
    
    for (int i=0; i<4; i++) {
        double   x=(kDeviceWidth/4)*i;
        double   y=40;
        
     UIButton  *    btn = [ZCControl createButtonWithFrame:CGRectMake(x,y, kDeviceWidth/4, kDeviceWidth/4) ImageName:imageArray[i] Target:self Action:@selector(handShareButtonClick:) Title:nil];
        btn.tag=10000+i;
        btn.backgroundColor=[UIColor whiteColor];
        [buttomView addSubview:btn];

    }
    
    UILabel  *shareLable =[ZCControl createLabelWithFrame:CGRectMake(0, 0,kDeviceWidth, 40) Font:14 Text:@"分享给好友"];
    shareLable.textAlignment=NSTextAlignmentCenter;
    shareLable.textColor=VBlue_color;
    [buttomView addSubview:shareLable];
    
}



//显示底部试图
-(void)showShareButtomView;
{
    [UIView animateWithDuration:0.5 animations:^{
        CGRect  Bframe=buttomView.frame;
        Bframe.origin.y=m_frame.size.height-kHeightNavigation-(kDeviceWidth/4+40);
        buttomView.frame=Bframe;
    } completion:^(BOOL finished) {
    }];
}
//隐藏底部试图
-(void)HidenShareButtomView;
{
    [UIView animateWithDuration:0.5 animations:^{
        CGRect  Bframe=buttomView.frame;
        Bframe.origin.y=m_frame.size.height-kHeightNavigation;
        buttomView.frame=Bframe;
    } completion:^(BOOL finished) {
        
    }];
}

//点击分享
-(void)handShareButtonClick:(UIButton *) button
{
    shareImage=[Function getImage:topView WithSize:CGSizeMake(kDeviceWidth, kDeviceWidth+20)];
 
    //把topview 生成一张图片
    if (self.delegate &&[self.delegate respondsToSelector:@selector(UMshareViewHandClick:ShareImage:MoviewModel:)]) {
        [self.delegate UMshareViewHandClick:button ShareImage:shareImage MoviewModel:self.StageInfo];
    }
    
}

-(void)layoutSubviews
{
         _ShareimageView.frame=CGRectMake(0, 0,kDeviceWidth, kDeviceWidth);
        logosupView.frame=CGRectMake(0, _ShareimageView.frame.origin.y+_ShareimageView.frame.size.height,kDeviceWidth, 20);
    
}

//点击屏幕弹回
-(void)TouchbuttonClick:(UIButton *) tap
{
    if (self.delegate &&[self.delegate respondsToSelector:@selector(SharetopViewTouchBengan)]) {
        [self.delegate SharetopViewTouchBengan];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self removeFromSuperview];
}
@end

