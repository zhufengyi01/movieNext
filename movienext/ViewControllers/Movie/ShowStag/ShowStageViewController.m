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
#import "WeiboModel.h"
#import "ZCControl.h"
#import "Constant.h"
#import "AddMarkViewController.h"
#import "UMShareView.h"
#import "UMSocial.h"
#import "StageView.h"
#import "ButtomToolView.h"
#import "AFNetworking.h"
#import "UserDataCenter.h"
#import "MyViewController.h"
#import "Function.h"
@interface ShowStageViewController() <UMShareViewDelegate,ButtomToolViewDelegate,StageViewDelegate>
{
    ButtomToolView *_toolBar;

}
@end

@implementation ShowStageViewController
{
    UIScrollView *scrollView;
    UIView *BgView2;
    UIButton  *ScreenButton;
    UIButton  *addMarkButton;
    UMShareView  *shareView;
    StageView *stageView;
    MarkView       *_mymarkView;

}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.alpha=1;
    self.tabBarController.tabBar.hidden=YES;
    self.navigationController.navigationBar.hidden=NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createScrollView];
    //[self createTopView];
    [self createStageView];
    //创建底部的分享
    [self createButtonView1];
    [self createToolBar];

    [self createShareView];
}

-(void)createScrollView
{
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-45)];
    scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:scrollView];
}
//-(void)createTopView
//{
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.frame = CGRectMake(kDeviceWidth-100, 0, 100, 44);
//    [btn setTitle:@"完成" forState:UIControlStateNormal];
//    [btn addTarget:self action:@selector(handleComplete) forControlEvents:UIControlEventTouchUpInside];
//    [scrollView addSubview:btn];
//}

-(void)createStageView
{
    float  ImageWith=[self.movieModel.stageinfo.w floatValue];
    float  ImgeHight=[self.movieModel.stageinfo.h floatValue];
    float hight=0;
    hight= kDeviceWidth;  // 计算的事bgview1的高度
    if(ImgeHight>ImageWith)
    {
        hight=  (ImgeHight/ImageWith) *kDeviceWidth;
    }
   // float y = hight >= kDeviceHeight ? 0 : (kDeviceHeight - hight)/2;
    scrollView.contentSize = CGSizeMake(kDeviceWidth, MIN(kDeviceHeight, hight));

    stageView = [[StageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, hight)];
    stageView.isAnimation = YES;
    stageView.delegate=self;
    stageView.StageInfoDict=self.movieModel.stageinfo;
    stageView.WeibosArray = self.movieModel.weibos;
    [stageView configStageViewforStageInfoDict];
     [scrollView addSubview:stageView];
    [stageView startAnimation];
    
    //创建分享和添加弹幕的的底部试图
}
-(void)createButtonView1
{
    BgView2=[[UIView alloc]initWithFrame:CGRectMake(0, kDeviceHeight-kHeightNavigation-45, kDeviceWidth, 45)];
    //改变toolar 的颜色
    
    BgView2.backgroundColor=View_ToolBar;
    [self.view bringSubviewToFront:BgView2];
    [self.view addSubview:BgView2];

    ScreenButton =[ZCControl createButtonWithFrame:CGRectMake(kDeviceWidth-140,10,60,26) ImageName:@"btn_share_default.png" Target:self Action:@selector(ScreenButtonClick:) Title:@""];
    [ScreenButton setBackgroundImage:[UIImage imageNamed:@"btn_share_select.png"] forState:UIControlStateHighlighted];
    [BgView2 addSubview:ScreenButton];
    
    addMarkButton =[ZCControl createButtonWithFrame:CGRectMake(kDeviceWidth-70,10,60,26) ImageName:@"btn_add_default.png" Target:self Action:@selector(addMarkButtonClick:) Title:@""];
    [addMarkButton setBackgroundImage:[UIImage imageNamed:@"btn_add_select.png"] forState:UIControlStateHighlighted];
    [BgView2 addSubview:addMarkButton];
    
}
//创建底部的视图
-(void)createToolBar

{
    _toolBar=[[ButtomToolView alloc]initWithFrame:CGRectMake(0,0,kDeviceWidth,kDeviceHeight)];
    _toolBar.delegete=self;
    
}

-(void)createShareView
{
    shareView=[[UMShareView alloc]initWithFrame:CGRectMake(0,0, kDeviceWidth, kDeviceHeight)];
    shareView.delegate=self;
}

// 分享
-(void)ScreenButtonClick:(UIButton  *) button
{
    float hight= kDeviceWidth;
    float  ImageWith=[self.movieModel.stageinfo.w intValue];
    float  ImgeHight=[self.movieModel.stageinfo.h intValue];
    if(ImgeHight>ImageWith)
    {
        hight=  (ImgeHight/ImageWith) *kDeviceWidth;
    }
  //  CommonStageCell *cell = (CommonStageCell *)(button.superview.superview.superview);
   /* UIGraphicsBeginImageContextWithOptions(CGSizeMake(kDeviceWidth,hight), YES, [UIScreen mainScreen].scale);
    [stageView drawViewHierarchyInRect:stageView.bounds afterScreenUpdates:YES];
    // old style [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    */
    
    UIImage  *image=[Function getImage:stageView WithSize:CGSizeMake(kDeviceWidth, hight)];
    

    //创建UMshareView 后必须配备这三个方法
    shareView.StageInfo=self.movieModel.stageinfo;
    shareView.screenImage=image;
    [shareView configShareView];
    [self.view addSubview:shareView];
    self.tabBarController.tabBar.hidden=YES;
    if ([shareView respondsToSelector:@selector(showShareButtomView)]) {
        [shareView showShareButtomView];
        
    }

}
//微博点赞请求
-(void)LikeRequstData:(WeiboModel  *) weiboDict StageInfo :(StageInfoModel *) stageInfoDict
{
    
    UserDataCenter  *userCenter=[UserDataCenter shareInstance];
    NSNumber  *weiboId=weiboDict.Id;  //[upDict objectForKey:@"id"];
    NSNumber  *stageId=self.movieModel.stageinfo.Id;//[stageInfoDict objectForKey:@"id"];
    NSString  *movieId=self.movieModel.stageinfo.movie_id; //[stageInfoDict objectForKey:@"movie_id"];
    NSString  *movieName=stageInfoDict.movie_name;//[stageInfoDict objectForKey:@"movie_name"];
    NSString  *userId=userCenter.user_id;
    NSString  *autorId =weiboDict.user_id; // [upDict objectForKey:@"user_id"];
    NSNumber  *uped;
    //if ([[upDict objectForKey:@"uped"]  intValue]==0) {
    //uped =[NSString stringWithFormat:@"%d",1];
    //}
    if ([weiboDict.uped  integerValue] ==0) {
        uped=[NSNumber numberWithInt:0];
    }
    else
    {
        uped=[NSNumber numberWithInt:1];
    }
    
    NSDictionary *parameters = @{@"weibo_id":weiboId, @"stage_id":stageId,@"movie_id":movieId,@"movie_name":movieName,@"user_id":userId,@"author_id":autorId,@"operation":uped};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/weiboUp/up", kApiBaseUrl] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject  objectForKey:@"return_code"]  intValue]==10000) {
            NSLog(@"点赞成功========%@",responseObject);
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}


#pragma  mark  -----UMButtomViewshareViewDlegate-------
-(void)UMshareViewHandClick:(UIButton *)button ShareImage:(UIImage *)shareImage MoviewModel:(StageInfoModel *)StageInfo
{
    NSArray  *sharearray =[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQzone, UMShareToSina, nil];
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
    
    [[UMSocialControllerService defaultControllerService] setShareText:StageInfo.movie_name shareImage:shareImage socialUIDelegate:self];        //设置分享内容和回调对象
    [UMSocialSnsPlatformManager getSocialPlatformWithName:[sharearray  objectAtIndex:button.tag-10000]].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
    NSLog(@"分享到微信");
     if (shareView) {
        [shareView HidenShareButtomView];
        [shareView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.5];
        
    }
}
///点击分享的屏幕，收回分享的背景
-(void)SharetopViewTouchBengan
{
    NSLog(@"controller touchbegan  中 执行了隐藏工具栏的方法");
    //取消当前的选中的那个气泡
   // [_mymarkView CancelMarksetSelect];
    if (shareView) {
        [shareView HidenShareButtomView];
        [shareView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.5];
        
    }
    
}

//添加弹幕
-(void)addMarkButtonClick:(UIButton  *) button
{
    
    
    NSLog(@" ==addMarkButtonClick  ====%ld",(long)button.tag);
    AddMarkViewController  *AddMarkVC=[[AddMarkViewController alloc]init];
    //HotMovieModel  *hotmovie=[[HotMovieModel alloc]init];
   
    AddMarkVC.stageInfoDict=self.movieModel.stageinfo;
    NSLog(@"dict.stageinfo = %@", AddMarkVC.stageInfoDict);
  //  AddMarkVC.pageSoureType=NSAddMarkPageSourceDefault;
    [self.navigationController pushViewController:AddMarkVC animated:NO];

}

#pragma mark  -----
#pragma mark  ---//点击了弹幕StaegViewDelegate
#pragma mark  ----
-(void)StageViewHandClickMark:(WeiboModel *)weiboDict withmarkView:(id)markView StageInfoDict:(StageInfoModel *)stageInfoDict
{
    ///执行buttonview 弹出
    //获取markview的指针
    MarkView   *mv=(MarkView *)markView;
    //把当前的markview 给存储在了controller 里面
    _mymarkView=mv;
    if (mv.isSelected==YES) {  //当前已经选中的状态
        //设置工具栏的值，并且，弹出工具栏
        // NSLog(@"出现工具栏,   ======stageinfo =====%@",stageInfoDict);
        [self SetToolBarValueWithDict:weiboDict markView:markView isSelect:YES StageInfo:stageInfoDict];
    }
    else if(mv.isSelected==NO)
    {
        NSLog(@"隐藏工具栏工具栏");
        [self SetToolBarValueWithDict:weiboDict markView:markView isSelect:NO StageInfo:stageInfoDict];
    }
    
}
#pragma mark  ----- toolbar 上面的按钮，执行给toolbar 赋值，显示，弹出工具栏
-(void)SetToolBarValueWithDict:(WeiboModel  *)weiboDict markView:(id) markView isSelect:(BOOL ) isselect StageInfo:(StageInfoModel *) stageInfo
{
    //先对它赋值，然后让他弹出到界面
    if (isselect==YES) {
        NSLog(@" new viewController SetToolBarValueWithDict  执行了出现工具栏的方法");
        
        //设置工具栏的值
        //[_toolBar setToolBarValue:weiboDict :markView WithStageInfo:stageInfo];
        _toolBar.weiboDict=weiboDict;
        _toolBar.StageInfoDict=stageInfo;
        _toolBar.markView=markView;
        [_toolBar configToolBar];
        
        //把工具栏添加到当前视图
        self.tabBarController.tabBar.hidden=YES;
        [self.view addSubview:_toolBar];
        //弹出工具栏
        [_toolBar ShowButtomView];
        
    }
    else if (isselect==NO)
    {
        //隐藏toolbar
        NSLog(@" 执行了隐藏工具栏的方法");
        self.tabBarController.tabBar.hidden=YES;
        //隐藏工具栏
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
-(void)ToolViewHandClick:(UIButton *)button :(MarkView *)markView weiboDict:(WeiboModel *)weiboDict StageInfo:(StageInfoModel *)stageInfoDict
{
    
    if (button.tag==10000) {
        ///点击了头像//进入个人页面
        MyViewController   *myVc=[[MyViewController alloc]init];
        myVc.author_id=weiboDict.user_id;
        [self.navigationController pushViewController:myVc animated:YES];
    }
#pragma mark     -----------分享
    else if (button.tag==10001)
    {
        //点击了分享
        //分享文字
        
        //    NSString  *shareText=weiboDict.topic;//[weiboDict objectForKey:@"topic"];
        NSLog(@" 点击了分享按钮");
        
        float hight= kDeviceWidth;
        float  ImageWith=[stageInfoDict.w intValue];
        float  ImgeHight=[stageInfoDict.h intValue];
        if(ImgeHight>ImageWith)
        {
            hight=  (ImgeHight/ImageWith) *kDeviceWidth;
        }
       // CommonStageCell *cell = (CommonStageCell *)(markView.superview.superview.superview);
        
       /* UIGraphicsBeginImageContextWithOptions(CGSizeMake(kDeviceWidth, hight), YES, [UIScreen mainScreen].scale);
        [stageView drawViewHierarchyInRect:stageView.bounds afterScreenUpdates:YES];
        
        // old style [self.layer renderInContext:UIGraphicsGetCurrentContext()];
        
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        */
        
        UIImage  *image=[Function getImage:stageView WithSize:CGSizeMake(kDeviceWidth, hight)];
        

        //创建UMshareView 后必须配备这三个方法
        shareView.StageInfo=stageInfoDict;
        shareView.screenImage=image;
        [shareView configShareView];
        [self.view addSubview:shareView];
        self.tabBarController.tabBar.hidden=YES;
        if ([shareView respondsToSelector:@selector(showShareButtomView)]) {
            [shareView showShareButtomView];
            
        }
        
    }
#pragma mark  ----------点赞--------------
    else  if(button.tag==10002)
    {
        //改变赞的状态
        //点击了赞
        
        NSLog(@" 点赞 前 微博dict  ＝====uped====%@    ups===%@",weiboDict.uped,weiboDict.ups);
        if ([weiboDict.uped intValue]==0)
        {
            weiboDict.uped=[NSNumber numberWithInt:1];
            int ups=[weiboDict.ups intValue];
            ups =ups+[weiboDict.uped intValue];
            weiboDict.ups=[NSNumber numberWithInt:ups];
            //重新给markview 赋值，改变markview的frame
            [self layoutMarkViewWithMarkView:markView WeiboInfo:weiboDict];
            
            
            
        }
        else  {
            
            weiboDict.uped=[NSNumber numberWithInt:0];
            int ups=[weiboDict.ups intValue];
            ups =ups-1;
            weiboDict.ups=[NSNumber numberWithInt:ups];
            [self layoutMarkViewWithMarkView:markView WeiboInfo:weiboDict];
        }
        
        ////发送到服务器
        [self LikeRequstData:weiboDict StageInfo:stageInfoDict];
        
    }
}
//重新布局markview
-(void)layoutMarkViewWithMarkView:(MarkView  *) markView WeiboInfo:(WeiboModel *) weibodict
{
    
    
    NSLog(@" 点赞 后 微博dict  ＝====uped====%@    ups===%@",weibodict.uped,weibodict.ups);
    
    //     float  x=[weibodict.x floatValue];
    //   float  y=[weibodict.y floatValue];
    NSString  *weiboTitleString=weibodict.topic;
    NSString  *UpString=[NSString stringWithFormat:@"%@",weibodict.ups];//weibodict.ups;
    //计算标题的size
    CGSize  Msize=[weiboTitleString boundingRectWithSize:CGSizeMake(kDeviceWidth/2,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:markView.TitleLable.font forKey:NSFontAttributeName] context:nil].size;
    // 计算赞数量的size
    CGSize Usize=[UpString boundingRectWithSize:CGSizeMake(40,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:markView.ZanNumLable.font forKey:NSFontAttributeName] context:nil].size;
    
    // NSLog(@"size= %f %f", Msize.width, Msize.height);
    //计算赞数量的长度
    float  Uwidth=[UpString floatValue]==0?0:Usize.width;
    //宽度=字的宽度+左头像图片的宽度＋赞图片的宽度＋赞数量的宽度+中间两个空格2+2
    float markViewWidth = Msize.width+23+Uwidth+5+5+11+5;
    float markViewHeight = Msize.height+6;
    if(IsIphone6)
    {
        markViewWidth=markViewWidth+10;
        markViewHeight=markViewHeight+4;
    }
#warning    kDeviceWidth 目前计算的是正方形的，当图片高度>屏幕的宽度的实际，需要使用图片的高度
    //markViewY = MIN(MAX(markViewY, 1.0f), kDeviceWidth-markViewHeight-1);
#pragma mark 设置气泡的大小和位置
    markView.frame=CGRectMake(markView.frame.origin.x, markView.frame.origin.y, markViewWidth, markViewHeight);
#pragma mark 设置标签的内容
    // markView.TitleLable.text=weiboTitleString;
    markView.ZanNumLable.text =[NSString stringWithFormat:@"%@",weibodict.ups];
    if ([weibodict.ups intValue]==0) {
        markView.ZanNumLable.hidden=YES;
    }
    else
    {
        markView.ZanNumLable.hidden=NO;
    }
    
}
#pragma mark  -----
#pragma mark  ------ToolbuttomView隐藏工具栏的方法
#pragma mark  -------
//点击屏幕，隐藏工具栏

-(void)topViewTouchBengan
{
    NSLog(@"controller touchbegan  中 执行了隐藏工具栏的方法");
    //取消当前的选中的那个气泡
    [_mymarkView CancelMarksetSelect];
    self.tabBarController.tabBar.hidden=YES;
    if (_toolBar) {
        [_toolBar HidenButtomView];
        //  [_toolBar performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.5];
        [_toolBar removeFromSuperview];
        
    }
    
}


//- (void)handleComplete {
//    [self dismissViewControllerAnimated:NO completion:^{ }];
//}

@end
