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
#import "MarkView.h"
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
    [self CreateTopView];
    [self createButtonView];
    [self CreateTopView0];
}
-(void)CreateTopView0
{
    BgView0 =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 0)];
    BgView0.backgroundColor=[UIColor whiteColor];
    [self.contentView addSubview:BgView0];
    
    UserLogoButton =[ZCControl createButtonWithFrame:CGRectMake(10, 8, 25, 25) ImageName:nil Target:self.superview Action:@selector(UserLogoButtonClick:) Title:@"头像"];
    UserLogoButton.layer.cornerRadius=2;
    UserLogoButton.layer.masksToBounds = YES;
    [BgView0 addSubview:UserLogoButton];
    
    UserNameLable =[ZCControl createLabelWithFrame:CGRectMake(UserLogoButton.frame.origin.x + UserLogoButton.frame.size.width + 3, 5, 180, 15) Font:14 Text:@"名字"];
    UserNameLable.textColor=VGray_color;
    UserNameLable.numberOfLines = 1;
    [BgView0 addSubview:UserNameLable];
    
    TimeLable =[ZCControl createLabelWithFrame:CGRectMake(UserNameLable.frame.origin.x, 20, 140, 15) Font:12 Text:@"时间"];
    TimeLable.textColor=VGray_color;
    [BgView0 addSubview:TimeLable];
    
    ZanButton =[ZCControl createButtonWithFrame:CGRectMake(kDeviceWidth-70, 10, 50, 25) ImageName:@"like.png" Target:self.superview Action:@selector(ZanButtonClick:) Title:@""];
    ZanButton.layer.cornerRadius=2;
    [ZanButton setBackgroundImage:[UIImage imageNamed:@"liked.png"] forState:UIControlStateSelected];
    [BgView0 addSubview:ZanButton];
}

-(void)CreateTopView
{
    _BgView1=[[StageView alloc]initWithFrame:CGRectMake(0, 45, kDeviceWidth, 200)];
    _BgView1.backgroundColor=[UIColor blackColor];
    [self.contentView addSubview:_BgView1];
    
    /*
    _MovieImageView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 200)];
    [BgView1 addSubview:_MovieImageView];
     */
 
}

-(void)createButtonView
{
    BgView2=[[UIView alloc]initWithFrame:CGRectMake(0, kDeviceWidth, kDeviceWidth, 45)];
    BgView2.backgroundColor=[UIColor whiteColor];
    [self.contentView addSubview:BgView2];
    
    //leftButtomButton =[ZCControl createButtonWithFrame:CGRectMake(10,8,100,30) ImageName:@"movie_icon_backgroud_color.png" Target:self.superview Action:@selector(dealMovieButtonClick:) Title:@"sd"];
    
    leftButtomButton=[UIButton buttonWithType:UIButtonTypeCustom];
    leftButtomButton.frame=CGRectMake(10, 8, 150, 30);
    [leftButtomButton setBackgroundImage:[[UIImage imageNamed:@"movie_icon_backgroud_color.png"]stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
    [leftButtomButton addTarget:self.superview action:@selector(dealMovieButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [leftButtomButton setTitleColor:VGray_color forState:UIControlStateNormal];
    [leftButtomButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 30, 0, 0)];
    leftButtomButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [BgView2 addSubview:leftButtomButton];
    
    MovieLogoImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,30, 30)];
    MovieLogoImageView.layer.cornerRadius=5;
    MovieLogoImageView.layer.masksToBounds = YES;
    [leftButtomButton addSubview:MovieLogoImageView];
    
    
    ScreenButton =[ZCControl createButtonWithFrame:CGRectMake(kDeviceWidth-150,10,60,25) ImageName:@"screen_shot share.png" Target:self.superview Action:@selector(ScreenButtonClick:) Title:@""];
    [BgView2 addSubview:ScreenButton];
    
    addMarkButton =[ZCControl createButtonWithFrame:CGRectMake(kDeviceWidth-75,10,60,25) ImageName:@"add.png" Target:self.superview Action:@selector(addMarkButtonClick:) Title:@""];
    [BgView2 addSubview:addMarkButton];
    
    
}
- (void)awakeFromNib {
    // Initialization code
}
-(void)setCellValue:(NSDictionary  *) dict indexPath:(NSInteger) row;
{
    if (_weiboDict) {
        _BgView1.weiboDict = _weiboDict;
    }
    
    if (_WeibosArray) {
        _BgView1.WeibosArray = _WeibosArray;
    }
    
    leftButtomButton.tag=1000+row;
    ScreenButton.tag=2000+row;
    addMarkButton.tag=3000+row;
    UserLogoButton.tag=4000+row;
    ZanButton.tag=5000+row;
    [_BgView1 setStageValue:dict];
    
    float  ImageWith=[[dict objectForKey:@"w"]  floatValue];
    float  ImgeHight=[[dict objectForKey:@"h"]  floatValue];
    float hight=0;
    if (ImageWith>ImgeHight) {
        hight= kDeviceWidth;
    }
    else if(ImgeHight>ImageWith)
    {
        hight=  (ImgeHight/ImageWith) *kDeviceWidth;
    }
    
   
    /*
    if ([dict  objectForKey:@"stage"]) {
        //计算位置
        float   y=(hight-(ImgeHight/ImageWith)*kDeviceWidth)/2;
          _MovieImageView.frame=CGRectMake(0,y, kDeviceWidth, (ImgeHight/ImageWith)*kDeviceWidth);
       [_MovieImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@!w640",kUrlStage,[dict objectForKey:@"stage"]]] placeholderImage:[UIImage imageNamed:@"loading_image_all.png"]];
     }
     */
    if ([dict  objectForKey:@"movie_name"]) {  //电影名字，这里设置title 偏移
        [leftButtomButton setTitle:[dict objectForKey:@"movie_name"] forState:UIControlStateNormal];
    }
    
#pragma  mark  热门cell
    if (_pageType  ==NSPageSourceTypeMainHotController) {  //热门
         BgView0.frame=CGRectMake(0, 0, 0, 0);
        BgView0.hidden=YES;
        _BgView1.frame=CGRectMake(0, 0, kDeviceWidth, hight);
        BgView2.frame=CGRectMake(0, kDeviceWidth, kDeviceWidth, 45);
        if ([dict objectForKey:@"stage"]) {
            [MovieLogoImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@!w100h100",kUrlMoviePoster,[dict objectForKey:@"movie_poster"]]] placeholderImage:[ UIImage imageNamed:@"loading_image_all.png"]];
        }
        _BgView1.isAnimation = YES;
    }
#pragma mark 最新cell
    else if(_pageType==NSPageSourceTypeMainNewController || _pageType==NSPageSourceTypeMyAddedViewController || _pageType==NSPageSourceTypeMyupedViewController)  //最新
    {
        BgView0.hidden=NO;
        BgView0.frame=CGRectMake(0, 0, kDeviceWidth, 45);
        _BgView1.frame=CGRectMake(0, 45, kDeviceWidth, hight);
        BgView2.frame=CGRectMake(0, kDeviceWidth+45, kDeviceWidth, 45);
        if ([dict objectForKey:@"stage"]) {
            [MovieLogoImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@!w100h100",kUrlMoviePoster,[dict objectForKey:@"movie_poster"]]] placeholderImage:[ UIImage imageNamed:@"loading_image_all.png"]];
        }
        
        [UserLogoButton sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@!thumb", kUrlAvatar, [_weiboDict objectForKey:@"avatar"]]] forState:UIControlStateNormal];
        UserNameLable.text = [_weiboDict objectForKey:@"username"];
        TimeLable.text = [Function friendlyTime:[_weiboDict objectForKey:@"create_time"]];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    
}

#pragma mark ---
#pragma mark ------下方按钮点击事件
#pragma mark ------
-(void)dealMovieButtonClick:(UIButton  *) button{
    
}
-(void)ScreenButtonClick:(UIButton  *) button
{
    
}
-(void)addMarkButtonClick:(UIButton  *) button
{
    
}
-(void)UserLogoButtonClick:(UIButton *) button
{
    
}
-(void)ZanButtonClick:(UIButton *)button
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
