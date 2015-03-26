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
    /*_myScrollerView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64,kDeviceWidth,m_frame.size.height-(kDeviceWidth/4)-40-kHeightNavigation)];
  #warning  暂时设置为kDeviceWidth
    //设置scrollview 的背景颜色是黄色的
    _myScrollerView.backgroundColor=[UIColor yellowColor];
    _myScrollerView.contentSize=CGSizeMake(kDeviceWidth, kDeviceWidth);
    [self addSubview:_myScrollerView];
    */
    
    topView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, m_frame.size.height-(kDeviceWidth/4)-40-kHeightNavigation)];
    topView.userInteractionEnabled=YES;
    topView.backgroundColor=VStageView_color;
    [self addSubview:topView];
     
    
    // 上面的透明背景
    UIButton    *_topButtom =[UIButton buttonWithType:UIButtonTypeSystem];
    _topButtom.frame=CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kHeightNavigation-(kDeviceWidth/4)-40);
    [_topButtom addTarget:self action:@selector(TouchbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
     [topView addSubview:_topButtom];
  
 
    _ShareimageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth,400)];
     [topView addSubview:_ShareimageView];
    
    //放置电影名和标签的view
    logosupView=[[UIView alloc]initWithFrame:CGRectMake(0, topView.frame.size.height-20, kDeviceWidth, 20)];
    logosupView.backgroundColor=VStageView_color;
    [topView addSubview:logosupView];
    
    
     _moviewName= [ZCControl createLabelWithFrame:CGRectMake(10,0, 200, 20) Font:12 Text:@""];
    _moviewName.textColor=VGray_color;
    [logosupView addSubview:_moviewName];
    
    logoLable=[ZCControl createLabelWithFrame:CGRectMake(kDeviceWidth-70,0, 60, 20) Font:12 Text:@"影弹App"];
    logoLable.textAlignment=NSTextAlignmentRight;
    logoLable.textColor=VGray_color;
    [logosupView addSubview:logoLable];
    
    //创建下部视图
    [ self createButtomView];


}
//配置view
-(void)configShareView;
{
    
    float  ImageWith=[self.StageInfo.w floatValue];
    float  ImgeHight=[self.StageInfo.h floatValue];
    float hight=0;
    hight= kDeviceWidth;  // 计算的事bgview1的高度
    if(ImgeHight>ImageWith)
    {
        hight=  (ImgeHight/ImageWith) *kDeviceWidth;
    }
    
    //配置shareimagview 的图片和高度
    _ShareimageView.image =self.screenImage;
    //_myScrollerView.contentSize=CGSizeMake(kDeviceWidth, hight);
    _ShareimageView.frame=CGRectMake(0, 0, kDeviceWidth, hight);
    _moviewName.text=self.StageInfo.movie_name;
    logosupView.frame=CGRectMake(0, hight,kDeviceWidth, 30);
    
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

    float  ImageWith=[self.StageInfo.w floatValue];
    float  ImgeHight=[self.StageInfo.h floatValue];
    float hight=0;
    hight= kDeviceWidth;  // 计算的事bgview1的高度
    if(ImgeHight>ImageWith)
    {
        hight=  (ImgeHight/ImageWith) *kDeviceWidth;
    }
    shareImage=[Function getImage:topView WithSize:CGSizeMake(kDeviceWidth, hight+30)];
 
    //把topview 生成一张图片
    if (self.delegate &&[self.delegate respondsToSelector:@selector(UMshareViewHandClick:ShareImage:MoviewModel:)]) {
        [self.delegate UMshareViewHandClick:button ShareImage:shareImage MoviewModel:self.StageInfo];
    }
    
}

-(void)layoutSubviews
{
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

