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
     bgImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight/3)];
    bgImageView.userInteractionEnabled=YES;
   // bgImageView.image =[UIImage imageNamed:@"loading_image_all"];
    [self addSubview:bgImageView];
    
    
    UIButton  *leftBtn= [UIButton buttonWithType:UIButtonTypeSystem];
    leftBtn.frame=CGRectMake(0, 70, 60, 36);
    [leftBtn addTarget:self action:@selector(dealBackClick:) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setTitle:@"返回" forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"Back__Icon.png"] forState:UIControlStateNormal];
    //leftBtn.imageEdgeInsets=UIEdgeInsetsMake(<#CGFloat top#>, <#CGFloat left#>, <#CGFloat bottom#>, <#CGFloat right#>)
    [bgImageView addSubview:leftBtn];

    
    
    movieLogoImageView  =[[UIImageView alloc]initWithFrame:CGRectMake(40, 40, 50, 70)];
    
    [bgImageView addSubview:movieLogoImageView];
    
    titleLable=[ZCControl createLabelWithFrame:CGRectMake(movieLogoImageView.frame.origin.x+movieLogoImageView.frame.size.width+10, movieLogoImageView.frame.origin.y,kDeviceWidth-20-50-20 ,30) Font:16 Text:@"电影标题"];
    
    [bgImageView addSubview:titleLable];
    
    //导演
    derectorLable=[ZCControl createLabelWithFrame:CGRectMake(movieLogoImageView.frame.origin.x+movieLogoImageView.frame.size.width,titleLable.frame.origin.y+titleLable.frame.size.height+5,kDeviceWidth-30-10-30,20) Font:12 Text:@"导演"];
    derectorLable.numberOfLines=2;
    [bgImageView addSubview:derectorLable];
    //演员
    performerLable=[ZCControl createLabelWithFrame:CGRectMake(movieLogoImageView.frame.origin.x+10+movieLogoImageView.frame.size.width, derectorLable.frame.origin.y+derectorLable.frame.size.height, kDeviceWidth-movieLogoImageView.frame.origin.x+movieLogoImageView.frame.size.width-10-10, 40) Font:12 Text:@"演员"];
    performerLable.numberOfLines=2;
    [bgImageView addSubview:performerLable];
    
    UIView  *btnBg =[[UIView  alloc] initWithFrame:CGRectMake(0, kDeviceHeight/3-45, kDeviceWidth, 45)];
    btnBg.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.4];
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
-(void)setCollectionHeaderValue:(NSDictionary *)dict
{
    NSLog(@ "在头部设置的信息  =====%@",dict);
    
    [movieLogoImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kUrlMoviePoster,[dict objectForKey:@"logo"]]] placeholderImage:[UIImage imageNamed:@"loading_image_all"]];
    //设置头部的北京图片
    // jpeg quality image data
    float quality = 0.00001f;
    // intensity of blurred
    float blurred = 0.9f;  //这个参数控制透明度

    NSData  *imageData=UIImageJPEGRepresentation(movieLogoImageView.image, quality);
     UIImage *blurredImage=[[UIImage imageWithData:imageData] blurredImage:blurred];
     bgImageView.image = blurredImage;
    
    titleLable.text=[NSString stringWithFormat:@"%@",[dict objectForKey:@"name"]];
    derectorLable.text=[NSString stringWithFormat:@"导演 :%@",[dict objectForKey:@"director"]];
    NSLog(@"导演 ＝＝＝＝＝＝＝xianshi ＝＝%@",[dict objectForKey:@"director"]);
    performerLable.text=[NSString stringWithFormat:@"演员:%@",[dict objectForKey:@"other_name"]];
    
    
}
-(void)dealChangeModelClick:(UIButton *) button
{
    if (self.delegate&& [self.delegate respondsToSelector:@selector(ChangeCollectionModel:)]) {
        [self.delegate ChangeCollectionModel:button];
    }

}

//返回按钮的实现
-(void)dealBackClick:(UIButton *) button
{
 //   [self.navigationController popViewControllerAnimated:YES];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(backClick)]) {
        [self.delegate backClick];
    }
    
}

//自动布局self.view的子类
-(void)layoutSubviews
{
    
}
@end
