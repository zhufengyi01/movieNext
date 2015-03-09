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
    movieLogoImageView  =[[UIImageView alloc]initWithFrame:CGRectMake(20, 20, 50, 70)];
    
    [self addSubview:movieLogoImageView];
    
    titleLable=[ZCControl createLabelWithFrame:CGRectMake(movieLogoImageView.frame.origin.x+movieLogoImageView.frame.size.width+10, movieLogoImageView.frame.origin.y,kDeviceWidth-20-50-20 ,30) Font:16 Text:@"电影标题"];
    
    [self addSubview:titleLable];
    
    //导演
    derectorLable=[ZCControl createLabelWithFrame:CGRectMake(movieLogoImageView.frame.origin.x+movieLogoImageView.frame.size.width+10,titleLable.frame.origin.y+titleLable.frame.size.height+5,kDeviceWidth-30-10-30,50) Font:12 Text:@"导演"];
    derectorLable.numberOfLines=2;
    [self addSubview:titleLable];
    //演员
    performerLable=[ZCControl createLabelWithFrame:CGRectMake(movieLogoImageView.frame.origin.x+10+movieLogoImageView.frame.size.width, derectorLable.frame.origin.y+derectorLable.frame.size.height+5, 100, 30) Font:12 Text:@"演员"];
    [self addSubview:performerLable];
    
    UIView  *btnBg =[[UIView  alloc] initWithFrame:CGRectMake(0, kDeviceHeight/3-45, kDeviceWidth, 45)];
    btnBg.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.7];
    [self addSubview:btnBg];
    
    
    UIButton  *btn1=[UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame=CGRectMake(0, 0, kDeviceWidth/2, 45);
    [btn1 addTarget:self action:@selector(dealChangeModelClick:) forControlEvents:UIControlEventTouchUpInside];
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
    titleLable.text=[NSString stringWithFormat:@"%@",[dict objectForKey:@"name"]];
    derectorLable.text=[NSString stringWithFormat:@"导演 :%@",[dict objectForKey:@"director"]];
    performerLable.text=[NSString stringWithFormat:@"演员:%@",[dict objectForKey:@"other_name"]];
    
    
}
-(void)dealChangeModelClick:(UIButton *) button
{
    if (self.delegate&& [self.delegate respondsToSelector:@selector(ChangeCollectionModel:)]) {
        [self.delegate ChangeCollectionModel:button];
    }

}
//自动布局self.view的子类
-(void)layoutSubviews
{
    
}
@end
