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
        [self createUI];
        
    }
    return self;
}
-(void)createUI
{     //创建底部试图
    //创建上部视图
    self.backgroundColor=[UIColor blackColor];
    topView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-(kDeviceWidth/4)-40-kHeightNavigation)];
    topView.userInteractionEnabled=YES;
    topView.backgroundColor=[UIColor blackColor];
    [self addSubview:topView];
    
    
    // 上面的透明背景
    UIButton    *_topButtom =[UIButton buttonWithType:UIButtonTypeSystem];
    _topButtom.frame=CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kHeightNavigation-(kDeviceWidth/4)-40);
    
    [_topButtom addTarget:self action:@selector(TouchbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
    _topButtom.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.2];
    [topView addSubview:_topButtom];

    

    _ShareimageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth,400)];
  //  _ShareimageView.backgroundColor=[UIColor redColor];
    [topView addSubview:_ShareimageView];
    
    //放置电影名和标签的view
    logosupView=[[UIView alloc]initWithFrame:CGRectMake(0, topView.frame.size.height-20, kDeviceWidth, 20)];
    logosupView.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.7];
    [topView addSubview:logosupView];
    
    
     _moviewName= [ZCControl createLabelWithFrame:CGRectMake(10,0, 200, 20) Font:12 Text:@""];
    _moviewName.textColor=VGray_color;
    //_moviewName.backgroundColor=[UIColor blackColor];
    [logosupView addSubview:_moviewName];
    
    logoLable=[ZCControl createLabelWithFrame:CGRectMake(kDeviceWidth-70,0, 60, 20) Font:12 Text:@"影弹App"];
    logoLable.textAlignment=NSTextAlignmentRight;
    logoLable.textColor=VGray_color;
    //logoLable.backgroundColor=[UIColor blackColor];
    [logosupView addSubview:logoLable];
    
    //创建下部视图
    [ self createButtomView];


}
//配置view
-(void)configShareView;
{
    _ShareimageView.image =self.screenImage;
    _moviewName.text=self.StageInfo.movie_name;
    
    
}

-(void)createButtomView
{

    buttomView=[[UIView alloc]initWithFrame:CGRectMake(0, kDeviceHeight, kDeviceWidth, kDeviceWidth/4+40)];
    buttomView.backgroundColor=[UIColor whiteColor];
    buttomView.userInteractionEnabled=YES;
    [self addSubview:buttomView];
#pragma create four button
    
    NSArray  *titleArray=[NSArray arrayWithObjects:@"微信",@"朋友圈",@"Q空间",@"微博",nil];
    NSArray  *imageArray=[NSArray arrayWithObjects:@"wechat_share_icon@2x.png",@"moments_share_icon@2x.png",@"qzone_share_icon@2x.png",@"weibo_share_icon@2x.png", nil];
    
    for (int i=0; i<4; i++) {
        double   x=(kDeviceWidth/4)*i;
        double   y=40;
        
     UIButton  *    btn = [ZCControl createButtonWithFrame:CGRectMake(x,y, kDeviceWidth/4, kDeviceWidth/4) ImageName:imageArray[i] Target:self Action:@selector(handShareButtonClick:) Title:nil];
       // [btn setImage:[UIImage imageNamed:imageArray[i]] forState:UIControlStateNormal];
      //  btn.titleEdgeInsets = UIEdgeInsetsMake(65, -30, 10, 10);
       // btn.titleLabel.font=[UIFont systemFontOfSize:12];
      //  [btn setTitleColor:VBlue_color forState:UIControlStateNormal];
       // [btn setImageEdgeInsets:UIEdgeInsetsMake(10, 20, 20, 10)];
        btn.tag=10000+i;
        btn.backgroundColor=[UIColor whiteColor];
        [buttomView addSubview:btn];

    }
    
    UILabel  *shareLable =[ZCControl createLabelWithFrame:CGRectMake(0, 0,kDeviceWidth, 40) Font:14 Text:@"分享给好友"];
    shareLable.textAlignment=NSTextAlignmentCenter;
    shareLable.textColor=VBlue_color;
    [buttomView addSubview:shareLable];
    
   /* UIView  *lineView1=[[UIView alloc]initWithFrame:CGRectMake(0, 40, kDeviceWidth, 0.5)];
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
*/
    
}



//显示底部试图
-(void)showShareButtomView;
{
    [UIView animateWithDuration:0.5 animations:^{
        CGRect  Bframe=buttomView.frame;
        Bframe.origin.y=kDeviceHeight-kHeightNavigation-(kDeviceWidth/4+40);
        buttomView.frame=Bframe;
    } completion:^(BOOL finished) {
    }];
}
//隐藏底部试图
-(void)HidenShareButtomView;
{
    [UIView animateWithDuration:0.5 animations:^{
        CGRect  Bframe=buttomView.frame;
        Bframe.origin.y=kDeviceHeight-kHeightNavigation;
        buttomView.frame=Bframe;
    } completion:^(BOOL finished) {
        
    }];
}



//点击分享
-(void)handShareButtonClick:(UIButton *) button
{

   
    shareImage=[Function getImage:topView];
 
    //把topview 生成一张图片
    if (self.delegate &&[self.delegate respondsToSelector:@selector(UMshareViewHandClick:ShareImage:MoviewModel:)]) {
        [self.delegate UMshareViewHandClick:button ShareImage:shareImage MoviewModel:self.StageInfo];
    }
    
}
/*
- (void)removeSelf:(UITapGestureRecognizer *)tap {
    [tap.view removeFromSuperview];
}*/
-(void)layoutSubviews
{
    
    //需要从新设置mshareimagview的frame
    
    //_moviewName.frame=CGRectMake(10,topView.frame.size.height-20, kDeviceWidth-20, 20);
    //logoLable.frame=CGRectMake(kDeviceWidth-70, topView.frame.size.height-20, 60, 20);
        float hight= kDeviceWidth;
        float  ImageWith=[self.StageInfo.w intValue];
        float  ImgeHight=[self.StageInfo.h intValue];
       if (ImageWith>ImgeHight) {
           //宽大于高的时候
           _ShareimageView.frame=CGRectMake(0,(topView.frame.size.height-hight)/2, kDeviceWidth, kDeviceWidth);
           
          
       }
       else if(ImgeHight>ImageWith)
        {
            hight=  (ImgeHight/ImageWith) *kDeviceWidth;
            if (hight>topView.frame.size.height) {
                // 这个时候需要把图片裁剪

            }
            _ShareimageView.frame=CGRectMake(0, 0,kDeviceWidth, hight);

        }
    


}

//点击屏幕弹回
-(void)TouchbuttonClick:(UIButton *) button
{
    if (self.delegate &&[self.delegate respondsToSelector:@selector(SharetopViewTouchBengan)]) {
        [self.delegate SharetopViewTouchBengan];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
   // [self removeFromSuperview];
}
@end

