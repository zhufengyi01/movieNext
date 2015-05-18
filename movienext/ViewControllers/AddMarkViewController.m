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
//#import "AddTagViewController.h"
#define  BOOKMARK_WORD_LIMIT 1000
@interface AddMarkViewController ()<UIAlertViewDelegate,UIScrollViewDelegate,UITextViewDelegate,TagViewDelegate,UIAlertViewDelegate,UMShareViewController2Delegate,UMSocialUIDelegate,UMSocialDataDelegate>
{
    UIScrollView *_myScorllerView;
    UIToolbar    *_toolBar;
    UIButton     *textLeftButton;
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
}
@end
@implementation AddMarkViewController

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.alpha=1;
    self.navigationController.navigationBar.hidden=YES;
    self.tabBarController.tabBar.hidden=YES;
    if (_myTextView) {
     //   [_myTextView becomeFirstResponder];
    }
    _myTextView.frame= CGRectMake(50, 10, kDeviceWidth-120, 30);
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
    [self createButtomView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
    

}
-(void)createNavigation
{
    UIView  *naview= [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 64)];
    naview.userInteractionEnabled=YES;
    naview.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:naview];
    UIButton  *leftBtn= [UIButton buttonWithType:UIButtonTypeSystem];
    leftBtn.frame=CGRectMake(10, 20, 60, 40);
    [leftBtn setTitleColor:VGray_color forState:UIControlStateNormal];
    [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    leftBtn.titleLabel.font=[UIFont boldSystemFontOfSize:18];
    [leftBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
    [leftBtn addTarget:self action:@selector(dealNavClick:) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.tag=100;
    [naview addSubview:leftBtn];
   // UIBarButtonItem  *leftBarButton=[[UIBarButtonItem alloc]initWithCustomView:leftBtn];
   // self.navigationItem.leftBarButtonItem=leftBarButton;
    if (self.weiboInfo) {
    UILabel  *lable =[ZCControl createLabelWithFrame:CGRectMake((kDeviceWidth-100)/2, 20, 100, 30) Font:15 Text:@"编辑"];
        lable.font=[UIFont boldSystemFontOfSize:18];
        lable.textAlignment=NSTextAlignmentCenter;
        lable.textColor=VBlue_color;
        [naview addSubview:lable];
    }
    RighttBtn= [UIButton buttonWithType:UIButtonTypeSystem];
    RighttBtn.frame=CGRectMake(kDeviceWidth-70, 20, 60, 40);
    [RighttBtn addTarget:self action:@selector(dealNavClick:) forControlEvents:UIControlEventTouchUpInside];
    RighttBtn.tag=101;
   // [RighttBtn setTitleColor:VGray_color forState:UIControlStateNormal];
    [RighttBtn setTitle:@"发布" forState:UIControlStateNormal];
    [RighttBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -10)];
    
    RighttBtn.titleLabel.font=[UIFont boldSystemFontOfSize:18];
    RighttBtn.hidden=YES;
    [naview addSubview:RighttBtn];
    //self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:RighttBtn];

}
-(void)initData
{
    userCenter=[UserDataCenter shareInstance];
    TAGArray =[[NSMutableArray alloc]init];
    if (self.weiboInfo) {
        NSArray  *array =self.weiboInfo.tagArray;
        for (int i=0;i<array.count; i++) {
//            NSString *tag =[[[array objectAtIndex:i] objectForKey:@"tag"] objectForKey:@""];
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
    float  ImageWith=[self.stageInfo.width floatValue];
    float  ImgeHight=[self.stageInfo.height floatValue];
    float hight=0;
    hight= kDeviceHeight;  // 计算的事bgview1的高度
    if((ImgeHight/ImageWith) *kDeviceWidth>kDeviceHeight)
    {
        hight=  (ImgeHight/ImageWith) *kDeviceWidth;
        _myScorllerView.bounces=YES;
    }
    _myScorllerView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, kDeviceWidth,hight)];
    _myScorllerView.contentSize=CGSizeMake(kDeviceWidth,kDeviceHeight);
    _myScorllerView.delegate=self;
    _myScorllerView.bounces=YES;
    [self.view addSubview:_myScorllerView];
    
    tipView =[[UIView alloc]initWithFrame:CGRectMake(0, kDeviceWidth+64, kDeviceWidth, 30)];
    tipView.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.7];
    UILabel  *tiplable =[[UILabel alloc]initWithFrame:CGRectMake(0,0,kDeviceWidth,30)];
    tiplable.textColor=[UIColor whiteColor];
    tiplable.textAlignment=NSTextAlignmentCenter;
    tiplable.font =[UIFont systemFontOfSize:14];
    tiplable.text=@"弹幕可拖动";
    [tipView addSubview:tiplable];
    tipView.alpha=1;
    [self.view addSubview:tipView];
    
}
-(void)createStageView
{
     stageView = [[StageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceWidth)];
     stageView.stageInfo=self.stageInfo;
    [stageView configStageViewforStageInfoDict];
       NSLog(@" 在 添加弹幕页面的   stagedict = %@",self.stageInfo);
     [_myScorllerView addSubview:stageView];
}

-(void)createButtomView
{
     _toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0,kDeviceHeight-50-kHeightNavigation, kDeviceWidth, 50)];
     //_toolBar.barTintColor=[UIColor redColor];   //背景颜色
     // [self.navigat setBackgroundImage:[UIImage imageNamed:@"tabbar_backgroud_color.png"] forBarMetrics:UIBarMetricsDefault];
     [_toolBar setBackgroundImage:[UIImage imageNamed:@"tabbar_backgroud_color.png"] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
         _toolBar.tintColor=VGray_color;  //内容颜色

        [UIView  animateWithDuration:0.1 animations:^{
            CGRect  tframe=_toolBar.frame;
            if (keybordHeight==0) {
                keybordHeight=252.0;
                if (IsIphone6) {
                    keybordHeight=258.0;
                }
                if (IsIphone6plus) {
                    keybordHeight=271;
                }
            }
            tframe.origin.y=kDeviceHeight-keybordHeight-50;
             _toolBar.frame=tframe;
    
        } completion:^(BOOL finished) {
        }];
    //添加一个按钮到标签搜索页
    textLeftButton =[ZCControl createButtonWithFrame:CGRectMake(5,5, 40, 40) ImageName:nil Target:self Action:@selector(dealNavClick:) Title:nil];
    [textLeftButton setImage:[UIImage imageNamed:@"add_tag_icon"] forState:UIControlStateNormal];
    textLeftButton.tag=102;
    [_toolBar addSubview:textLeftButton];
    
     _myTextView=[[UITextView alloc]initWithFrame:CGRectMake(50, 10, kDeviceWidth-120, 30)];
    _myTextView.delegate=self;
   // [_myTextView addPlaceHolder:@"输入弹幕"];
    _myTextView.textColor=VGray_color;
    _myTextView.font= [UIFont systemFontOfSize:16];
    _myTextView.backgroundColor=[UIColor clearColor];
    _myTextView.layer.cornerRadius=4;
    
    _myTextView.layer.borderWidth=0.5;
    _myTextView.layer.borderColor=VLight_GrayColor.CGColor;
    _myTextView.maximumZoomScale=3;
    _myTextView.returnKeyType=UIReturnKeyDone;
    _myTextView.scrollEnabled=YES;
    //_myTextView.autoresizingMask=UIViewAutoresizingFlexibleHeight;
    _myTextView.selectedRange = NSMakeRange(0,0);  //默认光标从第一个开始
    [_myTextView becomeFirstResponder];
    [_toolBar addSubview:_myTextView];
    
    //编辑
    if (self.weiboInfo) {
        //
        _myTextView.text=self.weiboInfo.content;
        
    }
     publishBtn=[ZCControl createButtonWithFrame:CGRectMake(kDeviceWidth-60, 10, 50, 28) ImageName:@"loginoutbackgroundcolor.png" Target:self Action:@selector(dealNavClick:) Title:@"确定"];
     publishBtn.enabled=NO;
     publishBtn.titleLabel.font=[UIFont systemFontOfSize:14];
     publishBtn.layer.cornerRadius=4;
     publishBtn.tag=99;
     if (self.weiboInfo) {
         publishBtn.enabled=YES;
    }
     publishBtn.clipsToBounds=YES;
     [_toolBar addSubview:publishBtn];
     [self.view addSubview:_toolBar];
}


-(void)dealNavClick:(UIButton *) button
{
    
    if (button.tag==100) {
         //取消发布
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else if (button.tag==101)
    {        [self  PublicRuqest];
        //执行发布的方法
    }
    else if (button.tag==99)
    {
        //点击确定按钮
         [self  PushlicInScreen];
        
    }
    else if (button.tag==102)
    {
        //点击进入搜索添加标签页面
        if (TAGArray.count==5) {
            UIAlertView  *al =[[UIAlertView alloc]initWithTitle:nil message:@"最多可以添加五个标签" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
            al.tag=1001;
            [al show];
            return;
        }
        AddTagViewController  *addtag =[[AddTagViewController alloc]init];
        addtag.delegate=self;
        addtag.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
        UINavigationController  *na =[[UINavigationController alloc]initWithRootViewController:addtag];
        //[self presentViewController:addtag animated:NO completion:nil];
        [self presentViewController:na animated:YES completion:nil];
    }
}
//把markview 添加到屏幕
-(void)PushlicInScreen
{
    //方法只是去掉左右两边的空格；
    InputStr = [_myTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    //发布到屏幕之后需要把输入框退回去
    [_myTextView resignFirstResponder];
  
       CGRect  iframe =_toolBar.frame;
       iframe.origin.y=kDeviceHeight;
       _toolBar.frame=iframe;
    [UIView animateWithDuration:0.3 animations:^{
        tipView.alpha=1;
    } completion:^(BOOL finished) {
        
    }];
    RighttBtn.hidden=NO;
    RighttBtn.titleLabel.textColor=VBlue_color;
     //清楚原来添加的弹幕
    for (UIView *view in stageView.subviews) {
        if ([view isKindOfClass:[MarkView class]]) {
            [view removeFromSuperview];
        }
    }
    
    //创建微博对象
    [self createWeibomodel];
   _myMarkView = [self createMarkViewWithDict:weibomodel andIndex:1000];
    _myMarkView.weiboInfo=weibomodel;
    _myMarkView.isAnimation=YES;
    [_myMarkView setValueWithWeiboInfo:weibomodel];
  //  _myMarkView.delegate=self;
    [stageView addSubview:_myMarkView];
    
    //在标签上添加一个手势
     UIPanGestureRecognizer   *pan=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handelPan:)];
    [_myMarkView addGestureRecognizer:pan];

}
//手动创建微博对象
-(void)createWeibomodel
{

    //计算弹幕的长度
    CGSize  Msize= [InputStr  boundingRectWithSize:CGSizeMake(kDeviceWidth/2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:14] forKey:NSFontAttributeName] context:nil].size;
    //标签的宽度
    
    NSMutableString  *tagString =[[NSMutableString alloc]init];
    for (int i=0; i<TAGArray.count; i++) {
        if (i<2) {
            [tagString appendString:[[TAGArray objectAtIndex:i] objectForKey:@"TAG"]];
        }
    }
    CGSize  Tsize =[tagString  boundingRectWithSize:CGSizeMake(kDeviceWidth/2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:14] forKey:NSFontAttributeName] context:nil].size;
    if (Tsize.width>Msize.width) {
        Msize=Tsize;
    }

    int  markViewWidth = (int)Msize.width+23+5+5+11+5;
     int   markViewHeight =(int) Msize.height+6;
    int  kw=kStageWidth;
    
    int  x=arc4random()%(kw-markViewWidth);//要求x在0~~~（宽度-markViewWidth）
    int  y=arc4random()%((kw-markViewHeight/2)+markViewHeight/2-markViewHeight);  //要求y在markviewheight.y/2 ~~~~~~~(高度--markViewheigth/2)
    
    X =[NSString stringWithFormat:@"%f",((x+markViewWidth)/310.0)*100];
    Y=[NSString stringWithFormat:@"%f",((y+markViewHeight/2)/310.0)*100];
    
    //开始创建weibo对象
      weibomodel =[[weiboInfoModel alloc]init];
    if (weibomodel) {
        //添加微博信息
        weibomodel.content=InputStr;
        weibomodel.x_percent=X;
        weibomodel.y_percent=Y;
        //1.添加用户信息
        weiboUserInfoModel *usermodel = [[weiboUserInfoModel alloc]init];
        if (usermodel) {
            usermodel.username=userCenter.username;
            usermodel.logo=userCenter.logo;
            usermodel.Id= [NSNumber numberWithInt: [userCenter.user_id intValue]];
            weibomodel.uerInfo=usermodel;
        }
        
        //2.添加stage信息
        weibomodel.stageInfo=self.stageInfo;
        NSMutableArray  *tagArray =[[NSMutableArray alloc]init];
        //添加标签数组
        for (int i=0; i<TAGArray.count; i++) {
            TagModel  *tagmodel =[[TagModel alloc]init];
            if (tagmodel) {
                TagDetailModel  *tagdetail =[[TagDetailModel alloc]init];
                if (tagdetail) {
                    tagdetail.title = [[TAGArray  objectAtIndex:i] objectForKey:@"TAG"];
                    tagmodel.tagDetailInfo=tagdetail;
                }
                [tagArray addObject:tagmodel];
            }
            
        }
        //标签数组
        weibomodel.tagArray=tagArray;
    }
    
}



#pragma mark 内部弹幕的方法
- (MarkView *) createMarkViewWithDict:(weiboInfoModel *)weibodict andIndex:(NSInteger)index{
    MarkView *markView=[[MarkView alloc]initWithFrame:CGRectZero];
    //设置tag 值为了在下面去取出来循环轮播
    markView.tag=1000+index;
    float  x=[weibodict.x_percent floatValue];   //位置的百分比
    float  y=[weibodict.y_percent floatValue];
    NSString  *weiboTitleString=weibodict.content;
    NSString  *UpString=[NSString stringWithFormat:@"%@",weibodict.like_count];//weibodict.ups;
    //计算标题的size
    CGSize  Msize=[weiboTitleString boundingRectWithSize:CGSizeMake(kDeviceWidth/2,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:markView.TitleLable.font forKey:NSFontAttributeName] context:nil].size;
    // 计算赞数量的size
    CGSize Usize=[UpString boundingRectWithSize:CGSizeMake(40,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:markView.ZanNumLable.font forKey:NSFontAttributeName] context:nil].size;
    float hight=kStageWidth;
    //计算赞数量的长度
    float  Uwidth=[UpString floatValue]==0?0:Usize.width;
    //宽度=字的宽度+左头像图片的宽度＋赞图片的宽度＋赞数量的宽度+中间两个空格2+2
    float markViewWidth = Msize.width+23+Uwidth+5+5+11+5;
    float markViewHeight = Msize.height+6;
    if (weibodict.tagArray.count>0) {
        markViewHeight=markViewHeight+25;
    }
    if(IsIphone6plus)
    {
        markViewWidth=markViewWidth+10;
        markViewHeight=markViewHeight+4;
    }
    float markViewX = (x*kStageWidth)/100-markViewWidth;
    markViewX = MIN(MAX(markViewX, 5.0f), kStageWidth-markViewWidth-5);
    float markViewY = (y*hight)/100 - markViewHeight/2;
    markViewY = MIN(MAX(markViewY, 5.0f), hight-markViewHeight-5);
#pragma mark 设置气泡的大小和位置
    markView.frame=CGRectMake(markViewX, markViewY, markViewWidth, markViewHeight);
    markView.TitleLable.text=weiboTitleString;
    
    NSString   *headurl =[NSString stringWithFormat:@"%@%@",kUrlAvatar,weibodict.uerInfo.logo];
    [markView.LeftImageView sd_setImageWithURL:[NSURL URLWithString:headurl] placeholderImage:[UIImage imageNamed:@"user_normal"]];
    markView.ZanNumLable.text=[NSString stringWithFormat:@"%@",weibodict.like_count];

    //设置标签
    return markView;
}

-(void)handelPan:(UIPanGestureRecognizer*)gestureRecognizer{
    
    [UIView animateWithDuration:0.5 animations:^{
        tipView.alpha=0;
    } completion:^(BOOL finished) {
        
    }];

   //获取平移手势对象在stageView的位置点，并将这个点作为self.aView的center,这样就实现了拖动的效果
    CGPoint curPoint = [gestureRecognizer locationInView:stageView];
    CGFloat xoffset = _myMarkView.frame.size.width/2.0;
    CGFloat yoffset = _myMarkView.frame.size.height/2.0;
    CGFloat x = MIN(kDeviceWidth-xoffset,  MAX(xoffset, curPoint.x) );
    CGFloat y = MIN(kDeviceWidth-yoffset,  MAX(yoffset, curPoint.y) );
    _myMarkView.center = CGPointMake(x, y);
    float  markViewY=_myMarkView.frame.origin.y;
    float  markviewHight2 =_myMarkView.frame.size.height/2;
    //发布的右下中部的位置
    X =[NSString stringWithFormat:@"%f",((_myMarkView.frame.origin.x+_myMarkView.frame.size.width)/kDeviceWidth)*100];
    Y=[NSString stringWithFormat:@"%f",((markViewY+markviewHight2)/kDeviceWidth)*100];
    
 
}
# pragma  mark  发布数据请求
//确定发布
-(void)PublicRuqest
{
 //   RighttBtn.enabled=NO;
    if ([X intValue]==0||[Y intValue]==0) {
        X =[NSString stringWithFormat:@"%d",100];
        Y=[NSString stringWithFormat:@"%d",100];
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
            NSString *message =@"发布成功";
            if (self.weiboInfo) {
                message=@"编辑成功";
            }
            UIAlertView  *Al=[[UIAlertView alloc]initWithTitle:nil message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            Al.tag=1000;
            [Al show];
            
            weibo =[[weiboInfoModel alloc]init];
            if (weibo) {
                [weibo setValuesForKeysWithDictionary:[responseObject objectForKey:@"model"]];
                weiboUserInfoModel  *weibouser=[[weiboUserInfoModel alloc]init];
                if (weibouser) {
                  weibouser.logo=userCenter.logo;
                  weibouser.username=userCenter.username;
                  weibo.uerInfo=weibouser;
                }
                NSMutableArray  *tagarray =[[NSMutableArray alloc]init];
                for (NSDictionary  *tagDict in [[responseObject objectForKey:@"model"] objectForKey:@"tags"]) {
                    TagModel  *tagmodel =[[TagModel alloc]init];
                    if (tagmodel) {
                        [tagmodel  setValuesForKeysWithDictionary:tagDict];
                        
                        TagDetailModel  *tagdeltail =[[TagDetailModel alloc]init];
                        if (tagdeltail) {
                            [tagdeltail setValuesForKeysWithDictionary:[tagDict objectForKey:@"tag"]];
                            tagmodel.tagDetailInfo=tagdeltail;
                        }
                        [tagarray addObject:tagmodel];
                    }
                }
                weibo.tagArray=tagarray;
            }
            [self.stageInfo.weibosArray addObject:weibo];
            //发布成功后，进入分享
 
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}



-(void)UMShareViewController2HandClick:(UIButton *)button ShareImage:(UIImage *)shareImage StageInfoModel:(stageInfoModel *)StageInfo
{
    NSArray  *sharearray =[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQzone, UMShareToSina, nil];
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
    [[UMSocialControllerService defaultControllerService] setShareText:StageInfo.movieInfo.name shareImage:shareImage socialUIDelegate:self];
    //设置分享内容和回调对象
    
    [UMSocialSnsPlatformManager getSocialPlatformWithName:[sharearray  objectAtIndex:button.tag-10000]].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);

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

//发布弹幕请求
#pragma mark 键盘的通知事件
-(void)keyboardWillShow:(NSNotification * )  notification
{

        NSDictionary *info = [notification userInfo];
        NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
         keyboardSize = [value CGRectValue].size;
        NSLog(@"will show     keyBoard   height  :%f", keyboardSize.height);
        keybordHeight=keyboardSize.height;
        CGRect  frame =_myTextView.frame;
        frame.size.height=30;
       _myTextView.frame=frame;
        CGSize Tsize =[taglable sizeThatFits:CGSizeMake(kDeviceWidth-20, CGFLOAT_MAX)];
    //位置和大小
       taglable.frame=CGRectMake(10,50,kDeviceWidth-20, Tsize.height);

   
    [UIView  animateWithDuration:0.1 animations:^{
     } completion:^(BOOL finished) {
         _toolBar.frame=CGRectMake(_toolBar.frame.origin.x,kDeviceHeight-keybordHeight-50-Tsize.height,_toolBar.frame.size.width, 50+Tsize.height);
         
    }];
    if ([TAGArray count]>0) {
        publishBtn.enabled=YES;
    }
    else
    {
        publishBtn.enabled=YES;
    }
    if (self.weiboInfo) {
        publishBtn.enabled=YES;
        //把tag放到_toolBar上
        //创建标签文本
        taglable =[[M80AttributedLabel alloc]initWithFrame:CGRectZero];
        taglable.backgroundColor =[UIColor clearColor];
        taglable.lineSpacing=5.0;
        taglable.font=[UIFont systemFontOfSize:MarkTextFont14];
        if (IsIphone6plus) {
            taglable.font =[UIFont systemFontOfSize:MarkTextFont16];
        }
        
        for (int i=0; i<TAGArray.count; i++) {
            NSDictionary  *dict =[TAGArray objectAtIndex:i];
            TagView   *tagview =[self createTagViewWithtagText:[dict objectForKey:@"TAG"] withIndex:i withBgImage:[UIImage imageNamed:@"tag_backgroud_color.png"]];
            [taglable appendView:tagview margin:UIEdgeInsetsMake(0, 10, 0, 0)];
        }
        CGSize Tsize =[taglable sizeThatFits:CGSizeMake(kDeviceWidth-20, CGFLOAT_MAX)];
        //位置和大小
        taglable.frame=CGRectMake(10,50,kDeviceWidth-20, Tsize.height);
        [_toolBar addSubview:taglable];
        [UIView  animateWithDuration:0.1 animations:^{
        } completion:^(BOOL finished) {
            _toolBar.frame=CGRectMake(_toolBar.frame.origin.x,kDeviceHeight-keybordHeight-50-Tsize.height,_toolBar.frame.size.width, 50+Tsize.height);
            
        }];

    }
    NSLog(@"====will show keyboard  tag====%f",_myTextView.frame.size.height);

}
-(void)keyboardWillHiden:(NSNotification *) notification
{
 
//    [UIView  animateWithDuration:0.1 animations:^{
//        CGRect  tframe=_toolBar.frame;
//        tframe.origin.y=kDeviceHeight-50-kHeightNavigation;
//        _toolBar.frame=tframe;
//    } completion:^(BOOL finished) {
//        
//    }];

}
#pragma  mark  ---UItextViewDelegate-------------
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    
 
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
   // [_myTextView resignFirstResponder];
    ///[self PushlicInScreen];
}
 -(void)textViewDidChangeSelection:(UITextView *)textView
{
    
}
//点击键盘上的return键执行这个方法
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //if ([text isEqualToString:@"\n"]) {
     //   [self PushlicInScreen];
       // return NO;
    //}
    //return YES;
    return YES;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //[_myTextView resignFirstResponder];
}
 //有时候我们要控件自适应输入的文本的内容的高度，只要在textViewDidChange的代理方法中加入调整控件大小的代理即可



-(void)textViewDidChange:(UITextView *)textView{
    //防止光标抖动
   
    if (textView==_myTextView) {
        if ([Function isBlankString:_myTextView.text]==NO) {
            publishBtn.enabled=YES;
        }
        else
        {
            publishBtn.enabled=YES;
        }
    }
 }


//控制输入文字的长度和内容，可通调用以下代理方法实现
/*-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //这个方法比textdidchange先执行
    if (range.location>=60)
    {
        //控制输入文本的长度
        return  YES;
    }
    if ([text isEqualToString:@"\n"]) {
        //禁止输入换行
        return NO;
    }
    else
    {
        return YES;
    }
    return YES;

}*/
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
 
        [self.delegate AddMarkViewControllerReturn];
        [self dismissViewControllerAnimated:YES completion:^{
            if (self.weiboInfo) {
                //编辑状态，不分享,刷新tabview
                if (self.delegate&&[self.delegate respondsToSelector:@selector(AddMarkViewControllerReturn)]) {
                    [self.delegate AddMarkViewControllerReturn];
                }
            }
            else {
                //编辑状态，不分享,刷新tabview
               if (self.delegate&&[self.delegate respondsToSelector:@selector(AddMarkViewControllerReturn)]) {
                [self.delegate AddMarkViewControllerReturn];
                }
             NSDictionary  *dict = [[NSDictionary alloc]initWithObjectsAndKeys:self.stageInfo,@"stageInfo",weibo,@"weiboInfo",self.delegate,@"delegate", nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ShareViewAlert" object:nil userInfo:dict];
            }
        
        }];
        
      }
    }
}
-(void)AddTagViewHandClickWithTag:(NSString *)tag
{    
//    if (TAGArray==nil) {
//        TAGArray =[[NSMutableArray alloc]init];
//    }

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

//创建标签文本
    taglable =[[M80AttributedLabel alloc]initWithFrame:CGRectZero];
    taglable.backgroundColor =[UIColor clearColor];
    taglable.lineSpacing=5.0;
    taglable.font=[UIFont systemFontOfSize:MarkTextFont14];
    if (IsIphone6plus) {
        taglable.font =[UIFont systemFontOfSize:MarkTextFont16];
    }
    
    for (int i=0; i<TAGArray.count; i++) {
        NSDictionary  *dict =[TAGArray objectAtIndex:i];
         TagView   *tagview =[self createTagViewWithtagText:[dict objectForKey:@"TAG"] withIndex:i withBgImage:[UIImage imageNamed:@"tag_backgroud_color.png"]];
        [taglable appendView:tagview margin:UIEdgeInsetsMake(0, 10, 0, 0)];
    }
    CGSize Tsize =[taglable sizeThatFits:CGSizeMake(kDeviceWidth-20, CGFLOAT_MAX)];
    //位置和大小
    taglable.frame=CGRectMake(10,50,kDeviceWidth-20, Tsize.height);
      [_toolBar addSubview:taglable];
    NSLog(@"==== add  tag====%f",_myTextView.frame.size.height);
    
}

//创建标签的方法
-(TagView *)createTagViewWithtagText:(NSString *) tagText withIndex:(NSInteger) index withBgImage:(UIImage *) imagename
{
    TagView *tagview =[[TagView alloc]initWithFrame:CGRectZero];
    tagview.tag=1000+index;
    tagview.delegete=self;
    [tagview setTagViewIsClick:YES];
    tagview.titleLable.text=tagText;
    CGSize  Tsize =[tagText boundingRectWithSize:CGSizeMake(MAXFLOAT, TagHeight) options:(NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin) attributes:[NSDictionary dictionaryWithObject:tagview.titleLable.font forKey:NSFontAttributeName] context:nil].size;
    
    tagview.tagBgImageview.image =[imagename stretchableImageWithLeftCapWidth:15 topCapHeight:15];
    tagview.frame=CGRectMake(0,0, Tsize.width+10, TagHeight+6);
    return tagview;
}
//点击标签，删除操作
-(void)TapViewClick:(TagView *)tagView Withweibo:(weiboInfoModel *)weiboInfo withTagInfo:(TagModel *)tagInfo
{
    
    NSLog(@"=========tagView %ld",tagView.tag);
    if(TAGArray.count>0)
    {
       [TAGArray  removeObjectAtIndex:tagView.tag-1000];
    }
    //删除完成后，清除所有的布局
     //移除所有tagview的子视图
    for (id view in taglable.subviews) {
        if ([view isKindOfClass:[TagView class]]) {
            TagView  *tag=(TagView *)view;
            [tag removeFromSuperview];
            tag=nil;
        }
    }
    if (taglable) {
        [taglable removeFromSuperview];
        taglable=nil;
    }
    
    taglable =[[M80AttributedLabel alloc]initWithFrame:CGRectZero];
    taglable.backgroundColor =[UIColor clearColor];
    taglable.font=[UIFont systemFontOfSize:MarkTextFont14];
    if(IsIphone6plus) {
        taglable.font =[UIFont systemFontOfSize:MarkTextFont16];
     }
     if(keybordHeight==0)
    {
        keybordHeight=252.0;
        if (IsIphone6) {
            keybordHeight=258.0;
        }
        if (IsIphone6plus) {
            keybordHeight=271.0;
        }
    }
    NSLog(@"删除之后的数组====%@",TAGArray);


    //然后从新开始渲染布局
    for (int i=0; i<TAGArray.count; i++) {
        
        NSDictionary  *dict =[TAGArray objectAtIndex:i];
        TagView   *tagview =[self createTagViewWithtagText:[dict objectForKey:@"TAG"] withIndex:i withBgImage:[UIImage imageNamed:@"tag_backgroud_color.png"]];
        [taglable appendView:tagview margin:UIEdgeInsetsMake(0, 10, 0, 0)];
    }
    
    CGSize Tsize =[taglable sizeThatFits:CGSizeMake(kDeviceWidth-20, CGFLOAT_MAX)];
    //位置和大小
    taglable.frame=CGRectMake(10,50,kDeviceWidth-20, Tsize.height);
    _toolBar.frame=CGRectMake(_toolBar.frame.origin.x,kDeviceHeight-keybordHeight-50-Tsize.height,_toolBar.frame.size.width, 50+Tsize.height);
    [_toolBar addSubview:taglable];
    
    _myTextView.frame=CGRectMake(_myTextView.frame.origin.x, 10,_myTextView.frame.size.width, 30);
    
    if (TAGArray.count==0) {
        if(keybordHeight==0)
        {
            keybordHeight=252.0;
            if (IsIphone6) {
                keybordHeight=258.0;
            }
            if (IsIphone6plus) {
                keybordHeight=271.0;
            }
        }
        _toolBar.frame=CGRectMake(_toolBar.frame.origin.x,kDeviceHeight-keybordHeight-50,_toolBar.frame.size.width, 50);
        [taglable removeFromSuperview];
      }
    if ([TAGArray count]>0) {
        publishBtn.enabled=YES;
    }
    else
    {
        publishBtn.enabled=YES;
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
