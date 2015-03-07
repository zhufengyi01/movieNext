//
//  MovieCollectionViewCell.h
//  movienext
//
//  Created by 风之翼 on 15/3/2.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieCollectionViewCell : UICollectionViewCell
{
    CGRect  m_frame;
    UIImageView    *LogoImage;
    UILabel        *TitleLable;
}
//-(void)setCellValue:(NSDictionary  *) dict;
-(void)setValueforCell:(NSDictionary  *) dict;

@end
