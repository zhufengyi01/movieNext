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
       // NSLog(@"=========打印cell 的frame ====%f");
        // 初始化放置标签的数组，每次创建的时候讲markview 添加到这个数组中
       // _MarkMuatableArray =[[NSMutableArray alloc]init];
        [self CreateUI];
    }
    return self;
}
-(void)CreateUI
{
    self.backgroundColor =[UIColor blackColor];
    //上部视图，包含头像，点赞
    [self CreateTopView];
    //中间的stageview 视图
    [self CreateSatageView];
      //底部视图
    [self createButtomView];
  
}
-(void)CreateTopView
{
    BgView0 =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth,45)];
    BgView0.backgroundColor=View_ToolBar;
    BgView0.userInteractionEnabled=YES;
    [self.contentView addSubview:BgView0];
    
    
    MovieLogoImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10,10,30, 26)];
    MovieLogoImageView.layer.cornerRadius=4;
    MovieLogoImageView.layer.masksToBounds = YES;
    [BgView0 addSubview:MovieLogoImageView];
    
    //movieNameLable=[ZCControl createLabelWithFrame:CGRectMake(50, 10, 120, 30) Font:16 Text:@""];
    movieNameLable =[[UILabel alloc]initWithFrame:CGRectMake(45, 10, 120, 26)];
    movieNameLable.font=[UIFont systemFontOfSize:16];
    movieNameLable.textColor=VGray_color;
   // movieNameLable.numberOfLines=1;
    movieNameLable.lineBreakMode=NSLineBreakByTruncatingTail;
    [BgView0 addSubview:movieNameLable];
    
    leftButtomButton=[UIButton buttonWithType:UIButtonTypeCustom];
    leftButtomButton.frame=CGRectMake(10, 5, 200, 35);
    //leftButtomButton.backgroundColor=[[UIColor redColor]colorWithAlphaComponent:0.2];
     [leftButtomButton addTarget:self action:@selector(cellButtonClick:) forControlEvents:UIControlEventTouchUpInside];
     [BgView0 addSubview:leftButtomButton];
    
}

-(void)CreateSatageView
{
    _stageView=[[StageView alloc]initWithFrame:CGRectMake(0, 45, kDeviceWidth, kDeviceWidth)];
    _stageView.backgroundColor=VStageView_color;
    _stageView.delegate=self;
    _stageView.userInteractionEnabled=YES;
    [self.contentView addSubview:_stageView];
  
}

-(void)createButtomView
{
    BgView2=[[UIView alloc]initWithFrame:CGRectMake(0, kDeviceWidth+45, kDeviceWidth, 45)];
    //改变toolar 的颜色
    BgView2.backgroundColor=[UIColor whiteColor];
    [self.contentView addSubview:BgView2];
 
    //更多
    moreButton=[ZCControl createButtonWithFrame:CGRectMake(10, 9, 40, 27) ImageName:@"btn_delete.png" Target:self Action:@selector(cellButtonClick:) Title:@""];
    moreButton.layer.cornerRadius=2;
     moreButton.hidden=NO;
    [BgView2 addSubview:moreButton];

    
    
    //分享
    ScreenButton =[ZCControl createButtonWithFrame:CGRectMake(kDeviceWidth-140,9,60,27) ImageName:@"btn_share_default.png" Target:self Action:@selector(cellButtonClick:) Title:@""];
    [ScreenButton setBackgroundImage:[UIImage imageNamed:@"btn_share_select.png"] forState:UIControlStateHighlighted];
    [BgView2 addSubview:ScreenButton];

    //添加弹幕
    addMarkButton =[ZCControl createButtonWithFrame:CGRectMake(kDeviceWidth-70,9,60,27) ImageName:@"btn_add_default.png" Target:self Action:@selector(cellButtonClick:) Title:@""];
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
    [BgView2 addSubview:lineImage];
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
    
        if (_tanlogoButton) {
             [_tanlogoButton removeFromSuperview];
            _tanlogoButton=nil;
        }
        _tanlogoButton =[UIButton buttonWithType:UIButtonTypeCustom];
        _tanlogoButton.frame=CGRectMake(kDeviceWidth-40, 5, 35, 35);
        [_tanlogoButton setImage:[UIImage imageNamed:@"close_danmu.png"] forState:UIControlStateNormal];
        [_tanlogoButton setImage:[UIImage imageNamed:@"open_danmu.png"] forState:UIControlStateSelected];
        [_tanlogoButton addTarget:self action:@selector(hidenAndShowMarkView:) forControlEvents:UIControlEventTouchUpInside];
       // [_tanlogoButton setTitleEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
        [self addSubview:_tanlogoButton];
          

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
 #pragma mark 区分于个人页面是来源于自己还是他人
//        if (self.userPage==NSUserPageTypeMySelfController ) {  //进来的页面是从我自己的页面进来的
//            deletButton.hidden=NO;
//        }
//        else
//        {
//            deletButton.hidden=YES;
//        }
    }
    else
    {
        
    }
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
    
    
}
#pragma mark ---
#pragma mark ------下方按钮点击事件 ,在父视图中实现具法代理方法
-(void)cellButtonClick:(UIButton*)button
{
    if (self.delegate &&[self.delegate respondsToSelector:@selector(commonStageCellToolButtonClick:Rowindex:)]) {
        [self.delegate commonStageCellToolButtonClick:button Rowindex:self.Cellindex];
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
