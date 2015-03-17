//
//  BigImageCollectionViewCell.m
//  movienext
//
//  Created by 风之翼 on 15/3/7.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "BigImageCollectionViewCell.h"
#import "Constant.h"
#import "UIImageView+WebCache.h"
//#import "UIButton+WebCache.h"
#import "Function.h"
#import "ZCControl.h"
@implementation BigImageCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self =[super initWithFrame:frame]) {
        m_frame=frame;
        [self CreateUI];
    }
    return self;
}
-(void)CreateUI
{
    self.backgroundColor =[UIColor blackColor];
    [self CreateTopView];
    [self createButtonView];

}
-(void)CreateTopView
{
    _StageView=[[StageView alloc]initWithFrame:CGRectMake(0, 45, kDeviceWidth, 200)];
    _StageView.backgroundColor=[UIColor blackColor];
    [self.contentView addSubview:_StageView];
    
}

-(void)createButtonView
{
    BgView2=[[UIView alloc]initWithFrame:CGRectMake(0, kDeviceWidth, kDeviceWidth, 45)];
    BgView2.backgroundColor=View_ToolBar;
    [self.contentView addSubview:BgView2];
    
    
    ScreenButton =[ZCControl createButtonWithFrame:CGRectMake(kDeviceWidth-150,10,60,25) ImageName:@"screen_shot share.png" Target:self.superview Action:@selector(ScreenButtonClick:) Title:@""];
    [BgView2 addSubview:ScreenButton];
    
    addMarkButton =[ZCControl createButtonWithFrame:CGRectMake(kDeviceWidth-75,10,60,25) ImageName:@"btn_add_default.png" Target:self.superview Action:@selector(addMarkButtonClick:) Title:@""];
    [BgView2 addSubview:addMarkButton];
    
    
}
- (void)awakeFromNib {
    // Initialization code
}
-(void)ConfigCellWithIndexPath:(NSInteger)row{
    //分享
    ScreenButton.tag=2000+row;
    // 添加弹幕
    addMarkButton.tag=3000+row;
    if (_weiboDict) {
        _StageView.weiboDict = _weiboDict;
    }
    
    if (_WeibosArray) {
        _StageView.WeibosArray = self.WeibosArray;
    }
    ScreenButton.tag=2000+row;  //截屏分享
    addMarkButton.tag=3000+row;   //添加弹幕
    //[_StageView setStageValue:dict];
    _StageView.StageInfoDict=self.StageInfoDict;
    [_StageView configStageViewforStageInfoDict];
    
    float  ImageWith=[self.StageInfoDict.w floatValue]; //[[self.StageInfoDict objectForKey:@"w"]  floatValue];
    float  ImgeHight=[self.StageInfoDict.h floatValue];//[[self.StageInfoDict objectForKey:@"h"]  floatValue];
    float hight=0;
    if (ImageWith>ImgeHight) {
        hight= kDeviceWidth;  // 计算的事bgview1的高度
    }
    else if(ImgeHight>ImageWith)
    {
        hight=  (ImgeHight/ImageWith) *kDeviceWidth;
    }
    _StageView.frame=CGRectMake(0, 0, kDeviceWidth, hight);
    BgView2.frame=CGRectMake(0, hight, kDeviceWidth, 45);
    _StageView.isAnimation = YES;
    
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
}

#pragma mark ---
#pragma mark ------下方按钮点击事件
#pragma mark ------
-(void)ScreenButtonClick:(UIButton  *) button
{
   //分享
}
-(void)addMarkButtonClick:(UIButton  *) button
{
    //添加弹幕
    
}

@end
