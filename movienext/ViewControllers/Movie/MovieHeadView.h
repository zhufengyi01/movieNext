//
//  MovieHeadView.h
//  movienext
//
//  Created by 风之翼 on 15/3/7.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MovieHeadViewDelegate <NSObject>
-(void)ChangeCollectionModel:(NSInteger ) index;
@end
@interface MovieHeadView : UICollectionReusableView
{
    UIImageView  *movieLogoImageView;
    UILabel      *titleLable;
    UILabel      *derectorLable;
    UILabel      *performerLable;
}
-(void)setCollectionHeaderValue:(NSDictionary *) dict;
@property (nonatomic,assign) id <MovieHeadViewDelegate> delegate;
@end
