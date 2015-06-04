//
//  ShowStageViewController.m
//  movienext
//
//  Created by 杜承玖 on 3/19/15.
//  Copyright (c) 2015 redianying. All rights reserved.
//

#import "ShowStageViewController.h"
#import "StageView.h"
#import "StageInfoModel.h"

#import "ZCControl.h"
#import "Constant.h"
#import "AddMarkViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UMSocial.h"
#import "StageView.h"
#import "ButtomToolView.h"
#import "AFNetworking.h"
#import "UserDataCenter.h"
#import "MyViewController.h"
#import "Function.h"
#import "UIImageView+WebCache.h"
#import "UMShareViewController.h"
#import "ScanMovieInfoViewController.h"
#import "UMShareViewController2.h"
#import "MovieDetailViewController.h"
#import "AppDelegate.h"
#import "UMShareView.h"
#import "UserDataCenter.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "M80AttributedLabel.h"
@interface ShowStageViewController() <ButtomToolViewDelegate,StageViewDelegate,AddMarkViewControllerDelegate,UMShareViewControllerDelegate,UMSocialDataDelegate,UMSocialUIDelegate,UIActionSheetDelegate,UMShareViewController2Delegate,UMShareViewDelegate,TagViewDelegate>
{
    ButtomToolView *_toolBar;
    UIButton  *moreButton;
    BOOL    isShowMark;
    UIScrollView *scrollView;
    UIView *BgView2;
    UIView  *TagContentView;
    UIButton  *ScreenButton;
     MarkView       *_mymarkView;
    UIImageView *BgView;
    UIButton  *_tanlogoButton;
    
    UIButton      *leftButtomButton;   //左下边按钮
    UILabel       *movieNameLable;
    UILabel       *Like_lable;       // 喜欢数量
    UIImageView   *MovieLogoImageView;  // 电影的小图片
    weiboInfoModel  *_TweiboInfo;
    stageInfoModel  *_TstageInfo;
    UIScrollView  *tagScrollView;
 
    UIImageView  *starImageView;
    UILabel  *markLable;
    ///当前微博的内容   初始化的时候，取了点赞数组的第一个元素
    weiboInfoModel  *_WeiboInfo;
    UIButton  *like_btn;
    
    UIView  *ShareView;
    
    UIButton *ShareButton;  //分享
    UIButton  *addMarkButton;  //添加弹幕

 }
@property(nonatomic,strong) M80AttributedLabel  *tagLable;  //弹幕的混排

@property(nonatomic,strong) M80AttributedLabel  *WeiboTagLable;  //中间

@property(nonatomic,strong) UIImageView   *stageImageView;

@end

@implementation ShowStageViewController

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.alpha=1;
    self.tabBarController.tabBar.hidden=YES;
    self.navigationController.navigationBar.hidden=NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    isShowMark=YES;
    [self createNav];
     [self createScrollView];
     [self createStageView];
    if (!self.stageInfo.weibosArray) {
        _WeiboInfo=self.weiboInfo;
    }
    //创建底部的分享
   // [self createCenterContentView];
    
    [self createShareToolBar];
    
  //  [self createToolBar];
    
}
-(void)createNav
{
    NSString  *titleString =[Function htmlString: self.stageInfo.movieInfo.name ];
    UILabel  *titleLable=[ZCControl createLabelWithFrame:CGRectMake(0, 0, 100, 30) Font:30 Text:titleString];
    titleLable.textColor=VBlue_color;
    titleLable.font=[UIFont systemFontOfSize:16];
    titleLable.textColor=VGray_color;
    titleLable.textAlignment=NSTextAlignmentCenter;
    self.navigationItem.titleView=titleLable;
    
    //更多
    moreButton=[ZCControl createButtonWithFrame:CGRectMake(kStageWidth-135, 9, 30, 25) ImageName:nil Target:self Action:@selector(NavigationButtonClick:) Title:@""];
    [moreButton setImage:[UIImage imageNamed:@"three_points"] forState:UIControlStateNormal];
    //moreButton.backgroundColor=VBlue_color;
    //moreButton.backgroundColor =[UIColor redColor];
    moreButton.imageEdgeInsets=UIEdgeInsetsMake(0, 10, 0, -10);
    moreButton.layer.cornerRadius=2;
    moreButton.hidden=NO;
    [moreButton setTitleColor:VGray_color forState:UIControlStateNormal];
    UIBarButtonItem  *item =[[UIBarButtonItem alloc]initWithCustomView:moreButton];
    if (!self.weiboInfo) {
        self.navigationItem.rightBarButtonItem=item;

    }

}
-(void)createScrollView
{
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    scrollView.backgroundColor =View_BackGround;
    scrollView.contentSize = CGSizeMake(kDeviceWidth, kDeviceHeight);
    [self.view addSubview:scrollView];
}


-(void)createStageView
{
    
    //分享出来的不是这个view
    BgView =[[UIImageView alloc]initWithFrame:CGRectMake(0,0,kDeviceWidth-0, (kDeviceWidth-0)*(9.0/16)+45+0)];
    BgView.clipsToBounds=YES;
    [BgView.layer setShadowOffset:CGSizeMake(kDeviceWidth, 20)];
    //[BgView.layer setShadowColor:[UIColor blackColor].CGColor];
    [BgView.layer setShadowRadius:10];
    BgView.backgroundColor=View_ToolBar;
   // BgView.layer.cornerRadius=4;
    BgView.clipsToBounds=YES;
    BgView.userInteractionEnabled=YES;
    [scrollView addSubview:BgView];
    
    
    //最后要分享出去的图
    ShareView =[[UIView alloc]initWithFrame:CGRectMake(10,10, kDeviceWidth-20, (kDeviceWidth-20)*(9.0/16))];
    ShareView.userInteractionEnabled=YES;
    //ShareView.backgroundColor=[UIColor redColor];
    [BgView addSubview:ShareView];
    
    
    self.stageImageView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth-20,(kDeviceWidth-20)*(9.0/16))];
     self.stageImageView.contentMode=UIViewContentModeScaleAspectFill;
    self.stageImageView.clipsToBounds=YES;
    NSString *photostring=[NSString stringWithFormat:@"%@%@!w640",kUrlStage,self.stageInfo.photo];
    [self.stageImageView   sd_setImageWithURL:[NSURL URLWithString:photostring] placeholderImage:nil options:(SDWebImageLowPriority|SDWebImageRetryFailed)];
    [ShareView addSubview:self.stageImageView];
    

  
//    stageView = [[StageView alloc] initWithFrame:CGRectMake(10,10,kDeviceWidth-10, (kDeviceWidth-20)*(9.0/16))];
//    stageView.isAnimation = YES;
//    stageView.delegate=self;
//    stageView.stageInfo=self.stageInfo;
//    
//   // stageView.weibosArray = self.stageInfo.weibosArray;
//    [stageView configStageViewforStageInfoDict];
//    
//    [BgView addSubview:stageView];
//    
//    [stageView startAnimation];
    
   // UITapGestureRecognizer  *tap =[[UITapGestureRecognizer alloc]initWithTarget:self /action:@selector(showAndHidenMarkViews)];
    //[stageView addGestureRecognizer:tap];
    
    //创建剧照上的渐变背景文字
    
    UIView  *_layerView =[[UIView alloc]initWithFrame:CGRectMake(0, self.stageImageView.frame.size.height-100, kDeviceWidth-10, 100)];
    [self.stageImageView addSubview:_layerView];
    
    CAGradientLayer * _gradientLayer = [CAGradientLayer layer];  // 设置渐变效果
    _gradientLayer.bounds = _layerView.bounds;
    _gradientLayer.borderWidth = 0;
    
    _gradientLayer.frame = _layerView.bounds;
    _gradientLayer.colors = [NSArray arrayWithObjects:
                             (id)[[UIColor clearColor] CGColor],
                             (id)[[UIColor blackColor] CGColor], nil, nil];
    _gradientLayer.startPoint = CGPointMake(0.5, 0.5);
    _gradientLayer.endPoint = CGPointMake(0.5, 1.0);
    [_layerView.layer insertSublayer:_gradientLayer atIndex:0];
    
    
    markLable=[ZCControl createLabelWithFrame:CGRectMake(20,40,_layerView.frame.size.width-40, 60) Font:20 Text:@"弹幕文字"];
    markLable.font =[UIFont boldSystemFontOfSize:20];
    //markLable.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.4];
    if (IsIphone6plus) {
        markLable.font=[UIFont boldSystemFontOfSize:24];
    }
    markLable.textColor=[UIColor whiteColor];
    weiboInfoModel *weibomodel;
    if (self.stageInfo.weibosArray.count>0) {
        weibomodel =[self.stageInfo.weibosArray objectAtIndex:0];
    }
   
     markLable.text=weibomodel.content;
    
    if (self.weiboInfo) {
        markLable.text=self.weiboInfo.content;
    }
    markLable.lineBreakMode=NSLineBreakByCharWrapping;
    markLable.contentMode=UIViewContentModeBottom;
    markLable.textAlignment=NSTextAlignmentCenter;
    [_layerView addSubview:markLable];
    //创建中间的工具栏
    [self createCenterContentView];
    [self createWeiboTagView];

}
 -(void)createCenterContentView
{
    
    BgView2=[[UIView alloc]initWithFrame:CGRectMake(0,self.stageImageView.frame.origin.y+self.stageImageView.frame.size.height+5, kDeviceWidth, 40 +0)];
    //改变toolar 的颜色
    BgView2.backgroundColor=View_ToolBar;
    [self.view bringSubviewToFront:BgView2];
    [BgView addSubview:BgView2];
    
    
    leftButtomButton=[UIButton buttonWithType:UIButtonTypeCustom];
    leftButtomButton.frame=CGRectMake(10, 5, 140, 35);
   
    [leftButtomButton addTarget:self action:@selector(StageMovieButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [BgView2 addSubview:leftButtomButton];
    
    

    MovieLogoImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,30, 30)];
    MovieLogoImageView.layer.cornerRadius=15;
     //显示微博的头像
     if (self.stageInfo.weibosArray.count>0) {
        _WeiboInfo =[self.stageInfo.weibosArray objectAtIndex:0];
    }
    NSString  *uselogoString =[NSString stringWithFormat:@"%@%@!thumb",kUrlAvatar,_WeiboInfo.uerInfo.logo];
    if (self.weiboInfo) {
        uselogoString=[NSString stringWithFormat:@"%@%@!thumb",kUrlAvatar,self.weiboInfo.uerInfo.logo];
    }
    [MovieLogoImageView sd_setImageWithURL:[NSURL URLWithString:uselogoString] placeholderImage:[UIImage imageNamed:@"user_normal.png"]];
    MovieLogoImageView.layer.masksToBounds = YES;
    [leftButtomButton addSubview:MovieLogoImageView];
    
    movieNameLable =[[UILabel alloc]initWithFrame:CGRectMake(35,12, 120, 30)];
    movieNameLable.font=[UIFont systemFontOfSize:16];
    movieNameLable.textColor=VGray_color;
    //movieNameLable.text=self.stageInfo.movieInfo.name;
    // movieNameLable.numberOfLines=1;
    movieNameLable.lineBreakMode=NSLineBreakByTruncatingTail;
    [leftButtomButton addSubview:movieNameLable];
//   
//    NSString  *nameStr=self.stageInfo.movieInfo.name;
    
    NSString  *nameStr=_WeiboInfo.uerInfo.username;
    if (!nameStr) {
        nameStr =self.weiboInfo.uerInfo.username;
    }
    CGSize  Nsize =[nameStr boundingRectWithSize:CGSizeMake(100, 27) options:(NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin) attributes:[NSDictionary dictionaryWithObject:movieNameLable.font forKey:NSFontAttributeName] context:nil].size;
    movieNameLable.frame=CGRectMake(35,0, Nsize.width+4, 30);
    leftButtomButton.frame=CGRectMake(10, 9, 30+5+movieNameLable.frame.size.width, 27);
    movieNameLable.text=[NSString stringWithFormat:@"%@",nameStr];


    
    
    //更多
    //moreButton=[ZCControl createButtonWithFrame:CGRectMake(kStageWidth-135, 9, 30, 25) ImageName:@"more_icon_default.png" Target:self Action:@selector(cellButtonClick:) Title:@""];
    //moreButton.layer.cornerRadius=2;
    //moreButton.hidden=NO;
    //[BgView2 addSubview:moreButton];
    

    
    
    ScreenButton =[ZCControl createButtonWithFrame:CGRectMake(kStageWidth-95,9,30,25) ImageName:@"btn_share_default.png" Target:self Action:@selector(ScreenButtonClick:) Title:@""];
    //[ScreenButton setBackgroundImage:[UIImage imageNamed:@"btn_share_select.png"] forState:UIControlStateHighlighted];
    [ScreenButton setBackgroundImage:[UIImage imageNamed:@"btn_share_select.png"] forState:UIControlStateNormal];
    //[BgView2 addSubview:ScreenButton];
    
    
    _tanlogoButton =[UIButton buttonWithType:UIButtonTypeCustom];
    _tanlogoButton.frame=CGRectMake(kStageWidth-100, 9, 45, 25);
    [_tanlogoButton setImage:[UIImage imageNamed:@"closed_icon_default.png"] forState:UIControlStateNormal];
    [_tanlogoButton setImage:[UIImage imageNamed:@"open_danmu.png.png"] forState:UIControlStateSelected];
    [_tanlogoButton addTarget:self action:@selector(hidenAndShowMarkView:) forControlEvents:UIControlEventTouchUpInside];
  //  [BgView2 addSubview:_tanlogoButton];

    
    addMarkButton =[ZCControl createButtonWithFrame:CGRectMake(kStageWidth-55,10,45,25) ImageName:@"btn_add_default.png" Target:self Action:@selector(addMarkButtonClick:) Title:@""];
    [addMarkButton setBackgroundImage:[UIImage imageNamed:@"btn_add_select.png"] forState:UIControlStateHighlighted];
    //[BgView2 addSubview:addMarkButton];
    
    
    
    //点赞的按钮 上面放一张图片 右边放文字
     like_btn =[ZCControl createButtonWithFrame:CGRectMake(kStageWidth-70,10,70,25) ImageName:nil Target:self Action:@selector(clickLike:) Title:@""];
    like_btn.backgroundColor=View_BackGround;
    [BgView2 addSubview:like_btn];
    
    //赞的星星
    starImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 8, 14,12)];
    starImageView.image =[UIImage imageNamed:@"like_nomoal.png"];
    [like_btn addSubview:starImageView];
    
    
    //赞的文字
    Like_lable =[ZCControl createLabelWithFrame:CGRectMake(20,0,40, 25) Font:14 Text:@""];
    Like_lable.textColor=VGray_color;
    Like_lable.textAlignment=NSTextAlignmentCenter;
    if ([_WeiboInfo.like_count intValue]==0) {
        Like_lable.text=[NSString stringWithFormat:@"喜欢"];
    }
    else
    {
        Like_lable.text=[NSString stringWithFormat:@"%@",_WeiboInfo.like_count];
    }
    
    [like_btn addSubview:Like_lable];
    
    for (int i=0; i<self.upweiboArray.count; i++) {
        UpweiboModel *upmodel=self.upweiboArray[i];
        //weiboInfoModel  *weiboInfo =[self.stageInfo.weibosArray objectAtIndex:0];
        if ([upmodel.weibo_id intValue]==[_WeiboInfo.Id intValue]) {
            like_btn.selected=YES;
            starImageView.image=[UIImage imageNamed:@"like_slected.png"];
            break;
        }
        else{
            like_btn.selected=NO;
             starImageView.image=[UIImage imageNamed:@"like_nomoal.png"];
        }
    }
}

-(void)createWeiboTagView
{
    if (TagContentView) {
        [TagContentView removeFromSuperview];
        TagContentView = nil;
    }
    if (self.WeiboTagLable) {
        [self.WeiboTagLable removeFromSuperview];
        self.WeiboTagLable=nil;
    }
      BgView.frame =CGRectMake(0,0,kDeviceWidth-0, (kDeviceWidth-0)*(9.0/16)+45+0);
    TagContentView  = [[UIView alloc]initWithFrame:CGRectMake(0, BgView2.frame.origin.y+BgView2.frame.size.height, kDeviceWidth, 40)];
    //TagContentView.backgroundColor =[UIColor redColor];
    [BgView addSubview:TagContentView];
    
    self.WeiboTagLable=[[M80AttributedLabel alloc]initWithFrame:CGRectZero];
    self.WeiboTagLable.backgroundColor =[UIColor clearColor];
    self.WeiboTagLable.lineSpacing=5;
    [TagContentView addSubview:self.WeiboTagLable];
    //初始化的时候获取第一个标签
    if (_WeiboInfo.tagArray.count>0) {
        for (int i=0; i<_WeiboInfo.tagArray.count; i++) {
        TagView  *tagView= [[TagView alloc]initWithWeiboInfo:_WeiboInfo AndTagInfo:_WeiboInfo.tagArray[i] delegate:self isCanClick:YES backgoundImage:nil isLongTag:NO];
            [tagView setcornerRadius:2];
            tagView.backgroundColor =[UIColor redColor];
            [self.WeiboTagLable appendView:tagView margin:UIEdgeInsetsMake(5, 10, 0, 0)];
        }
    }
    CGSize  Tsize =[self.WeiboTagLable sizeThatFits:CGSizeMake(kDeviceWidth-20,CGFLOAT_MAX)];
    self.WeiboTagLable.frame=CGRectMake(0, 0, kDeviceWidth-20, Tsize.height+0);
    TagContentView.frame=CGRectMake(0, BgView2.frame.origin.y+BgView2.frame.size.height+5, kDeviceWidth,Tsize.height+0);
    CGRect bRect = BgView.frame;
    
    BgView.frame=CGRectMake(BgView.frame.origin.x, BgView.frame.origin.y,kDeviceWidth,bRect.size.height+TagContentView.frame.size.height);
   
    
}
#pragma mark 星星点赞方法
//点赞实现的方法
-(void)clickLike:(UIButton *) btn
{
    UserDataCenter  * userCenter =[UserDataCenter shareInstance];
    /*if ([userCenter.is_admin intValue]>0) {
        //管理员用户//请求随机用户，然后点一次变身一次
        [self requestChangeUserRand4];
        
        starImageView.image=[UIImage imageNamed:@"like_slected.png"];
        [Function BasicAnimationwithkey:@"transform.scale" Duration:0.25 repeatcont:1 autoresverses:YES fromValue:1.0 toValue:1.5 View:starImageView];
        // 把赞的数量+1
        int like =[Like_lable.text intValue];
        like = like+1;
         Like_lable.text=[NSString stringWithFormat:@"%d",like];
    }
    else
    {*/
        //普通用户
    NSNumber  *operation;
    if (btn.selected==YES) {
        btn.selected=NO;
        //已赞的,再点击就要移除数组
        operation =[NSNumber numberWithInt:0];
        for (int i=0; i<self.upweiboArray.count; i++) {
            //已赞的
            UpweiboModel *upmodel =self.upweiboArray[i];
            if ([upmodel.weibo_id intValue]==[_WeiboInfo.Id intValue]) {
                 [self.upweiboArray removeObjectAtIndex:i];
                break;
            }
        }
        starImageView.image=[UIImage imageNamed:@"like_nomoal.png"];
        //把赞的数量-1
        int  like =   [Like_lable.text intValue];
        like=like>0 ? like-1 : 0;
        _WeiboInfo.like_count=[NSNumber numberWithInt:like];

        if ([_WeiboInfo.like_count intValue]==0) {
            Like_lable.text=[NSString stringWithFormat:@"喜欢"];
        }
        else
        {
            Like_lable.text=[NSString stringWithFormat:@"%@",_WeiboInfo.like_count];
        }
        
    }
    else if (btn.selected==NO)
    {
        
//        CGRect  starframe =leftButtomButton.frame;
//        
//        UIImageView  *addone =[[UIImageView alloc]initWithFrame:CGRectMake(kDeviceWidth-70, starframe.origin.y-10, 10, 10)];
//        addone.backgroundColor =[UIColor redColor];
//        [BgView2 addSubview:addone];
//        
//        
//        
//        [UIView animateWithDuration:1 animations:^{
//            // 改变位置
//            CGRect  addframe = addone.frame;
//            addframe.origin.y=addframe.origin.y-50;
//            //大小
//            addframe.size=CGSizeMake(1, 0);
//            addone.frame=addframe;
//            
//            addone.alpha=0;
//            
//            
//        } completion:^(BOOL finished) {
//            [addone removeFromSuperview];
//            ///addone=nil;
//            
//        }];
    
        
        btn.selected=YES;
        //未赞
        operation =[NSNumber numberWithInt:1];
        UpweiboModel  *upmodel =[[UpweiboModel alloc]init];
        upmodel.weibo_id=_WeiboInfo.Id;
        upmodel.created_at=_WeiboInfo.created_at;
        upmodel.created_by=_WeiboInfo.created_by;
        upmodel.updated_at=_WeiboInfo.updated_at;
        [self.upweiboArray addObject:upmodel];
        
         starImageView.image=[UIImage imageNamed:@"like_slected.png"];
        [Function BasicAnimationwithkey:@"transform.scale" Duration:0.25 repeatcont:1 autoresverses:YES fromValue:1.0 toValue:1.5 View:starImageView];
        // 把赞的数量+1
        int like=[_WeiboInfo.like_count intValue];
        like=like+1;
        _WeiboInfo.like_count=[NSNumber numberWithInt:like];
        Like_lable.text=[NSString stringWithFormat:@"%@",_WeiboInfo.like_count];
      }
       [self LikeRequstData:_WeiboInfo withOperation:operation withuserId:userCenter.user_id];
    //}
    
    
}
//创建固定于地步的分享按钮
-(void)createShareToolBar
{
 
    UIView  *shareView=[[UIView alloc]initWithFrame:CGRectMake(0, kDeviceHeight-200-kHeightNavigation, kDeviceWidth, 200)];
    shareView.userInteractionEnabled=YES;
    shareView.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:shareView];
    
    //标签的滚动视图
    tagScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(10,10,kDeviceWidth-20, 135)];
    tagScrollView.backgroundColor =[UIColor whiteColor];
    [shareView addSubview:tagScrollView];
    
    //创建标签，但是这个标签的内容是弹幕的内容
    self.tagLable=[[M80AttributedLabel alloc]initWithFrame:CGRectZero];
    self.tagLable.backgroundColor =[UIColor clearColor];
    
    
    if (self.weiboInfo) {//如果 从管理员的最新页进来
        TagView *tagview = [self createTagViewWithweiboInfo:self.weiboInfo andIndex:300];
        [tagview setbigTagWithSize:CGSizeMake(10, 10)];
        [self.tagLable appendView:tagview margin:UIEdgeInsetsMake(0, 0, 0, 10)];
        self.tagLable.lineSpacing=10;
        self.tagLable.numberOfLines=0;
        tagview.tagBgImageview.backgroundColor =VLight_GrayColor;
        tagview.titleLable.textColor=[UIColor whiteColor];
    }
    else {
    for (int i=0; i<self.stageInfo.weibosArray.count; i++) {
        TagView *tagview = [self createTagViewWithweiboInfo:self.stageInfo.weibosArray[i] andIndex:i];
        [tagview setbigTagWithSize:CGSizeMake(10, 10)];
         [self.tagLable appendView:tagview margin:UIEdgeInsetsMake(0, 0, 0, 10)];
         self.tagLable.lineSpacing=10;
        self.tagLable.numberOfLines=0;
        if (i==0) {
            tagview.tagBgImageview.backgroundColor =VLight_GrayColor;
            tagview.titleLable.textColor=[UIColor whiteColor];
        }
      }
    }
    //标签的高度
    CGSize Tagsize =[self.tagLable sizeThatFits:CGSizeMake(kDeviceWidth-20, CGFLOAT_MAX)];
    self.tagLable.frame=CGRectMake(0, 0, kDeviceWidth-20, Tagsize.height);
    [tagScrollView addSubview:self.tagLable];
    tagScrollView.contentSize=CGSizeMake(kDeviceWidth-20, Tagsize.height+20);
    
//   底部的分享和添加按钮

    addMarkButton =[ZCControl createButtonWithFrame:CGRectMake(0,200-45,kDeviceWidth/2,45) ImageName:nil Target:self Action:@selector(ShareButtonClick:) Title:@"我要添加"];
     addMarkButton.titleLabel.font =[UIFont boldSystemFontOfSize:16];
    [addMarkButton setTitleColor:VBlue_color forState:UIControlStateNormal];
    //ShareButton.backgroundColor =[UIColor redColor];
    [addMarkButton setBackgroundImage:[UIImage imageNamed:@"tabbar_backgroud_color"] forState:UIControlStateNormal];
     [shareView addSubview:addMarkButton];
   
    ShareButton =[ZCControl createButtonWithFrame:CGRectMake(kDeviceWidth/2,200-45,kDeviceWidth/2,45) ImageName:nil Target:self Action:@selector(ShareButtonClick:) Title:@"我要分享"];
    ShareButton.titleLabel.font =[UIFont boldSystemFontOfSize:16];
     [ShareButton setTitleColor:VBlue_color forState:UIControlStateNormal];
    //addMarkButton.backgroundColor=[UIColor redColor];
    [ShareButton setBackgroundImage:[UIImage imageNamed:@"tabbar_backgroud_color"] forState:UIControlStateNormal];
    [shareView addSubview:ShareButton];
    
}

-(TagView *) createTagViewWithweiboInfo:(weiboInfoModel *) weiboInfo andIndex:(NSInteger) index
{
    TagView *tagview =[[TagView alloc]initWithWeiboInfo:weiboInfo AndTagInfo:nil delegate:self isCanClick:YES backgoundImage:nil isLongTag:NO];
    [tagview setcornerRadius:4];
    tagview.tagBgImageview.backgroundColor =VLight_GrayColor_apla;
    tagview.titleLable.textColor=VGray_color;
    tagview.tag=2000+index;
    //[tagview setbigTag:YES];
    return tagview;
}


-(void)TapViewClick:(TagView *)tagView Withweibo:(weiboInfoModel *)weiboInfo withTagInfo:(TagModel *)tagInfo
{
    
    _WeiboInfo=weiboInfo;

     dispatch_async(dispatch_get_main_queue(), ^{
         [self createWeiboTagView];

     });
    for (int i=0; i<self.stageInfo.weibosArray.count; i++) {
        TagView  *tagView=(TagView *)[self.tagLable viewWithTag:2000+i];
        tagView.tagBgImageview.backgroundColor =VLight_GrayColor_apla;
        tagView.titleLable.textColor=VGray_color;
    }
    
    tagView.tagBgImageview.backgroundColor =VLight_GrayColor;
    tagView.titleLable.textColor=[UIColor whiteColor];
    markLable.text=weiboInfo.content;
    Like_lable.text=[NSString stringWithFormat:@"%@",_WeiboInfo.like_count];
    
    // 看是否已赞的
    for (int i=0; i<self.upweiboArray.count; i++) {
        UpweiboModel *upmodel=self.upweiboArray[i];
        //weiboInfoModel  *weiboInfo =[self.stageInfo.weibosArray objectAtIndex:0];
        if ([upmodel.weibo_id intValue]==[_WeiboInfo.Id intValue]) {
            like_btn.selected=YES;
            starImageView.image=[UIImage imageNamed:@"like_slected.png"];
            break;
        }
        else{
            like_btn.selected=NO;
            starImageView.image=[UIImage imageNamed:@"like_nomoal.png"];
        }
    }
    
    if ([_WeiboInfo.like_count intValue]==0) {
        Like_lable.text=[NSString stringWithFormat:@"喜欢"];
    }
    NSString  *uselogoString =[NSString stringWithFormat:@"%@%@!thumb",kUrlAvatar,_WeiboInfo.uerInfo.logo];
    [MovieLogoImageView sd_setImageWithURL:[NSURL URLWithString:uselogoString] placeholderImage:[UIImage imageNamed:@"user_normal.png"]];
    
    NSString  *nameStr=weiboInfo.uerInfo.username;
    CGSize  Nsize =[nameStr boundingRectWithSize:CGSizeMake(100, 27) options:(NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin) attributes:[NSDictionary dictionaryWithObject:movieNameLable.font forKey:NSFontAttributeName] context:nil].size;
    movieNameLable.frame=CGRectMake(35,0, Nsize.width+4, 30);
    leftButtomButton.frame=CGRectMake(10, 9, 30+5+movieNameLable.frame.size.width, 27);
    movieNameLable.text=[NSString stringWithFormat:@"%@",nameStr];

    

}

////创建标签的方法
//-(TagView *)createTagViewWithtagInfo:(TagModel *) tagmodel andIndex:(NSInteger ) index
//{
//    TagView *tagview =[[TagView alloc]initWithWeiboInfo:self.weiboInfo AndTagInfo:tagmodel delegate:self isCanClick:YES backgoundImage:nil isLongTag:YES];
//    [tagview setbigTag:YES];
//    return tagview;
//}


//创建底部的视图
-(void)createToolBar
{
    _toolBar=[[ButtomToolView alloc]initWithFrame:CGRectMake(0,0,kDeviceWidth,kDeviceHeight)];
    _toolBar.delegete=self;
    
}


#pragma mark 点击屏幕显示和隐藏marview
//显示隐藏markview
/*-(void)hidenAndShowMarkView:(UIButton *) button
{
    [stageView showAndHidenMarkView:button.selected];
    
    if (button.selected==NO) {
        NSLog(@"执行了隐藏 view ");
        button.selected=YES;
        for (UIView  *view  in stageView.subviews) {
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
        for (UIView  *view  in stageView.subviews) {
            if  ([view isKindOfClass:[MarkView class]]) {
                MarkView  *mv =(MarkView *)view;
                mv.hidden=NO;
            }
        }
    }
}

-(void)showAndHidenMarkViews
{
    if (isShowMark==NO) {
        [stageView showAndHidenMarkView:NO];
        isShowMark=YES;
        NSLog(@"执行了隐藏 view ");
        for (id view  in stageView.subviews) {
            if  ([view isKindOfClass:[MarkView class]]) {
                MarkView  *mv =(MarkView *)view;
                mv.hidden=YES;
            }
        }
    }
    else if (isShowMark==YES)
    {
        NSLog(@"执行了显示view ");
        isShowMark=NO;
        [stageView showAndHidenMarkView:YES];
        for (id   view  in stageView.subviews) {
            if  ([view isKindOfClass:[MarkView class]]) {
                MarkView  *mv =(MarkView *)view;
                mv.hidden=NO;
            }
        }
    }
}*/



#pragma  mark  ----RequestData
#pragma  mark  ---

//管理员用户的点赞和点踩
-(void)requestUpAndDownWithDeretion:(NSString *)direction;
{
    
    UserDataCenter  *userCenter=[UserDataCenter shareInstance];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters=@{@"user_id":userCenter.user_id,@"stage_id":self.stageInfo.Id,@"weibo_id":_WeiboInfo.Id,@"direction":direction};
    
    [manager POST:[NSString stringWithFormat:@"%@/weibo/adjust", kApiBaseUrl] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject  objectForKey:@"code"]  intValue]==0) {
            //改变likelable 的状态
            if ([direction isEqualToString:@"up"]) {//点赞
                int like =[_WeiboInfo.like_count intValue];
                like = like + 1;
                _WeiboInfo.like_count =[NSNumber numberWithInt:like];
                
            }
            else if([direction isEqualToString:@"down"]){
                int like =[_WeiboInfo.like_count intValue];
                like = like -1;
                _WeiboInfo.like_count =[NSNumber numberWithInt:like];

            }
            //在主线程中更新likelable 的文字
            
            //获取子线程
           // dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
            //});
            
            dispatch_async(dispatch_get_main_queue(), ^{
                Like_lable.text=[NSString stringWithFormat:@"%@",_WeiboInfo.like_count];

            });
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    
}


//随机用户请求
//变身请求的随机数种子请求，根据请求出来的随机种子 ，去请求点赞
-(void)requestChangeUserRand4
{
    
    UserDataCenter  *userCenter=[UserDataCenter shareInstance];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters=@{@"user_id":userCenter.user_id};
    [manager POST:[NSString stringWithFormat:@"%@/user/fakeuserid", kApiBaseUrl] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject  objectForKey:@"code"]  intValue]==0) {
            NSLog(@"随机数种子请求成功=======%@",responseObject);
            NSString  *usr_id =[responseObject objectForKey:@"user_id"];
            [self LikeRequstData:_WeiboInfo withOperation:@1 withuserId:usr_id];
            //请求点赞
            
         }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    

}
//屏幕剧照
-(void)requestRemoveStage:(NSString *) type
{
    UserDataCenter *usercenter=[UserDataCenter shareInstance];
    NSDictionary *parameters;
    parameters = @{@"stage_id":self.stageInfo.Id,@"user_id":usercenter.user_id};
    if ([type intValue]==1) {
        //恢复剧照
          parameters = @{@"stage_id":self.stageInfo.Id,@"user_id":usercenter.user_id,@"block":type};
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *urlString =[NSString stringWithFormat:@"%@/stage/block", kApiBaseUrl];
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject  objectForKey:@"code"]  intValue]==0) {
            NSLog(@"移除剧照成功=======%@",responseObject);
            NSString *message =@"屏蔽剧照成功";
            if ([type intValue]==1) {
                message=@"恢复剧照成功";
            }
            UIAlertView  *Al =[[UIAlertView alloc]initWithTitle:nil message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [Al show];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}



-(void)requestmoveReviewToNormal:(NSString *) stageId
{
    UserDataCenter *usercenter=[UserDataCenter shareInstance];
    NSString  *review;
    if ([Version  isEqualToString:@"1.0.1"]) {
        //从审核版到正常
        review=@"0";
    }
    else
    {
        review=@"1";
        
    }
    NSDictionary *parameters = @{@"stage_id":stageId,@"user_id":usercenter.user_id,@"review":review};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *urlString =[NSString stringWithFormat:@"%@/stage/move-to-review", kApiBaseUrl];
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject  objectForKey:@"code"]  intValue]==0) {
            NSLog(@"移除剧照成功=======%@",responseObject);
            UIAlertView  *Al =[[UIAlertView alloc]initWithTitle:nil message:@"审核（正常）切换成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [Al show];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

//微博点赞请求




//operation  == 1 点赞    为  0  取消点赞
-(void)LikeRequstData:(weiboInfoModel  *) weiboInfo withOperation:(NSNumber *) operation withuserId:(NSString*)user_id
{
   //UserDataCenter  *userCenter=[UserDataCenter shareInstance];
    NSNumber  *weiboId=weiboInfo.Id;
    NSNumber  *author_id=weiboInfo.uerInfo.Id;
    if (!weiboInfo) {
        return;
    }
    NSDictionary *parameters=@{@"weibo_id":weiboId,@"user_id":user_id,@"author_id":author_id,@"operation":operation};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *urlString = [NSString stringWithFormat:@"%@/weibo/up", kApiBaseUrl];
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject  objectForKey:@"code"]  intValue]==0) {
            NSLog(@"点赞成功========%@",responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

//微博举报
-(void)requestReportweibo
{
    // NSString *type=@"1";
    UserDataCenter *userCenter =[UserDataCenter shareInstance];
    NSDictionary *parameters = @{@"reported_user_id":_TweiboInfo.uerInfo.Id,@"weibo_id":_TweiboInfo.Id,@"reason":@"",@"user_id":userCenter.user_id};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/report-weibo/create", kApiBaseUrl] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject  objectForKey:@"code"]  intValue]==0) {
            NSLog(@"随机数种子请求成功=======%@",responseObject);
            UIAlertView  *Al =[[UIAlertView alloc]initWithTitle:nil message:@"你的举报已成功,我们会在24小时内处理" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [Al show];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

-(void)requestReportSatge
{
    // NSString *type=@"1";
    NSNumber  *stageId=self.stageInfo.Id;
    NSString  *author_id=self.stageInfo.created_by;
    
    UserDataCenter *userCenter =[UserDataCenter shareInstance];
    NSDictionary *parameters = @{@"reported_user_id":author_id,@"stage_id":stageId,@"reason":@"",@"user_id":userCenter.user_id};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/report-stage/create", kApiBaseUrl] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject  objectForKey:@"code"] intValue]==0) {
             UIAlertView  *Al =[[UIAlertView alloc]initWithTitle:nil message:@"你的举报已成功,我们会在24小时内处理" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [Al show];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

//推荐微博的接口
-(void)requestrecommendDataWithStageId:(NSString *) stageId weiboId:(NSString *) weiboId
{
    UserDataCenter  *userCenter =[UserDataCenter shareInstance];
    NSDictionary *parameters = @{@"weibo_id":weiboId,@"stage_id":stageId,@"user_id":userCenter.user_id};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/hot/create", kApiBaseUrl] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject  objectForKey:@"code"]  intValue]==0) {
            NSLog(@"推荐成功=======%@",responseObject);
            UIAlertView  *Al=[[UIAlertView alloc]initWithTitle:nil message:@"推荐成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [Al show];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}
//删除微博的接口
-(void)requestDelectDataWithweiboId:(NSString  *) weiboId
{
    UserDataCenter *userCenter=[UserDataCenter shareInstance];
    NSDictionary *parameters = @{@"weibo_id":weiboId,@"user_id":userCenter.user_id};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/weibo/remove", kApiBaseUrl] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject  objectForKey:@"code"]  intValue]==0) {
            NSLog(@"删除数据成功=======%@",responseObject);
            UIAlertView  *Al=[[UIAlertView alloc]initWithTitle:nil message:@"删除成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [Al show];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

//变身请求的随机数种子
/*-(void)requestChangeUserRand4
{
    
    UserDataCenter  *userCenter=[UserDataCenter shareInstance];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters=@{@"user_id":userCenter.user_id};
    [manager POST:[NSString stringWithFormat:@"%@/user/fakeuserid", kApiBaseUrl] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject  objectForKey:@"code"]  intValue]==0) {
            NSLog(@"随机数种子请求成功=======%@",responseObject);
            [self  requestChangeUser:[responseObject objectForKey:@"user_id"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}*/
//跟换用户的数据请求
-(void)requestChangeUser:( NSString *) author_id
{
    UserDataCenter  *userCenter =[UserDataCenter shareInstance];
    NSDictionary *parameters = @{@"weibo_id":_TweiboInfo.Id,@"user_id":userCenter.user_id,@"author_id":author_id};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString  *urlString =[NSString stringWithFormat:@"%@/weibo/switch", kApiBaseUrl];
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject  objectForKey:@"code"]  intValue]==0) {
            weiboUserInfoModel  *usermodel=[[weiboUserInfoModel alloc]init];
            if (usermodel) {
                [usermodel setValuesForKeysWithDictionary:[responseObject objectForKey:@"model"]];
            }
            NSLog(@"变身成功=======%@",responseObject);
            UIAlertView  *Al=[[UIAlertView alloc]initWithTitle:nil message:@"变身成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [Al show];
            
            int Id=[author_id intValue];
            _TweiboInfo.uerInfo.Id=[NSNumber numberWithInt:Id];
            _TweiboInfo.uerInfo.logo=usermodel.logo;
            NSString  *urlString =[NSString stringWithFormat:@"%@%@",kUrlAvatar,usermodel.logo];
            [_mymarkView.LeftImageView sd_setImageWithURL:[NSURL URLWithString:urlString]];
            
        }
        else
        {
            NSLog(@"error ===%@",[responseObject objectForKey:@"message"]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}


-(void)UMShareViewControllerHandClick:(UIButton *)button ShareImage:(UIImage *)shareImage StageInfoModel:(stageInfoModel *)StageInfo
{
    NSArray  *sharearray =[NSArray arrayWithObjects:UMShareToWechatTimeline,UMShareToWechatSession, UMShareToSina, nil];
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
    
    [[UMSocialControllerService defaultControllerService] setShareText:StageInfo.movieInfo.name shareImage:shareImage socialUIDelegate:self];        //设置分享内容和回调对象
    [UMSocialSnsPlatformManager getSocialPlatformWithName:[sharearray  objectAtIndex:button.tag-10000]].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
    NSLog(@"分享到微信");
}
-(void)UMShareViewController2HandClick:(UIButton *)button ShareImage:(UIImage *)shareImage StageInfoModel:(stageInfoModel *)StageInfo
{
    NSArray  *sharearray =[NSArray arrayWithObjects:UMShareToWechatTimeline,UMShareToWechatSession, UMShareToSina, nil];
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
    [[UMSocialControllerService defaultControllerService] setShareText:StageInfo.movieInfo.name shareImage:shareImage socialUIDelegate:self];
    //设置分享内容和回调对象
    
    [UMSocialSnsPlatformManager getSocialPlatformWithName:[sharearray  objectAtIndex:button.tag-10000]].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
    
}
-(void)UMShareViewHandClick:(UIButton *)button ShareImage:(UIImage *)shareImage StageInfoModel:(stageInfoModel *)StageInfo
{
    
    
    NSArray  *sharearray =[NSArray arrayWithObjects:UMShareToWechatTimeline,UMShareToWechatSession, UMShareToSina, nil];
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
    [[UMSocialControllerService defaultControllerService] setShareText:StageInfo.movieInfo.name shareImage:shareImage socialUIDelegate:self];
    //设置分享内容和回调对象
    
    [UMSocialSnsPlatformManager getSocialPlatformWithName:[sharearray  objectAtIndex:button.tag-10000]].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
    

}
//跳转到电影页
-(void)StageMovieButtonClick:(UIButton *) button
{
    
  /*  //电影按钮
    MovieDetailViewController *vc =  [MovieDetailViewController new];
    vc.movieId = self.stageInfo.movie_id;
   // NSMutableString  *backstr=[[NSMutableString alloc]initWithString:self.stageInfo.movieInfo.name];
    vc.moviename=self.stageInfo.movieInfo.name;
    vc.movielogo=self.stageInfo.movieInfo.logo;
    UIBarButtonItem  *item =[[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem=item;

    [self.navigationController pushViewController:vc animated:YES];*/
    
    MyViewController  *myVC=[[MyViewController alloc]init];
    weiboInfoModel *model = [self.stageInfo.weibosArray objectAtIndex:0];
    if (self.weiboInfo) {
        model=self.weiboInfo;
    }
    myVC.author_id =[NSString stringWithFormat:@"%@",model.uerInfo.Id];
    UIBarButtonItem  *item =[[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem=item;
    [self.navigationController pushViewController:myVC animated:YES];

}
// 分享
-(void)ShareButtonClick:(UIButton  *) button
{
    
    if (button==ShareButton) {  //分享有关
    UIImage  *image=[Function getImage:ShareView WithSize:CGSizeMake(kStageWidth-10, (kDeviceWidth-20)*(9.0/16))];
        if (self.weiboInfo) {
            self.stageInfo=self.weiboInfo.stageInfo;
        }
        UMShareView *shareView =[[UMShareView alloc] initwithStageInfo:self.stageInfo ScreenImage:image delgate:self];
        [shareView show];
    }
    else if (button==addMarkButton)//添加有关
    {
        
        [self addMarkButtonClick:button];
        
    }
}

//添加弹幕
-(void)addMarkButtonClick:(UIButton  *) button
{
    
    
    NSLog(@" ==addMarkButtonClick  ====%ld",(long)button.tag);
    AddMarkViewController  *AddMarkVC=[[AddMarkViewController alloc]init];
    AddMarkVC.delegate=self;
   // AddMarkVC.model=self.stageInfo;
    AddMarkVC.stageInfo=self.stageInfo;
     UINavigationController  *na =[[UINavigationController alloc]initWithRootViewController:AddMarkVC];
    [self.navigationController presentViewController:na animated:NO completion:nil];
}
-(void)NavigationButtonClick:(UIButton  *) button
{
     UserDataCenter  *userCenter =[UserDataCenter shareInstance];
    //点击了更多
    if ([userCenter.is_admin intValue]>0) {
        UIActionSheet  *Act=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"内容投诉",@"版权投诉",@"图片信息",@"[切换剧照到审核/正式版]",@"[屏蔽剧照]",@"[编辑弹幕]",@"[屏蔽弹幕]",@"[恢复剧照]",@"[点赞]",@"[点踩]",nil];
        Act.tag=507;
        [Act showInView:Act];
    }
    else
    {
        UIActionSheet  *Act=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"内容投诉",@"版权投诉",@"图片信息", nil];
        Act.tag=507;
        [Act showInView:Act];
    }
    


}
#pragma  mark -------AddMarkViewControllerReturn  --Delegete-------------
-(void)AddMarkViewControllerReturn
{
  //  [stageView configStageViewforStageInfoDict];
    
}
#pragma mark  -----
#pragma mark  ---//点击了弹幕StaegViewDelegate
#pragma mark  ----
-(void)StageViewHandClickMark:(weiboInfoModel *)weiboDict withmarkView:(id)markView StageInfoDict:(stageInfoModel *)stageInfoDict
{
    //获取markview的指针
    MarkView   *mv=(MarkView *)markView;
    _mymarkView=mv;
    if (mv.isSelected==YES) {  //当前已经选中的状态
        [self SetToolBarValueWithDict:weiboDict markView:markView isSelect:YES StageInfo:stageInfoDict];
    }
    else if(mv.isSelected==NO)
    {
        NSLog(@"隐藏工具栏工具栏");
        [self SetToolBarValueWithDict:weiboDict markView:markView isSelect:NO StageInfo:stageInfoDict];
    }
    
}
#pragma mark  ----- toolbar 上面的按钮，执行给toolbar 赋值，显示，弹出工具栏
-(void)SetToolBarValueWithDict:(weiboInfoModel  *)weiboDict markView:(id) markView isSelect:(BOOL ) isselect StageInfo:(stageInfoModel *) stageInfo
{
    //先对它赋值，然后让他弹出到界面
    if (isselect==YES) {
        _toolBar.alertView.frame=CGRectMake(15,0,kStageWidth-20, 100);
        _toolBar.weiboInfo=weiboDict;
        _toolBar.stageInfo=stageInfo;
        _toolBar.markView=markView;
        [_toolBar configToolBar];
        [[[[UIApplication sharedApplication] delegate] window] addSubview:_toolBar ];
        [_toolBar ShowButtomView];
        
    }
    else if (isselect==NO)
    {
        //隐藏toolbar
        if (_toolBar) {
            [_toolBar HidenButtomView];
            //从父视图中除掉工具栏
            [_toolBar removeFromSuperview];
        }
    }
    
    
}
#pragma mark   ------
#pragma mark   -------- ButtomToolViewDelegate
#pragma  mark  -------
-(void)ToolViewHandClick:(UIButton *)button :(MarkView *)markView weiboDict:(weiboInfoModel *)weiboDict StageInfo:(stageInfoModel *)stageInfoDict
{
    UserDataCenter  *userCenter=[UserDataCenter shareInstance];
    
    _TweiboInfo =weiboDict;
    _TstageInfo=stageInfoDict;
    if (button.tag==10000) {
        ///点击了头像//进入个人页面
        [_mymarkView CancelMarksetSelect];
        if (_toolBar) {
            [_toolBar HidenButtomView];
            [_toolBar removeFromSuperview];
        }
        MyViewController   *myVc=[[MyViewController alloc]init];
        myVc.author_id=weiboDict.created_by;
        UIBarButtonItem  *item =[[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        self.navigationItem.backBarButtonItem=item;
        [self.navigationController pushViewController:myVc animated:YES];
    }
#pragma mark     -----------分享
    else if (button.tag==10001)
    {
        //点击了分享
        //分享文字
      //   UIImage  *image=[Function getImage:stageView WithSize:CGSizeMake(kDeviceWidth, kDeviceWidth)];
        [_mymarkView CancelMarksetSelect];
        if (_toolBar) {
            [_toolBar HidenButtomView];
            [_toolBar removeFromSuperview];
        }
        UMShareViewController2  *shareVC=[[UMShareViewController2 alloc]init];
        shareVC.StageInfo=stageInfoDict;
        shareVC.weiboInfo=weiboDict;
        shareVC.delegate=self;
        //UINavigationController  *na =[[UINavigationController alloc]initWithRootViewController:shareVC];
        [self.navigationController presentViewController:shareVC animated:YES completion:nil];
        
     }
#pragma mark  ----------点赞--------------
    else  if(button.tag==10002)
    {

        NSNumber  *operation;
        int tag=0;// 标志是否 已赞  如果tag＝1  已赞  否则tag＝0 是未赞的
        for (int i=0; i<self.upweiboArray.count; i++) {
            //已赞的
            UpweiboModel *upmodel =self.upweiboArray[i];
            
            if ([upmodel.weibo_id intValue]==[weiboDict.Id intValue]) {
                tag=1;
                operation =[NSNumber numberWithInt:0];
                int like=[weiboDict.like_count intValue];
                like=like-1;
                weiboDict.like_count=[NSNumber numberWithInt:like];
                [self.upweiboArray removeObjectAtIndex:i];
                break;
            }
        }
        //查询到最后如果没有查到说明是没有赞过的微博,那么把这条赞信息添加到了赞数组中去
        if (tag==0) {
            //没有赞的
            operation =[NSNumber numberWithInt:1];
            UpweiboModel  *upmodel =[[UpweiboModel alloc]init];
            upmodel.weibo_id=weiboDict.Id;
            upmodel.created_at=weiboDict.created_at;
            upmodel.created_by=weiboDict.created_by;
            upmodel.updated_at=weiboDict.updated_at;
            
            int like=[weiboDict.like_count intValue];
            like=like+1;
            weiboDict.like_count=[NSNumber numberWithInt:like];
            [self.upweiboArray addObject:upmodel];
        }
        [self layoutMarkViewWithMarkView:markView WeiboInfo:weiboDict];
        ////发送到服务器
        [self LikeRequstData:weiboDict withOperation:operation withuserId:userCenter.user_id];
        
    }else if (button.tag==10003)
    {
        UserDataCenter  *userCenter =[UserDataCenter shareInstance];
        if ([userCenter.is_admin  intValue]>0) {
            UIActionSheet   *ash=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"删除",@"变身",@"推荐",@"编辑", nil];
            ash.tag=500;
            [ash showInView:self.view];
        }
        else
        {
            UIActionSheet   *ash=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"举报" otherButtonTitles:nil, nil];
            ash.tag=504;
            [ash showInView:self.view];

        }
    }
}
-(void)ToolViewTagHandClickTagView:(TagView *)tagView withweiboinfo:(weiboInfoModel *)weiboInfo WithTagInfo:(TagModel *)tagInfo
{
    
         [_mymarkView CancelMarksetSelect];
        if (_toolBar) {
            [_toolBar  HidenButtomView];
            [_toolBar removeFromSuperview];
        }
        TagToStageViewController  *vc=[[TagToStageViewController alloc]init];
        vc.weiboInfo=weiboInfo;
        vc.tagInfo=tagInfo;
        UIBarButtonItem  *item =[[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        self.navigationItem.backBarButtonItem=item;
        [self.navigationController pushViewController:vc animated:YES];
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag==500) {
        if (buttonIndex==0) {
            //删除
            [self requestDelectDataWithweiboId:[NSString stringWithFormat:@"%@",_TweiboInfo.Id]];
            
        }
        else if(buttonIndex==1)
        {
            ///变身
            // [self.navigationController pushViewController:[ChangeSelfViewController new] animated:YES];
            //请求随机数种子
            [self requestChangeUserRand4];
        }
        else if(buttonIndex==2)
        {
            //推荐
            [self requestrecommendDataWithStageId:[NSString stringWithFormat:@"%@",_TstageInfo.Id] weiboId:[NSString stringWithFormat:@"%@",_TweiboInfo.Id]];
        }
        else if (buttonIndex==3)
        {
            [_mymarkView CancelMarksetSelect];
            if (_toolBar) {
                [_toolBar HidenButtomView];
                [_toolBar removeFromSuperview];
                
            }

            //弹幕编辑
            AddMarkViewController  *AddMarkVC=[[AddMarkViewController alloc]init];
            AddMarkVC.stageInfo=self.stageInfo;
            AddMarkVC.weiboInfo=_TweiboInfo;
            AddMarkVC.delegate=self;
            [self presentViewController:AddMarkVC animated:NO completion:nil];

        }
    }
    else if (actionSheet.tag==504)
    {
        //确认举报
        [self requestReportweibo];

    }
  
   else if (actionSheet.tag==507) {
        if (buttonIndex==0) {
            //举报剧情
            [self requestReportSatge];
            
        }
        else if(buttonIndex==1)
        {
            //版权问题
            
            [self sendFeedBackWithStageInfo:self.stageInfo];
            
        }
        else if(buttonIndex==2)
        {
            //           查看图片信息
            
            ScanMovieInfoViewController * scanvc =[ScanMovieInfoViewController new];
            scanvc.stageInfo=self.stageInfo;
            [self presentViewController:scanvc animated:YES completion:nil];
        }
        else if (buttonIndex==3)
        {
            NSString  *stageId;
           // stageInfoModel *model=[_dataArray objectAtIndex:Rowindex];
            stageId=[NSString stringWithFormat:@"%@",self.stageInfo.Id];
            //移动到审核版或者正常
            [self requestmoveReviewToNormal:stageId];

        }
        else if (buttonIndex==4)
        {
            //屏蔽剧照
            [self requestRemoveStage:@"0"];
        }
       else if (buttonIndex==5)
       {
           //编辑弹幕功能
           //弹幕编辑
           AddMarkViewController  *AddMarkVC=[[AddMarkViewController alloc]init];
           AddMarkVC.stageInfo=self.stageInfo;
           //AddMarkVC.model=model;
           AddMarkVC.weiboInfo=_WeiboInfo;
           AddMarkVC.delegate=self;
           [self presentViewController:AddMarkVC animated:NO completion:nil];

       }
       else if (buttonIndex==6)
       {
           NSString *weibo_id =[NSString stringWithFormat:@"%@",_WeiboInfo.Id];
           [self requestDelectDataWithweiboId:weibo_id];
       }
       else if (buttonIndex==7)
       {
           //恢复剧照
           [self requestRemoveStage:@"1"];
       }
       else if (buttonIndex==8)
       {
           
           [self requestUpAndDownWithDeretion:@"up"];
           
       }
       else if (buttonIndex==9)
       {
           [self requestUpAndDownWithDeretion:@"down"];
       }
     }
}


- (void)sendFeedBackWithStageInfo:(stageInfoModel *)stageInfo

{
    //    [self showNativeFeedbackWithAppkey:UMENT_APP_KEY];
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (mailClass != nil)
    {
        // We must always check whether the current device is configured for sending emails
        if ([mailClass canSendMail])
        {
            [self displayComposerSheet:stageInfo];
        }
        else
        {
            [self launchMailAppOnDevice];
        }
    }
    else
    {
        [self launchMailAppOnDevice];
    }
    
}
-(void)displayComposerSheet:(stageInfoModel *) stageInfo

{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];/*MFMailComposeViewController邮件发送选择器*/
    picker.mailComposeDelegate = self;
    
    // Custom NavgationBar background And set the backgroup picture
    picker.navigationBar.tintColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.5];
    //    picker.navigationBar.tintColor = [UIColor colorWithRed:178.0/255 green:173.0/255 blue:170.0/255 alpha:1.0]; //    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0) {
    //        [picker.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg.png"] forBarMetrics:UIBarMetricsDefault];
    //    }
    //    NSArray *ccRecipients = [NSArray arrayWithObjects:@"dcj3sjt@gmail.com", nil];
    //    NSArray *bccRecipients = [NSArray arrayWithObjects:@"dcj3sjt@163.com", nil];
    //    [picker setCcRecipients:ccRecipients];
    //    [picker setBccRecipients:bccRecipients];
    
    // Set up recipients
    NSArray *toRecipients = [NSArray arrayWithObject:@"feedback@redianying.com"];
    [picker setToRecipients:toRecipients];
    // Fill out the email body text
    //struct utsname device_info;
    //uname(&device_info);
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appCurName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *appCurVersionNum = [infoDictionary objectForKey:@"CFBundleVersion"];
    
    UIDevice * myDevice = [UIDevice currentDevice];
    NSString * sysVersion = [myDevice systemVersion];
    // NSString *emailBody = [NSString stringWithFormat:@"\n\n\n\n附属信息：\n\n%@ %@(%@)\n%@ / %@ / %@ IOS%@", appCurName, appCurVersion, appCurVersionNum, @"", @"", @"",  sysVersion];

    UserDataCenter  *usercenter=[UserDataCenter shareInstance];
    
    NSString *emailBody = [NSString stringWithFormat:@"\n您的名字：\n联系电话:\n投诉内容:\n\n\n\n\n-------\n请勿删除以下信息，并提交你拥有此版权的证明--------\n\n 电影:%@\n剧情id:%@\n投诉人id:%@\n投诉昵称:%@\n",stageInfo.movieInfo.name,stageInfo.Id,usercenter.user_id,usercenter.username];
    [picker setTitle:@"@版权问题"];
    [picker setMessageBody:emailBody isHTML:NO];
    [picker setSubject:[NSString stringWithFormat:@"版权投诉"]];/*emailpicker标题主题行*/
    
    [self presentViewController:picker animated:YES completion:nil];
    //        [self.navigationController presentViewController:picker animated:YES completion:nil];
    //        [self.navigationController pushViewController:picker animated:YES];
}
-(void)launchMailAppOnDevice
{
    NSString *recipients = @"mailto:dcj3sjt@gmail.com&subject=Pocket Truth or Dare Support";
    NSString *body = @"&body=email body!";
    NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
    email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}
// 2. Displays an email composition interface inside the application. Populates all the Mail fields.

#pragma mark - 协议的委托方法

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    NSString *msg;
    switch (result)
    {
        case MFMailComposeResultCancelled:
            msg = @"邮件发送取消";//@"邮件发送取消";
            break;
        case MFMailComposeResultSaved:
            msg = @"邮件保存成功";//@"邮件保存成功";
            break;
        case MFMailComposeResultSent:
            msg = @"邮件发送成功";//@"邮件发送成功";
            break;
        case MFMailComposeResultFailed:
            msg = @"邮件发送失败";//@"邮件发送失败";
            break;
        default:
            msg = @"邮件未发送";
            break;
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
}


//重新布局markview
-(void)layoutMarkViewWithMarkView:(MarkView  *) markView WeiboInfo:(weiboInfoModel *) weibodict
{
#pragma mark   缩放整体的弹幕大小
    [Function BasicAnimationwithkey:@"transform.scale" Duration:0.25 repeatcont:1 autoresverses:YES fromValue:1.0 toValue:1.05 View:markView];
     NSString  *weiboTitleString=weibodict.content;
    NSString  *UpString=[NSString stringWithFormat:@"%@",weibodict.like_count];//weibodict.ups;
    //计算标题的size
    CGSize  Msize=[weiboTitleString boundingRectWithSize:CGSizeMake(kDeviceWidth/2,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:markView.TitleLable.font forKey:NSFontAttributeName] context:nil].size;
    // 计算赞数量的size
    CGSize Usize=[UpString boundingRectWithSize:CGSizeMake(40,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:markView.ZanNumLable.font forKey:NSFontAttributeName] context:nil].size;
     //计算赞数量的长度
    float  Uwidth=[UpString floatValue]==0?0:Usize.width;
    //宽度=字的宽度+左头像图片的宽度＋赞图片的宽度＋赞数量的宽度+中间两个空格2+2
    float markViewWidth = Msize.width+23+Uwidth+5+5+11+5;
    float markViewHeight = Msize.height+6;
    if(IsIphone6plus)
    {
        markViewWidth=markViewWidth+10;
        markViewHeight=markViewHeight+4;
    }
#pragma mark 设置气泡的大小和位置
    markView.frame=CGRectMake(markView.frame.origin.x, markView.frame.origin.y, markViewWidth, markViewHeight);
    if (weibodict.tagArray.count>0) {
        markView.frame=CGRectMake(markView.frame.origin.x, markView.frame.origin.y, markViewWidth, markViewHeight+TagHeight+6);
    }

#pragma mark 设置标签的内容
    // markView.TitleLable.text=weiboTitleString;
    markView.ZanNumLable.text =[NSString stringWithFormat:@"%@",weibodict.like_count];
    if ([weibodict.like_count intValue]==0) {
        markView.ZanNumLable.hidden=YES;
    }
    else
    {
        markView.ZanNumLable.hidden=NO;
    }
    
}


//- (void)handleComplete {
//    [self dismissViewControllerAnimated:NO completion:^{ }];
//}

@end
