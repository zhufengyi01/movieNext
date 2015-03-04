//
//  MarkView.h
//  movienext
//
//  Created by 风之翼 on 15/3/4.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MarkViewDelegate <NSObject>
   -(void)MarkViewClick;
@end

@interface MarkView : UIView
{
    CGRect  m_frame;
    UIView  *rightView;  //又视图
    UILabel  *TitleLable;
    UIImageView  *ZanImageView;
}

@property (nonatomic,strong) UIImageView  *LeftImageView;
@property (nonatomic,strong) UILabel      *TitleLable;
@property (nonatomic,strong) UILabel      *ZanNumLable;
@property (nonatomic,assign) id <MarkViewDelegate> delegate;
@end
