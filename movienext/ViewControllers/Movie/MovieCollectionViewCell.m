//
//  MovieCollectionViewCell.m
//  movienext
//
//  Created by 风之翼 on 15/3/2.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "MovieCollectionViewCell.h"
#import "Constant.h"
#import "ZCControl.h"
#import "UIImageView+WebCache.h"
@implementation MovieCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        m_frame=frame;
        [self createUI];
    }
    return self;
}
-(void)createUI
{
 
    LogoImage =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0,m_frame.size.width, m_frame.size.height-30)];
    [self.contentView addSubview:LogoImage];
    
    TitleLable=[ZCControl createLabelWithFrame:CGRectMake(0, LogoImage.frame.origin.y+LogoImage.frame.size.height, LogoImage.frame.size.width, 30) Font:14 Text:@"电影描述"];
    TitleLable.textAlignment=NSTextAlignmentCenter;
    TitleLable.textColor=VGray_color;
    [self.contentView addSubview:TitleLable];
}
-(void)setValueforCell:(NSDictionary  *) dict;
{
    if ([dict objectForKey:@"picture"])
    {
        NSURL *urlString=[NSURL URLWithString:  [NSString stringWithFormat:@"%@%@!poster",kUrlFeed,[dict objectForKey:@"picture"]]];
        [LogoImage sd_setImageWithURL:urlString placeholderImage:[UIImage imageNamed:@"loading_image_all.png"]];
    }
    if ([dict objectForKey:@"title"]) {
        TitleLable.text=[NSString stringWithFormat:@"%@",[dict objectForKey:@"title"]];
    }
    
}
@end
