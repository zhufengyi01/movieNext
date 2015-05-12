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
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface ShowStageViewController() <ButtomToolViewDelegate,StageViewDelegate,AddMarkViewControllerDelegate,UMShareViewControllerDelegate,UMSocialDataDelegate,UMSocialUIDelegate,UIActionSheetDelegate,UMShareViewController2Delegate>
{
    ButtomToolView *_toolBar;
    UIButton  *moreButton;
    BOOL    isShowMark;
    UIScrollView *scrollView;
    UIView *BgView2;
    UIButton  *ScreenButton;
    UIButton  *addMarkButton;
    //   UMShareView  *shareView;
    StageView *stageView;
    MarkView       *_mymarkView;
    UIImageView *BgView;
    UIButton  *_tanlogoButton;
    
    UIButton      *leftButtomButton;   //左下边按钮
    UILabel       *movieNameLable;
    UIImageView   *MovieLogoImageView;  // 电影的小图片
    

}
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
    //[self createTopView];
    [self createStageView];
    //创建底部的分享
    [self createButtonView1];
    [self createToolBar];
 }

-(void)createNav
{
    UILabel  *titleLable=[ZCControl createLabelWithFrame:CGRectMake(0, 0, 100, 20) Font:16 Text:self.stageInfo.movieInfo.name];
    titleLable.textColor=VBlue_color;
    
    titleLable.font=[UIFont boldSystemFontOfSize:18];
    titleLable.textAlignment=NSTextAlignmentCenter;
    //self.navigationItem.titleView=titleLable;
    
   // UIBarButtonItem  *barbutton =[[UIBarButtonItem alloc]initWithCustomView:titleLable];
    //self.navigationItem.backBarButtonItem = barbutton;
   

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
    BgView =[[UIImageView alloc]initWithFrame:CGRectMake(5,5,kDeviceWidth-10, kDeviceWidth+45)];
    BgView.clipsToBounds=YES;
    [BgView.layer setShadowOffset:CGSizeMake(kDeviceWidth, 20)];
    [BgView.layer setShadowColor:[UIColor blackColor].CGColor];
    [BgView.layer setShadowRadius:10];
    BgView.layer.cornerRadius=4;
    BgView.clipsToBounds=YES;
    BgView.userInteractionEnabled=YES;
    [scrollView addSubview:BgView];
    

    
    stageView = [[StageView alloc] initWithFrame:CGRectMake(0,0,kDeviceWidth, kDeviceWidth)];
    stageView.isAnimation = YES;
    stageView.delegate=self;
    stageView.stageInfo=self.stageInfo;
    stageView.weibosArray = self.stageInfo.weibosArray;
    [stageView configStageViewforStageInfoDict];
     [BgView addSubview:stageView];
    [stageView startAnimation];
    
    UITapGestureRecognizer  *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showAndHidenMarkViews)];
    [stageView addGestureRecognizer:tap];

}
 -(void)createButtonView1
{
    BgView2=[[UIView alloc]initWithFrame:CGRectMake(0,stageView.frame.origin.y+stageView.frame.size.height, kDeviceWidth, 45)];
    //改变toolar 的颜色
    BgView2.backgroundColor=View_ToolBar;
    [self.view bringSubviewToFront:BgView2];
    [BgView addSubview:BgView2];
    
    leftButtomButton=[UIButton buttonWithType:UIButtonTypeCustom];
    leftButtomButton.frame=CGRectMake(10, 5, 140, 35);
    //leftButtomButton.backgroundColor=[[UIColor redColor]colorWithAlphaComponent:0.2];
    [leftButtomButton setBackgroundImage:[[UIImage imageNamed:@"movie_button_bg"] stretchableImageWithLeftCapWidth:15 topCapHeight:15] forState:UIControlStateNormal];
    
    [leftButtomButton addTarget:self action:@selector(StageMovieButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [BgView2 addSubview:leftButtomButton];

    MovieLogoImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,30, 27)];
    MovieLogoImageView.layer.cornerRadius=4;
    if (self.stageInfo.movieInfo.logo) {
        NSString  *logoString =[NSString stringWithFormat:@"%@%@!w100h100",kUrlMoviePoster,self.stageInfo.movieInfo.logo];
        [MovieLogoImageView sd_setImageWithURL:[NSURL URLWithString:logoString] placeholderImage:[UIImage imageNamed:@"loading_image_all.png"]];
    }
    
    MovieLogoImageView.layer.masksToBounds = YES;
    [leftButtomButton addSubview:MovieLogoImageView];
    
    movieNameLable =[[UILabel alloc]initWithFrame:CGRectMake(35, 9, 120, 30)];
    movieNameLable.font=[UIFont systemFontOfSize:16];
    movieNameLable.textColor=VGray_color;
    //movieNameLable.text=self.stageInfo.movieInfo.name;
    // movieNameLable.numberOfLines=1;
    movieNameLable.lineBreakMode=NSLineBreakByTruncatingTail;
    [leftButtomButton addSubview:movieNameLable];
    NSString  *nameStr=self.stageInfo.movieInfo.name;

    
    
    CGSize  Nsize =[nameStr boundingRectWithSize:CGSizeMake(100, 27) options:(NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin) attributes:[NSDictionary dictionaryWithObject:movieNameLable.font forKey:NSFontAttributeName] context:nil].size;
    movieNameLable.frame=CGRectMake(35, 0, Nsize.width+4, 27);
    leftButtomButton.frame=CGRectMake(10, 9, 30+5+movieNameLable.frame.size.width, 27);
    movieNameLable.text=[NSString stringWithFormat:@"%@",nameStr];


    
    
    //更多
    moreButton=[ZCControl createButtonWithFrame:CGRectMake(kStageWidth-130, 9, 30, 25) ImageName:@"more_icon.png" Target:self Action:@selector(cellButtonClick:) Title:@""];
    moreButton.layer.cornerRadius=2;
    moreButton.hidden=NO;
    [BgView2 addSubview:moreButton];
    

    
    
//    ScreenButton =[ZCControl createButtonWithFrame:CGRectMake(kDeviceWidth-110,10,45,25) ImageName:@"btn_share_default.png" Target:self Action:@selector(ScreenButtonClick:) Title:@""];
//    [ScreenButton setBackgroundImage:[UIImage imageNamed:@"btn_share_select.png"] forState:UIControlStateHighlighted];
//    [BgView2 addSubview:ScreenButton];
    
    if (_tanlogoButton) {
        [_tanlogoButton removeFromSuperview];
        _tanlogoButton=nil;
    }
    _tanlogoButton =[UIButton buttonWithType:UIButtonTypeCustom];
    _tanlogoButton.frame=CGRectMake(kStageWidth-100, 9, 45, 25);
    [_tanlogoButton setImage:[UIImage imageNamed:@"close_danmu.png"] forState:UIControlStateNormal];
    [_tanlogoButton setImage:[UIImage imageNamed:@"open_danmu.png.png"] forState:UIControlStateSelected];
    [_tanlogoButton addTarget:self action:@selector(hidenAndShowMarkView:) forControlEvents:UIControlEventTouchUpInside];
    [BgView2 addSubview:_tanlogoButton];

    
    addMarkButton =[ZCControl createButtonWithFrame:CGRectMake(kStageWidth-55,10,45,25) ImageName:@"btn_add_default.png" Target:self Action:@selector(addMarkButtonClick:) Title:@""];
    [addMarkButton setBackgroundImage:[UIImage imageNamed:@"btn_add_select.png"] forState:UIControlStateHighlighted];
    [BgView2 addSubview:addMarkButton];
    
}
//创建底部的视图
-(void)createToolBar

{
    _toolBar=[[ButtomToolView alloc]initWithFrame:CGRectMake(0,0,kDeviceWidth,kDeviceHeight)];
    _toolBar.delegete=self;
    
}


#pragma mark 点击屏幕显示和隐藏marview
//显示隐藏markview
-(void)hidenAndShowMarkView:(UIButton *) button
{
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
        for (id   view  in stageView.subviews) {
            if  ([view isKindOfClass:[MarkView class]]) {
                MarkView  *mv =(MarkView *)view;
                mv.hidden=NO;
            }
        }
    }
}




#pragma  mark  ----RequestData
#pragma  mark  ---

//屏幕剧照
-(void)requestRemoveStage
{
    UserDataCenter *usercenter=[UserDataCenter shareInstance];
    NSDictionary *parameters = @{@"stage_id":self.stageInfo.Id,@"user_id":usercenter.user_id};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *urlString =[NSString stringWithFormat:@"%@/stage/block", kApiBaseUrl];
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject  objectForKey:@"code"]  intValue]==0) {
            NSLog(@"移除剧照成功=======%@",responseObject);
            UIAlertView  *Al =[[UIAlertView alloc]initWithTitle:nil message:@"移除剧照成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
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
-(void)LikeRequstData:(weiboInfoModel  *) weiboInfo withOperation:(NSNumber *) operation
{
    UserDataCenter  *userCenter=[UserDataCenter shareInstance];
    NSNumber  *weiboId=weiboInfo.Id;
    NSString  *userId=userCenter.user_id;
    NSNumber  *author_id=weiboInfo.uerInfo.Id;
    NSDictionary *parameters=@{@"weibo_id":weiboId,@"user_id":userId,@"author_id":author_id,@"operation":operation};
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


-(void)UMShareViewControllerHandClick:(UIButton *)button ShareImage:(UIImage *)shareImage StageInfoModel:(stageInfoModel *)StageInfo
{
    NSArray  *sharearray =[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQzone, UMShareToSina, nil];
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
    
    [[UMSocialControllerService defaultControllerService] setShareText:StageInfo.movieInfo.name shareImage:shareImage socialUIDelegate:self];        //设置分享内容和回调对象
    [UMSocialSnsPlatformManager getSocialPlatformWithName:[sharearray  objectAtIndex:button.tag-10000]].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
    NSLog(@"分享到微信");
}
-(void)UMShareViewController2HandClick:(UIButton *)button ShareImage:(UIImage *)shareImage StageInfoModel:(stageInfoModel *)StageInfo
{
    NSArray  *sharearray =[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQzone, UMShareToSina, nil];
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
    [[UMSocialControllerService defaultControllerService] setShareText:StageInfo.movieInfo.name shareImage:shareImage socialUIDelegate:self];
    //设置分享内容和回调对象
    
    [UMSocialSnsPlatformManager getSocialPlatformWithName:[sharearray  objectAtIndex:button.tag-10000]].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
    
}

//跳转到电影页
-(void)StageMovieButtonClick:(UIButton *) button
{
    
    //电影按钮
    MovieDetailViewController *vc =  [MovieDetailViewController new];
    vc.movieId = self.stageInfo.movie_id;
    NSMutableString  *backstr=[[NSMutableString alloc]initWithString:self.stageInfo.movieInfo.name];
    vc.moviename=self.stageInfo.movieInfo.name;
    vc.movielogo=self.stageInfo.movieInfo.logo;
 
    [self.navigationController pushViewController:vc animated:YES];
}
// 分享
-(void)ScreenButtonClick:(UIButton  *) button
{
    UIImage  *image=[Function getImage:stageView WithSize:CGSizeMake(kDeviceWidth, kDeviceWidth)];
    UMShareViewController  *shareVC=[[UMShareViewController alloc]init];
    shareVC.StageInfo=self.stageInfo;
    shareVC.screenImage=image;
    shareVC.delegate=self;
    UINavigationController  *na =[[UINavigationController alloc]initWithRootViewController:shareVC];
    [self presentViewController:na animated:YES completion:nil];

}
//添加弹幕
-(void)addMarkButtonClick:(UIButton  *) button
{
    
    
    NSLog(@" ==addMarkButtonClick  ====%ld",(long)button.tag);
    AddMarkViewController  *AddMarkVC=[[AddMarkViewController alloc]init];
    AddMarkVC.delegate=self;
   // AddMarkVC.model=self.stageInfo;
    AddMarkVC.stageInfo=self.stageInfo;
  //  AddMarkVC.pageSoureType=NSAddMarkPageSourceDefault;
 //   [self.navigationController pushViewController:AddMarkVC animated:NO];
    UINavigationController  *na =[[UINavigationController alloc]initWithRootViewController:AddMarkVC];
    [self.navigationController presentViewController:na animated:YES completion:nil];


}
-(void)cellButtonClick:(UIButton  *) button
{
     UserDataCenter  *userCenter =[UserDataCenter shareInstance];
    //点击了更多
    if ([userCenter.is_admin intValue]>0) {
        
        UIActionSheet  *Act=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"内容投诉",@"版权投诉",@"图片信息",@"切换剧照到（审核/正式）",@"屏蔽剧照",nil];
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
    [stageView configStageViewforStageInfoDict];
    
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
    
    if (button.tag==10000) {
        ///点击了头像//进入个人页面
        [_mymarkView CancelMarksetSelect];
        if (_toolBar) {
            [_toolBar HidenButtomView];
            [_toolBar removeFromSuperview];
        }

        MyViewController   *myVc=[[MyViewController alloc]init];
        myVc.author_id=weiboDict.created_by;
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
        int tag=0;// 标志是否含有weiboid
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
        [self LikeRequstData:weiboDict withOperation:operation];
        
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
    
        [self.navigationController pushViewController:vc animated:YES];
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag==507) {
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
            [self requestRemoveStage];
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
