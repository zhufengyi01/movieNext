//
//  SelectTimeView.h
//  movienext
//
//  Created by 朱封毅 on 16/06/15.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectTimeViewDelegate <NSObject>

-(void)DatePickerSelectedTime :(NSString *) dateString;

@end
@interface SelectTimeView : UIView
{
    UIDatePicker *datePicker;
}
@property(nonatomic,assign) id <SelectTimeViewDelegate>  delegate;
-(void)show;
@end
