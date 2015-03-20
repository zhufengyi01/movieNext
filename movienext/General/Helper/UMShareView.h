//
//  UMShareView.h
//  movienext
//
//  Created by 风之翼 on 15/3/19.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol UMShareViewDelegate <NSObject>
-(void)UMshareViewHandClick:(UIButton *) button;
@end

@interface UMShareView : UIView
{
    UILabel  *logoLable;
    UIButton  *wechatSessionBtn;
    UIButton  *wechatTimelineBtn;
    UIButton  *qzoneBtn;
    UIButton  *weiboBtn;
}
@property(nonatomic,assign)id<UMShareViewDelegate> delegate;
@property(nonatomic,strong) UIImageView *ShareimageView;
@property(nonatomic,strong) UILabel      *moviewName;

@end
