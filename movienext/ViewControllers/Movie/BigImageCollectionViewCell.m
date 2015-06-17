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
    self.backgroundColor=View_BackGround;
    BgView =[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, kDeviceWidth-10, kDeviceWidth+90)];
    
    BgView.clipsToBounds=YES;
    BgView.layer.cornerRadius=4;
    BgView.clipsToBounds=YES;
    BgView.userInteractionEnabled=YES;
    [self.contentView addSubview:BgView];
    
    //[self CreateTopView];
    [self CreateSatageView];
    [self createButtonView];
    
}
/*
 -(void)CreateTopView
 {
 BgView0 =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth,45)];
 BgView0.backgroundColor=View_ToolBar;
 BgView0.userInteractionEnabled=YES;
 [BgView addSubview:BgView0];
 }*/

-(void)CreateSatageView
{
    _StageView=[[StageView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth,kDeviceWidth)];
    _StageView.backgroundColor=VStageView_color;
    [BgView addSubview:_StageView];
    
}
-(void)createButtonView
{
    BgView2=[[UIView alloc]initWithFrame:CGRectMake(0, kDeviceWidth, kDeviceWidth, 45)];
    BgView2.backgroundColor=[UIColor whiteColor];
    [BgView addSubview:BgView2];
    
    //更多
    moreButton=[ZCControl createButtonWithFrame:CGRectMake(10, 9, 30, 25) ImageName:@"more_icon.png" Target:self Action:@selector(cellButtonClick:) Title:@""];
    moreButton.layer.cornerRadius=2;
    moreButton.hidden=NO;
    moreButton.tag=4000;
    [BgView2 addSubview:moreButton];
    
    
    ScreenButton =[ZCControl createButtonWithFrame:CGRectMake(kDeviceWidth-120,10,45,25) ImageName:@"btn_share_default.png" Target:self Action:@selector(cellButtonClick:) Title:@""];
    ScreenButton.tag=2000;
    [BgView2 addSubview:ScreenButton];
    
    addMarkButton =[ZCControl createButtonWithFrame:CGRectMake(kDeviceWidth-65,10,45,25) ImageName:@"btn_add_default.png" Target:self Action:@selector(cellButtonClick:) Title:@""];
    addMarkButton.tag=3000;
    [BgView2 addSubview:addMarkButton];
    //底部2像素的投影
    UIImageView *lineImage =[[UIImageView alloc]initWithFrame:CGRectMake(0,44, kDeviceWidth, 2)];
    lineImage.image=[UIImage imageNamed:@"cell_buttom_line.png"];
    [BgView2 addSubview:lineImage];
    
    
    
}
- (void)awakeFromNib {
    // Initialization code
}
-(void)ConfigCellWithIndexPath:(NSInteger)row{
    self.Cellindex=row;
    if (_tanlogoButton) {
        [_tanlogoButton removeFromSuperview];
        _tanlogoButton=nil;
    }
    _tanlogoButton =[UIButton buttonWithType:UIButtonTypeCustom];
    _tanlogoButton.frame=CGRectMake(moreButton.frame.origin.x+moreButton.frame.size.width+10, 5, 35, 35);
    [_tanlogoButton setImage:[UIImage imageNamed:@"close_danmu.png"] forState:UIControlStateNormal];
    [_tanlogoButton setImage:[UIImage imageNamed:@"open_danmu.png"] forState:UIControlStateSelected];
    [_tanlogoButton addTarget:self action:@selector(hidenAndShowMarkView:) forControlEvents:UIControlEventTouchUpInside];
    [BgView2 addSubview:_tanlogoButton];
    
    
    
    if (self.weibosArray) {
        _StageView.weibosArray = self.weibosArray;
    }
    _StageView.stageInfo=self.stageInfo;
    [_StageView configStageViewforStageInfoDict];
    _StageView.isAnimation = YES;
    
}
#pragma mark 点击屏幕显示和隐藏marview
//显示隐藏markview
-(void)hidenAndShowMarkView:(UIButton *) button
{
    if (button.selected==NO) {
        NSLog(@"执行了隐藏 view ");
        button.selected=YES;
        [self.StageView  showAndHidenMarkView:YES];
        for (UIView  *view  in self.StageView.subviews) {
            if  ([view isKindOfClass:[MarkView class]]) {
                MarkView  *mv =(MarkView *)view;
                mv.hidden=YES;
            }
        }
    }
    else if (button.selected==YES)
    {
        NSLog(@"执行了显示view ");
        button.selected=NO;
        [self.StageView showAndHidenMarkView:NO];
        for (UIView  *view  in self.StageView.subviews) {
            if  ([view isKindOfClass:[MarkView class]]) {
                MarkView  *mv =(MarkView *)view;
                mv.hidden=NO;
            }
        }
    }
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // BgView2.frame=CGRectMake(0, kDeviceWidth, kDeviceWidth, 45);
    
}

#pragma mark ---
#pragma mark ------下方按钮点击事件 ,在父视图中实现具体的方法
-(void)cellButtonClick:(UIButton*)button
{
    if (self.delegate &&[self.delegate respondsToSelector:@selector(BigImageCollectionViewCellToolButtonClick:Rowindex:)]) {
        [self.delegate BigImageCollectionViewCellToolButtonClick:button Rowindex:self.Cellindex];
    }
    
}
-(void)ScreenButtonClick:(UIButton  *) button
{
    //分享
}
-(void)addMarkButtonClick:(UIButton  *) button
{
    //添加弹幕
    
}

@end
