//
//  StageView.h
//  movienext
//
//  Created by 杜承玖 on 3/6/15.
//  Copyright (c) 2015 redianying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StageView : UIView
{
    UIImageView   *_MovieImageView;
}
@property (nonatomic,strong ) NSMutableArray   *WeibosArray;   //小标签的数组，在多个标签的时候使用这个
@property (nonatomic,strong )NSDictionary      *weiboDict;     //只有一个标签的时候传递这个参数

- (void)setStageValue:(NSDictionary *)stageDict;

@end
