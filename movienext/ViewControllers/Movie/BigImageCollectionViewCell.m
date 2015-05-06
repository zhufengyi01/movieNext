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
    BgView =[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, kDeviceWidth-10, kStageWidth+90)];
    
    BgView.clipsToBounds=YES;
    BgView.layer.cornerRadius=4;
    BgView.clipsToBounds=YES;
    BgView.backgroundColor =[UIColor whiteColor];
    BgView.userInteractionEnabled=YES;
    [self.contentView addSubview:BgView];

    //[self CreateTopView];
    [self CreateSatageView];
    [self createTagView];
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
    _StageView=[[StageView alloc]initWithFrame:CGRectMake(0, 0, kStageWidth,kStageWidth*(9.0/16))];
    _StageView.backgroundColor=VStageView_color;
    
    [BgView addSubview:_StageView];
    
}
-(void)createTagView
{
    
    tagView =[[UIView alloc]initWithFrame:CGRectMake(0,310*(9.0/16), kStageWidth,45)];
    tagView.backgroundColor=[UIColor whiteColor];
    tagView.userInteractionEnabled=YES;
    [BgView addSubview:tagView];
    
    marklable =[ZCControl  createLabelWithFrame:CGRectMake(10, 10, 100, 10) Font:16 Text:@"wehlwehwehweh"];
    marklable.textColor=VGray_color;
    [tagView addSubview:marklable];
    
    
}

-(void)createButtonView
{
    BgView2=[[UIView alloc]initWithFrame:CGRectMake(0, kDeviceWidth, kDeviceWidth, 45)];
    BgView2.backgroundColor=[UIColor whiteColor];
    [BgView addSubview:BgView2];
    
    //更多
//    moreButton=[ZCControl createButtonWithFrame:CGRectMake(10, 9, 30, 25) ImageName:@"more_icon.png" Target:self Action:@selector(cellButtonClick:) Title:@""];
//    moreButton.layer.cornerRadius=2;
//    moreButton.hidden=NO;
//    moreButton.tag=4000;
    //[BgView2 addSubview:moreButton];
    

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
//    _tanlogoButton =[UIButton buttonWithType:UIButtonTypeCustom];
//    _tanlogoButton.frame=CGRectMake(moreButton.frame.origin.x+moreButton.frame.size.width+10, 5, 35, 35);
//    [_tanlogoButton setImage:[UIImage imageNamed:@"close_danmu.png"] forState:UIControlStateNormal];
//    [_tanlogoButton setImage:[UIImage imageNamed:@"open_danmu.png"] forState:UIControlStateSelected];
//    [_tanlogoButton addTarget:self action:@selector(hidenAndShowMarkView:) forControlEvents:UIControlEventTouchUpInside];
//    [BgView2 addSubview:_tanlogoButton];
//    
    marklable.text=self.weiboInfo.content;
    
    if (tagLable) {
        [tagLable removeFromSuperview];
        tagLable=nil;
    }
    if (self.weiboInfo.tagArray&&self.weiboInfo.tagArray.count) {
        for (int i=0; i<self.weiboInfo.tagArray.count; i++) {
            tagLable =[[M80AttributedLabel alloc]initWithFrame:CGRectMake(0,10,200,TagHeight)];
            tagLable.backgroundColor =[UIColor clearColor];

            TagView *tagview = [self createTagViewWithtagInfo:self.weiboInfo.tagArray[i] andIndex:i];
            [tagLable appendView:tagview margin:UIEdgeInsetsMake(0, 0, 0, 10)];
        }
        [tagView addSubview:tagLable];
    }
    
    
    
    if (self.weibosArray) {
        _StageView.weibosArray = self.weibosArray;
    }
    _StageView.stageInfo=self.stageInfo;
    [_StageView configStageViewforStageInfoDict];
    _StageView.isAnimation = YES;
    
}

//创建标签的方法
-(TagView *)createTagViewWithtagInfo:(TagModel *) tagmodel andIndex:(NSInteger ) index
{
    
    TagView *tagview =[[TagView alloc]initWithFrame:CGRectZero];
    tagview.tag=1000+index;
    tagview.delegete=self;
    //设置是否可以点击
    [tagview setTagViewIsClick:YES];
    tagview.tagInfo=tagmodel;
    tagview.weiboInfo=self.weiboInfo;
    NSString *titleStr = tagmodel.tagDetailInfo.title;
    tagview.titleLable.text=titleStr;
    CGSize  Tsize =[titleStr boundingRectWithSize:CGSizeMake(MAXFLOAT, TagHeight) options:(NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin) attributes:[NSDictionary dictionaryWithObject:tagview.titleLable.font forKey:NSFontAttributeName] context:nil].size;
    tagview.frame=CGRectMake(0,0, Tsize.width+10, TagHeight+10);
    return tagview;
}



#pragma mark 点击屏幕显示和隐藏marview
//显示隐藏markview
-(void)hidenAndShowMarkView:(UIButton *) button
{
    if (button.selected==NO) {
        NSLog(@"执行了隐藏 view ");
        button.selected=YES;
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
    
    BgView.frame=CGRectMake(5,5, kStageWidth, self.frame.size.height-10);
    tagView.frame=CGRectMake(0, 310*(9.0/16), kStageWidth, self.frame.size.height-(310*(9.0/16)-45));
    
    NSString  *contString =self.weiboInfo.content;
    CGSize size =[contString boundingRectWithSize:CGSizeMake(kStageWidth-20, MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:16] forKey:NSFontAttributeName] context:nil].size;
    
    marklable.frame=CGRectMake(10, 10,kStageWidth-20, size.height);
    tagLable.frame=CGRectMake(10,marklable.frame.origin.y+marklable.frame.size.height+10, kStageWidth-20, TagHeight+10);
    BgView2.frame=CGRectMake(0,self.frame.size.height-45-10, kStageWidth, 45);
    
}

#pragma mark ---
#pragma mark ------下方按钮点击事件 ,在父视图中实现具体的方法
-(void)cellButtonClick:(UIButton*)button
{
    
    if (self.delegate &&[self.delegate respondsToSelector:@selector(BigImageCollectionViewCellToolButtonClick:Rowindex:)]) {
        [self.delegate BigImageCollectionViewCellToolButtonClick:button Rowindex:self.Cellindex];
    }
    
}
-(void)TapViewClick:(TagView *)tagView Withweibo:(weiboInfoModel *)weiboInfo withTagInfo:(TagModel *)tagInfo
{
 
    if (self.delegate &&[self.delegate respondsToSelector:@selector(BigcellTapViewClick:withWeibo:withTagInfo:)]) {
        [self.delegate BigcellTapViewClick:tagView withWeibo:weiboInfo withTagInfo:tagInfo];
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
