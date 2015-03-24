//
//  MovieHeadView.h
//  movienext
//
//  Created by 风之翼 on 15/3/7.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MovieHeadViewDelegate <NSObject>
//改变显示大图和小图的状态
//button.tag==1000 大图  button.tag==1000 小图
-(void)ChangeCollectionModel:(UIButton  *) button;
-(void)NavigationClick:(UIButton *) button;
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
//@property(nonatomic,strong) UILabel  
-(void)setCollectionHeaderValue:(NSDictionary *) dict;
@property (nonatomic,assign) id <MovieHeadViewDelegate> delegate;
@end
