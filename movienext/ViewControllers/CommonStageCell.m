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
    BgView0 =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 0)];
    BgView0.backgroundColor=View_ToolBar;
    [self.contentView addSubview:BgView0];
    
    UserLogoButton =[ZCControl createButtonWithFrame:CGRectMake(10, 8, 30, 30) ImageName:nil Target:self Action:@selector(cellButtonClick:) Title:@"头像"];
    UserLogoButton.layer.cornerRadius=4;
    UserLogoButton.layer.masksToBounds = YES;
    [BgView0 addSubview:UserLogoButton];
    
    UserNameLable =[ZCControl createLabelWithFrame:CGRectMake(UserLogoButton.frame.origin.x + UserLogoButton.frame.size.width + 5, 8, 180, 15) Font:14 Text:@"名字"];
    UserNameLable.textColor=VGray_color;
    UserNameLable.numberOfLines = 1;
    [BgView0 addSubview:UserNameLable];
    
    TimeLable =[ZCControl createLabelWithFrame:CGRectMake(UserNameLable.frame.origin.x, 23, 140, 15) Font:12 Text:@"时间"];
    TimeLable.textColor=VGray_color;
    [BgView0 addSubview:TimeLable];
    
    deletButton=[ZCControl createButtonWithFrame:CGRectMake(kDeviceWidth-50, 10, 40, 27) ImageName:@"btn_delete.png" Target:self Action:@selector(cellButtonClick:) Title:@""];
    deletButton.layer.cornerRadius=2;
    //deletButton.backgroundColor=[UIColor redColor];
    deletButton.hidden=YES;
    //[ZanButton setBackgroundImage:[UIImage imageNamed:@"liked.png"] forState:UIControlStateSelected];
    [BgView0 addSubview:deletButton];
    
   
}

-(void)CreateSatageView
{
    _stageView=[[StageView alloc]initWithFrame:CGRectMake(0, 45, kDeviceWidth, 200)];
    _stageView.backgroundColor=VStageView_color;
    _stageView.delegate=self;
    _stageView.userInteractionEnabled=YES;
    [self.contentView addSubview:_stageView];
  
}

-(void)createButtomView
{
    BgView2=[[UIView alloc]initWithFrame:CGRectMake(0, kDeviceWidth, kDeviceWidth, 45)];
    //改变toolar 的颜色
    BgView2.backgroundColor=View_ToolBar;
    [self.contentView addSubview:BgView2];
    
    
    leftButtomButton=[UIButton buttonWithType:UIButtonTypeCustom];
    leftButtomButton.frame=CGRectMake(10, 10, 120, 26);
    [leftButtomButton setBackgroundImage:[[UIImage imageNamed:@"movie_icon_backgroud_color.png"]stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
    [leftButtomButton addTarget:self action:@selector(cellButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [leftButtomButton setTitleColor:VGray_color forState:UIControlStateNormal];
    [leftButtomButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 33, 0, 5)];
    leftButtomButton.titleLabel.font = [UIFont systemFontOfSize:13];
    leftButtomButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [BgView2 addSubview:leftButtomButton];
    
    MovieLogoImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,30, 26)];
    MovieLogoImageView.layer.cornerRadius=5;
    MovieLogoImageView.layer.masksToBounds = YES;
    [leftButtomButton addSubview:MovieLogoImageView];
    
    ScreenButton =[ZCControl createButtonWithFrame:CGRectMake(kDeviceWidth-140,10,60,26) ImageName:@"btn_share_default.png" Target:self Action:@selector(cellButtonClick:) Title:@""];
    [ScreenButton setBackgroundImage:[UIImage imageNamed:@"btn_share_select.png"] forState:UIControlStateHighlighted];
    [BgView2 addSubview:ScreenButton];

    addMarkButton =[ZCControl createButtonWithFrame:CGRectMake(kDeviceWidth-70,10,60,26) ImageName:@"btn_add_default.png" Target:self Action:@selector(cellButtonClick:) Title:@""];
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
   //单个标签的时候用这个
     if (_weiboDict) {
         _stageView.weiboDict = _weiboDict;
     }
    // 多个标签用这个
     if (_WeibosArray.count>0) {
         _stageView.WeibosArray = _WeibosArray;
     }
    _stageView.StageInfoDict=self.StageInfoDict;
    [_stageView configStageViewforStageInfoDict];
    //这里计算hight 图片的高度，主要是为了计算toolbar 的y轴坐标，真实赋值是在stageview
 #pragma mark 设置底部tool的图片，名字
    //设置底部
    if (self.StageInfoDict.movie_name) {  //电影名字，这里设置title 偏移
        [leftButtomButton setTitle:self.StageInfoDict.movie_name forState:UIControlStateNormal];
    }
    
    if (self.StageInfoDict.stage) {
        [MovieLogoImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@!w100h100",kUrlMoviePoster,self.StageInfoDict.movie_poster] ] placeholderImage:[ UIImage imageNamed:@"loading_image_all.png"]];
    }
    
#pragma  mark  热门cell
    if (_pageType==NSPageSourceTypeMainHotController) {  //热门
         BgView0.frame=CGRectMake(0, 0, 0, 0);
        BgView0.hidden=YES;
        _stageView.frame=CGRectMake(0, 0, kDeviceWidth, kDeviceWidth);
        BgView2.frame=CGRectMake(0,kDeviceWidth,kDeviceWidth, 45);
        
        //这里设置为了表示气泡是可以移动的
        _stageView.isAnimation = YES;
    }
#pragma mark 首页最新,我的添加，赞 cell
    else if(_pageType==NSPageSourceTypeMainNewController || _pageType==NSPageSourceTypeMyAddedViewController || _pageType==NSPageSourceTypeMyupedViewController)  //最新
    {
        BgView0.hidden=NO;
        BgView0.frame=CGRectMake(0, 0, kDeviceWidth, 45);
        _stageView.frame=CGRectMake(0, 45, kDeviceWidth, kDeviceWidth);
        _stageView.isAnimation=NO;
        BgView2.frame=CGRectMake(0, kDeviceWidth+45,kDeviceWidth,45);
        pressview.hidden=YES;
        [UserLogoButton sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@!thumb", kUrlAvatar, _weiboDict.avatar]] forState:UIControlStateNormal];
        UserNameLable.text = _weiboDict.username;
        TimeLable.text = [Function friendlyTime:_weiboDict.create_time];
        // 点赞按钮的状态
        if ([self.weiboDict.uped  intValue]==0) {
            ZanButton.selected=NO;
        }
        else
        {
            ZanButton.selected=YES;
        }
#pragma mark 区分于个人页面是来源于自己还是他人
        if (self.userPage==NSUserPageTypeMySelfController ) {  //进来的页面是从我自己的页面进来的
            deletButton.hidden=NO;
        }
        else
        {
            deletButton.hidden=YES;
        }
    }
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    
}
#pragma mark ---
#pragma mark ------下方按钮点击事件 ,在父视图中实现具体的方法
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
            //pressView.tag=7000+row
            [self.delegate commonStageCellLoogPressClickindex:pressview.tag];
        }
        
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
