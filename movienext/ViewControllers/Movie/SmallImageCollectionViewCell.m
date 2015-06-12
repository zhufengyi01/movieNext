//
//  SmallImageCollectionViewCell.m
//  movienext
//
//  Created by 风之翼 on 15/3/7.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "SmallImageCollectionViewCell.h"

@implementation SmallImageCollectionViewCell


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        m_frame=frame;
        [self createUI];
    }
    return self;
}

- (void)createUI {
    //定义CELL单元格内容
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, m_frame.size.width, m_frame.size.height)];
    //_imageView.image=[UIImage imageNamed:@"loading_image_all"];
    _imageView.backgroundColor = [UIColor clearColor];
    _imageView.contentMode=UIViewContentModeScaleAspectFill;
    _imageView.clipsToBounds=YES;
    [self.contentView addSubview:_imageView];
    
    _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(10, m_frame.size.height-30, m_frame.size.width-20, 30)];
    //_titleLab.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.5];
    _titleLab.text=@"";
    _titleLab.textAlignment = NSTextAlignmentCenter;
    _titleLab.textColor = [UIColor whiteColor];
    _titleLab.font = [UIFont boldSystemFontOfSize:16];
    [self.contentView addSubview:_titleLab];
    
    _ivAvatar = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 20, 20)];
    _ivAvatar.backgroundColor = [UIColor clearColor];
    _ivAvatar.contentMode=UIViewContentModeScaleAspectFill;
    _ivAvatar.clipsToBounds=YES;
    _ivAvatar.layer.cornerRadius = 10;
    [self.contentView addSubview:_ivAvatar];
    
    _ivLike = [[UIImageView alloc]initWithFrame:CGRectMake(m_frame.size.width-40, 10, 10, 10)];
    _ivLike.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_ivLike];

    _lblTime = [[UILabel alloc]initWithFrame:CGRectMake(30, 5, 40, 20)];
    _lblTime.text=@"";
    _lblTime.textAlignment = NSTextAlignmentCenter;
    _lblTime.textColor = [UIColor whiteColor];
    _lblTime.font = [UIFont boldSystemFontOfSize:12];
    [self.contentView addSubview:_lblTime];
    
    _lblLikeCount = [[UILabel alloc]initWithFrame:CGRectMake(m_frame.size.width-30, 5, 30, 20)];
    _lblLikeCount.text=@"";
    _lblLikeCount.textAlignment = NSTextAlignmentCenter;
    _lblLikeCount.textColor = [UIColor whiteColor];
    _lblLikeCount.font = [UIFont boldSystemFontOfSize:12];
    [self.contentView addSubview:_lblLikeCount];
}

@end
