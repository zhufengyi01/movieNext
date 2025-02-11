//
//  CommonStageCell.m
//  movienext
//
//  Created by 风之翼 on 15/3/3.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "CommonStageCell.h"
#import "Constant.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "Function.h"
#import "ZCControl.h"
//#import "MarkView.h"
@implementation CommonStageCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[ super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        m_frame=self.frame;
        [self CreateUI];
    }
    return self;
}
-(void)CreateUI
{
    self.backgroundColor=View_BackGround;
     BgView =[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, kDeviceWidth-10, kStageWidth+45)];
    
     BgView.clipsToBounds=YES;
    BgView.layer.cornerRadius=4;
    BgView.clipsToBounds=YES;
    BgView.userInteractionEnabled=YES;
    [self.contentView addSubview:BgView];
    
    //上部视图，包含头像，点赞
    //[self CreateTopView];
    //中间的stageview 视图
    [self CreateSatageView];
      //底部视图
    [self createButtomView];
  
}
-(void)CreateTopView
{
    BgView0 =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kStageWidth,45)];
    BgView0.backgroundColor=View_ToolBar;
    BgView0.userInteractionEnabled=YES;
    [BgView addSubview:BgView0];
    
    
}

-(void)CreateSatageView
{
    _stageView=[[StageView alloc]initWithFrame:CGRectMake(0,0, kStageWidth, kStageWidth)];
    _stageView.backgroundColor=VStageView_color;
   // _stageView.layer.cornerRadius=4;
    //_stageView.clipsToBounds=YES;
    _stageView.delegate=self;
    _stageView.userInteractionEnabled=YES;
    [BgView addSubview:_stageView];
  
}

-(void)createButtomView
{
    BgView2=[[UIView alloc]initWithFrame:CGRectMake(0, kStageWidth, kStageWidth, 45)];
    //改变toolar 的颜色
    BgView2.backgroundColor=View_ToolBar;
    [BgView addSubview:BgView2];
 
    leftButtomButton=[UIButton buttonWithType:UIButtonTypeCustom];
    leftButtomButton.frame=CGRectMake(10, 9, 140, 27);
    [leftButtomButton addTarget:self action:@selector(cellButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [leftButtomButton setBackgroundImage:[[UIImage imageNamed:@"movie_button_bg"] stretchableImageWithLeftCapWidth:15 topCapHeight:15] forState:UIControlStateNormal];
    [BgView2 addSubview:leftButtomButton];
    
    MovieLogoImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,30, 27)];
    MovieLogoImageView.layer.cornerRadius=4;
    MovieLogoImageView.contentMode=UIViewContentModeScaleAspectFill;
    MovieLogoImageView.layer.masksToBounds = YES;
    [leftButtomButton addSubview:MovieLogoImageView];
    
    movieNameLable =[[UILabel alloc]initWithFrame:CGRectMake(35, 0, 120, 27)];
    movieNameLable.font=[UIFont systemFontOfSize:16];
    movieNameLable.textColor=VGray_color;
    // movieNameLable.numberOfLines=1;
    movieNameLable.lineBreakMode=NSLineBreakByTruncatingTail;
    [leftButtomButton addSubview:movieNameLable];
    
   
    
    //更多
    moreButton=[ZCControl createButtonWithFrame:CGRectMake(kStageWidth-135, 9, 30, 25) ImageName:@"more_icon_default.png" Target:self Action:@selector(cellButtonClick:) Title:@""];
    //moreButton.backgroundColor=VBlue_color;
    moreButton.layer.cornerRadius=2;
     moreButton.hidden=NO;
    [BgView2 addSubview:moreButton];
    
    
    //分享
    ScreenButton =[ZCControl createButtonWithFrame:CGRectMake(kStageWidth-95,9,30,25) ImageName:@"btn_share_default.png" Target:self Action:@selector(cellButtonClick:) Title:@""];
   // [ScreenButton setBackgroundImage:[UIImage imageNamed:@"btn_share_select.png"] forState:UIControlStateHighlighted];
    [ScreenButton setBackgroundImage:[UIImage imageNamed:@"btn_share_select.png"] forState:UIControlStateNormal];
    [BgView2 addSubview:ScreenButton];

     _tanlogoButton =[UIButton buttonWithType:UIButtonTypeCustom];
    _tanlogoButton.frame=CGRectMake(kStageWidth-100, 9, 45, 25);
    [_tanlogoButton setImage:[UIImage imageNamed:@"closed_icon_default.png"] forState:UIControlStateNormal];
    [_tanlogoButton setImage:[UIImage imageNamed:@"open_danmu.png.png"] forState:UIControlStateSelected];
    [_tanlogoButton addTarget:self action:@selector(hidenAndShowMarkView:) forControlEvents:UIControlEventTouchUpInside];
   // [BgView2 addSubview:_tanlogoButton];

    //添加弹幕
    addMarkButton =[ZCControl createButtonWithFrame:CGRectMake(kStageWidth-55,9,45,25) ImageName:@"btn_add_default.png" Target:self Action:@selector(cellButtonClick:) Title:@""];
    [addMarkButton setBackgroundImage:[UIImage imageNamed:@"btn_add_select.png"] forState:UIControlStateHighlighted];
    [BgView2 addSubview:addMarkButton];
    

    //底部2像素的投影
    UIImageView *lineImage =[[UIImageView alloc]initWithFrame:CGRectMake(0,44, kDeviceWidth, 2)];
    lineImage.image=[UIImage imageNamed:@"cell_buttom_line.png"];
    //[BgView2 addSubview:lineImage];
}
- (void)awakeFromNib {
    // Initialization code
}
-(void)ConfigsetCellindexPath:(NSInteger)row{
    self.Cellindex=row;
    leftButtomButton.tag=1000;
    ScreenButton.tag=2000;
    addMarkButton.tag=3000;
    UserLogoButton.tag=4000;
    deletButton.tag=5000;
    moreButton.tag=6000;
    
#pragma mark  configDatawithSatgeView------------------------------
   //单个标签的时候用这个
     if (self.weiboInfo) {
         _stageView.weiboinfo = self.weiboInfo;
     }
    // 多个标签用这个
     if (self.weibosArray.count>0) {
         _stageView.weibosArray = self.weibosArray;
     }
    _stageView.stageInfo=self.stageInfo;
    [_stageView configStageViewforStageInfoDict];

#pragma  mark 通用的cell底部数据的设置
    //设置底部
    if (self.stageInfo.movieInfo.name) {  //电影名字，s这里设置title 偏移
        NSString  *nameStr=self.stageInfo.movieInfo.name;
        float  nameW =kDeviceWidth*0.36;
        
        CGSize  Nsize =[nameStr boundingRectWithSize:CGSizeMake(nameW, 27) options:(NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin) attributes:[NSDictionary dictionaryWithObject:movieNameLable.font forKey:NSFontAttributeName] context:nil].size;
        movieNameLable.frame=CGRectMake(35, 0, Nsize.width+4, 27);
        leftButtomButton.frame=CGRectMake(10, 9, 30+5+movieNameLable.frame.size.width, 27);
         movieNameLable.text=[NSString stringWithFormat:@"%@",nameStr];
    }
    
    if (self.stageInfo.movieInfo.logo) {
        NSString  *logoString =[NSString stringWithFormat:@"%@%@!w100h100",kUrlMoviePoster,self.stageInfo.movieInfo.logo];
        [MovieLogoImageView sd_setImageWithURL:[NSURL URLWithString:logoString] placeholderImage:[UIImage imageNamed:@"loading_image_all.png"]];
    }
    
   // leftButtomButton.frame=
    
    
#pragma  mark  根据不同cell 配置cell 的样式------------------------------
#pragma  mark  热门cell
    if (_pageType==NSPageSourceTypeMainHotController||_pageType==NSPageSourceTypeMainNewController) {  //热门
         _stageView.isAnimation = YES;
        
    }
#pragma mark 首页最新,我的添加，赞 cell
    else if( _pageType==NSPageSourceTypeMyAddedViewController || _pageType==NSPageSourceTypeMyupedViewController)  //最新
    {
        if (_pageType==NSPageSourceTypeMainNewController) {
            
        }
         _stageView.isAnimation=NO;
        if (_pageType==NSPageSourceTypeMyupedViewController) {
            moreButton.hidden=YES;
        }
    }
    
}


#pragma mark 点击屏幕显示和隐藏marview
//显示隐藏markview
-(void)hidenAndShowMarkView:(UIButton *) button
{
    [self.stageView showAndHidenMarkView:button.selected];
    if (button.selected==NO) {
        NSLog(@"执行了隐藏 view ");
        button.selected=YES;
        //[self.stageView showAndHidenMarkView:NO];
        for (id view  in self.stageView.subviews) {
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
        //[self.stageView showAndHidenMarkView:NO];
        for (id   view  in self.stageView.subviews) {
            if  ([view isKindOfClass:[MarkView class]]) {
                MarkView  *mv =(MarkView *)view;
                mv.hidden=NO;
            }
        }
    }
    
}

-(void)showAndHidenMarkViews:(BOOL) isShow
{
    [self.stageView showAndHidenMarkView:isShow];
    
    if (isShow==NO) {
        NSLog(@"执行了隐藏 view ");
          for (id view  in self.stageView.subviews) {
            if  ([view isKindOfClass:[MarkView class]]) {
                MarkView  *mv =(MarkView *)view;
                mv.hidden=YES;
            }
        }
    }
    else if (isShow==YES)
    {
        NSLog(@"执行了显示view ");
         for (id   view  in self.stageView.subviews) {
            if  ([view isKindOfClass:[MarkView class]]) {
                MarkView  *mv =(MarkView *)view;
                mv.hidden=NO;
            }
        }
    }
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    
}
#pragma mark ---
#pragma mark ------下方按钮点击事件 ,在父视图中实现具法代理方法
-(void)cellButtonClick:(UIButton*)button
{
    if (self.delegate &&[self.delegate respondsToSelector:@selector(commonStageCellToolButtonClick:Rowindex:)]) {
        [self.delegate commonStageCellToolButtonClick:button Rowindex:self.Cellindex];
    }
    
}
////长安显示了
//-(void)logPress:(UILongPressGestureRecognizer *) logPress
//{
//    //开始
//    if(logPress.state==UIGestureRecognizerStateBegan)
//    {
//        if (self.delegate&&[self.delegate respondsToSelector:@selector(commonStageCellLoogPressClickindex:)]) {
//            [self.delegate commonStageCellLoogPressClickindex:pressview.tag];
//        }
//        
//    }
//    
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
