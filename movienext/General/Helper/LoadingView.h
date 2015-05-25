//
//  LoadingView.h
//  movienext
//
//  Created by 风之翼 on 15/3/1.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LoadingViewDelegate <NSObject>
/*
 点击重新加载按钮，重新加载数据
 */
@required

-(void)reloadDataClick;

@end
@interface LoadingView : UIView
{
    UIImageView  *CircleImageView;
    BOOL  isanimal;
    double angle;
    CGRect  m_frame;
    
    UIView  *failLoadView;
     //没有数据的view
    UIView   *NullDataView;
   // UILabel * failTitle2;
}
 //注意：数据加载完成后先停止动画，然后再把loadview  从supview 中remove 防止占内存空间

@property(assign,nonatomic)id<LoadingViewDelegate> delegate;
//startanimation
-(void)startAnimation;
//end animation
-(void)stopAnimation;



//custom  property
/*
    fail
 */
@property (nonatomic,strong) UILabel    *failTitle;
@property (nonatomic,strong) UIButton   *failBtn;
/*
 null data
 */
@property(nonatomic,strong) UIImageView   *nullImageView;

@property(nonatomic,strong)UILabel   *nullTitle;



//Custom Method
//reload data
-(void)hidenFailLoadAndShowAnimation;

//fail data
-(void)showFailLoadData;

// null data
-(void)showNullView:(NSString *) failString;
@end
