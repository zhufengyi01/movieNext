//
//  AddLoadingView.h
//  movienext
//
//  Created by 风之翼 on 15/6/5.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddLoadingView : UIView
{
    UIActivityIndicatorView  *activitiView;
    NSString  *_title;
}
-(instancetype)initWithtitle:(NSString *) title;

//标题
@property(nonatomic) UILabel  *titleLable;
//显示
-(void)show;

//移除
-(void)remove;
@end
