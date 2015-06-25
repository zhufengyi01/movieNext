//
//  SmallImageCollectionViewCell.m
//  movienext
//
//  Created by 风之翼 on 15/3/7.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "SmallImageCollectionViewCell.h"
#import "Constant.h"
#import "UIView+Shadow.h"
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
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,self.frame.size.width,self.frame.size.height)];
    _imageView.backgroundColor = [UIColor clearColor];
    _imageView.contentMode=UIViewContentModeScaleAspectFill;
    _imageView.clipsToBounds=YES;
    [self.contentView addSubview:_imageView];
    
    UIView  *view =[[UIView alloc]initWithFrame:CGRectMake(0, m_frame.size.height-40, m_frame.size.width, 40)];
    [view setShadow];
    [self.contentView addSubview:view];
    
    self.platformlbl = [[UILabel alloc]initWithFrame:CGRectMake(10, m_frame.size.height-50, m_frame.size.width-20, 30)];
    self.platformlbl.text=@"";
    self.platformlbl.textAlignment = NSTextAlignmentCenter;
    self.platformlbl.textColor = [UIColor whiteColor];
    self.platformlbl.font = [UIFont fontWithName:kFontDouble size:14];
    [self.contentView addSubview:self.platformlbl];

    _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(10, m_frame.size.height-30, m_frame.size.width-20, 30)];
    _titleLab.text=@"";
    _titleLab.textAlignment = NSTextAlignmentCenter;
    _titleLab.textColor = [UIColor whiteColor];
    _titleLab.font = [UIFont fontWithName:kFontDouble size:16];
    [self.contentView addSubview:_titleLab];
    
    _ivAvatar = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 20, 20)];
    _ivAvatar.backgroundColor = [UIColor clearColor];
    _ivAvatar.contentMode=UIViewContentModeScaleAspectFill;
    _ivAvatar.clipsToBounds=YES;
    _ivAvatar.layer.cornerRadius = 10;
    [self.contentView addSubview:_ivAvatar];
    
    _ivLike = [[UIImageView alloc]initWithFrame:CGRectMake(m_frame.size.width-33, 12, 9, 8)];
    _ivLike.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_ivLike];
    
    _lblTime = [[UILabel alloc]initWithFrame:CGRectMake(30, 5, 80, 20)];
    _lblTime.text=@"";
    _lblTime.textAlignment = NSTextAlignmentLeft;
    _lblTime.textColor = [UIColor whiteColor];
    _lblTime.font = [UIFont fontWithName:kFontRegular size:12];
    [self.contentView addSubview:_lblTime];
    
    _lblLikeCount = [[UILabel alloc]initWithFrame:CGRectMake(m_frame.size.width-20,5, 20, 20)];
    _lblLikeCount.text=@"";
    _lblLikeCount.textAlignment = NSTextAlignmentLeft;
    _lblLikeCount.textColor = [UIColor whiteColor];
    _lblLikeCount.font = [UIFont fontWithName:kFontRegular size:12];
    [self.contentView addSubview:_lblLikeCount];
}

@end
