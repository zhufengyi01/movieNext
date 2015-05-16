//
//  MyViewController.m
//  movienext
//
//  Created by 风之翼 on 15/2/27.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "MyViewController.h"
#import "Constant.h"
#import "ZCControl.h"
#import "LoadingView.h"
#import "UserDataCenter.h"
#import "AFNetworking.h"
#import "AFHTTPRequestOperationManager.h"
#import "CommonStageCell.h"
#import "UserDataCenter.h"
#import "SettingViewController.h"
#import "UIImageView+WebCache.h"
#import "StageView.h"
#import "stageInfoModel.h"
#import "ButtomToolView.h"
#import "MovieDetailViewController.h"
#import "UMSocial.h"
#import "MJRefresh.h"
#import "AddMarkViewController.h"
#import "Function.h"
#import "ChangeSelfViewController.h"
#import "UMShareViewController.h"
#import "UMShareViewController2.h"
#import "userAddmodel.h"
#import "Function.h"
#import "UIImage-Helpers.h"
#import "ScanMovieInfoViewController.h"
#import "TagToStageViewController.h"
#import "UpweiboModel.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface MyViewController ()<UITableViewDataSource, UITableViewDelegate,StageViewDelegate,StageViewDelegate,ButtomToolViewDelegate,UIActionSheetDelegate,UMSocialDataDelegate,UMSocialUIDelegate,CommonStageCellDelegate,UMShareViewControllerDelegate,UMShareViewController2Delegate>
{
    //UISegmentedControl *segment;
    UITableView   *_tableView;
    NSMutableArray    *_addedDataArray;
    NSMutableArray    *_upedDataArray;
   // NSMutableDictionary  *_userInfoDict;
    LoadingView   *loadView;
    int page1;
    int page2;
    int pageSize;
    int pageCount1;
    int pageCount2;
    UIImageView *ivAvatar;//头像
    UILabel *lblUsername;//用户名
    UILabel *lblCount;//统计信息
    UILabel *lblZanCout;
    UILabel *lblBrief;//简介
    UserDataCenter  *userCenter;
    ButtomToolView *_toolBar;
    MarkView       *_mymarkView;
     int  productCount;
    //保存头部视图按钮的状态
    NSMutableDictionary  *buttonStateDict;
    NSMutableDictionary  *IsNullStateDict; //纪录添加还是赞的数据为空
   // HotMovieModel  *_Tmodel;  ///用户删除的时候存储的model
    NSInteger  Rowindex;
    weiboUserInfoModel  *userInfomodel;
    stageInfoModel  *_TStageInfo;
    weiboInfoModel      *_TweiboInfo;
    BOOL  isShowMark;

}
@end

@implementation MyViewController
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden=NO;
    self.navigationController.navigationBar.alpha=1;
    self.tabBarController.tabBar.hidden=NO;
    self.navigationController.navigationBar.translucent=NO;
    if (self.author_id.length>0&&![self.author_id isEqualToString:@"0"]) {
        self.tabBarController.tabBar.hidden=YES;
    }
    else
    {
        self.tabBarController.tabBar.hidden=NO;
    }
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(changeUser) name:@"initUser" object:nil];
    //NSNotificationCenter  *c= [NSNotificationCenter defaultCenter];
    [[UINavigationBar appearance] setShadowImage:[UIImage imageWithColor:tabBar_line size:CGSizeMake(kDeviceWidth, 1)]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableView) name:@"RefeshTableview" object:nil];

    

    
 }
-(void)changeUser
{
    if (_tableView) {
        [_tableView  removeFromSuperview];
        _tableView=nil;
        [self requestUserInfo];

    }
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
 
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RefeshTableview" object:nil];
 }
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNavigation];
    [self initData];

     [self requestUserInfo];
    
    //[self requestData];
    [self createToolBar];
    //[self createShareView];
    if (self.author_id&&![self.author_id isEqualToString:@"0"]) {
        //如果有用户id 并且用户的id 不为0
        self.navigationItem.rightBarButtonItem=nil;
        self.navigationItem.titleView=nil;
    }
   
}

-(void)initData {
    page1=1;
    page2=1;
    pageSize=20;
    pageCount1=1;
    pageCount2=1;
    isShowMark=YES;
    _addedDataArray = [[NSMutableArray alloc] init];
    _upedDataArray = [[NSMutableArray alloc] init];
    buttonStateDict=[[NSMutableDictionary alloc]init];
    [buttonStateDict setValue:@"YES" forKey:@"100"];
    //纪录那个数据为空
    IsNullStateDict =[[NSMutableDictionary  alloc]init];
    [IsNullStateDict setValue:@"NO" forKey:@"ONE"];
    [IsNullStateDict setValue:@"NO" forKey:@"TWO"];
    
    userInfomodel=[[weiboUserInfoModel alloc]init];
    if (self.author_id&&![self.author_id isEqualToString:@"0"]) {
        //如果有用户id 并且用户的id 不为0
       // _userInfoDict =[[NSMutableDictionary alloc]init];
    }

}
#pragma mark - CreateUI
-(void)createNavigation
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"tabbar_backgroud_color.png"] forBarMetrics:UIBarMetricsDefault];

    UILabel  *titleLable=[ZCControl createLabelWithFrame:CGRectMake(0, 0, 100, 20) Font:16 Text:@"我的"];
    titleLable.textColor=VBlue_color;
    
    titleLable.font=[UIFont boldSystemFontOfSize:18];
    titleLable.textAlignment=NSTextAlignmentCenter;
    self.navigationItem.titleView=titleLable;
    
    UIButton  *button=[UIButton buttonWithType:UIButtonTypeCustom];
    //[button setTitle:@"设置" forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"setting.png"] forState:UIControlStateNormal];
    button.frame=CGRectMake(kDeviceWidth-30, 10, 18, 18);
    [button addTarget:self action:@selector(GotoSettingClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem  *barButton=[[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem=barButton;
    
    
}
//点击可刷新
-(void)refreshTableView
{
    [_tableView  headerBeginRefreshing];
}


-(void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kHeightNavigation-kHeigthTabBar+10)];
    _tableView.backgroundColor=View_BackGround;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    //是从别人的页面进来的不是自己的
    if (self.author_id.length>0&&![self.author_id isEqualToString:@"0"]) {
        _tableView.frame=CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kHeightNavigation);
    }

    userCenter=[UserDataCenter shareInstance];
    NSString  *signature=[NSString stringWithFormat:@"%@", userInfomodel.brief];
    if (signature==nil) {
        signature=@"";
    }
     UIView *viewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 130)];
    viewHeader.backgroundColor =[UIColor whiteColor];
     int ivAvatarWidth = 50;
    ivAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, ivAvatarWidth, ivAvatarWidth)];
    ivAvatar.layer.cornerRadius = ivAvatarWidth * 0.5;
    ivAvatar.layer.masksToBounds = YES;
    ivAvatar.layer.borderColor=VBlue_color.CGColor;
    ivAvatar.layer.borderWidth=3;

    //ivAvatar.backgroundColor = [UIColor redColor];
    NSURL   *imageURL;
    if (userInfomodel) {
        imageURL =[NSURL URLWithString:[NSString stringWithFormat:@"%@%@!thumb",kUrlAvatar,userInfomodel.logo]];
    }
    [ivAvatar sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"user_normal.png"]];
   
    
    [viewHeader addSubview:ivAvatar];
    
      if ([userCenter.is_admin  intValue]>0) {
          //在头像上添加一个手势，实现变成功能
          UIView  *view =[[UIView alloc]initWithFrame:ivAvatar.frame];
          view.backgroundColor =[ UIColor clearColor];
          [viewHeader addSubview:view];
          UILongPressGestureRecognizer  *longPressHeader =[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressHead:)];
          
          [view addGestureRecognizer:longPressHeader];


    }
    
    
    lblUsername = [[UILabel alloc] initWithFrame:CGRectMake(ivAvatar.frame.origin.x+ivAvatar.frame.size.width+10, ivAvatar.frame.origin.y, 200, 20)];
    lblUsername.font = [UIFont boldSystemFontOfSize:15];
    lblUsername.textColor = VGray_color;
    if (userInfomodel) {
        lblUsername.text=[NSString stringWithFormat:@"%@",userInfomodel.username];
    }
     [viewHeader addSubview:lblUsername];
    
    UILabel  *lbl1=[ZCControl createLabelWithFrame:CGRectMake(lblUsername.frame.origin.x,lblUsername.frame.origin.y+lblUsername.frame.size.height+5, 35, 20) Font:14 Text:@"内容"];
    lbl1.textColor=VBlue_color;
   // lbl1.backgroundColor =[UIColor redColor];
    [viewHeader addSubview:lbl1];
    
    //内容的数量
    lblCount = [[UILabel alloc] initWithFrame:CGRectMake(lbl1.frame.origin.x+lbl1.frame.size.width, lblUsername.frame.origin.y+lblUsername.frame.size.height+5, 25, 20)];
  //  lblCount.backgroundColor=[UIColor yellowColor];
    lblCount.font = [UIFont systemFontOfSize:14];

    if (userInfomodel) {
        lblCount.text=[NSString stringWithFormat:@"%@",userInfomodel.weibo_count];
    }
     lblCount.textColor = VGray_color;
    //lblCount.backgroundColor = [UIColor purpleColor];
    [viewHeader addSubview:lblCount];
    
    
    UILabel  *lbl2=[ZCControl createLabelWithFrame:CGRectMake(lblCount.frame.origin.x+lblCount.frame.size.width,lblUsername.frame.origin.y+lblUsername.frame.size.height+5, 35, 20) Font:14 Text:@"被赞"];
    lbl2.textColor=VBlue_color;
    //lbl2.backgroundColor=[UIColor grayColor];
    [viewHeader addSubview:lbl2];

    //赞的数量
    lblZanCout = [[UILabel alloc] initWithFrame:CGRectMake(lbl2.frame.origin.x+lbl2.frame.size.width,lblCount.frame.origin.y , 50, 20)];
    lblZanCout.font = [UIFont systemFontOfSize:14];
  //  lblZanCout.backgroundColor=[UIColor blueColor];
    lblZanCout.textColor = VGray_color;
    if (userInfomodel) {
        lblZanCout.text  =[NSString stringWithFormat:@"%@",userInfomodel.liked_count];
    }
     [viewHeader addSubview:lblZanCout];
    
   //简介
    lblBrief = [[UILabel alloc] initWithFrame:CGRectMake(ivAvatar.frame.origin.x+ivAvatar.frame.size.width+10,lblCount.frame.origin.y+lblCount.frame.size.height+10, kDeviceWidth-ivAvatar.frame.origin.x-ivAvatar.frame.size.width-20, 20)];
    lblBrief.numberOfLines=0;
    lblBrief.font = [UIFont systemFontOfSize:14];
    
    CGSize  Msize= [signature boundingRectWithSize:CGSizeMake(kDeviceWidth-80, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:lblBrief.font forKey:NSFontAttributeName] context:nil].size;
    lblBrief.textColor = VGray_color;
   // lblBrief.backgroundColor = [UIColor orangeColor];
    lblBrief.text=signature;
    lblBrief.frame=CGRectMake(ivAvatar.frame.origin.x+ivAvatar.frame.size.width+10,lblCount.frame.origin.y+lblCount.frame.size.height+10, kDeviceWidth-ivAvatar.frame.origin.x-ivAvatar.frame.size.width-20, Msize.height);
      [viewHeader addSubview:lblBrief];
    
    
    UIButton  *addButton=[ZCControl createButtonWithFrame:CGRectMake(0,  lblBrief.frame.origin.y+lblBrief.frame.size.height+25, kDeviceWidth/2, 40) ImageName:nil Target:self Action:@selector(dealSegmentClick:) Title:@"添加"];
    [addButton setTitleColor:VGray_color forState:UIControlStateNormal];
    [addButton setTitleColor:VBlue_color forState:UIControlStateSelected];
    if ([[buttonStateDict objectForKey:@"100"] isEqualToString:@"YES"]) {
        [addButton setSelected:YES];
    }
    else{
        [addButton setSelected:NO];
    }
    addButton.titleLabel.font=[UIFont systemFontOfSize:16];
    //addButton.backgroundColor=VLight_GrayColor;
    addButton.tag=100;
    [viewHeader addSubview:addButton];
    
    UIView  *lineView=[[UIView alloc]initWithFrame:CGRectMake(kDeviceWidth/2,addButton.frame.origin.y+10,0.5,20)];
    lineView.backgroundColor=VLight_GrayColor;
    [viewHeader addSubview:lineView];
    
    UIButton  *zanButton=[ZCControl createButtonWithFrame:CGRectMake(kDeviceWidth/2,  lblBrief.frame.origin.y+lblBrief.frame.size.height+25, kDeviceWidth/2, 40) ImageName:nil Target:self Action:@selector(dealSegmentClick:) Title:@"赞"];
    [zanButton setTitleColor:VGray_color forState:UIControlStateNormal];
    [zanButton setTitleColor:VBlue_color forState:UIControlStateSelected];
    if ([[buttonStateDict objectForKey:@"101"] isEqualToString:@"YES"]) {
        [zanButton setSelected:YES];
    }
    else{
        [zanButton setSelected:NO];
    }
    zanButton.titleLabel.font=[UIFont systemFontOfSize:16];
    zanButton.tag=101;
    [viewHeader addSubview:zanButton];

    [self createLoadview];
    //修改了loadview的frame
    if (loadView) {
        float  y=zanButton.frame.origin.y+zanButton.frame.size.height;
        loadView.frame=CGRectMake(0, y, kDeviceWidth, kDeviceHeight-y-kHeightNavigation);
    }
    
    viewHeader.frame=CGRectMake(0, 0, kDeviceWidth,addButton.frame.origin.y+addButton.frame.size.height);
    [_tableView setTableHeaderView:viewHeader];
    [self setupRefresh];

}
//长按进入虚拟用户选择
-(void)longPressHead:(UILongPressGestureRecognizer  *) longPressHeader
{
    if (longPressHeader.state==UIGestureRecognizerStateBegan) {
        
        [self.navigationController pushViewController:[ChangeSelfViewController new] animated:YES];
    }
}

-(void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [_tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    //  #warning 自动刷新(一进入程序就下拉刷新)
    //if (!self.author_id &&[self.author_id isEqualToString:@""]) {
            [_tableView headerBeginRefreshing];
    //}
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [_tableView addFooterWithTarget:self action:@selector(footerRereshing)];
}
#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    
    for (int i=100; i<102;i++ ) {
        UIButton  *btn =(UIButton *)[self.view viewWithTag:i];
        if (btn.tag==100&&btn.selected==YES) {
            if (_addedDataArray.count>0) {
                [_addedDataArray removeAllObjects];
            }
            page1=1;
            [self requestData];

        }
        else if (btn.tag==101&&btn.selected==YES)
        {
            if (_upedDataArray.count>0) {
                [_upedDataArray removeAllObjects];
            }
            page2=1;
            [self requestData];
        }
    }
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [_tableView reloadData];
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [_tableView headerEndRefreshing];
    });
}

- (void)footerRereshing
{

 
    for (int i=100; i<102;i++ ) {
        UIButton  *btn =(UIButton *)[self.view viewWithTag:i];
        if (btn.tag==100&&btn.selected==YES) {
            if (pageCount1>page1) {
              page1=page1+1;
            [self requestData];
            }
        }
        else if (btn.tag==101&&btn.selected==YES)
        {
            if (pageCount2>page2) {
            page2=page2+1;
            [self requestData];
        }
    }
    }

    
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [_tableView reloadData];
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [_tableView footerEndRefreshing];
    });
}



-(void)dealSegmentClick:(UIButton *) button
{
    if(button.tag==100)
    {
        NSLog(@"点击了第一个按钮");
        if (button.selected==YES) {
            //已经选择的情况下，点击这个没有反应
        }
        else if(button.selected==NO)
        {
            button.selected=YES;
            [buttonStateDict setValue:@"YES" forKey:@"100"];
            //把赞设置为选择状态
            UIButton  *btn =(UIButton *)[self.view viewWithTag:101];
            btn.selected=NO;
            [buttonStateDict setValue:@"NO" forKey:@"101"];
            [_tableView reloadData];
            if (_addedDataArray.count==0) {
                [self requestData];
            }
            if ( [[IsNullStateDict objectForKey:@"ONE"] isEqualToString:@"YES"]) {
                [_tableView addSubview:loadView];
            }
            else
            {
                [loadView removeFromSuperview];
            }
        }
    }
    else if(button.tag==101)
    {
        NSLog(@"点击了第er个按钮");

        if (button.selected==YES) {
            
        }
        else if(button.selected==NO)
        {
           button.selected=YES;
         
          [buttonStateDict setValue:@"YES" forKey:@"101"];
         //把赞设置为选择状态
          UIButton  *btn =(UIButton *)[self.view viewWithTag:100];
          [buttonStateDict setValue:@"NO" forKey:@"100"];
          btn.selected=NO;
          [_tableView reloadData];
           if (_upedDataArray.count==0) {
            [self requestData];
           }
          if ( [[IsNullStateDict objectForKey:@"TWO"] isEqualToString:@"YES"]) {
                [_tableView addSubview:loadView];
            }
            else
            {
                [loadView removeFromSuperview];
            }

        }
    }
    
    NSLog(@"buttonStateDict=======%@",buttonStateDict);
}
- (void)createLoadview
{
    loadView =[[LoadingView alloc]initWithFrame:CGRectMake(0, 200, kDeviceWidth, kDeviceHeight-kHeightNavigation-200)];
}

//创建底部的视图
-(void)createToolBar

{
    _toolBar=[[ButtomToolView alloc]initWithFrame:CGRectMake(0,0,kDeviceWidth,kDeviceHeight)];
    _toolBar.delegete=self;
    
}


#pragma  mark -----
#pragma  mark ------  DataRequest 
#pragma  mark ----
//举报剧情
-(void)requestReportweibo
{
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



//举报剧情
-(void)requestReportSatge
{
    // NSString *type=@"1";
    NSString  *stageId=@"";
    NSString  *author_id=@"";
    for (int i=100; i<102;i++ ) {
        UIButton  *btn =(UIButton *)[self.view viewWithTag:i];
        if (btn.tag==100&&btn.selected==YES) {
            userAddmodel *model =[_addedDataArray objectAtIndex:Rowindex];
            stageId=[NSString stringWithFormat:@"%@",model.weiboInfo.stageInfo.Id];
            author_id=model.weiboInfo.stageInfo.created_by;

        }
        else if (btn.tag==101&&btn.selected==YES)
        {
         
            userAddmodel *model =[_upedDataArray objectAtIndex:Rowindex];
            stageId=[NSString stringWithFormat:@"%@",model.weiboInfo.stageInfo.Id];
            author_id=model.weiboInfo.stageInfo.created_by;

        }
    }
    
    NSDictionary *parameters = @{@"reported_user_id":author_id,@"stage_id":stageId,@"reason":@"",@"user_id":userCenter.user_id};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/report-stage/create", kApiBaseUrl] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject  objectForKey:@"code"]  intValue]==0) {
            NSLog(@"随机数种子请求成功=======%@",responseObject);
            UIAlertView  *Al =[[UIAlertView alloc]initWithTitle:nil message:@"你的举报已成功,我们会在24小时内处理" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [Al show];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}




-(void)requestUserInfo
{
    NSString  *userId;
    if (self.author_id>0&&![self.author_id isEqualToString:@"0"]) {
        userId=self.author_id;
    }
    else
    {
        UserDataCenter  *user=[UserDataCenter shareInstance];
        userId=user.user_id;
    }
    NSDictionary *parameters = @{@"user_id":userId};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/user/info", kApiBaseUrl] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject  objectForKey:@"code"]  intValue]==0) {
          ///  NSLog(@"请求的用户数据========%@",responseObject);
//            if (_userInfoDict ==nil){
//                _userInfoDict=[[NSMutableDictionary alloc]init];
//            }
//            _userInfoDict =[responseObject objectForKey:@"detail"];
//            productCount=[[_userInfoDict objectForKey:@"product_count"]  intValue];
            [userInfomodel setValuesForKeysWithDictionary:[responseObject objectForKey:@"model"]];
        
            [self createTableView];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}
- (void)requestData{
    NSString  *autorid;
    if (self.author_id>0&&![self.author_id isEqualToString:@"0"]) {
        autorid=self.author_id;
    }
    else
    {
        UserDataCenter  *user=[UserDataCenter shareInstance];
        autorid=user.user_id;
    }
    //user_id是当前用户的ID
    NSDictionary *parameters = @{@"user_id":userCenter.user_id,@"author_id":autorid};
    NSString * section;
    int  page;
    for (int i=100; i<102;i++ ) {
        UIButton  *btn =(UIButton *)[self.view viewWithTag:i];
        if (btn.tag==100&&btn.selected==YES) {
            section= @"user-create-weibo/list";

            page=page1;
        }
        else if (btn.tag==101&&btn.selected==YES)
        {
            section=@"user-up-weibo/list";
            page=page2;
        }
    }
    NSLog(@" parameters  ====%@",parameters);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
     NSString *urlString =[NSString stringWithFormat:@"%@/%@?per-page=%d&page=%d", kApiBaseUrl, section,pageSize,page];
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"code"] intValue]==0) {
            //NSLog(@"个人页面返回的数据====%@",responseObject);
             NSMutableArray  *Detailarray=[responseObject objectForKey:@"models"];
        for (int i=100; i<102;i++ ) {
            UIButton  *btn =(UIButton *)[self.view viewWithTag:i];
            if (btn.tag==100&&btn.selected==YES) {
                pageCount1=[[responseObject objectForKey:@"pageCount"] intValue];

                for (NSDictionary  *addDict  in Detailarray) {
                userAddmodel  *model=[[userAddmodel alloc]init];
                if (model) {
                    [model setValuesForKeysWithDictionary:addDict];
                    weiboInfoModel *weibomodel =[[weiboInfoModel alloc]init];
                    if (![[addDict objectForKey:@"weibo"] isKindOfClass:[NSNull class]]) {
                        [weibomodel setValuesForKeysWithDictionary:[addDict objectForKey:@"weibo"]];
                    
                        stageInfoModel  *stagemodel =[[stageInfoModel alloc]init];
                        if (stagemodel) {
                            if (![[[addDict objectForKey:@"weibo"] objectForKey:@"stage"] isKindOfClass:[NSNull class]]) {
                                
                            [stagemodel setValuesForKeysWithDictionary:[[addDict objectForKey:@"weibo"] objectForKey:@"stage"]];
                            movieInfoModel *moviemodel =[[movieInfoModel alloc]init];
                            if (moviemodel) {
                                if (![[[[addDict objectForKey:@"weibo"] objectForKey:@"stage"] objectForKey:@"movie"] isKindOfClass:[NSNull class]]) {
                                
                                [moviemodel setValuesForKeysWithDictionary:[[[addDict objectForKey:@"weibo"] objectForKey:@"stage"] objectForKey:@"movie"]];
                                stagemodel.movieInfo=moviemodel;
                                }
                            }
                            weibomodel.stageInfo=stagemodel;
                            }
                        }
                        weiboUserInfoModel *usermodel =[[weiboUserInfoModel alloc]init];
                        if (usermodel) {
                            [usermodel setValuesForKeysWithDictionary:[[addDict objectForKey:@"weibo"] objectForKey:@"user"]];
                            weibomodel.uerInfo=usermodel;
                        }
                        
                        //tag
                        NSMutableArray  *tagArray = [[NSMutableArray alloc]init];
                        for (NSDictionary  *tagDict  in [[addDict objectForKey:@"weibo"] objectForKey:@"tags"]) {
                            TagModel *tagmodel =[[TagModel alloc]init];
                            if (tagmodel) {
                                [tagmodel setValuesForKeysWithDictionary:tagDict];
                                TagDetailModel *tagedetail = [[TagDetailModel alloc]init];
                                if (tagedetail) {
                                    [tagedetail setValuesForKeysWithDictionary:[tagDict  objectForKey:@"tag"]];
                                    tagmodel.tagDetailInfo=tagedetail;
                                }
                                
                                [tagArray addObject:tagmodel];
                            }
                        }
                        weibomodel.tagArray=tagArray;

                        
                        
                        
                        
                        model.weiboInfo=weibomodel;
                        if (_addedDataArray ==nil) {
                            _addedDataArray=[[NSMutableArray alloc]init];
                        }

                        [_addedDataArray addObject:model];
                    }
                }
            }
                //点赞的数组
//            for (NSDictionary  *updict in [responseObject objectForKey:@"upweibos"]) {
//                UpweiboModel *upmodel =[[UpweiboModel alloc]init];
//                if (upmodel) {
//                    [upmodel setValuesForKeysWithDictionary:updict];
//                    if (_upWeiboArray==nil) {
//                        _upWeiboArray =[[NSMutableArray alloc]init];
//                    }
//                    [_upWeiboArray addObject:upmodel];
//                    }
//                }

            if (_addedDataArray.count==0) {
                [IsNullStateDict setValue:@"YES" forKey:@"ONE"];
                [_tableView addSubview:loadView];
                [loadView showNullView:@"没有数据"];
            }
            else
            {
                [IsNullStateDict setValue:@"NO" forKey:@"ONE"];
                [loadView stopAnimation];
                [loadView removeFromSuperview];
                [_tableView reloadData];
            }
        }
        else if(btn.tag==101&&btn.selected==YES)
        {
            pageCount2=[[responseObject objectForKey:@"pageCount"] intValue];

            if (_upedDataArray ==nil) {
                _upedDataArray=[[NSMutableArray alloc]init];
            }
            for (NSDictionary  *addDict  in Detailarray) {
                
                userAddmodel  *model=[[userAddmodel alloc]init];
                if (model) {
                    [model setValuesForKeysWithDictionary:addDict];
                    weiboInfoModel *weibomodel =[[weiboInfoModel alloc]init];
                    if (weibomodel) {
                        [weibomodel setValuesForKeysWithDictionary:[addDict objectForKey:@"weibo"]];
                        
                        stageInfoModel  *stagemodel =[[stageInfoModel alloc]init];
                        if (stagemodel) {
                            if (![[[addDict objectForKey:@"weibo"] objectForKey:@"stage"] isKindOfClass:[NSNull class]]) {
                            [stagemodel setValuesForKeysWithDictionary:[[addDict objectForKey:@"weibo"] objectForKey:@"stage"]];
                            movieInfoModel *moviemodel =[[movieInfoModel alloc]init];
                            if (moviemodel) {
                                if (![[[[addDict objectForKey:@"weibo"]  objectForKey:@"stage"] objectForKey:@"movie"] isKindOfClass:[NSNull class]]) {
                                
                                [moviemodel setValuesForKeysWithDictionary:[[[addDict objectForKey:@"weibo"] objectForKey:@"stage"] objectForKey:@"movie"]];
                                stagemodel.movieInfo=moviemodel;
                                }
                            }
                            weibomodel.stageInfo=stagemodel;
                            }
                        }
                        weiboUserInfoModel *usermodel =[[weiboUserInfoModel alloc]init];
                        if (usermodel) {
                            [usermodel setValuesForKeysWithDictionary:[[addDict objectForKey:@"weibo"] objectForKey:@"user"]];
                            weibomodel.uerInfo=usermodel;
                        }
                        
                        //tag
                        NSMutableArray  *tagArray = [[NSMutableArray alloc]init];
                        for (NSDictionary  *tagDict  in [[addDict objectForKey:@"weibo"] objectForKey:@"tags"]) {
                            TagModel *tagmodel =[[TagModel alloc]init];
                            if (tagmodel) {
                                [tagmodel setValuesForKeysWithDictionary:tagDict];
                                TagDetailModel *tagedetail = [[TagDetailModel alloc]init];
                                if (tagedetail) {
                                    if (![[tagDict objectForKey:@"tag"] isKindOfClass:[NSNull class]]) {
                                    [tagedetail setValuesForKeysWithDictionary:[tagDict  objectForKey:@"tag"]];
                                    tagmodel.tagDetailInfo=tagedetail;
                                    }
                                }
                                
                                [tagArray addObject:tagmodel];
                            }
                        }
                        weibomodel.tagArray=tagArray;

                        
                        model.weiboInfo=weibomodel;
                        [_upedDataArray addObject:model];
                    }
                }
            }

        
            if (_upedDataArray.count==0) {
                  [IsNullStateDict setValue:@"YES" forKey:@"TWO"];
                [_tableView addSubview:loadView];
                [loadView showNullView:@"没有数据"];
            }
            else
            {
                [IsNullStateDict setValue:@"NO" forKey:@"TWO"];
                [loadView stopAnimation];
                [loadView removeFromSuperview];
                [_tableView reloadData];
                
            }
            [_tableView reloadData];
        }
        }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"下载失败 Error: %@", error);
        [loadView stopAnimation];
        [loadView showFailLoadData];
     
    }];
}

-(void)requestDelectDatawithRowindex:(NSInteger) index
{
    userAddmodel  *model =[_addedDataArray objectAtIndex:index];
    NSDictionary *parameters = @{@"weibo_id":model.weiboInfo.Id,@"remove_type":@"0",@"user_id":userCenter.user_id};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/weibo/remove", kApiBaseUrl] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject  objectForKey:@"code"]  intValue]==0) {
            NSLog(@"删除数据成功=======%@",responseObject);
            if (_addedDataArray.count>0) {
            [_addedDataArray removeObjectAtIndex:index];
            }
            [_tableView reloadData];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}
//微博点赞请求
-(void)LikeRequstData:(WeiboModel  *) weiboDict StageInfo :(stageInfoModel *) stageInfoDict
{
    NSNumber  *weiboId=weiboDict.Id;
    NSNumber  *stageId=stageInfoDict.Id;
    NSString  *movieId=stageInfoDict.movie_id;
    NSString  *movieName=stageInfoDict.movieInfo.name;
    NSString  *userId=userCenter.user_id;
    NSString  *autorId =weiboDict.user_id;
    NSNumber  *uped;
   
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


#pragma mark  -----
#pragma mark --------UItableViewDelegate
#pragma mark  -------
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    for (int i=100; i<102;i++ ) {
        UIButton  *btn =(UIButton *)[self.view viewWithTag:i];
        if (btn.tag==100&&btn.selected==YES) {
            return _addedDataArray.count;

        }
        else if (btn.tag==101&&btn.selected==YES)
        {
            return _upedDataArray.count;
        }
        
    }

    return 0;
}

-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kStageWidth+45+10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommonStageCell  *cell;
    for (int i=100; i<102;i++ ) {
        UIButton  *btn =(UIButton *)[self.view viewWithTag:i];
    if  (btn.tag==100&&btn.selected==YES) {
       
        static NSString *cellID=@"CELL1";
        cell= (CommonStageCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell=[[CommonStageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.backgroundColor=View_BackGround;
        }
            cell.pageType=NSPageSourceTypeMyAddedViewController;
             if (self.author_id.length==0||[self.author_id isEqualToString:@"0"]) {  //表示直接进入这个页面的话，这个为空
                cell.userPage=NSUserPageTypeMySelfController;
            }
            else {
                cell.userPage=NSUserPageTypeOthersController;
            }
        if (_addedDataArray.count>indexPath.row) {
            userAddmodel  *model =[_addedDataArray objectAtIndex:indexPath.row];

            cell.weiboInfo=model.weiboInfo;
            //小闪动标签的数组
            cell.delegate=self;
            cell.stageInfo=model.weiboInfo.stageInfo;
            [cell ConfigsetCellindexPath:indexPath.row];
            cell.stageView.delegate=self;
            
        }
        return cell;
    }
    else if (btn.tag==101&&btn.selected==YES)
    {
        static NSString *cellID=@"CELL2";
        cell= (CommonStageCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell=[[CommonStageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.backgroundColor=View_BackGround;
        }
            cell.pageType=NSPageSourceTypeMyupedViewController;
            if (_upedDataArray.count>indexPath.row) {
                userAddmodel  *model  =[_upedDataArray objectAtIndex:indexPath.row];

            cell.weiboInfo =model.weiboInfo;
            cell.stageInfo=model.weiboInfo.stageInfo;
            [cell ConfigsetCellindexPath:indexPath.row];
            cell.stageView.delegate=self;
            cell.delegate=self;
            
          }
        return cell;
     }
    }
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    CommonStageCell   *cell=(CommonStageCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (isShowMark==YES) {
        [cell showAndHidenMarkViews:YES];
        isShowMark=NO;
    }
    else if (isShowMark==NO)
    {
        isShowMark=YES;
        [cell showAndHidenMarkViews:NO];
    }

 
}
//设置页面
-(void)GotoSettingClick:(UIButton  *) button
{
    
    [self.navigationController pushViewController:[SettingViewController new] animated:YES];
}

#pragma  mark  =====ButtonClick
#pragma  mark  -----UMButtomViewshareViewDlegate-------
-(void)UMShareViewControllerHandClick:(UIButton *)button ShareImage:(UIImage *)shareImage StageInfoModel:(stageInfoModel *)StageInfo
{
    NSArray  *sharearray =[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQzone, UMShareToSina, nil];
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
    
    [[UMSocialControllerService defaultControllerService] setShareText:StageInfo.movieInfo.name shareImage:shareImage socialUIDelegate:self];        //设置分享内容和回调对象
    [UMSocialSnsPlatformManager getSocialPlatformWithName:[sharearray  objectAtIndex:button.tag-10000]].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
 
}
-(void)UMShareViewController2HandClick:(UIButton *)button ShareImage:(UIImage *)shareImage StageInfoModel:(stageInfoModel *)StageInfo
{
    
    NSArray  *sharearray =[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQzone, UMShareToSina, nil];
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
    [[UMSocialControllerService defaultControllerService] setShareText:StageInfo.movieInfo.name shareImage:shareImage socialUIDelegate:self];
    //设置分享内容和回调对象
    
    [UMSocialSnsPlatformManager getSocialPlatformWithName:[sharearray  objectAtIndex:button.tag-10000]].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
    
}


///点击分享的屏幕，收回分享的背景
-(void)SharetopViewTouchBengan
{
    NSLog(@"controller touchbegan  中 执行了隐藏工具栏的方法");
    //取消当前的选中的那个气泡
    [_mymarkView CancelMarksetSelect];

}
-(void)didCloseUIViewController:(UMSViewControllerType)fromViewControllerType
{
    //返回到app执行的方法，移除的时候应该写在这里
    NSLog(@"didCloseUIViewController第一步执行这个");
    
}
//根据有的view 上次一张图片
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    NSLog(@"didFinishGetUMSocialDataInViewController第二部执行这个");
 
}
-(void)didFinishGetUMSocialDataResponse:(UMSocialResponseEntity *)response;
{
    NSLog(@"didFinishGetUMSocialDataResponse第二部执行这个");
    
    
}

#pragma mark   -----commonStageCelldelegate  ---------------------------------------------
-(void)commonStageCellToolButtonClick:(UIButton *)button Rowindex:(NSInteger)index
{
    
     userAddmodel  *addmodel;
    Rowindex =index;

    for (int i=100; i<102;i++ ) {
        UIButton  *btn =(UIButton *)[self.view viewWithTag:i];
        if (btn.tag==100&&btn.selected==YES) {
            addmodel =[_addedDataArray objectAtIndex:index];}
        else if (btn.tag==101&&btn.selected==YES)
        {
            addmodel=[_upedDataArray objectAtIndex:index];
        }
    }
    if(button.tag==1000)
    {
        // 电影
        MovieDetailViewController *vc =  [MovieDetailViewController new];
        vc.movieId = addmodel.weiboInfo.stageInfo.movieInfo.Id;
        vc.moviename=addmodel.weiboInfo.stageInfo.movieInfo.name;
        vc.movielogo=addmodel.weiboInfo.stageInfo.movieInfo.logo;

        [self.navigationController pushViewController:vc animated:YES];

    }
    else if(button.tag==2000)
    {
        //分享
        CommonStageCell *cell = (CommonStageCell *)(button.superview.superview.superview.superview);
        UIImage  *image=[Function getImage:cell.stageView WithSize:CGSizeMake(kDeviceWidth, kDeviceWidth)];
        //创建UMshareView 后必须配备这三个方法
       UMShareViewController  *shareVC=[[UMShareViewController alloc]init];
       shareVC.StageInfo=addmodel.weiboInfo.stageInfo;
        shareVC.screenImage=image;
        shareVC.delegate=self;
        UINavigationController  *na =[[UINavigationController alloc]initWithRootViewController:shareVC];
        [self presentViewController:na animated:YES completion:nil];
        

    }
    else if(button.tag==3000)
    {
        //添加弹幕
        AddMarkViewController  *AddMarkVC=[[AddMarkViewController alloc]init];
        AddMarkVC.stageInfo=addmodel.weiboInfo.stageInfo;
        //AddMarkVC.pageSoureType=NSAddMarkPageSourceDefault;
        NSLog(@"dict.stageinfo = %@", AddMarkVC.stageInfo);
//        UINavigationController  *na =[[UINavigationController alloc]initWithRootViewController:AddMarkVC];
//        [self.navigationController pushViewController:na animated:NO];
        UINavigationController  *na =[[UINavigationController alloc]initWithRootViewController:AddMarkVC];
        [self.navigationController presentViewController:na animated:NO completion:nil];

    }
    else if(button.tag==4000)
    {
     //个人头像
    }
    else if(button.tag==6000)
    {
        //删除
        if ([self.author_id intValue]==0||[self.author_id intValue]==[userCenter.user_id intValue]) {
            UIActionSheet   *ash=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除弹幕" otherButtonTitles:nil, nil];
            ash.tag=200;
            [ash showInView:self.view];
        }
        else
        {
            //点击了更多
            UIActionSheet  *Act=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"内容投诉",@"版权投诉",@"查看图片信息", nil];
            Act.tag=507;
            [Act showInView:Act];
        }

        
    }
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    NSLog(@" button Index ===%ld",(long)buttonIndex);
    if (actionSheet.tag==200) {
        if (buttonIndex==0) {
            UIActionSheet   *ash=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil, nil];
            ash.tag=300;
            [ash showInView:self.view];
        }
    }
    else if (actionSheet.tag==507) {
        //点击了更多
        if (buttonIndex==0) {
            //举报剧情
            [self requestReportSatge];
            
            
        }
        else if(buttonIndex==1)
        {
            //版权问题
            //[self sendFeedBack];
            
            stageInfoModel  *stageInfo;
            for (int i=100; i<102;i++ ) {
                UIButton  *btn =(UIButton *)[self.view viewWithTag:i];
                if (btn.tag==100&&btn.selected==YES) {
                    userAddmodel   *model =[_addedDataArray objectAtIndex:Rowindex];
                    stageInfo=model.weiboInfo.stageInfo;
                    
                }
                else if (btn.tag==101&&btn.selected==YES)
                {
                    userAddmodel   *model =[_addedDataArray objectAtIndex:Rowindex];
                    stageInfo=model.weiboInfo.stageInfo;
                    
                }
            }
            //版权问题
            [self sendFeedBackWithStageInfo: stageInfo];

        }
        else if(buttonIndex==2)
        {
            //           查看图片信息
            
            // 查看图片信息
            ScanMovieInfoViewController * scanvc =[ScanMovieInfoViewController new];
            for (int i=100; i<102;i++ ) {
                UIButton  *btn =(UIButton *)[self.view viewWithTag:i];
                if (btn.tag==100&&btn.selected==YES) {
                    userAddmodel   *model =[_addedDataArray objectAtIndex:Rowindex];
                    scanvc.stageInfo=model.weiboInfo.stageInfo;

                }
                else if (btn.tag==101&&btn.selected==YES)
                {
                    userAddmodel   *model =[_addedDataArray objectAtIndex:Rowindex];
                    scanvc.stageInfo=model.weiboInfo.stageInfo;

                 }
            }
            
            [self presentViewController:scanvc animated:YES completion:nil];
        }

        
        
    }
    else
    {
        if (buttonIndex==0) {
//            [_addedDataArray removeObjectAtIndex:Rowindex];
            if (productCount>=1) {
              productCount=productCount-1;
            }
            lblCount.text=[NSString stringWithFormat:@"%d",productCount];
           // [_tableView reloadData];
            [self requestDelectDatawithRowindex:Rowindex];
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

#pragma mark   ---
#pragma mark   ----stageViewDelegate   -----------
#pragma mark    ---
-(void)StageViewHandClickMark:(weiboInfoModel *)weiboDict withmarkView:(id)markView StageInfoDict:(stageInfoModel *)stageInfoDict
{
    ///执行buttonview 弹出
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
-(void)SetToolBarValueWithDict:(weiboInfoModel  *)weiboDict markView:(id) markView isSelect:(BOOL ) isselect StageInfo:(stageInfoModel *) stageInfo
{
    //先对它赋值，然后让他弹出到界面
    if (isselect==YES) {
        _toolBar.alertView.frame=CGRectMake(15,0,kStageWidth-20, 100);
        _toolBar.weiboInfo=weiboDict;
        _toolBar.stageInfo=stageInfo;
        _toolBar.markView=markView;
        [_toolBar configToolBar];
        
        //把工具栏添加到当前视图
        self.tabBarController.tabBar.hidden=NO;
        [AppView addSubview:_toolBar];
        //[self.view addSubview:_toolBar];
        //弹出工具栏
        [_toolBar ShowButtomView];
        
    }
    else if (isselect==NO)
    {
        //隐藏toolbar
        NSLog(@" 执行了隐藏工具栏的方法");
        self.tabBarController.tabBar.hidden=NO;
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
-(void)ToolViewHandClick:(UIButton *)button :(MarkView *)markView weiboDict:(weiboInfoModel *)weiboDict StageInfo:(stageInfoModel *)stageInfoDict
{
    //把值全局化，有利于下面进行一系列的删除变身操作
    _TStageInfo=stageInfoDict;
    _TweiboInfo=weiboDict;
    
    if (button.tag==10000) {
        ///点击了头像//进入个人页面
        NSLog(@"点击头像  微博dict  ＝====%@ ======出现的stageinfo  ＝＝＝＝＝＝%@",weiboDict,stageInfoDict);
        
    }
#pragma mark     -----------分享
    else if (button.tag==10001)
    {
        //点击了分享
        
//         float hight= kDeviceWidth;
//        CommonStageCell *cell = (CommonStageCell *)(markView.superview.superview.superview.superview);
//        UIImage  *image=[Function getImage:cell.stageView WithSize:CGSizeMake(kDeviceWidth, hight)];
//        //创建UMshareView 后必须配备这三个方法
//        
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
        //改变赞的状态
//        //点击了赞
//        NSLog(@" 点赞 前 微博dict  ＝====uped====%@    ups===%@",weiboDict.uped,weiboDict.ups);
//        if ([weiboDict.uped intValue]==0)
//        {
//            weiboDict.uped=[NSNumber numberWithInt:1];
//            int ups=[weiboDict.ups intValue];
//            ups =ups+[weiboDict.uped intValue];
//            weiboDict.ups=[NSNumber numberWithInt:ups];
//            //重新给markview 赋值，改变markview的frame
//            [self layoutMarkViewWithMarkView:markView WeiboInfo:weiboDict];
//            
//        }
//        else  {
//            
//            weiboDict.uped=[NSNumber numberWithInt:0];
//            int ups=[weiboDict.ups intValue];
//            ups =ups-1;
//            weiboDict.ups=[NSNumber numberWithInt:ups];
//            [self layoutMarkViewWithMarkView:markView WeiboInfo:weiboDict];
//        }
//        
//        ////发送到服务器
//        [self LikeRequstData:weiboDict StageInfo:stageInfoDict];
        
        
        
        
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


//重新布局markview
-(void)layoutMarkViewWithMarkView:(MarkView  *) markView WeiboInfo:(WeiboModel *) weibodict
{
    
    
    NSLog(@" 点赞 后 微博dict  ＝====uped====%@    ups===%@",weibodict.uped,weibodict.ups);
        [Function BasicAnimationwithkey:@"transform.scale" Duration:0.25 repeatcont:1 autoresverses:YES fromValue:1.0 toValue:1.05 View:markView];
    NSString  *weiboTitleString=weibodict.topic;
    NSString  *UpString=[NSString stringWithFormat:@"%@",weibodict.ups];//weibodict.ups;
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
    markView.frame=CGRectMake(markView.frame.origin.x,markView.frame.origin.y, markViewWidth, markViewHeight);
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
-(void)dealloc
{
      [[NSNotificationCenter defaultCenter]removeObserver:self name:@"initUser" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshTableView" object:nil];
 

}



/*-(void)StageViewHandClickMark:(NSDictionary *)weiboDict withStageView:(id)stageView
{
    NSLog(@"点击了一个标签，标签的内容为   =====%@",weiboDict);
}*/
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
