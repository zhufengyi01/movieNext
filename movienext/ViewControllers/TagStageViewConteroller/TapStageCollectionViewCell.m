//
//  TapStageCollectionViewCell.m
//  movienext
//
//  Created by 风之翼 on 15/4/27.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "TapStageCollectionViewCell.h"

@implementation TapStageCollectionViewCell

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
    _imageView.image=[UIImage imageNamed:@"loading_image_all"];
     [self.contentView addSubview:_imageView];
    
    _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, m_frame.size.height-30,m_frame.size.width, 30)];
    _titleLab.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.5];
    _titleLab.textAlignment = NSTextAlignmentLeft;
    _titleLab.textColor = [UIColor whiteColor];
    _titleLab.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_titleLab];
}


@end
