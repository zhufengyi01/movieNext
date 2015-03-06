//
//  StageView.h
//  movienext
//
//  Created by 杜承玖 on 3/6/15.
//  Copyright (c) 2015 redianying. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kTimeOffset 0.7  //间隔时间
@interface StageView : UIView
{
    UIImageView   *_MovieImageView;
    NSInteger currentMarkIndex;
}
@property (nonatomic,strong ) NSMutableArray   *WeibosArray;   //小标签的数组，在多个标签的时候使用这个
@property (nonatomic,strong )NSDictionary      *weiboDict;     //只有一个标签的时候传递这个参数
@property (nonatomic, strong) NSTimer * timer;

- (void)setStageValue:(NSDictionary *)stageDict;

/**
 *  开始动画
 */
- (void)startAnimation; //在celldisplay执行的方法

/**
 *  结束动画
 */
- (void)stopAnimation;   //在cellenddisplay 执行的方法
@end
