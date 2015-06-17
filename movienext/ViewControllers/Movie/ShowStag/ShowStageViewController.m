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
#import "UIButton+Block.h"
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
#import "SelectTimeView.h"
#define ADM_ACTION_TAG    1000   //统一管理管弹出框

#define ADM_NEW_ADD       1003  //最新添加
#define ADM_CLOSE_STAGE   1004   //已屏蔽的弹幕
#define ADM_DSCORVER      1005  // 发现
#define ADM_RECOMMEND     1006    //管理员热门
#define ADM_HOT_LIST       1007   //管理员热门进入
#define CUS_ACTION_TAG   1001   //普通用户弹出框
#define CUSSEFT_ACTION_TAG   1002  //普通用户自己的页弹出框
#define  TOOLBAR_HEIGHT  160
#define ADM_BTN_BLOCK   2000  //屏蔽
#define ADM_BTN_NEW     2001  //最新
#define ADM_BTN_NORMAL  2002  //正常
#define ADM_BTN_DISCOVER 2003 //发现
#define ADM_BTN_TIMING   2004 //定时

@interface ShowStageViewController() <ButtomToolViewDelegate,StageViewDelegate,AddMarkViewControllerDelegate,UMShareViewControllerDelegate,UMSocialDataDelegate,UMSocialUIDelegate,UIActionSheetDelegate,UMShareViewController2Delegate,UMShareViewDelegate,TagViewDelegate,UIAlertViewDelegate,SelectTimeViewDelegate>
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
    // weiboInfoModel  *_WeiboInfo;
    UIButton  *like_btn;
    UIButton *ShareButton;  //分享
    UIButton  *addMarkButton;  //添加弹幕
    
}
@property(nonatomic,strong) M80AttributedLabel  *tagLable;  //弹幕的混排

@property(nonatomic,strong) M80AttributedLabel  *WeiboTagLable;  //中间

@property(nonatomic,strong) UIImageView   *stageImageView;

@property(nonatomic,strong) UIView  *ShareView;

@property(nonatomic,strong) weiboInfoModel  *WeiboInfo;


@end

@implementation ShowStageViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    if (self.stageInfo.weibosArray.count>0) {
        _WeiboInfo=[self.stageInfo.weibosArray objectAtIndex:0];
    }
    else
    {
        _WeiboInfo=self.weiboInfo;
    }
    
    [self createShareToolBar];
}
-(void)createNav
{
    __weak typeof(self) weakSelf = self;
    NSString  *titleString =[Function htmlString: self.stageInfo.movieInfo.name ];
    UILabel  *titleLable=[ZCControl createLabelWithFrame:CGRectMake(0, 0, 100, 30) Font:30 Text:titleString];
    titleLable.textColor=VBlue_color;
    titleLable.font=[UIFont fontWithName:kFontDouble size:16];
    titleLable.textColor=VGray_color;
    titleLable.textAlignment=NSTextAlignmentCenter;
    self.navigationItem.titleView=titleLable;
    UserDataCenter  *usecenter =[UserDataCenter shareInstance];
    UIButton  *admOper =[UIButton buttonWithType:UIButtonTypeCustom];
    admOper.frame=CGRectMake(0, 0, 30, 25);
    admOper.imageEdgeInsets=UIEdgeInsetsMake(0, 10, 0, -10);
    admOper.hidden=YES;
    [admOper setTitleColor:VGray_color forState:UIControlStateNormal];
    ///[admOper setTitle:@"管" forState:UIControlStateNormal];
    [admOper setImage:[UIImage imageNamed:@"guanliyuan_detail"] forState:UIControlStateNormal];
    [admOper setTitleColor:VBlue_color forState:UIControlStateNormal];
    
    
    [admOper  addActionHandler:^(NSInteger tag) {
        //管理员
            UIActionSheet  *Act=[[UIActionSheet alloc]initWithTitle:nil delegate:weakSelf cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"[切换剧照到审核/正式版]",@"[编辑弹幕]",@"[点赞]",@"[点踩]",@"[发送到 “屏蔽”]",@"[发送到 “最新”]",@"[发送到 “正常”]",@"[发送到 “发现”]",@"[定时到 “热门”]",nil];
            Act.tag=ADM_ACTION_TAG;
            [Act showInView:weakSelf.view];
    }];
    UIBarButtonItem  *aditme =[[UIBarButtonItem alloc]initWithCustomView:admOper];
    //更多
    //moreButton=[ZCControl createButtonWithFrame:CGRectMake(kStageWidth-135, 9, 30, 25) ImageName:nil Target:self Action:@selector(NavigationButtonClick:) Title:@""];
    moreButton =[UIButton buttonWithType:UIButtonTypeCustom];
    moreButton.frame=CGRectMake(0, 0, 30, 25);
    [moreButton setImage:[UIImage imageNamed:@"three_points"] forState:UIControlStateNormal];
    moreButton.imageEdgeInsets=UIEdgeInsetsMake(0, 10, 0, -10);
    [moreButton addActionHandler:^(NSInteger tag) {
        // UserDataCenter  *userCenter =[UserDataCenter shareInstance];
        //点击了更多
        if (self.pageType==NSStagePapeTypeMyAdd) {
            UIActionSheet  *Act=[[UIActionSheet alloc]initWithTitle:nil delegate:weakSelf cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"删除卡片",nil];
            Act.tag=CUSSEFT_ACTION_TAG;
            [Act showInView:weakSelf.view];
        }
        else
        {
            UIActionSheet  *Act=[[UIActionSheet alloc]initWithTitle:nil delegate:weakSelf cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"内容投诉",@"版权投诉",@"图片信息",nil];
            Act.tag=CUS_ACTION_TAG;
            [Act showInView:weakSelf.view];
        }
    }];
    if ([usecenter.is_admin intValue] >0) {
        admOper.hidden=NO;
    }
    
    if (weakSelf.pageType==NSStagePapeTypeAdmin_New_Add
        || weakSelf.pageType==NSStagePapeTypeAdmin_Close_Weibo
        || weakSelf.pageType==NSStagePapeTypeAdmin_Dscorver
        || weakSelf.pageType==NSStagePapeTypeAdmin_Recommed
        || weakSelf.pageType==NSStagePapeTypeAdmin_Timing
        || weakSelf.pageType==NSStagePapeTypeAdmin_Not_Review) {
        admOper.hidden = YES;
    }
    
    //隐藏该隐藏的地方
    if (self.pageType==NSStagePapeTypeAdmin_Close_Weibo||self.pageType==NSStagePapeTypeAdmin_Dscorver||self.pageType==NSStagePapeTypeAdmin_New_Add||self.pageType==NSStagePapeTypeAdmin_Recommed) {
        moreButton.hidden=YES;
    }
    
    [moreButton setTitleColor:VGray_color forState:UIControlStateNormal];
    UIBarButtonItem  *item =[[UIBarButtonItem alloc]initWithCustomView:moreButton];
    self.navigationItem.rightBarButtonItems =@[item,aditme];
    
    
}
-(void)createScrollView
{
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-TOOLBAR_HEIGHT)];
    scrollView.backgroundColor =View_BackGround;
    scrollView.contentSize = CGSizeMake(kDeviceWidth, kDeviceHeight);
    [self.view addSubview:scrollView];
}


-(void)createStageView
{
    
    
    //分享出来的不是这个view
    BgView =[[UIImageView alloc]initWithFrame:CGRectMake(0,0,kDeviceWidth, (kDeviceWidth-0)*(9.0/16))];
    BgView.clipsToBounds=YES;
    [BgView.layer setShadowOffset:CGSizeMake(kDeviceWidth, 20)];
    BgView.backgroundColor=View_ToolBar;
    BgView.userInteractionEnabled=YES;
    [scrollView addSubview:BgView];
    
    //最后要分享出去的图
    self.ShareView =[[UIView alloc]initWithFrame:CGRectMake(10,10, kDeviceWidth-20, (kDeviceWidth-20)*(9.0/16))];
    self.ShareView.userInteractionEnabled=YES;
    self.ShareView.backgroundColor=[UIColor blackColor];
    [BgView addSubview:self.ShareView];
    CGRect frame =[Function getImageFrameWithwidth:[self.stageInfo.width intValue] height:[self.stageInfo.height intValue] inset:20];
    
    //分享的view 上面放一张图片
    self.stageImageView =[[UIImageView alloc]initWithFrame:frame];
    self.stageImageView.contentMode=UIViewContentModeScaleAspectFill;
    self.stageImageView.clipsToBounds=YES;
    NSString *photostring=[NSString stringWithFormat:@"%@%@!w640",kUrlStage,self.stageInfo.photo];
    [self.stageImageView   sd_setImageWithURL:[NSURL URLWithString:photostring] placeholderImage:nil options:(SDWebImageLowPriority|SDWebImageRetryFailed)];
    [self.ShareView addSubview:self.stageImageView];
    
    
    
    
    self.ShareView.frame=CGRectMake(10, 10, kDeviceWidth-20, self.stageImageView.frame.size.height+0);
    BgView.frame=CGRectMake(0, 0, kDeviceWidth, self.ShareView.frame.size.height+20);
    
    
    //创建剧照上的渐变背景文字
    UIView  *_layerView =[[UIView alloc]initWithFrame:CGRectMake(0, self.stageImageView.frame.size.height-60, kDeviceWidth-20, 60)];
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
    
    
    markLable=[ZCControl createLabelWithFrame:CGRectMake(10,40,_layerView.frame.size.width-20, 60) Font:20 Text:@"弹幕文字"];
    markLable.font =[UIFont fontWithName:kFontDouble size:23];
    //markLable.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.4];
    if (IsIphone6) {
        markLable.frame=CGRectMake(20, 30, _layerView.frame.size.width-40, 65);
        markLable.font =[UIFont fontWithName:kFontDouble size:25];
    }
    if (IsIphone6plus) {
        markLable.frame=CGRectMake(20, 20,_layerView.frame.size.width-40, 70);
        markLable.font=[UIFont fontWithName:kFontDouble size:28];
    }

    
    
    
    markLable.textColor=[UIColor whiteColor];
    weiboInfoModel *weibomodel;
    if (self.stageInfo.weibosArray.count>0) {
        weibomodel =[self.stageInfo.weibosArray objectAtIndex:0];
    }
    if (self.weiboInfo) {
        weibomodel=self.WeiboInfo;
    }
     markLable.text=weibomodel.content;
    
    if (self.weiboInfo) {
        markLable.text=self.weiboInfo.content;
   }
    markLable.lineBreakMode=NSLineBreakByCharWrapping;
    markLable.contentMode=UIViewContentModeBottom;
    markLable.textAlignment=NSTextAlignmentCenter;
    [self.ShareView addSubview:markLable];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;
    NSDictionary *attributes = @{
                                 NSFontAttributeName:markLable.font,
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    markLable.attributedText = [[NSAttributedString alloc] initWithString:markLable.text attributes:attributes];
    

    
    //计算文字的高度从而确定整个shareview的高度
    
    CGSize  Msize = [markLable.text boundingRectWithSize:CGSizeMake(kDeviceWidth-40, MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:[NSDictionary dictionaryWithObject:markLable.font forKey:NSFontAttributeName] context:nil].size;
    
    self.ShareView.frame=CGRectMake(self.ShareView.frame.origin.x, self.ShareView.frame.origin.y, self.ShareView.frame.size.width, self.ShareView.frame.size.height+Msize.height-27);
    BgView.frame=CGRectMake(0, 0, kDeviceWidth, self.ShareView.frame.size.height+20);
    
    markLable.frame=CGRectMake(10, self.ShareView.frame.size.height-Msize.height-5 ,self.ShareView.frame.size.width-20,Msize.height);
    
    
    //创建中间的工具栏
    [self createCenterContentView];
    
}
-(void)createCenterContentView
{
    
    BgView2=[[UIView alloc]initWithFrame:CGRectMake(0,self.ShareView.frame.origin.y+self.ShareView.frame.size.height+5, kDeviceWidth, 40 +0)];
    //改变toolar 的颜色
    BgView2.backgroundColor=View_ToolBar;
    [self.view bringSubviewToFront:BgView2];
    [BgView addSubview:BgView2];
    BgView.frame=CGRectMake(0, 0, kDeviceWidth, self.ShareView.frame.size.height+45+20);
    
    
    leftButtomButton=[UIButton buttonWithType:UIButtonTypeCustom];
    leftButtomButton.frame=CGRectMake(10, 5, 140, 35);
    __weak typeof(self) weakSeaf = self;
    // [leftButtomButton addTarget:self action:@selector(StageMovieButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [leftButtomButton addActionHandler:^(NSInteger tag) {
        MyViewController  *myVC=[[MyViewController alloc]init];
        weiboInfoModel *model = [weakSeaf.stageInfo.weibosArray objectAtIndex:0];
        if (weakSeaf.weiboInfo) {
            model=self.weiboInfo;
        }
        myVC.author_id =[NSString stringWithFormat:@"%@",model.uerInfo.Id];
        UIBarButtonItem  *item =[[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        weakSeaf.navigationItem.backBarButtonItem=item;
        [weakSeaf.navigationController pushViewController:myVC animated:YES];
        
    }];
    [BgView2 addSubview:leftButtomButton];
    
    
    MovieLogoImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,30, 30)];
    MovieLogoImageView.layer.cornerRadius=15;
    //显示微博的头像
    if (self.stageInfo.weibosArray.count>0) {
        _WeiboInfo =[self.stageInfo.weibosArray objectAtIndex:0];
    }
    else if (self.weiboInfo)
    {
        _WeiboInfo=self.weiboInfo;
    }
    NSString  *uselogoString =[NSString stringWithFormat:@"%@%@!thumb",kUrlAvatar,_WeiboInfo.uerInfo.logo];
    if (self.weiboInfo) {
        uselogoString=[NSString stringWithFormat:@"%@%@!thumb",kUrlAvatar,self.weiboInfo.uerInfo.logo];
    }
    [MovieLogoImageView sd_setImageWithURL:[NSURL URLWithString:uselogoString] placeholderImage:[UIImage imageNamed:@"user_normal.png"]];
    MovieLogoImageView.layer.masksToBounds = YES;
    
    ///给管理员添加查看是否为虚拟用户
    UserDataCenter *userDataCenter = [UserDataCenter shareInstance];
    if ([userDataCenter.is_admin intValue]>0 && [_WeiboInfo.uerInfo.fake intValue] == 0) {
        UIImageView *ivFake = [[UIImageView alloc] initWithFrame:CGRectMake(MovieLogoImageView.bounds.size.width-10 , MovieLogoImageView.bounds.size.height-10, 6, 6)];
        ivFake.backgroundColor = [UIColor blueColor];
        ivFake.layer.masksToBounds = YES;
        ivFake.layer.cornerRadius = 3;
        [MovieLogoImageView addSubview:ivFake];
    }
    
    [leftButtomButton addSubview:MovieLogoImageView];
    
    movieNameLable =[[UILabel alloc]initWithFrame:CGRectMake(35,12, 120, 30)];
    movieNameLable.font=[UIFont fontWithName:kFontRegular size:16];
    movieNameLable.textColor=VGray_color;
    //movieNameLable.text=self.stageInfo.movieInfo.name;
    // movieNameLable.numberOfLines=1;
    movieNameLable.lineBreakMode=NSLineBreakByTruncatingTail;
    [leftButtomButton addSubview:movieNameLable];
    NSString  *nameStr=_WeiboInfo.uerInfo.username;
    if (!nameStr) {
        nameStr =self.weiboInfo.uerInfo.username;
    }
    CGSize  Nsize =[nameStr boundingRectWithSize:CGSizeMake(kDeviceWidth-35-70, 27) options:(NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin) attributes:[NSDictionary dictionaryWithObject:movieNameLable.font forKey:NSFontAttributeName] context:nil].size;
    movieNameLable.frame=CGRectMake(35,0, Nsize.width+4, 30);
    leftButtomButton.frame=CGRectMake(10, 9, 30+5+movieNameLable.frame.size.width, 27);
    movieNameLable.text=[NSString stringWithFormat:@"%@",nameStr];
    
    //点赞的按钮 上面放一张图片 右边放文字
    like_btn =[ZCControl createButtonWithFrame:CGRectMake(kStageWidth-70,10,70,25) ImageName:nil Target:self Action:@selector(clickLike:) Title:@""];
    like_btn.layer.cornerRadius=4;
    like_btn.clipsToBounds=YES;
    like_btn.backgroundColor=View_BackGround;
    [BgView2 addSubview:like_btn];
    
    //赞的星星
    starImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 7, 14,12)];
    starImageView.image =[UIImage imageNamed:@"like_nomoal.png"];
    [like_btn addSubview:starImageView];
    
    //赞的文字
    Like_lable =[ZCControl createLabelWithFrame:CGRectMake(20,0,40, 25) Font:14 Text:@""];
    Like_lable.textColor=VGray_color;
    Like_lable.textAlignment=NSTextAlignmentCenter;
    if (IsIphone6plus) {
        like_btn.frame=CGRectMake(kStageWidth-80, 10, 80, 32);
        starImageView.frame=CGRectMake(15, 10, 14, 12);
        Like_lable.frame=CGRectMake(20, 0, 60, 32);
    }
    
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
    [self createWeiboTagView];
    
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
    
    TagContentView  = [[UIView alloc]initWithFrame:CGRectMake(0, BgView2.frame.origin.y+BgView2.frame.size.height, kDeviceWidth, 40)];
    TagContentView.backgroundColor =[UIColor clearColor];
    [BgView addSubview:TagContentView];
    
    self.WeiboTagLable=[[M80AttributedLabel alloc]initWithFrame:CGRectZero];
    self.WeiboTagLable.backgroundColor =[UIColor clearColor];
    self.WeiboTagLable.lineSpacing=5;
    [TagContentView addSubview:self.WeiboTagLable];
    //初始化的时候获取第一个标签
    if (_WeiboInfo.tagArray.count>0) {
        for (int i=0; i<_WeiboInfo.tagArray.count; i++) {
            TagView  *tagView= [[TagView alloc]initWithWeiboInfo:_WeiboInfo AndTagInfo:_WeiboInfo.tagArray[i] delegate:self isCanClick:YES backgoundImage:nil isLongTag:NO];
            [tagView setcornerRadius:4];
            [tagView setbigTagWithSize:CGSizeMake(6,6)];
            tagView.tag=5000+i;
            //            tagView.backgroundColor =[UIColor redColor];
            [self.WeiboTagLable appendView:tagView margin:UIEdgeInsetsMake(5, 10, 0, 0)];
        }
    }
    CGSize  Tsize =[self.WeiboTagLable sizeThatFits:CGSizeMake(kDeviceWidth-20,CGFLOAT_MAX)];
    self.WeiboTagLable.frame=CGRectMake(0, 0, kDeviceWidth-20, Tsize.height+0);
    if (Tsize.height>10) {
        TagContentView.frame=CGRectMake(0, BgView2.frame.origin.y+BgView2.frame.size.height+5, kDeviceWidth,Tsize.height+5);
    }
    else
    {
        TagContentView.frame=CGRectMake(0, BgView2.frame.origin.y+BgView2.frame.size.height, kDeviceWidth, 10);
    }
    BgView.frame=CGRectMake(0,0,kDeviceWidth,TagContentView.frame.origin.y+TagContentView.frame.size.height+0);
    
    
}
#pragma mark 星星点赞方法
//点赞实现的方法
-(void)clickLike:(UIButton *) btn
{
    UserDataCenter  * userCenter =[UserDataCenter shareInstance];
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
    __weak typeof(self) weakSelf = self;
    UIView  *shareView=[[UIView alloc]initWithFrame:CGRectMake(0, kDeviceHeight-TOOLBAR_HEIGHT-kHeightNavigation, kDeviceWidth, TOOLBAR_HEIGHT)];
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
    self.tagLable.numberOfLines=1;
    
    
    if (self.weiboInfo) {//如果 从管理员的最新页进来
        TagView *tagview = [self createTagViewWithweiboInfo:self.weiboInfo andIndex:300];
        [tagview setbigTagWithSize:CGSizeMake(10, 12)];
        [self.tagLable appendView:tagview margin:UIEdgeInsetsMake(0, 0, 0, 5)];
        self.tagLable.lineSpacing=5;
        self.tagLable.numberOfLines=0;
        if (self.weiboInfo.content.length==0) {
            tagview.frame=CGRectZero;
        }
        tagview.tagBgImageview.backgroundColor =VLight_GrayColor;
        tagview.titleLable.textColor=[UIColor whiteColor];
    }
    else {
        for (int i=0; i<self.stageInfo.weibosArray.count; i++) {
            TagView *tagview = [self createTagViewWithweiboInfo:self.stageInfo.weibosArray[i] andIndex:i];
            [tagview setbigTagWithSize:CGSizeMake(10, 12)];
            [self.tagLable appendView:tagview margin:UIEdgeInsetsMake(0, 0, 0, 5)];
            self.tagLable.lineSpacing=5;
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
    
    if (weakSelf.pageType==NSStagePapeTypeAdmin_New_Add
        || weakSelf.pageType==NSStagePapeTypeAdmin_Close_Weibo
        || weakSelf.pageType==NSStagePapeTypeAdmin_Dscorver
        || weakSelf.pageType==NSStagePapeTypeAdmin_Recommed
        || weakSelf.pageType==NSStagePapeTypeAdmin_Timing
        || weakSelf.pageType==NSStagePapeTypeAdmin_Not_Review) {
        NSArray *titleArray = [NSArray arrayWithObjects:@"屏蔽", @"最新", @"正常", @"发现", @"定时", nil];
        for (int i=0; i<5; i++) {
            UIButton *btnBlock =[UIButton buttonWithType:UIButtonTypeCustom];
            btnBlock.tag = 2000 + i;
            btnBlock.frame=CGRectMake(kDeviceWidth/5*i, TOOLBAR_HEIGHT-45, kDeviceWidth/5, 45);
            [btnBlock setTitle:titleArray[i] forState:UIControlStateNormal];
            [btnBlock setTitleColor:VBlue_color forState:UIControlStateNormal];
            [btnBlock setBackgroundImage:[UIImage imageNamed:@"tabbar_backgroud_color"] forState:UIControlStateNormal];
            [btnBlock addTarget:self action:@selector(changeWeiboStatus:) forControlEvents:UIControlEventTouchUpInside];
            [shareView addSubview:btnBlock];
        }
    } else {
        addMarkButton =[UIButton buttonWithType:UIButtonTypeCustom];
        addMarkButton.frame=CGRectMake(0, TOOLBAR_HEIGHT-45, kDeviceWidth/2, 45);
        [addMarkButton setTitle:@"我要添加" forState:UIControlStateNormal];
        
        [addMarkButton addActionHandler:^(NSInteger tag) {
            AddMarkViewController  *AddMarkVC=[[AddMarkViewController alloc]init];
            AddMarkVC.delegate=weakSelf;
            // AddMarkVC.model=self.stageInfo;
            AddMarkVC.stageInfo=weakSelf.stageInfo;
            [weakSelf.navigationController pushViewController:AddMarkVC animated:NO];
            
        }];
        addMarkButton.titleLabel.font =[UIFont fontWithName:kFontDouble size:16];
        [addMarkButton setTitleColor:VBlue_color forState:UIControlStateNormal];
        //ShareButton.backgroundColor =[UIColor redColor];
        [addMarkButton setBackgroundImage:[UIImage imageNamed:@"tabbar_backgroud_color"] forState:UIControlStateNormal];
        [shareView addSubview:addMarkButton];
        
        ShareButton =[UIButton buttonWithType:UIButtonTypeCustom];
        ShareButton.frame=CGRectMake(kDeviceWidth/2, TOOLBAR_HEIGHT-45, kDeviceWidth/2, 45);
        [ShareButton setTitle:@"我要分享" forState:UIControlStateNormal];
        [ShareButton addActionHandler:^(NSInteger tag) {
            float  height = weakSelf.ShareView.frame.size.height;
            UIImage  *image=[Function getImage:weakSelf.ShareView WithSize:CGSizeMake(kDeviceWidth-20,height)];
            if (weakSelf.weiboInfo) {
                weakSelf.stageInfo=weakSelf.weiboInfo.stageInfo;
            }
            UMShareView *shareView =[[UMShareView alloc] initwithStageInfo:weakSelf.stageInfo ScreenImage:image delgate:weakSelf andShareHeight:height];
            [shareView setShareLable];
            [shareView show];
            
        }];
        ShareButton.titleLabel.font =[UIFont fontWithName:kFontDouble size:16];
        [ShareButton setTitleColor:VBlue_color forState:UIControlStateNormal];
        [ShareButton setBackgroundImage:[UIImage imageNamed:@"tabbar_backgroud_color"] forState:UIControlStateNormal];
        [shareView addSubview:ShareButton];
        
        //添加一个线
        UIView  *verline =[[UIView alloc]initWithFrame:CGRectMake(kDeviceWidth/2,TOOLBAR_HEIGHT-36, 0.5, 26)];
        verline.backgroundColor =VLight_GrayColor;
        [shareView addSubview:verline];
    }
    
}

-(TagView *) createTagViewWithweiboInfo:(weiboInfoModel *) weiboInfo andIndex:(NSInteger) index
{
    TagView *tagview =[[TagView alloc]initWithWeiboInfo:weiboInfo AndTagInfo:nil delegate:self isCanClick:YES backgoundImage:nil isLongTag:NO];
    [tagview setcornerRadius:2];
    if (weiboInfo.content.length==0) {
        tagview.frame=CGRectZero;
    }
    
    tagview.tagBgImageview.backgroundColor =VLight_GrayColor_apla;
    tagview.titleLable.textColor=VGray_color;
    tagview.tag=2000+index;
    //[tagview setbigTag:YES];
    return tagview;
}


-(void)TapViewClick:(TagView *)tagView Withweibo:(weiboInfoModel *)weiboInfo withTagInfo:(TagModel *)tagInfo
{
    
    if (tagView.tag<5000) {  // 点击的是微博标签
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
        
        ///重新改变shareview的高度
        markLable.text=weiboInfo.content;
        CGSize  Msize = [weiboInfo.content boundingRectWithSize:CGSizeMake(kDeviceWidth-40, MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:[NSDictionary dictionaryWithObject:markLable.font forKey:NSFontAttributeName] context:nil].size;
        
        self.ShareView.frame=CGRectMake(10,10, self.ShareView.frame.size.width, self.stageImageView.frame.size.height+Msize.height-27);
        BgView2.frame=CGRectMake(BgView2.frame.origin.x, self.ShareView.frame.origin.y+self.ShareView.frame.size.height+5, BgView2.frame.size.width, BgView2.frame.size.height);
        BgView.frame=CGRectMake(0, 0, kDeviceWidth, self.ShareView.frame.size.height+45+20);
        markLable.frame=CGRectMake(10, self.ShareView.frame.size.height-Msize.height-5 ,self.ShareView.frame.size.width-20,Msize.height);
        
        
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
            else {
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
    
    else
    {
        //跳转到标签列表页
        TagToStageViewController  *vc=[[TagToStageViewController alloc]init];
        vc.weiboInfo=weiboInfo;
        vc.tagInfo=tagInfo;
        UIBarButtonItem  *item =[[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        self.navigationItem.backBarButtonItem=item;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark --- User Action
#pragma mark ---

- (void)changeWeiboStatus:(UIButton *)sender{
    switch (sender.tag) {
        case ADM_BTN_BLOCK:
        {
            [self requestChangeStageStatusWithweiboId:[NSString stringWithFormat:@"%@",_WeiboInfo.Id] StatusType:@"0"];
        }
            break;
        case ADM_BTN_NEW:
        {
            [self requestChangeStageStatusWithweiboId:[NSString stringWithFormat:@"%@",_WeiboInfo.Id] StatusType:@"5"];
        }
            break;
        case ADM_BTN_NORMAL:
        {
            [self requestChangeStageStatusWithweiboId:[NSString stringWithFormat:@"%@",_WeiboInfo.Id] StatusType:@"1"];
        }
            break;
        case ADM_BTN_DISCOVER:
        {
            [self requestChangeStageStatusWithweiboId:[NSString stringWithFormat:@"%@",_WeiboInfo.Id] StatusType:@"2"];
        }
            break;
        case ADM_BTN_TIMING:
        {
            //时间
            SelectTimeView  *datepicker =[[SelectTimeView alloc]init];
            datepicker.delegate=self;
            [datepicker show];
        }
            break;
            
        default:
            break;
    }
}

#pragma  mark  ----RequestData
#pragma  mark  ---
// status 0 屏蔽 1 最新/初始 2 发现/电影页 3 热门
//status为2是移到发现/电影页, status为3是移到推荐页
-(void)requestChangeStageStatusWithweiboId:(NSString *)weiboId StatusType:(NSString *) status
{
    UserDataCenter  *userCenter=[UserDataCenter shareInstance];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters=@{@"user_id":userCenter.user_id,@"weibo_id":weiboId,@"status":status};
    
    [manager POST:[NSString stringWithFormat:@"%@/weibo/change-status", kApiBaseUrl] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject  objectForKey:@"code"]  intValue]==0) {
            UIAlertView  * al =[[UIAlertView alloc]initWithTitle:nil message:@"操作成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [al show];
            //请求点赞
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}
//定时发送到热门,发送时间戳
-(void)requesttiming:(NSString *)weiboId AndTimeSp:(NSString *)timeSp
{
    UserDataCenter  *userCenter=[UserDataCenter shareInstance];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters=@{@"user_id":userCenter.user_id,@"weibo_id":weiboId,@"status":@"3",@"updated_at":timeSp};
    [manager POST:[NSString stringWithFormat:@"%@/weibo/change-status", kApiBaseUrl] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject  objectForKey:@"code"]  intValue]==0) {
            
            UIAlertView  * al =[[UIAlertView alloc]initWithTitle:nil message:@"定时到热门成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [al show];
            //请求点赞
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
    }];
}




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
    NSDictionary *parameters = @{@"reported_user_id":_WeiboInfo.uerInfo.Id,@"weibo_id":_WeiboInfo.Id,@"reason":@"",@"user_id":userCenter.user_id};
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
-(void)requestDelectDataWithweiboId:(NSString  *) weiboId WithremoveType:(NSString *)type
{
    UserDataCenter *userCenter=[UserDataCenter shareInstance];
    NSDictionary *parameters = @{@"weibo_id":weiboId,@"user_id":userCenter.user_id,@"remove_type":type};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/weibo/remove", kApiBaseUrl] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject  objectForKey:@"code"]  intValue]==0) {
            NSLog(@"删除数据成功=======%@",responseObject);
            UIAlertView  *Al=[[UIAlertView alloc]initWithTitle:nil message:@"删除成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            Al.tag=3000;
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

#pragma  mark -------AddMarkViewControllerReturn  --Delegete-------------
-(void)AddMarkViewControllerReturn
{
    //  [stageView configStageViewforStageInfoDict];
    
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
    if (actionSheet.tag==ADM_ACTION_TAG) {
        //管理员的
        if (buttonIndex==0) {
            //切换剧照到审核版
            NSString  *stageId;
            // stageInfoModel *model=[_dataArray objectAtIndex:Rowindex];
            stageId=[NSString stringWithFormat:@"%@",self.stageInfo.Id];
            //移动到审核版或者正常
            [self requestmoveReviewToNormal:stageId];
        }
        else if (buttonIndex==1)
        {
            // 编辑弹幕
            //弹幕编辑
            AddMarkViewController  *AddMarkVC=[[AddMarkViewController alloc]init];
            AddMarkVC.stageInfo=self.stageInfo;
            AddMarkVC.weiboInfo=_WeiboInfo;
            AddMarkVC.delegate=self;
            [self.navigationController pushViewController:AddMarkVC animated:NO];
        }
        else if (buttonIndex==2)
        {
            //点赞
            [self requestUpAndDownWithDeretion:@"up"];
            
        }
        else if (buttonIndex==3)
        {
            // 踩
            [self requestUpAndDownWithDeretion:@"down"];
        }
        else if (buttonIndex==4)
        {
            // 屏蔽
            NSString *weibo_id =[NSString stringWithFormat:@"%@",_WeiboInfo.Id];
            [self requestChangeStageStatusWithweiboId:weibo_id StatusType:@"0"];
        }
        else if (buttonIndex==5)
        {
            //最新
            NSString *weibo_id =[NSString stringWithFormat:@"%@",_WeiboInfo.Id];
            [self requestChangeStageStatusWithweiboId:weibo_id StatusType:@"5"];
        }
        else if (buttonIndex==6)
        {
            //正常
            NSString *weibo_id =[NSString stringWithFormat:@"%@",_WeiboInfo.Id];
            [self requestChangeStageStatusWithweiboId:weibo_id StatusType:@"1"];
        }
        else if (buttonIndex==7)
        {
            //发现
            NSString *weibo_id =[NSString stringWithFormat:@"%@",_WeiboInfo.Id];
            [self requestChangeStageStatusWithweiboId:weibo_id StatusType:@"2"];
        }
        else if (buttonIndex==8)
        {
            //定时到热门
            SelectTimeView  *datepicker =[[SelectTimeView alloc]init];
            datepicker.delegate=self;
            [datepicker show];
        }
    }
    else if (actionSheet.tag==CUS_ACTION_TAG)
    {
        //普通用户
        if (buttonIndex==0) {
            //确认举报
            [self requestReportweibo];
        }else if (buttonIndex==1)
        {
            //版权投诉
            [self sendFeedBackWithStageInfo:self.stageInfo];
            
        }else if(buttonIndex==2)
        {
            //图片信息
            ScanMovieInfoViewController * scanvc =[ScanMovieInfoViewController new];
            scanvc.stageInfo=self.stageInfo;
            [self presentViewController:scanvc animated:YES completion:nil];
        }
        
    }
    else if (actionSheet.tag==CUSSEFT_ACTION_TAG)
    {
        //普通用户自己删除
        if(buttonIndex==0)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"确认删除吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = 3001;
            [alert show];
        }
    }
}
#pragma mark  selected date time
-(void)DatePickerSelectedTime:(NSString *)dateString
{
    //定时到热门，伴随时间戳
    [self requesttiming:[NSString stringWithFormat:@"%@",_WeiboInfo.Id] AndTimeSp:dateString];
    
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==3000) {
        if (self.pageType==NSStagePapeTypeMyAdd) {
            //返回
            if (self.delegate && [self.delegate respondsToSelector:@selector(reloadMyAddCollectionView)]) {
                [self.delegate reloadMyAddCollectionView];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else if (alertView.tag==3001) {
        if (buttonIndex==1) { // 点击确定再进行删除
            NSString *weibo_id =[NSString stringWithFormat:@"%@",_WeiboInfo.Id];
            [self requestDelectDataWithweiboId:weibo_id WithremoveType:@"0"];
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

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

//- (void)handleComplete {
//    [self dismissViewControllerAnimated:NO completion:^{ }];
//}

@end
