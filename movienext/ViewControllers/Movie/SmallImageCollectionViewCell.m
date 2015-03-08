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
    _imageView.backgroundColor = [UIColor clearColor];
    [self addSubview:_imageView];
    
    _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(80, 80, 20, 20)];
    //_titleLab.backgroundColor = [UIColor blackColor];
    _titleLab.text=@"1212";
    _titleLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLab];
}

@end
