//
//  ButtomToolView.h
//  movienext
//
//  Created by 风之翼 on 15/3/11.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarkView.h"
@protocol ButtomToolViewDelegate <NSObject>
//点击底部视图的方法，根据tag值判断是点击了那一个按钮
//button.tag=10000; 头像
//button.tag=10001;  分享
//button.tag=10002  赞
-(void)ToolViewHandClick:(UIButton  *) button :(MarkView *) markView weiboDict:(NSDictionary *) weiboDict;

@end
@interface ButtomToolView : UIView
{
    UIButton  *headButton;
    UILabel   *nameLable;
    UIButton  *shareButton;
    UIButton  *zanbutton;
    MarkView  *_markView;
    NSDictionary  *_weiboDict;
}
-(void)setToolBarValue:(NSDictionary  *) dict :(id) markView;
@property (nonatomic,strong) id<ButtomToolViewDelegate> delegete;

@end
