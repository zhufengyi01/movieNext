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
    UserLogoButton =[ZCControl createButtonWithFrame:CGRectMake(10, 6, 25, 25) ImageName:nil Target:self.superview Action:@selector(UserLogoButtonClick:) Title:@"头像"];
    UserLogoButton.layer.cornerRadius=2;
    [BgView0 addSubview:UserLogoButton];
    
    UserNameLable =[ZCControl createLabelWithFrame:CGRectMake(35, 5, 140, 20) Font:14 Text:@"名字"];
    UserNameLable.textColor=VGray_color;
    [BgView0 addSubview:UserNameLable];
    
    TimeLable =[ZCControl createLabelWithFrame:CGRectMake(35, 25, 140, 20) Font:12 Text:@"时间"];
    TimeLable.textColor=VGray_color;
    [BgView0 addSubview:TimeLable];
    
    ZanButton =[ZCControl createButtonWithFrame:CGRectMake(kDeviceWidth-70, 10, 40, 25) ImageName:@"like.png" Target:self.superview Action:@selector(UserLogoButtonClick:) Title:@""];
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
    leftButtomButton.frame=CGRectMake(10, 8, 140, 30);
    [leftButtomButton setBackgroundImage:[[UIImage imageNamed:@"movie_icon_backgroud_color.png"]stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
    [leftButtomButton addTarget:self action:@selector(dealMovieButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [leftButtomButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftButtomButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 30, 0, 0)];
    leftButtomButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [BgView2 addSubview:leftButtomButton];
    
    MovieLogoImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,30, 30)];
    MovieLogoImageView.layer.cornerRadius=5;
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
        
     //遍历bgview1，删除bgview 的子视图
        /*
        for (UIView  *Mview in  BgView1.subviews) {
            if ([Mview isKindOfClass:[MarkView class]]) {
                [Mview  removeFromSuperview];
            }
        }
         */
        
        /*
        for ( int i=0;i<_WeibosArray.count ; i++) {
        
            MarkView *markView=[[MarkView alloc]initWithFrame:CGRectMake(10, 10, 100, 30)];

#warning 暂时设为YES
            //markView.clipsToBounds = YES;
            markView.tag=1000+i;
           [BgView1 addSubview:markView];
                    
            NSDictionary  *weibodict=[NSDictionary dictionaryWithDictionary:[_WeibosArray  objectAtIndex:i]];
            float  x=[[weibodict objectForKey:@"x"]floatValue ];
            float  y=[[weibodict objectForKey:@"y"]floatValue ];
            NSLog(@" ==== =mark  view  ===%f  ==== mark view =====%f",x,y);
            NSString  *weiboTitleString=[weibodict  objectForKey:@"topic"];
            NSString  *UpString=[weibodict objectForKey:@"ups"];
            NSLog(@"weibo dict ======%@",weibodict);
            
            
            
            //计算标题的size
            CGSize  Msize=[weiboTitleString boundingRectWithSize:CGSizeMake(kDeviceWidth/2,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:markView.TitleLable.font forKey:NSFontAttributeName] context:nil].size;
            // 计算赞数量的size
            CGSize Usize=[UpString boundingRectWithSize:CGSizeMake(40,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:markView.ZanNumLable.font forKey:NSFontAttributeName] context:nil].size;
          
        
            NSLog(@"size= %f %f", Msize.width, Msize.height);
            //计算赞数量的长度
            float  Uwidth=[UpString floatValue]==0?0:Usize.width;
            //宽度=字的宽度+左头像图片的宽度＋赞图片的宽度＋赞数量的宽度+中间两个空格2+2
            //位置=
            float markViewWidth = Msize.width+23+Uwidth+5+5+11+5;
            float markViewHeight = Msize.height+15;
            float markViewX = (x*kDeviceWidth)/100-markViewWidth;
            markViewX = MIN(MAX(markViewX, 0.0f), kDeviceWidth-markViewWidth);
            
            float markViewY = (y*kDeviceWidth)/100+(Msize.height/2);
#warning    kDeviceWidth 目前计算的是正方形的，当图片高度>屏幕的宽度的实际，需要使用图片的高度
            markViewY = MIN(MAX(markViewY, markViewHeight/2), kDeviceWidth-markViewHeight);
            
            markView.frame=CGRectMake(markViewX, markViewY, markViewWidth, markViewHeight);
          
            markView.TitleLable.text=weiboTitleString;
            ///显示标签的头像
            [ markView.LeftImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kUrlAvatar,[weibodict objectForKey:@"avatar"]]]];
            
            markView.ZanNumLable.text=[weibodict objectForKey:@"ups"];
            markView.isAnimation = YES;
            
      
        }
         */

        
    }
#pragma mark 最新cell
    else if(_pageType==NSPageSourceTypeMainNewController)  //最新
    {
        /*
        BgView0.hidden=NO;
        BgView0.frame=CGRectMake(0, 0, kDeviceWidth, 45);
        BgView1.frame=CGRectMake(0, 45, kDeviceWidth, hight);
        BgView2.frame=CGRectMake(0, kDeviceWidth+45, kDeviceWidth, 45);
        if ([dict objectForKey:@"stage"]) {
            [MovieLogoImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@!w100h100",kUrlMoviePoster,[dict objectForKey:@"movie_poster"]]] placeholderImage:[ UIImage imageNamed:@"loading_image_all.png"]];
        }
        float  x=[[_weiboDict objectForKey:@"x"]floatValue ];
        float  y=[[_weiboDict objectForKey:@"y"]floatValue ];
        //遍历bgview1，删除bgview 的子视图
        for (UIView  *Mview in  BgView1.subviews) {
            if ([Mview isKindOfClass:[MarkView class]]) {
                [Mview  removeFromSuperview];
            }
        }
        //  创建静态标签
        MarkView *markView=[[MarkView alloc]initWithFrame:CGRectMake(10, 10, 100, 30)];
       // markView.TitleLable.frame=CGRectMake(0,0, Msize.width ,Msize.height);
         markView.rightView.layer.borderWidth=1;
        markView.rightView.layer.borderColor=VBlue_color.CGColor;
        [BgView1 addSubview:markView];
        
       
        NSString  *weiboTitleString=[_weiboDict objectForKey:@"topic"];
        NSString  *UpString=[_weiboDict objectForKey:@"ups"];
        //宽度屏幕1/2
        CGSize  Msize=[weiboTitleString boundingRectWithSize:CGSizeMake(kDeviceWidth/2,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:markView.TitleLable.font forKey:NSFontAttributeName] context:nil].size;
        
        // 计算赞数量的size
        CGSize Usize=[UpString boundingRectWithSize:CGSizeMake(40,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:markView.ZanNumLable.font forKey:NSFontAttributeName] context:nil].size;
        
        
        NSLog(@"size= %f %f", Msize.width, Msize.height);
        //计算赞数量的长度
        float  Uwidth=[UpString floatValue]==0?0:Usize.width;
        //宽度=字的宽度+左头像图片的宽度＋赞图片的宽度＋赞数量的宽度+中间两个空格2+2
        //位置=
        float markViewWidth = Msize.width+23+Uwidth+5+5+11+5;
        float markViewHeight = Msize.height+15;
        float markViewX = (x*kDeviceWidth)/100-markViewWidth;
        markViewX = MIN(MAX(markViewX, 0.0f), kDeviceWidth-markViewWidth);
        
        float markViewY = (y*kDeviceWidth)/100+(Msize.height/2);
#warning    kDeviceWidth 目前计算的是正方形的，当图片高度>屏幕的宽度的实际，需要使用图片的高度
        markViewY = MIN(MAX(markViewY, markViewHeight/2), kDeviceWidth-markViewHeight);
        
        markView.frame=CGRectMake(markViewX, markViewY, markViewWidth, markViewHeight);
        
        markView.TitleLable.text=weiboTitleString;
        ///显示标签的头像
        [ markView.LeftImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kUrlAvatar,[_weiboDict objectForKey:@"avatar"]]]];
        
        markView.ZanNumLable.text=[_weiboDict objectForKey:@"ups"];
        */

        
        
        
        
    }

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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
