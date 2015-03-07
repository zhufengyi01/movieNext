//
//  MovieHeadView.h
//  movienext
//
//  Created by 风之翼 on 15/3/7.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieHeadView : UICollectionReusableView
{
    UIImageView  *movieLogoImageView;
    UILabel      *titleLable;
    UILabel      *derectorLable;
    UILabel      *performerLable;
}
-(void)setCollectionHeaderValue:(NSDictionary *) dict;

@end
