//
//  SelectTimeView.m
//  movienext
//
//  Created by 朱封毅 on 16/06/15.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "SelectTimeView.h"

#import "UIButton+Block.h"


#import "Constant.h"

#import "ZCControl.h"

@implementation SelectTimeView

-(instancetype)initWithFrame:(CGRect)frame
{
    
    if (self =[super initWithFrame:frame]) {
        self.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight);
        self.backgroundColor =[[UIColor blackColor] colorWithAlphaComponent:0.4];
        UITapGestureRecognizer  *tap  =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancleshow)];
        [self addGestureRecognizer:tap];
        [self createDatePickerView];
    }
    return self;
}

-(void)cancleshow
{
    [self removeFromSuperview];
}

-(void)show
{
    
    [AppView addSubview:self];
}
-(void)createDatePickerView
{
    
    UIView  *bgview = [[UIView alloc]initWithFrame:CGRectMake(0,( kDeviceHeight-260)/2, kDeviceWidth, 266)];
    bgview.backgroundColor =[UIColor whiteColor];
    bgview.userInteractionEnabled=YES;
    [self addSubview:bgview];
    
    
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];
    datePicker.backgroundColor =[UIColor whiteColor];
    // 设置时区
    [datePicker setTimeZone:[NSTimeZone timeZoneWithName:@"GMT+0800"]];
    // 设置当前显示时间
    //[datePicker setDate:tempDate animated:YES];
    // 设置显示最大时间（此处为当前时间）
    //[datePicker setMaximumDate:[NSDate date]];
    // 设置UIDatePicker的显示模式
    [datePicker setDatePickerMode:UIDatePickerModeDateAndTime];
    // 当值发生改变的时候调用的方法
    // [datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    [bgview addSubview:datePicker];
    
    UIButton  *btn =[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(0, 216,kDeviceWidth,50);
    [btn addActionHandler:^(NSInteger tag) {
        // 获得当前UIPickerDate所在的时间
        NSDate *selected = [datePicker date];
        NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[selected timeIntervalSince1970]];
        if(self.delegate &&[self.delegate respondsToSelector:@selector(DatePickerSelectedTime:)])
            [self.delegate DatePickerSelectedTime:timeSp];
        [self removeFromSuperview];
    }];
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [btn setTitleColor:VBlue_color forState:UIControlStateNormal];
    [bgview addSubview:btn];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
