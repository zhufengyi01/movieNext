//
//  AddMarkViewController.m
//  movienext
//
//  Created by 风之翼 on 15/3/9.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "AddMarkViewController.h"
#import "ZCControl.h"
#import "UITextView+PlaceHolder.h"
#import "Constant.h"
#import "Function.h"
#import "UserDataCenter.h"
#import "UIImageView+WebCache.h"
#import "AFNetworking.h"
#import "weiboInfoModel.h"
#import "MovieDetailViewController.h"
#import "TagView.h"
#import "UMSocialData.h"
#import "UMShareViewController2.h"
#import "UMSocial.h"
#import "Masonry.h"
#import "UMShareView.h"
#import "UIButton+Block.h"
//#import "AddTagViewController.h"
#import "UploadProgressView.h"
#import "AddLoadingView.h"
#import  "MyViewController.h"
#import "UITextView+PlaceHolder.h"

#define  PULISH_TOOLBAR_HEIGHT 80

#define  BOOKMARK_WORD_LIMIT 1000


@interface AddMarkViewController ()<UIAlertViewDelegate,UIScrollViewDelegate,UITextViewDelegate,TagViewDelegate,UIAlertViewDelegate,UMShareViewController2Delegate,UMSocialUIDelegate,UMSocialDataDelegate,UMShareViewDelegate>
{
    UIScrollView *_myScorllerView;
    UIToolbar    *_toolBar;
    //UIButton     *textLeftButton;
    UITextView   *_myTextView;
    MarkView     *_myMarkView;
    NSString     *X;
    NSString     *Y;
    CGSize       keyboardSize;
    float        keybordHeight;
    UIButton     *RighttBtn;
    UIView       *tipView;
    UIButton     *publishBtn;
    NSString     *InputStr;
    //标签的lable
    M80AttributedLabel  *taglable;
    UserDataCenter      *userCenter;
    weiboInfoModel      *weibomodel;
    NSMutableArray      *TAGArray;        //把第一个标签到第二个标签存储在数组中
    weiboInfoModel *weibo;
    //UIView *shareView;
    //  UILabel  *markLable;
    
    AddLoadingView  *loading;
}
@property(nonatomic,strong) UIImageView  *stageImageView;  //剧照的图片


@property(nonatomic,strong) UIView      *ShareView;

@property(nonatomic,strong) UIView       *TagContentView;

@end
@implementation AddMarkViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.alpha=1;
    self.navigationController.navigationBar.hidden=YES;
    self.tabBarController.tabBar.hidden=YES;
    //_myTextView.frame= CGRectMake(50, 10, kDeviceWidth-120, 30);
}
//页面已经出现的时候执行这个   所以在执行代理完成后再执行通知的方法
-(void)viewDidAppear:(BOOL)animated
{
    if(_myTextView)
    {
        [_myTextView becomeFirstResponder];
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    keybordHeight=0;
    [self createNavigation];
    [self initData];
    //键盘将要显示
    //一旦开启通知后，那么整个过程中都在监视键盘的事件
    //键盘将要隐藏
    //[[NSNotificationCenter defaultCenter ]addObserver:self selector:@selector(keyboardWillHiden:) name:UIKeyboardWillHideNotification object:nil];
    [self createMyScrollerView];
    [self createStageView];
    [self createAddTagView];
    [self creatPushlishBar];
    // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
    
}
-(void)createNavigation
{
    __weak typeof(self) weakSelf = self;
    UIView  *naview= [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 64)];
    naview.userInteractionEnabled=YES;
    naview.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:naview];
    
    UIButton  *leftBtn= [UIButton buttonWithType:UIButtonTypeSystem];
    leftBtn.frame=CGRectMake(0, 20, 60, 40);
    leftBtn.titleLabel.font =[UIFont fontWithName:kFontRegular size:16];
    [leftBtn setTitleColor:VGray_color forState:UIControlStateNormal];
    [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    leftBtn.titleLabel.adjustsFontSizeToFitWidth=NO;
    [leftBtn addActionHandler:^(NSInteger tag) {
        [weakSelf.navigationController popViewControllerAnimated:NO];
    }];
    [leftBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -0, 0,10)];
    //[leftBtn addTarget:self action:@selector(dealNavClick:) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.tag=100;
    [naview addSubview:leftBtn];
    // UIBarButtonItem  *leftBarButton=[[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    // self.navigationItem.leftBarButtonItem=leftBarButton;
    
    UILabel  *lable =[ZCControl createLabelWithFrame:CGRectMake((kDeviceWidth-100)/2, 25, 100, 30) Font:15 Text:@"添加文字"];
    lable.adjustsFontSizeToFitWidth=NO;
    lable.font=[UIFont fontWithName:kFontDouble size:16];
    lable.textAlignment=NSTextAlignmentCenter;
    lable.textColor=VGray_color;
    [naview addSubview:lable];
    if (self.weiboInfo) {
        lable.text=@"编辑";
    }
    RighttBtn= [UIButton buttonWithType:UIButtonTypeSystem];
    RighttBtn.frame=CGRectMake(kDeviceWidth-70, 20, 60, 40);
    // [RighttBtn addTarget:self action:@selector(dealNavClick:) forControlEvents:UIControlEventTouchUpInside];
    RighttBtn.tag=101;
    // [RighttBtn setTitleColor:VGray_color forState:UIControlStateNormal];
    [RighttBtn setTitle:@"发布" forState:UIControlStateNormal];
    [RighttBtn addActionHandler:^(NSInteger tag) {
        [weakSelf  PublicRuqest];
    }];
    RighttBtn.titleLabel.adjustsFontSizeToFitWidth=NO;
    [RighttBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -10)];
    RighttBtn.titleLabel.font=[UIFont fontWithName:kFontRegular size:16];
    RighttBtn.hidden=YES;
    //[naview addSubview:RighttBtn];
    //self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:RighttBtn];
}
-(void)initData
{
    userCenter=[UserDataCenter shareInstance];
    TAGArray =[[NSMutableArray alloc]init];
    if (self.weiboInfo) {
        NSArray  *array =self.weiboInfo.tagArray;
        for (int i=0;i<array.count; i++) {
            TagModel *tagmodel =[array objectAtIndex:i];
            NSString  *tagString =tagmodel.tagDetailInfo.title;
            NSMutableDictionary  *dict =[NSMutableDictionary  dictionaryWithObject:tagString forKey:@"TAG"];
            [TAGArray   addObject:dict];
        }
    }
}
-(void)createMyScrollerView
{
    //计算stagview 的高度
    _myScorllerView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, kDeviceWidth,kDeviceHeight-kHeightNavigation-PULISH_TOOLBAR_HEIGHT)];
    _myScorllerView.contentSize=CGSizeMake(kDeviceWidth,kDeviceHeight);
    _myScorllerView.delegate=self;
    _myScorllerView.bounces=YES;
    _myScorllerView.backgroundColor =[UIColor whiteColor];
    _myScorllerView.userInteractionEnabled=YES;
    [self.view addSubview:_myScorllerView];
}
-(void)createStageView
{
    //最后要分享出去的图
    self.ShareView =[[UIView alloc]initWithFrame:CGRectMake(10,0, kDeviceWidth-20, (kDeviceWidth-20)*(9.0/16))];
    self.ShareView.userInteractionEnabled=YES;
    self.ShareView.backgroundColor=[UIColor blackColor];
    [_myScorllerView addSubview:self.ShareView];
    
    CGRect  frame  = [Function getImageFrameWithwidth:[self.stageInfo.width intValue] height:[self.stageInfo.height intValue] inset:20];
    
    self.stageImageView =[[UIImageView alloc]initWithFrame:frame];
    self.stageImageView.contentMode=UIViewContentModeScaleAspectFill;
    self.stageImageView.clipsToBounds=YES;
    self.stageImageView.userInteractionEnabled=YES;
    [self.ShareView addSubview:self.stageImageView];
    
    self.ShareView.frame=CGRectMake(10, 0, kDeviceWidth-20, self.stageImageView.frame.size.height);
    NSString *photostring=[NSString stringWithFormat:@"%@%@!w640",kUrlStage,self.stageInfo.photo];
    [self.stageImageView   sd_setImageWithURL:[NSURL URLWithString:photostring] placeholderImage:nil options:(SDWebImageLowPriority|SDWebImageRetryFailed)];
    
    UIView  *_layerView =[[UIView alloc]initWithFrame:CGRectMake(0, self.stageImageView.frame.size.height-60, kDeviceWidth-0, 60)];
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
    
    _myTextView=[[UITextView alloc]initWithFrame:CGRectMake(10,self.ShareView.frame.size.height-40, kDeviceWidth-40, 40)];
    // [_myTextView addPlaceHolder:@"输入弹幕"];
    _myTextView.textColor=[UIColor whiteColor];
    _myTextView.font= [UIFont fontWithName:kFontDouble size:22];
    
    if (IsIphone6plus) {
        _myTextView.font =[UIFont fontWithName:kFontDouble size:24];
    }
    _myTextView.backgroundColor=[UIColor clearColor];
     //_myTextView.layer.cornerRadius=4;
    //_myTextView.layer.borderWidth=0.5;
    _myTextView.layer.allowsEdgeAntialiasing=YES;
    //_myTextView.layer.borderColor=VLight_GrayColor.CGColor;
    //_myTextView.maximumZoomScale=3;
    _myTextView.returnKeyType=UIReturnKeyDone;
    _myTextView.layoutManager.allowsNonContiguousLayout=NO;
    _myTextView.scrollEnabled=YES;
    _myTextView.delegate=self;
    _myTextView.textAlignment=NSTextAlignmentCenter;
    _myTextView.delegate=self;
    // _myTextView.autoresizingMask=UIViewAutoresizingFlexibleHeight;
    _myTextView.selectedRange = NSMakeRange(0,0);  //默认光标从第一个开始
    [_myTextView becomeFirstResponder];
    if (self.weiboInfo) {//编辑
        _myTextView.text =self.weiboInfo.content;
    }
    [self.ShareView addSubview:_myTextView];
}
-(void)createAddTagView
{
    
    
    self.TagContentView =[[UIView alloc]initWithFrame:CGRectMake(0,self.ShareView.frame.origin.y+self.ShareView.frame.size.height, kDeviceWidth, 100)];
    self.TagContentView.userInteractionEnabled=YES;
    self.TagContentView.backgroundColor =View_ToolBar;
    [_myScorllerView addSubview:self.TagContentView];
    
    //    float height =kDeviceHeight-kHeightNavigation-(kDeviceWidth)*(9.0/16);
    //    shareView=[[UIView alloc]initWithFrame:CGRectMake(0,kHeightNavigation+(kDeviceWidth)*(9.0/16), kDeviceWidth, height)];
    //    shareView.userInteractionEnabled=YES;
    //    shareView.backgroundColor =[UIColor yellowColor];
    //
    //    [self.view addSubview:shareView];
    
    
    taglable =[[M80AttributedLabel alloc]initWithFrame:CGRectZero];
    taglable.backgroundColor =[UIColor clearColor];
    taglable.lineSpacing=5.0;
    taglable.font=[UIFont fontWithName:kFontRegular size:MarkTextFont14];
    if (IsIphone6plus) {
        taglable.font =[UIFont fontWithName:kFontRegular size:MarkTextFont16];
    }
    //从编辑进来的
    if (self.weiboInfo) {
        for (int i=0; i<self.weiboInfo.tagArray.count; i++) {
            // NSDictionary  *dict =[TAGArray objectAtIndex:i];
            TagModel  *tagmodel =[self.weiboInfo.tagArray objectAtIndex:i];
            TagView   *tagview =[self createTagViewWithtagText:tagmodel.tagDetailInfo.title withIndex:i withBgImage:[UIImage imageNamed:@"tag_backgroud_color.png"]];
            [taglable appendView:tagview margin:UIEdgeInsetsMake(0, 10, 0, 0)];
        }
    }
    
    //初始化的时候添加一个添加标签的按钮就好了
    TagView  *tagView =[self createTagViewWithtagText:@"添加标签" withIndex:999 withBgImage:nil];
    //[tagView setcornerRadius:YES];
    [tagView setcornerRadius:4];
    tagView.titleLable.textColor=VBlue_color;
    tagView.tagBgImageview.backgroundColor =[UIColor whiteColor];
    tagView.layer.borderColor=VBlue_color.CGColor;
    tagView.layer.borderWidth=2;
    
    [taglable appendView:tagView margin:UIEdgeInsetsMake(0, 0, 0, 0)];
    CGSize  Tsize =[taglable sizeThatFits:CGSizeMake(kDeviceWidth-20, CGFLOAT_MAX)];
    taglable.frame=CGRectMake(10,10, kDeviceWidth-20, Tsize.height);
    [self.TagContentView addSubview:taglable];
    
}
-(void)creatPushlishBar
{
    UIView  *toolview =[[UIView alloc]initWithFrame:CGRectMake(0, kDeviceHeight-PULISH_TOOLBAR_HEIGHT, kDeviceWidth,PULISH_TOOLBAR_HEIGHT)];
    toolview.backgroundColor =View_ToolBar;
    [self.view addSubview:toolview];
    
    UIButton  *publishbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    publishbtn.frame=CGRectMake(40,20,kDeviceWidth-80, 40);
    [publishbtn setTitle:@"发布" forState:UIControlStateNormal];
    publishbtn.layer.cornerRadius=4;
    [publishbtn addActionHandler:^(NSInteger tag) {
        [self PublicRuqest];
        
    }];
    publishbtn.tag=100;
    publishbtn.titleLabel.font =[UIFont fontWithName:kFontDouble size:16];
    publishbtn.backgroundColor = VBlue_color;
    [toolview addSubview:publishbtn];
    
    
}
# pragma  mark  发布数据请求
//确定发布
-(void)PublicRuqest
{
    
    loading = [[AddLoadingView alloc]initWithtitle:@"正在发布"];
    [loading show];
    
    int x=arc4random()%100-1;
    int  y =arc4random()%100-1;
    X=[NSString stringWithFormat:@"%d",x];
    Y=[NSString stringWithFormat:@"%d",y];
    InputStr = [_myTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    
    if ([InputStr isEqualToString:@" "]||!InputStr) {
        UIAlertView  *al =[[UIAlertView alloc]initWithTitle:nil message:@"对不起，内容不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [al show];
    }
    int x_percent=[X intValue];
    X=[NSString stringWithFormat:@"%d",x_percent];
    int y_percent=[Y intValue];
    Y =[NSString stringWithFormat:@"%d",y_percent];
    // UserDataCenter  *userCenter=[UserDataCenter shareInstance];
    NSString  *userid=userCenter.user_id;
    NSNumber  *stageId=self.stageInfo.Id;
    
    NSDictionary *parameter;
    if (TAGArray.count==0) {
        parameter = @{@"user_id": userid,@"content":InputStr,@"stage_id":stageId,@"x_percent":X,@"y_percent":Y};
        if (self.weiboInfo) {
            parameter = @{@"user_id":userid,@"content":InputStr,@"stage_id":stageId,@"x_percent":X,@"y_percent":Y,@"weibo_id":self.weiboInfo.Id};
        }
    }
    else if (TAGArray.count==1)
    {
        NSString  *tag1 =[[TAGArray objectAtIndex:0] objectForKey:@"TAG"];
        parameter = @{@"user_id": userid,@"content":InputStr,@"stage_id":stageId,@"x_percent":X,@"y_percent":Y,@"tags[0]":tag1};
        if (self.weiboInfo) {
            parameter = @{@"user_id": userid,@"content":InputStr,@"stage_id":stageId,@"weibo_id":self.weiboInfo.Id,@"x_percent":X,@"y_percent":Y,@"tags[0]":tag1};
        }
    }
    else if(TAGArray.count==2)
    {
        NSString  *tag1 =[[TAGArray objectAtIndex:0] objectForKey:@"TAG"];
        NSString  *tag2 =[[TAGArray objectAtIndex:1] objectForKey:@"TAG"];
        parameter = @{@"user_id": userid,@"content":InputStr,@"stage_id":stageId,@"x_percent":X,@"y_percent":Y,@"tags[0]":tag1,@"tags[1]":tag2};
        if (self.weiboInfo) {
            parameter = @{@"user_id": userid,@"content":InputStr,@"stage_id":stageId,@"weibo_id":self.weiboInfo.Id,@"x_percent":X,@"y_percent":Y,@"tags[0]":tag1,@"tags[1]":tag2};
        }
    }
    else if (TAGArray.count==3)
    {
        NSString  *tag1 =[[TAGArray objectAtIndex:0] objectForKey:@"TAG"];
        NSString  *tag2 =[[TAGArray objectAtIndex:1] objectForKey:@"TAG"];
        NSString  *tag3 =[[TAGArray objectAtIndex:2] objectForKey:@"TAG"];
        parameter = @{@"user_id": userid,@"content":InputStr,@"stage_id":stageId,@"x_percent":X,@"y_percent":Y,@"tags[0]":tag1,@"tags[1]":tag2,@"tags[2]":tag3};
        if (self.weiboInfo) {
            parameter = @{@"user_id": userid,@"content":InputStr,@"stage_id":stageId,@"weibo_id":self.weiboInfo.Id,@"x_percent":X,@"y_percent":Y,@"tags[0]":tag1,@"tags[1]":tag2,@"tags[2]":tag3};
        }
    }
    else if (TAGArray.count==4)
    {
        NSString  *tag1 =[[TAGArray objectAtIndex:0] objectForKey:@"TAG"];
        NSString  *tag2 =[[TAGArray objectAtIndex:1] objectForKey:@"TAG"];
        NSString  *tag3 =[[TAGArray objectAtIndex:2] objectForKey:@"TAG"];
        NSString  *tag4 =[[TAGArray objectAtIndex:3] objectForKey:@"TAG"];
        parameter = @{@"user_id": userid,@"content":InputStr,@"stage_id":stageId,@"x_percent":X,@"y_percent":Y,@"tags[0]":tag1,@"tags[1]":tag2,@"tags[2]":tag3,@"tags[3]":tag4};
        if (self.weiboInfo) {
            parameter = @{@"user_id": userid,@"content":InputStr,@"stage_id":stageId,@"weibo_id":self.weiboInfo.Id,@"x_percent":X,@"y_percent":Y,@"tags[0]":tag1,@"tags[1]":tag2,@"tags[2]":tag3,@"tags[3]":tag4};
        }
    }
    else if (TAGArray.count==5)
    {
        NSString  *tag1 =[[TAGArray objectAtIndex:0] objectForKey:@"TAG"];
        NSString  *tag2 =[[TAGArray objectAtIndex:1] objectForKey:@"TAG"];
        NSString  *tag3 =[[TAGArray objectAtIndex:2] objectForKey:@"TAG"];
        NSString  *tag4 =[[TAGArray objectAtIndex:3] objectForKey:@"TAG"];
        NSString  *tag5 =[[TAGArray objectAtIndex:3] objectForKey:@"TAG"];
        parameter = @{@"user_id": userid,@"content":InputStr,@"stage_id":stageId,@"x_percent":X,@"y_percent":Y,@"tags[0]":tag1,@"tags[1]":tag2,@"tags[2]":tag3,@"tags[3]":tag4,@"tags[4]":tag5};
        if (self.weiboInfo) {
            parameter = @{@"user_id": userid,@"content":InputStr,@"stage_id":stageId,@"weibo_id":self.weiboInfo.Id,@"x_percent":X,@"y_percent":Y,@"tags[0]":tag1,@"tags[1]":tag2,@"tags[2]":tag3,@"tags[3]":tag4,@"tags[4]":tag5};
        }
    }
    
    NSString *urlString =[NSString stringWithFormat:@"%@/weibo/create", kApiBaseUrl];
    
    if (self.weiboInfo) {
        //更新
        urlString =[NSString stringWithFormat:@"%@/weibo/update",kApiBaseUrl];
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:urlString parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"  添加弹幕发布请求    JSON: %@", responseObject);
        if ([[responseObject  objectForKey:@"code"] intValue]==0) {
            loading.titleLable.text=@"发布成功";
            if ([loading respondsToSelector:@selector(remove)]) {
                [loading performSelector:@selector(remove) withObject:nil afterDelay:1];
                
            }
            if (self.pageSoureType==NSAddMarkPageSourceAddCard) {
                [self.navigationController dismissViewControllerAnimated:NO completion:nil];}
            else {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            //通知回到个人页
            [[NSNotificationCenter defaultCenter] postNotificationName:GOTO_USER_CENTER object:nil];
            UIImage  *image=[Function getImage:self.ShareView WithSize:CGSizeMake(kDeviceWidth-20,self.ShareView.frame.size.height)];
            UMShareView *ShareView =[[UMShareView alloc] initwithStageInfo:self.stageInfo ScreenImage:image delgate:self andShareHeight:self.ShareView.frame.size.height];
            ShareView.pageType=UMShareTypeSuccess;
            [ShareView setShareLable];
            [ShareView show];
        
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [loading remove];
        UIAlertView  *Al =[[UIAlertView alloc]initWithTitle:nil message:@"发布失败，请稍候重试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [Al show];
    }];
    
}
-(void)keyboardWillShow:(NSNotification *) notifi
{
    //[ _myScorllerView setCenter:CGPointMake(kDeviceWidth/2, _myTextView.frame.origin.y)];
    
    //     NSValue  *value  = [notifi.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    //    CGSize  size = [value  CGRectValue].size;
    //   [ _myScorllerView setContentOffset:CGPointMake(0, size.height) animated:YES];
    //
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

//友盟取消分享
-(void)UMCancleShareClick
{
    
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
}
-(void)didCloseUIViewController:(UMSViewControllerType)fromViewControllerType
{
    [self.navigationController popViewControllerAnimated:NO];
}
//根据有的view 上次一张图片
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    
    [self.navigationController popViewControllerAnimated:NO];
}
-(void)didFinishGetUMSocialDataResponse:(UMSocialResponseEntity *)response;
{
    NSLog(@"didFinishGetUMSocialDataResponse第二部执行这个");
    [self.navigationController popViewControllerAnimated:NO];
}
-(void)keyboardWillHiden:(NSNotification *) notification
{
    
}
#pragma  mark  ---UItextViewDelegate-------------
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    
    // [_myScorllerView setContentOffset:CGPointMake(0, 200) animated:YES];
    
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    // [_myTextView resignFirstResponder];
}
-(void)textViewDidChangeSelection:(UITextView *)textView
{
    
}
//点击键盘上的return键执行这个方法
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        //   [self PushlicInScreen];
        [_myTextView resignFirstResponder];
        return NO;
    }
    return YES;
    
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_myTextView resignFirstResponder];
}
//有时候我们要控件自适应输入的文本的内容的高度，只要在textViewDidChange的代理方法中加入调整控件大小的代理即可

-(void)textViewDidChange:(UITextView *)textView{
    CGRect  frame = _myTextView.frame;
    frame.size.height=_myTextView.contentSize.height+0;
    _myTextView.frame=frame;
    
    self.ShareView.frame=CGRectMake(10,0, kDeviceWidth-20, _myTextView.frame.size.height-40+self.stageImageView.frame.size.height);
    self.TagContentView.frame=CGRectMake(0, self.ShareView.frame.origin.y+self.ShareView.frame.size.height, kDeviceWidth, 100);
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma  mark  ----UIAlertViewdelegate  ---
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1000) {
        //发布弹幕成功的返回
        if (buttonIndex==0) {
            
            // [self.delegate AddMarkViewControllerReturn];
            [self dismissViewControllerAnimated:YES completion:^{
                if (self.weiboInfo) {
                    //编辑状态，不分享,刷新tabview
                    if (self.delegate&&[self.delegate respondsToSelector:@selector(AddMarkViewControllerReturn)]) {
                        [self.delegate AddMarkViewControllerReturn];
                    }
                }
                else {
                    
                }
                
            }];
            
        }
    }
}

#pragma  mark ------------------------AddTagViewHandClickWithTagDelegate -----------------
-(void)AddTagViewHandClickWithTag:(NSString *)tag
{
    
    if (TAGArray.count==0) {
        NSMutableDictionary  *tag1Dict =[NSMutableDictionary dictionaryWithObject:tag forKey:@"TAG"];
        [TAGArray insertObject:tag1Dict atIndex:0];
    }
    else  if(TAGArray.count==1)
    {
        NSMutableDictionary  *tag2Dict =[NSMutableDictionary dictionaryWithObject:tag forKey:@"TAG"];
        [TAGArray insertObject:tag2Dict atIndex:1];
    }
    else if (TAGArray.count==2)
    {
        NSMutableDictionary  *tag3Dict =[NSMutableDictionary dictionaryWithObject:tag forKey:@"TAG"];
        [TAGArray insertObject:tag3Dict atIndex:2];
        
    }
    else if (TAGArray.count==3)
    {
        NSMutableDictionary  *tag4Dict =[NSMutableDictionary dictionaryWithObject:tag forKey:@"TAG"];
        [TAGArray insertObject:tag4Dict atIndex:3];
        
    }
    else if (TAGArray.count==4)
    {
        NSMutableDictionary  *tag5Dict =[NSMutableDictionary dictionaryWithObject:tag forKey:@"TAG"];
        [TAGArray insertObject:tag5Dict atIndex:4];
    }
    //清楚了所有
    if (taglable) {
        [taglable  removeFromSuperview];
        taglable=nil;
    }
    
    //创建标签文本
    taglable =[[M80AttributedLabel alloc]initWithFrame:CGRectZero];
    taglable.backgroundColor =[UIColor clearColor];
    taglable.lineSpacing=5.0;
    taglable.font=[UIFont fontWithName:kFontRegular size:MarkTextFont14];
    if (IsIphone6plus) {
        taglable.font =[UIFont fontWithName:kFontRegular size:MarkTextFont16];
    }
    for (int i=0; i<TAGArray.count; i++) {
        NSDictionary  *dict =[TAGArray objectAtIndex:i];
        TagView   *tagview =[self createTagViewWithtagText:[dict objectForKey:@"TAG"] withIndex:i withBgImage:[UIImage imageNamed:@"tag_backgroud_color.png"]];
        [taglable appendView:tagview margin:UIEdgeInsetsMake(0, 0, 0, 10)];
    }
    
    TagView  *tagView =[self createTagViewWithtagText:@"添加标签" withIndex:999 withBgImage:nil];
    [tagView setcornerRadius:4];
    tagView.titleLable.textColor=VBlue_color;
    tagView.tagBgImageview.backgroundColor =[UIColor whiteColor];
    tagView.layer.borderColor=VBlue_color.CGColor;
    tagView.layer.borderWidth=2;
    [taglable appendView:tagView margin:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    CGSize Tsize =[taglable sizeThatFits:CGSizeMake(kDeviceWidth-20, CGFLOAT_MAX)];
    //位置和大小
    taglable.frame=CGRectMake(10,10,kDeviceWidth-20, Tsize.height);
    [self.TagContentView addSubview:taglable];
    NSLog(@"==== add  tag====%f",_myTextView.frame.size.height);
    
}

//创建标签的方法
-(TagView *)createTagViewWithtagText:(NSString *) tagText withIndex:(NSInteger) index withBgImage:(UIImage *) imagename
{
    TagModel  *tagmodel =[[TagModel alloc]init];
    TagDetailModel  *tagdetail =[[TagDetailModel alloc]init];
    tagdetail.title=tagText;
    tagmodel.tagDetailInfo=tagdetail;
    TagView *tagview =[[TagView alloc]initWithWeiboInfo:self.weiboInfo AndTagInfo:tagmodel  delegate:self isCanClick:YES backgoundImage:imagename isLongTag:YES];
    [tagview setcornerRadius:4];
    //    if (index==999) {//最后一个是添加按钮
    //        tagview.tagBgImageview.image=nil;
    //    }
    // [tagview setbigTag:YES];
    [tagview setbigTagWithSize:CGSizeMake(8, 6)];
    tagview.tag=1000+index;
    return tagview;
}
//点击标签，删除操作
-(void)TapViewClick:(TagView *)tagView Withweibo:(weiboInfoModel *)weiboInfo withTagInfo:(TagModel *)tagInfo
{
    
    if (tagView.tag==1999) {  //表明点击的是添加标签按钮
        AddTagViewController  *addtag =[[AddTagViewController alloc]init];
        addtag.delegate=self;
        addtag.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
        UINavigationController  *na =[[UINavigationController alloc]initWithRootViewController:addtag];
        //[self presentViewController:addtag animated:NO completion:nil];
        //[self presentViewController:na animated:YES completion:nil];
        [self.navigationController pushViewController:addtag animated:NO];
    }
    
    else
    {
        if (TAGArray.count==5) {
            UIAlertView  *al =[[UIAlertView alloc]initWithTitle:nil message:@"最多可以添加五个标签" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
            al.tag=1001;
            [al show];
            return;
        }
        
        if(TAGArray.count>0)
        {
            [TAGArray  removeObjectAtIndex:tagView.tag-1000];
        }
        if (taglable) {
            [taglable removeFromSuperview];
            taglable=nil;
        }
        taglable =[[M80AttributedLabel alloc]initWithFrame:CGRectZero];
        taglable.backgroundColor =[UIColor clearColor];
        taglable.lineSpacing=5;
        taglable.font=[UIFont fontWithName:kFontRegular size:MarkTextFont14];
        if(IsIphone6plus) {
            taglable.font =[UIFont fontWithName:kFontRegular size:MarkTextFont16];
        }
        
        for (int i=0; i<TAGArray.count; i++) {
            NSDictionary  *dict =[TAGArray objectAtIndex:i];
            TagView   *tagview =[self createTagViewWithtagText:[dict objectForKey:@"TAG"] withIndex:i withBgImage:[UIImage imageNamed:@"tag_backgroud_color.png"]];
            [taglable appendView:tagview margin:UIEdgeInsetsMake(0, 0, 0, 10)];
        }
        
        
        TagView  *tagview =[self createTagViewWithtagText:@"添加标签" withIndex:999 withBgImage:nil];
        [tagview setcornerRadius:4];
        tagview.titleLable.textColor=VBlue_color;
        tagview.tagBgImageview.backgroundColor =[UIColor whiteColor];
        tagview.layer.borderColor=VBlue_color.CGColor;
        tagview.layer.borderWidth=2;
        
        [taglable appendView:tagview margin:UIEdgeInsetsMake(0, 0, 0, 0)];
        CGSize Tsize =[taglable sizeThatFits:CGSizeMake(kDeviceWidth-20, CGFLOAT_MAX)];
        //位置和大小
        taglable.frame=CGRectMake(10,10,kDeviceWidth-20, Tsize.height);
        [self.TagContentView addSubview:taglable];
        
        
    }
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
