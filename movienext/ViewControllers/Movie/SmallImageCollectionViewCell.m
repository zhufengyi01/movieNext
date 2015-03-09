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
    [self addSubview:_imageView];
    
    _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(m_frame.size.width-20, m_frame.size.height-20, 20, 20)];
    _titleLab.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.5];
    _titleLab.text=@"";
    _titleLab.textAlignment = NSTextAlignmentCenter;
    _titleLab.textColor = [UIColor whiteColor];
    _titleLab.font = [UIFont systemFontOfSize:12];
    [self addSubview:_titleLab];
}

@end
