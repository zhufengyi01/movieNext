//
//  UploadProgressView.m
//  movienext
//
//  Created by 风之翼 on 15/3/23.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "UploadProgressView.h"
#import "Constant.h"
#import "ZCControl.h"
@implementation UploadProgressView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        m_frame=frame;
        [self createUI];
    }
    return self;
}
-(void)createUI
{
    self.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.4];
    UIView  *progressBg=[[UIView alloc]initWithFrame:CGRectMake((kDeviceWidth-240)/2, (kDeviceWidth-70)/2, 240, 70)];
    progressBg.backgroundColor=[UIColor whiteColor];
    progressBg.layer.cornerRadius=6;
    progressBg.clipsToBounds=YES;
    [self addSubview:progressBg];
    
    self.myProgressView=[[UIProgressView alloc]initWithFrame:CGRectMake(20, 25, 200, 20)];
    self.myProgressView.progress=0;
    self.myProgressView.progressViewStyle=UIProgressViewStyleDefault;
    [progressBg addSubview:self.myProgressView];
    
    
    tipLable=[ZCControl createLabelWithFrame:CGRectMake(0,35, 240, 20) Font:12 Text:@"正在上传图片..."];
    tipLable.textAlignment=NSTextAlignmentCenter;
    tipLable.textColor=VLight_GrayColor;
    [progressBg addSubview:tipLable];
}
//设置progress进度
-(void)setProgress:(float) progress
{
    _myProgressView.progress=progress;
    
}
-(void)setProgressTitle:(NSString *) title;
{
    tipLable.text=@"上传成功";
}
@end
