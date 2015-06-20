//
//  TapStageCollectionViewCell.m
//  movienext
//
//  Created by 风之翼 on 15/4/27.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "TapStageCollectionViewCell.h"

#import "UIView+Shadow.h"

#import "Constant.h"

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
    _imageView.contentMode=UIViewContentModeScaleAspectFill;
    _imageView.clipsToBounds=YES;
    [self.contentView addSubview:_imageView];
    
    float  height=40;
    if (IsIphone6plus) {
        height=50;
    }
    UIView  *titlebg =[[UIView alloc]initWithFrame:CGRectMake(0, m_frame.size.height-height,m_frame.size.width,height)];
    [titlebg setShadow];
    [self.contentView addSubview:titlebg];
    
    
    _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(5,5,m_frame.size.width-10, height)];
    //_titleLab.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.5];
    _titleLab.textAlignment = NSTextAlignmentCenter;
    _titleLab.textColor = [UIColor whiteColor];
    _titleLab.font = [UIFont fontWithName:kFontRegular size:14];
    if (IsIphone6plus) {
        _titleLab.font=[UIFont fontWithName:kFontRegular size:17];
    }
    [titlebg addSubview:_titleLab];
}


@end
