//
//  MovieHeadView.m
//  movienext
//
//  Created by 风之翼 on 15/3/7.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "MovieHeadView.h"
#import "ZCControl.h"
#import "UIImageView+WebCache.h"
#import "Constant.h"
#import "UIImage+Blur.h"
#import "UIImage-Helpers.h"
@implementation MovieHeadView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self= [super initWithFrame:frame]) {
        m_frame=frame;
        [self createUI];
    }
    return self;
}
-(void)createUI
{
    //放置所有控件的view

     bgImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth,(kDeviceHeight/3+64)+180)];
    bgImageView.backgroundColor=VLight_GrayColor;
    bgImageView.userInteractionEnabled=YES;
   // bgImageView.image =[UIImage imageNamed:@"loading_image_all"];
    [self addSubview:bgImageView];
    
    movieLogoImageView  =[[UIImageView alloc]initWithFrame:CGRectMake(15, 64+20+180, 50, 70)];
    [bgImageView addSubview:movieLogoImageView];
    
    titleLable=[ZCControl createLabelWithFrame:CGRectMake(movieLogoImageView.frame.origin.x+movieLogoImageView.frame.size.width+10, movieLogoImageView.frame.origin.y,kDeviceWidth-20-50-20 ,30) Font:16 Text:@""];
    titleLable.textColor=[UIColor whiteColor];
    titleLable.font=[UIFont boldSystemFontOfSize:18];
    [bgImageView addSubview:titleLable];
    
    //导演
    derectorLable=[ZCControl createLabelWithFrame:CGRectMake(movieLogoImageView.frame.origin.x+movieLogoImageView.frame.size.width+10,titleLable.frame.origin.y+titleLable.frame.size.height,kDeviceWidth-30-10-30,15) Font:14 Text:@""];
    derectorLable.textColor=[UIColor whiteColor];
    derectorLable.numberOfLines=2;
    [bgImageView addSubview:derectorLable];
    //演员
    performerLable=[ZCControl createLabelWithFrame:CGRectMake(movieLogoImageView.frame.origin.x+10+movieLogoImageView.frame.size.width, derectorLable.frame.origin.y+derectorLable.frame.size.height, kDeviceWidth-movieLogoImageView.frame.origin.x-movieLogoImageView.frame.size.width-10-10, 50) Font:12 Text:@""];
    performerLable.numberOfLines=3;
    performerLable.lineBreakMode=NSLineBreakByCharWrapping;
    performerLable.textColor=[UIColor whiteColor];
    [bgImageView addSubview:performerLable];
    
    //下面的点击
    
    UIView  *btnBg =[[UIView  alloc] initWithFrame:CGRectMake(0, kDeviceHeight/3+64-45+180, kDeviceWidth, 45)];
    btnBg.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.2];
    [bgImageView addSubview:btnBg];
    
    
    UIButton  *btn1=[UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame=CGRectMake(0, 0, kDeviceWidth/2, 45);
    [btn1 addTarget:self action:@selector(dealChangeModelClick:) forControlEvents:UIControlEventTouchUpInside];
    btn1.selected=YES;
    [btn1 setImage:[UIImage imageNamed:@"single_switch(gray).png"] forState:UIControlStateNormal];
    [btn1 setImage:[UIImage imageNamed:@"single_switch.png"] forState:UIControlStateSelected];
    
    btn1.tag=1000;
    [btnBg addSubview:btn1];
    

    
    UIButton  *btn2=[UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame=CGRectMake(kDeviceWidth/2, 0, kDeviceWidth/2, 45);
    [btn2 addTarget:self action:@selector(dealChangeModelClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn2 setImage:[UIImage imageNamed:@"three_swtich(gray).png"] forState:UIControlStateNormal];
    [btn2 setImage:[UIImage imageNamed:@"three switch.png"] forState:UIControlStateSelected];
    btn2.tag=1001;
    [btnBg addSubview:btn2];

    
}
-(void)setCollectionHeaderValue
{
    //NSLog(@ "在头部设置的信息  =====%@",dict);
    
   
    [movieLogoImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kUrlMoviePoster,self.movieInfo.logo]] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        //设置头部的北京图片
        // jpeg quality image data
        float quality = 0.00001f;
        // intensity of blurred
        float blurred = 0.9f;  //这个参数控制透明度
        
        NSData  *imageData=UIImageJPEGRepresentation(movieLogoImageView.image, quality);
        UIImage *blurredImage=[[UIImage imageWithData:imageData] blurredImage:blurred];
        bgImageView.image = blurredImage;
    }];
  
    if (self.movieInfo.name ) {
        titleLable.text=[NSString stringWithFormat:@"%@",self.movieInfo.name];
    }
    if (self.movieInfo.director) {
        derectorLable.text=[NSString stringWithFormat:@"导演 :%@",self.movieInfo.director];
    }
     if (self.movieInfo.actors) {
        performerLable.text=[NSString stringWithFormat:@"演员:%@",self.movieInfo.actors];
    }
    
}
//切换按钮
-(void)dealChangeModelClick:(UIButton *) button
{
    if (self.delegate&& [self.delegate respondsToSelector:@selector(ChangeCollectionModel:)]) {
        [self.delegate ChangeCollectionModel:button];
    }

}

//返回按钮的实现添加剧照
//-(void)dealBackClick:(UIButton *) button
//{
// //   [self.navigationController popViewControllerAnimated:YES];
//    if (self.delegate&&[self.delegate respondsToSelector:@selector(NavigationClick:)]) {
//        [self.delegate NavigationClick:button];
//    }
//    
//}

//自动布局self.view的子类
-(void)layoutSubviews
{
    
}
@end
