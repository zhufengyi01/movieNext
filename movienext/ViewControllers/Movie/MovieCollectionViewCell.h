//
//  MovieCollectionViewCell.h
//  movienext
//
//  Created by 风之翼 on 15/3/2.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MovieCollectionViewCellDelegate <NSObject>
-(void)MovieCollectionViewlongPress:(NSInteger) cellRowIndex;
@end

@interface MovieCollectionViewCell : UICollectionViewCell
{
    CGRect  m_frame;
    UIImageView    *LogoImage;
    UILabel        *TitleLable;
}
@property (nonatomic,assign)id <MovieCollectionViewCellDelegate> delegate;
@property (nonatomic,assign) NSInteger Cellindex;
-(void)setValueforCell:(NSDictionary  *) dict inRow:(NSInteger) inrow;

@end
