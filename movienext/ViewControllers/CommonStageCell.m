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
     BgView =[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, kDeviceWidth-10, kStageWidth+90)];
    
     BgView.clipsToBounds=YES;
    BgView.layer.cornerRadius=4;
    BgView.clipsToBounds=YES;
    BgView.userInteractionEnabled=YES;
    BgView.backgroundColor=[UIColor whiteColor];
    [self.contentView addSubview:BgView];
    
    //上部视图，包含头像，点赞
    //[self CreateTopView];
    //中间的stageview 视图
    [self CreateSatageView];
    [self createTagView];
      //底部视图
    [self createButtomView];
  
}
-(void)CreateTopView
{
    BgView0 =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kStageWidth,45)];
    BgView0.backgroundColor=View_ToolBar;
    BgView0.userInteractionEnabled=YES;
    [BgView addSubview:BgView0];
    
    
//    MovieLogoImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10,7.5,30, 30)];
//    MovieLogoImageView.layer.cornerRadius=4;
//    MovieLogoImageView.layer.masksToBounds = YES;
//    [BgView0 addSubview:MovieLogoImageView];
//    
//    movieNameLable =[[UILabel alloc]initWithFrame:CGRectMake(45, 7.5, 120, 30)];
//    movieNameLable.font=[UIFont systemFontOfSize:16];
//    movieNameLable.textColor=VGray_color;
//   // movieNameLable.numberOfLines=1;
//    movieNameLable.lineBreakMode=NSLineBreakByTruncatingTail;
//    [BgView0 addSubview:movieNameLable];
//    
//    leftButtomButton=[UIButton buttonWithType:UIButtonTypeCustom];
//    leftButtomButton.frame=CGRectMake(10, 5, 200, 35);
//    //leftButtomButton.backgroundColor=[[UIColor redColor]colorWithAlphaComponent:0.2];
//     [leftButtomButton addTarget:self action:@selector(cellButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//     [BgView0 addSubview:leftButtomButton];
    
}

-(void)CreateSatageView
{
    _stageView=[[StageView alloc]initWithFrame:CGRectMake(0,0, kStageWidth, 310*(9.0/16))];
    _stageView.backgroundColor=VStageView_color;
   // _stageView.layer.cornerRadius=4;
    //_stageView.clipsToBounds=YES;
    _stageView.delegate=self;
    _stageView.userInteractionEnabled=YES;
    [BgView addSubview:_stageView];
  
}
-(void)createTagView
{
 
    tagView =[[UIView alloc]initWithFrame:CGRectMake(0,310*(9.0/16), kStageWidth,45)];
    tagView.backgroundColor=[UIColor whiteColor];
    tagView.userInteractionEnabled=YES;
    [BgView addSubview:tagView];
    
    
     marklable =[ZCControl  createLabelWithFrame:CGRectMake(10, 10, 10, 10) Font:16 Text:@""];
    marklable.textColor=VGray_color;
    [tagView addSubview:marklable];
}

-(void)createButtomView
{
    BgView2=[[UIView alloc]initWithFrame:CGRectMake(0, 310*(9.0/16), kStageWidth, 45)];
    //改变toolar 的颜色
    BgView2.backgroundColor=[UIColor whiteColor];
    [BgView addSubview:BgView2];
 
    MovieLogoImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10,7.5,30, 30)];
    MovieLogoImageView.layer.cornerRadius=4;
    MovieLogoImageView.layer.masksToBounds = YES;
    [BgView2 addSubview:MovieLogoImageView];
    
    movieNameLable =[[UILabel alloc]initWithFrame:CGRectMake(45, 7.5, 120, 30)];
    movieNameLable.font=[UIFont systemFontOfSize:16];
    movieNameLable.textColor=VGray_color;
    // movieNameLable.numberOfLines=1;
    movieNameLable.lineBreakMode=NSLineBreakByTruncatingTail;
    [BgView2 addSubview:movieNameLable];
    
    leftButtomButton=[UIButton buttonWithType:UIButtonTypeCustom];
    leftButtomButton.frame=CGRectMake(10, 5, 140, 35);
    //leftButtomButton.backgroundColor=[[UIColor redColor]colorWithAlphaComponent:0.2];
    [leftButtomButton addTarget:self action:@selector(cellButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [BgView2 addSubview:leftButtomButton];
    
    
    
    //更多
    moreButton=[ZCControl createButtonWithFrame:CGRectMake(kStageWidth-95, 9, 30, 25) ImageName:@"more_icon.png" Target:self Action:@selector(cellButtonClick:) Title:@""];
    //moreButton.backgroundColor=VBlue_color;
    moreButton.layer.cornerRadius=2;
     moreButton.hidden=NO;
    [BgView2 addSubview:moreButton];

    
    
//    //分享
//    ScreenButton =[ZCControl createButtonWithFrame:CGRectMake(kDeviceWidth-120,9,45,25) ImageName:@"btn_share_default.png" Target:self Action:@selector(cellButtonClick:) Title:@""];
//    [ScreenButton setBackgroundImage:[UIImage imageNamed:@"btn_share_select.png"] forState:UIControlStateHighlighted];
//    [BgView2 addSubview:ScreenButton];

    
//    if (_tanlogoButton) {
//        [_tanlogoButton removeFromSuperview];
//        _tanlogoButton=nil;
//    }
//    _tanlogoButton =[UIButton buttonWithType:UIButtonTypeCustom];
//    _tanlogoButton.frame=CGRectMake(kStageWidth-100, 9, 45, 25);
//    [_tanlogoButton setImage:[UIImage imageNamed:@"close_danmu.png"] forState:UIControlStateNormal];
//    [_tanlogoButton setImage:[UIImage imageNamed:@"open_danmu.png.png"] forState:UIControlStateSelected];
//    [_tanlogoButton addTarget:self action:@selector(hidenAndShowMarkView:) forControlEvents:UIControlEventTouchUpInside];
//    [BgView2 addSubview:_tanlogoButton];

    //添加弹幕
    addMarkButton =[ZCControl createButtonWithFrame:CGRectMake(kStageWidth-55,9,45,25) ImageName:@"btn_add_default.png" Target:self Action:@selector(cellButtonClick:) Title:@""];
    [addMarkButton setBackgroundImage:[UIImage imageNamed:@"btn_add_select.png"] forState:UIControlStateHighlighted];
    [BgView2 addSubview:addMarkButton];
    
    UserDataCenter  *userCenter=[UserDataCenter shareInstance];
    if ([userCenter.is_admin intValue]>0) {
        //创建长按手势
        pressview=[[UIView alloc]initWithFrame:CGRectMake(ScreenButton.frame.origin.x-50, ScreenButton.frame.origin.y, 50,30)];
        [BgView2 addSubview:pressview];
        UILongPressGestureRecognizer   *longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(logPress:)];
        [pressview addGestureRecognizer:longPress];

    }
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
         movieNameLable.text=[NSString stringWithFormat:@"%@",nameStr];
    }
    
    if (self.stageInfo.movieInfo.logo) {
        NSString  *logoString =[NSString stringWithFormat:@"%@%@!w100h100",kUrlMoviePoster,self.stageInfo.movieInfo.logo];
        [MovieLogoImageView sd_setImageWithURL:[NSURL URLWithString:logoString] placeholderImage:[UIImage imageNamed:@"loading_image_all.png"]];
    }
    
    marklable.text=self.weiboInfo.content;
    if (tagLable) {
        [tagLable removeFromSuperview];
        tagLable=nil;
    }
    if (self.weiboInfo.tagArray&&self.weiboInfo.tagArray.count) {
        tagLable =[[M80AttributedLabel alloc]initWithFrame:CGRectMake(0,10,200,TagHeight)];
        tagLable.backgroundColor =[UIColor clearColor];
        for (int i=0; i<self.weiboInfo.tagArray.count; i++) {
            TagView *tagview = [self createTagViewWithtagInfo:self.weiboInfo.tagArray[i] andIndex:i];
            [tagLable appendView:tagview margin:UIEdgeInsetsMake(0, 0, 0, 10)];
        }
        [tagView addSubview:tagLable];
    }

    
#pragma  mark  根据不同cell 配置cell 的样式------------------------------
#pragma  mark  热门cell
    if (_pageType==NSPageSourceTypeMainHotController) {  //热门
         _stageView.isAnimation = YES;
    }
#pragma mark 首页最新,我的添加，赞 cell
    else if(_pageType==NSPageSourceTypeMainNewController || _pageType==NSPageSourceTypeMyAddedViewController || _pageType==NSPageSourceTypeMyupedViewController)  //最新
    {
         pressview.hidden=YES;
        if (_pageType==NSPageSourceTypeMainNewController) {
            pressview.hidden=NO;
        }
         _stageView.isAnimation=NO;
    }
    else
    {
        
    }
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
        for (UIView  *view  in self.stageView.subviews) {
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
        for (UIView  *view  in self.stageView.subviews) {
            if  ([view isKindOfClass:[MarkView class]]) {
                MarkView  *mv =(MarkView *)view;
                mv.hidden=NO;
            }
        }
    }
    
}


- (void)layoutSubviews {
    [super layoutSubviews];
    BgView.frame=CGRectMake(5,5, kStageWidth, self.frame.size.height-10);
    tagView.frame=CGRectMake(0, 310*(9.0/16), kStageWidth, self.frame.size.height-(310*(9.0/16)-45));
    
    NSString  *contString =self.weiboInfo.content;
    CGSize size =[contString boundingRectWithSize:CGSizeMake(kStageWidth-20, MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:16] forKey:NSFontAttributeName] context:nil].size;
    marklable.frame=CGRectMake(10, 10,kStageWidth-20, size.height);
    tagLable.frame=CGRectMake(10,marklable.frame.origin.y+marklable.frame.size.height+10, kStageWidth-20, TagHeight+10);
    BgView2.frame=CGRectMake(0,self.frame.size.height-45-10, kStageWidth, 45);
    
    
}
#pragma mark ---
#pragma mark ------下方按钮点击事件 ,在父视图中实现具法代理方法
-(void)cellButtonClick:(UIButton*)button
{
    
    if (self.delegate &&[self.delegate respondsToSelector:@selector(commonStageCellToolButtonClick:Rowindex:)]) {
        [self.delegate commonStageCellToolButtonClick:button Rowindex:self.Cellindex];
    }
    
}
//标签的点击事件
-(void)TapViewClick:(TagView*)TagView Withweibo:(weiboInfoModel *)weiboInfo withTagInfo:(TagModel *)tagInfo
{
    if (self.delegate &&[self.delegate respondsToSelector:@selector(cellTapViewClick:withWeibo:withTagInfo:)]) {
        [self.delegate cellTapViewClick:TagView withWeibo:weiboInfo withTagInfo:tagInfo];
    }
    
}
//长安显示了
-(void)logPress:(UILongPressGestureRecognizer *) logPress
{
    //开始
    if(logPress.state==UIGestureRecognizerStateBegan)
    {
        if (self.delegate&&[self.delegate respondsToSelector:@selector(commonStageCellLoogPressClickindex:)]) {
            [self.delegate commonStageCellLoogPressClickindex:pressview.tag];
        }
        
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
