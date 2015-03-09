//
//  MovieHeadView.h
//  movienext
//
//  Created by 风之翼 on 15/3/7.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MovieHeadViewDelegate <NSObject>
-(void)ChangeCollectionModel:(UIButton  *) button;
@end
@interface MovieHeadView : UICollectionReusableView
{
    UIImageView  *bgImageView;
    UIImageView  *movieLogoImageView;
    UILabel      *titleLable;
    UILabel      *derectorLable;
    UILabel      *performerLable;
    CGRect       m_frame;
    
}
-(void)setCollectionHeaderValue:(NSDictionary *) dict;
@property (nonatomic,assign) id <MovieHeadViewDelegate> delegate;
@end
