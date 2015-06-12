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
#import "UMShareView.h"
#import "ShowStageViewController.h"
#import "SmallImageCollectionViewCell.h"
#import "UserHeaderReusableView.h"
static const CGFloat MJDuration = 1.0;

#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
@interface MyViewController ()<StageViewDelegate,StageViewDelegate,ButtomToolViewDelegate,UIActionSheetDelegate,UMSocialDataDelegate,UMSocialUIDelegate,CommonStageCellDelegate,UMShareViewControllerDelegate,UMShareViewController2Delegate,UMShareViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UserHeaderReusableViewDelegate>
{
  
    UICollectionViewFlowLayout    *layout;
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
    //NSMutableDictionary  *buttonStateDict;
    NSMutableDictionary  *IsNullStateDict; //纪录添加还是赞的数据为空
   // HotMovieModel  *_Tmodel;  ///用户删除的时候存储的model
    NSInteger  Rowindex;
    weiboUserInfoModel  *userInfomodel;
    stageInfoModel  *_TStageInfo;
    weiboInfoModel      *_TweiboInfo;
    BOOL  isShowMark;
    NSMutableArray  *_addWeiboArray ;
    NSMutableArray   *_upWeiboArray;

}
@end
@implementation MyViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
 }
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor =[UIColor whiteColor];
     [self createNavigation];
     [self initData];
     [self requestUserInfo];
     [self requestData];
    [self createLoadview];
    
}
-(void)initData{
    page1=1;
    page2=1;
    pageSize=20;
    pageCount1=1;
    pageCount2=1;
    isShowMark=YES;
     userCenter  = [UserDataCenter shareInstance];
    _addedDataArray = [[NSMutableArray alloc] init];
    _upedDataArray = [[NSMutableArray alloc] init];
    
    _addWeiboArray =  [[NSMutableArray alloc]init];
    _upWeiboArray =[[NSMutableArray alloc]init];
    self.buttonStateDict=[[NSMutableDictionary alloc]init];
    //默认第一个选择状态
    [self.buttonStateDict setValue:@"100" forKey:@"YES"];
    
    //纪录那个数据为空
    IsNullStateDict =[[NSMutableDictionary  alloc]init];
    [IsNullStateDict setValue:@"NO" forKey:@"ONE"];
    [IsNullStateDict setValue:@"NO" forKey:@"TWO"];
    userInfomodel=[[weiboUserInfoModel alloc]init];
   
}
#pragma mark - CreateUI
-(void)createNavigation
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"tabbar_backgroud_color.png"] forBarMetrics:UIBarMetricsDefault];
    NSString  *titleString=@"我的";
    if (self.author_id&&![self.author_id isEqualToString:@"0"]) {
         titleString=@"他的主页";
    }
    UILabel  *titleLable=[ZCControl createLabelWithFrame:CGRectMake(0, 0, 100, 20) Font:16 Text:titleString];
    titleLable.textColor=VGray_color;
    titleLable.font=[UIFont boldSystemFontOfSize:16];
    titleLable.textAlignment=NSTextAlignmentCenter;
    self.navigationItem.titleView=titleLable;
    
    UIButton  *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"设置" forState:UIControlStateNormal];
    ///[button setBackgroundImage:[UIImage imageNamed:@"setting.png"] forState:UIControlStateNormal];
    button.frame=CGRectMake(0, 0, 40, 30);
    button.titleLabel.font =[UIFont systemFontOfSize:16];
    button.titleEdgeInsets=UIEdgeInsetsMake(0, 10, 0, -10);
    [button setTitleColor:VGray_color forState:UIControlStateNormal];
    [button addTarget:self action:@selector(GotoSettingClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem  *barButton=[[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem=barButton;
    if (self.author_id&&![self.author_id isEqualToString:@"0"]) {
        //如果有用户id 并且用户的id 不为0
        self.navigationItem.rightBarButtonItem=nil;
        self.navigationItem.titleView=nil;
    }

}

-(void)createCollectionView
{
    
    layout=[[UICollectionViewFlowLayout alloc]init];

    //layout.minimumInteritemSpacing=10; //cell之间左右的
    //layout.minimumLineSpacing=10;      //cell上下间隔
    //layout.itemSize=CGSizeMake(80,140);  //cell的大小
     layout.sectionInset=UIEdgeInsetsMake(0,0,64, 0); //整个偏移量 上左下右
    
    _myConllectionView.backgroundColor =[UIColor clearColor];
     _myConllectionView =[[UICollectionView alloc]initWithFrame:CGRectMake(0,0,kDeviceWidth, kDeviceHeight-0-0-100) collectionViewLayout:layout];
    if (self.author_id&&![self.author_id isEqualToString:@"0"]) {
        //如果有用户id 并且用户的id 不为0
        _myConllectionView.frame=CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-60);
     }
    [layout setHeaderReferenceSize:CGSizeMake(_myConllectionView.frame.size.width,160)];
    _myConllectionView.backgroundColor=[UIColor whiteColor];
    //注册大图模式
     //注册小图模式
    [_myConllectionView registerClass:[SmallImageCollectionViewCell class] forCellWithReuseIdentifier:@"smallcell"];
    // 注册头部视图
    [_myConllectionView registerClass:[UserHeaderReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView"];
    _myConllectionView.delegate=self;
    _myConllectionView.dataSource=self;
    [self.view addSubview:_myConllectionView];
    //[self setupHeadView];
    //[self setupFootView];
    [self setupRefreshView];
}


- (void)setupRefreshView
{
    __weak typeof(self) weakSelf = self;
    // 下拉刷新
    [self.myConllectionView addLegendHeaderWithRefreshingBlock:^{
        // 增加5条假数据
//        for (int i = 0; i<10; i++) {
//            [weakSelf.colors insertObject:MJRandomColor atIndex:0];
//        }
        NSString *Btag =[weakSelf.buttonStateDict objectForKey:@"YES"];
        if ([Btag isEqualToString:@"100"]) {
            if (weakSelf.addedDataArray.count>0) {
                [weakSelf.addedDataArray removeAllObjects];
            }
            page1=1;
            [weakSelf requestData];
        }
        else if ([Btag isEqualToString:@"101"])
        {
            if (weakSelf.upedDataArray.count>0) {
                [weakSelf.upedDataArray removeAllObjects];
            }
            page2=1;
            [weakSelf requestData];
        }
        // 设置文字
        [weakSelf.myConllectionView.header setTitle:@"下拉刷新..." forState:MJRefreshHeaderStateIdle];
        [weakSelf.myConllectionView.header setTitle:@"释放刷新..." forState:MJRefreshHeaderStatePulling];
        [weakSelf.myConllectionView.header setTitle:@"正在刷新..." forState:MJRefreshHeaderStateRefreshing];
        //隐藏时间
        weakSelf.myConllectionView.header.updatedTimeHidden=YES;
        
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.myConllectionView reloadData];
            
            // 结束刷新
            [weakSelf.myConllectionView.header endRefreshing];
        });
    }];
   [self.myConllectionView.header beginRefreshing];
    
    // 上拉刷新
    [self.myConllectionView addLegendFooterWithRefreshingBlock:^{
        // 增加5条假数据
//        for (int i = 0; i<5; i++) {
//            [weakSelf.colors addObject:MJRandomColor];
//        }
        NSString *Btag =[weakSelf.buttonStateDict objectForKey:@"YES"];
        if ([Btag isEqualToString:@"100"]) {
            if (pageCount1>page1) {
                page1=page1+1;
                [weakSelf requestData];
            }
            else
            {
                [weakSelf.myConllectionView.footer noticeNoMoreData];
            }
        }
        else if ([Btag isEqualToString:@"101"])
        {
            if (pageCount2>page2) {
                page2=page2+1;
                [weakSelf requestData];
            }
            else
            {
                [weakSelf.myConllectionView.footer noticeNoMoreData];
            }
        }
        // 设置文字
        [weakSelf.myConllectionView.footer setTitle:@"点击加载更多..." forState:MJRefreshFooterStateIdle];
        [weakSelf.myConllectionView.footer setTitle:@"加载更多..." forState:MJRefreshFooterStateRefreshing];
        [weakSelf.myConllectionView.footer setTitle:@"THE END" forState:MJRefreshFooterStateNoMoreData];
        
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.myConllectionView reloadData];
            
            // 结束刷新
            [weakSelf.myConllectionView.footer endRefreshing];
        });
    }];
    // 默认先隐藏footer
    //self.myConllectionView.footer.hidden = YES;
}
/*

-(void)setupHeadView
{
    __unsafe_unretained typeof(self) vc = self;
    [self.myConllectionView.footer setTitle:@"下拉刷新" forState:MJRefreshFooterStateIdle];
    [self.myConllectionView.footer setTitle:@"加载更多" forState:MJRefreshFooterStateRefreshing];
    //[self.myConllectionView.footer setTitle:@"没有更多数据" forState:MJRefreshFooterStateNoMoreData];
    
    // 添加下拉刷新头部控件
    [_myConllectionView addHeaderWithCallback:^{
         NSString *Btag =[vc.buttonStateDict objectForKey:@"YES"];
             if ([Btag isEqualToString:@"100"]) {
                 
                if (vc.addedDataArray.count>0) {
                    [vc.addedDataArray removeAllObjects];
                }
                page1=1;
                [vc requestData];
                
            }
            else if ([Btag isEqualToString:@"101"])
            {
                if (vc.upedDataArray.count>0) {
                    [vc.upedDataArray removeAllObjects];
                }
                page2=1;
                [vc requestData];
            }
        // 模拟延迟加载数据，因此2秒后才调用）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //[vc.myConllectionView reloadData];
            // 结束刷新
            [vc.myConllectionView headerEndRefreshing];
        });
    }];
}

- (void)setupFootView
{
    __unsafe_unretained typeof(self) vc = self;
    // 添加上拉刷新尾部控件
    [vc.myConllectionView addFooterWithCallback:^{
        NSString *Btag =[vc.buttonStateDict objectForKey:@"YES"];
        if ([Btag isEqualToString:@"100"]) {
            if (pageCount1>page1) {
                page1=page1+1;
                [self requestData];
            }
        }
        else if ([Btag isEqualToString:@"101"])
        {
            if (pageCount2>page2) {
                page2=page2+1;
                [self requestData];
            }
        }
        // 进入刷新状态就会回调这个Block
               // 模拟延迟加载数据，因此2秒后才调用）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //  [vc.myConllectionView reloadData];
            // 结束刷新
            [vc.myConllectionView footerEndRefreshing];
        });
    }];
}*/

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
            [self.buttonStateDict setValue:@"YES" forKey:@"100"];
            //把赞设置为选择状态
            UIButton  *btn =(UIButton *)[self.view viewWithTag:101];
            btn.selected=NO;
            [self.buttonStateDict setValue:@"NO" forKey:@"101"];
            [self.myConllectionView reloadData];
            if (_addedDataArray.count==0) {
                [self requestData];
            }
            if ( [[IsNullStateDict objectForKey:@"ONE"] isEqualToString:@"YES"]) {
                [self.myConllectionView addSubview:loadView];
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
         
          [self.buttonStateDict setValue:@"YES" forKey:@"101"];
         //把赞设置为选择状态
           [self.buttonStateDict setValue:@"NO" forKey:@"100"];
          ///btn.selected=NO;
          [self.myConllectionView reloadData];
           if (_upedDataArray.count==0) {
            [self requestData];
           }
          if ( [[IsNullStateDict objectForKey:@"TWO"] isEqualToString:@"YES"]) {
                [self.myConllectionView addSubview:loadView];
            }
            else
            {
                [loadView removeFromSuperview];
            }

        }
    }
    
   // NSLog(@"buttonStateDict=======%@",buttonStateDict);
}
- (void)createLoadview
{
    loadView =[[LoadingView alloc]initWithFrame:CGRectMake(0, 200, kDeviceWidth, kDeviceHeight-kHeightNavigation-200)];
    [self.view addSubview:loadView];
}

////创建底部的视图
//-(void)createToolBar
//
//{
//    _toolBar=[[ButtomToolView alloc]initWithFrame:CGRectMake(0,0,kDeviceWidth,kDeviceHeight)];
//    _toolBar.delegete=self;
//    
//}


#pragma  mark -----
#pragma  mark ------  DataRequest 
#pragma  mark ----
//举报剧情
//-(void)requestReportweibo
//{
//     NSDictionary *parameters = @{@"reported_user_id":_TweiboInfo.uerInfo.Id,@"weibo_id":_TweiboInfo.Id,@"reason":@"",@"user_id":userCenter.user_id};
//    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    [manager POST:[NSString stringWithFormat:@"%@/report-weibo/create", kApiBaseUrl] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        if ([[responseObject  objectForKey:@"code"]  intValue]==0) {
//            NSLog(@"随机数种子请求成功=======%@",responseObject);
//            UIAlertView  *Al =[[UIAlertView alloc]initWithTitle:nil message:@"你的举报已成功,我们会在24小时内处理" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [Al show];
//            
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//    }];
//    
//}



//举报剧情
//-(void)requestReportSatge
//{
//    // NSString *type=@"1";
//    NSString  *stageId=@"";
//    NSString  *author_id=@"";
//    for (int i=100; i<102;i++ ) {
//        UIButton  *btn =(UIButton *)[self.view viewWithTag:i];
//        if (btn.tag==100&&btn.selected==YES) {
//            userAddmodel *model =[_addedDataArray objectAtIndex:Rowindex];
//            stageId=[NSString stringWithFormat:@"%@",model.weiboInfo.stageInfo.Id];
//            author_id=model.weiboInfo.stageInfo.created_by;
//
//        }
//        else if (btn.tag==101&&btn.selected==YES)
//        {
//         
//            userAddmodel *model =[_upedDataArray objectAtIndex:Rowindex];
//            stageId=[NSString stringWithFormat:@"%@",model.weiboInfo.stageInfo.Id];
//            author_id=model.weiboInfo.stageInfo.created_by;
//
//        }
//    }
//    
//    NSDictionary *parameters = @{@"reported_user_id":author_id,@"stage_id":stageId,@"reason":@"",@"user_id":userCenter.user_id};
//    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    [manager POST:[NSString stringWithFormat:@"%@/report-stage/create", kApiBaseUrl] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        if ([[responseObject  objectForKey:@"code"]  intValue]==0) {
//            NSLog(@"随机数种子请求成功=======%@",responseObject);
//            UIAlertView  *Al =[[UIAlertView alloc]initWithTitle:nil message:@"你的举报已成功,我们会在24小时内处理" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [Al show];
//            
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//    }];
//    
//}
//
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
            
            
            [userInfomodel setValuesForKeysWithDictionary:[responseObject objectForKey:@"model"]];
            if (!userInfomodel.logo) {
                userInfomodel.logo =userCenter.logo;
            }
          
            [self createCollectionView];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}
- (void)requestData{
    
    NSString  *autorid;
    UserDataCenter  *user=[UserDataCenter shareInstance];
    if (self.author_id>0&&![self.author_id isEqualToString:@"0"]) {
        autorid=self.author_id;
    }
    else
    {
        autorid=user.user_id;
    }
    //user_id是当前用户的ID
    NSDictionary *parameters = @{@"user_id":user.user_id,@"author_id":autorid};
    NSString * section;
    int  page;
    if ([[self.buttonStateDict objectForKey:@"YES"] isEqualToString:@"100"]) {
        section= @"user-create-weibo/list";
        page=page1;
    }
    else if([[self.buttonStateDict objectForKey:@"YES"] isEqualToString:@"101"])
    {
        section=@"user-up-weibo/list";
        page=page2;

    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
     NSString *urlString =[NSString stringWithFormat:@"%@/%@?per-page=%d&page=%d", kApiBaseUrl, section,pageSize,page];
    
    NSLog(@"=======urlstring ==%@",urlString);
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"code"] intValue]==0) {
            NSLog(@"个人页面返回的数据====%@",responseObject);
             NSMutableArray  *Detailarray=[responseObject objectForKey:@"models"];
             NSString  *Btag = [self.buttonStateDict objectForKey:@"YES"];
            if ([Btag isEqualToString:@"100"]) {
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
          // 添加的点赞的数组
            for (NSDictionary  *updict in [responseObject objectForKey:@"upweibos"]) {
                UpweiboModel *upmodel =[[UpweiboModel alloc]init];
                if (upmodel) {
                    [upmodel setValuesForKeysWithDictionary:updict];
                    if (_addWeiboArray==nil) {
                        _addWeiboArray =[[NSMutableArray alloc]init];
                    }
                    [_addWeiboArray addObject:upmodel];
                    }
            }

            if (_addedDataArray.count==0) {
                [IsNullStateDict setValue:@"YES" forKey:@"ONE"];
                [self.myConllectionView addSubview:loadView];
                [loadView showNullView:@"没有数据"];
            }
            else
            {
                [IsNullStateDict setValue:@"NO" forKey:@"ONE"];
                [loadView stopAnimation];
                [loadView removeFromSuperview];
                [self.myConllectionView reloadData];
            }
            [self.myConllectionView reloadData];
        }
        else if([Btag isEqualToString:@"101"])
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

            // 添加的点赞的数组
            for (NSDictionary  *updict in [responseObject objectForKey:@"upweibos"]) {
                UpweiboModel *upmodel =[[UpweiboModel alloc]init];
                if (upmodel) {
                    [upmodel setValuesForKeysWithDictionary:updict];
                    if (_upWeiboArray==nil) {
                        _upWeiboArray =[[NSMutableArray alloc]init];
                    }
                    [_upWeiboArray addObject:upmodel];
                }
            }

            if (_upedDataArray.count==0) {
                  [IsNullStateDict setValue:@"YES" forKey:@"TWO"];
                [self.myConllectionView addSubview:loadView];
                [loadView showNullView:@"没有数据"];
            }
            else
            {
                [IsNullStateDict setValue:@"NO" forKey:@"TWO"];
                [loadView stopAnimation];
                [loadView removeFromSuperview];
                [self.myConllectionView reloadData];
                
            }
            [self.myConllectionView reloadData];
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
            [self.myConllectionView reloadData];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}
#pragma  mark
#pragma mark - UICollectionViewDataSource ----

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
   
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
 
    NSString  *Btag = [self.buttonStateDict objectForKey:@"YES"];
    if ([Btag isEqualToString:@"100"]) {
        return  self.addedDataArray.count;
    }
    else if ([Btag isEqualToString:@"101"])
    {
        return self.upedDataArray.count;
    }
    return 0;
 }

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SmallImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"smallcell" forIndexPath:indexPath];
    NSString  *Btag = [self.buttonStateDict objectForKey:@"YES"];
        if ([Btag isEqualToString:@"100"]) {
            if (_addedDataArray.count>indexPath.row) {
            userAddmodel  *model =[_addedDataArray objectAtIndex:indexPath.row];
             NSURL  *url =[NSURL URLWithString:[NSString stringWithFormat:@"%@%@!w340h340",kUrlStage,model.weiboInfo.stageInfo.photo]];
                
            [cell.imageView sd_setImageWithURL:url placeholderImage:nil options:(SDWebImageRetryFailed|SDWebImageLowPriority)];
            cell.titleLab.text=model.weiboInfo.content;
            }
        }
        else if ([Btag isEqualToString:@"101"])
        {
            if (_upedDataArray.count > indexPath.row) {
            userAddmodel  *model =[_upedDataArray objectAtIndex:indexPath.row];
             NSURL  *url =[NSURL URLWithString:[NSString stringWithFormat:@"%@%@!w340h340",kUrlStage,model.weiboInfo.stageInfo.photo]];
            [cell.imageView sd_setImageWithURL:url placeholderImage:nil options:(SDWebImageRetryFailed|SDWebImageLowPriority)];
            cell.titleLab.text=model.weiboInfo.content;
            }
            
        }

    return cell;
}
//点击小图模式的时候，跳转到大图模式
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString  *Btag =[self.buttonStateDict objectForKey:@"YES"];
    if ([Btag isEqualToString:@"100"]) {
        
        ShowStageViewController *vc = [[ShowStageViewController alloc] init];
        userAddmodel *model=[_addedDataArray objectAtIndex:indexPath.row];
        vc.upweiboArray=_addWeiboArray;
        vc.stageInfo = model.weiboInfo.stageInfo;
        vc.weiboInfo=model.weiboInfo;
        vc.pageType=NSStagePapeTypeMyAdd;//用户添加的
        if (self.pageType==NSMyPageTypeOthersController) {
            vc.pageType=NSStagePapeTypeOthersAdd;
        }
        UIBarButtonItem  *item =[[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        self.navigationItem.backBarButtonItem=item;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    else if ([Btag isEqualToString:@"101"])
    {
        ShowStageViewController *vc = [[ShowStageViewController alloc] init];
        userAddmodel *model=[_upedDataArray objectAtIndex:indexPath.row];
       vc.upweiboArray=_upWeiboArray;
        vc.weiboInfo=model.weiboInfo;
        vc.stageInfo =model.weiboInfo.stageInfo;
        UIBarButtonItem  *item =[[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        self.navigationItem.backBarButtonItem=item;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

//设置头尾部内容
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
 {
     UICollectionReusableView *reusableView = nil;
     if (kind == UICollectionElementKindSectionHeader) {
    //定制头部视图的内容
     UserHeaderReusableView *headerV = (UserHeaderReusableView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView" forIndexPath:indexPath];
      headerV.delegate=self;
         
     [headerV setcollectionHeaderViewValueWithUserInfo:userInfomodel];
      reusableView = headerV;
  }
 return reusableView;
}

 -(void)changeCollectionHandClick:(UIButton *)btn
{
    
    if(btn.tag==100)
    {
        NSLog(@"点击了第一个按钮");
        if (btn.selected==NO) {
            //已经选择的情况下，点击这个没有反应
        }
        else if(btn.selected==YES)
        {
            [self.buttonStateDict setObject:@"100" forKey:@"YES"];
            

            if (_addedDataArray.count==0) {
                [self requestData];
            }
            [self.myConllectionView reloadData];
            if ( [[IsNullStateDict objectForKey:@"ONE"] isEqualToString:@"YES"]) {
                [self.myConllectionView addSubview:loadView];
            }
            else
            {
                [loadView removeFromSuperview];
            }
        }
    }
    else if(btn.tag==101)
    {
        NSLog(@"点击了第er个按钮");
        
        if (btn.selected==NO) {
            
        }
        else if(btn.selected==YES)
        {
            [self.buttonStateDict setObject:@"101" forKey:@"YES"];
            
   
            if (_upedDataArray.count==0) {
                [self requestData];
            }
            [self.myConllectionView reloadData];
            if ( [[IsNullStateDict objectForKey:@"TWO"] isEqualToString:@"YES"]) {
                [self.myConllectionView addSubview:loadView];
            }
            else
            {
                [loadView removeFromSuperview];
            }
        }
    }
}
#pragma  mark ----
#pragma  mark -----UICollectionViewLayoutDelegate
#pragma  mark ----

// 设置每个item的尺寸
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((kDeviceWidth-5)/2,(kDeviceWidth-10)/3);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
     return UIEdgeInsetsMake(0,0, 5,0);
}
//左右间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
//上下
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
     return 5;
}



//设置页面
-(void)GotoSettingClick:(UIButton  *) button
{
    UIBarButtonItem  *item =[[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem=item;
    [self.navigationController pushViewController:[SettingViewController new] animated:YES];
}

#pragma  mark  =====ButtonClick
#pragma  mark  -----UMButtomViewshareViewDlegate-------
/*-(void)UMShareViewControllerHandClick:(UIButton *)button ShareImage:(UIImage *)shareImage StageInfoModel:(stageInfoModel *)StageInfo
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
-(void)UMShareViewHandClick:(UIButton *)button ShareImage:(UIImage *)shareImage StageInfoModel:(stageInfoModel *)StageInfo
{
    NSArray  *sharearray =[NSArray arrayWithObjects:UMShareToWechatTimeline,UMShareToWechatSession, UMShareToSina, nil];
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
        UIBarButtonItem  *item =[[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        self.navigationItem.backBarButtonItem=item;
        [self.navigationController pushViewController:vc animated:YES];

    }
    else if(button.tag==2000)
    {
        //分享
        CommonStageCell *cell = (CommonStageCell *)(button.superview.superview.superview.superview);
        UIImage  *image=[Function getImage:cell.stageView WithSize:CGSizeMake(kStageWidth, kStageWidth)];
        if (UMShareStyle==1) {
        //创建UMshareView 后必须配备这三个方法
       UMShareViewController  *shareVC=[[UMShareViewController alloc]init];
       shareVC.StageInfo=addmodel.weiboInfo.stageInfo;
        shareVC.screenImage=image;
        shareVC.delegate=self;
        UINavigationController  *na =[[UINavigationController alloc]initWithRootViewController:shareVC];
        [self presentViewController:na animated:YES completion:nil];
        }
        else if (UMShareStyle==0)//使用view方式分享
        {
            UMShareView *ShareView =[[UMShareView alloc] initwithStageInfo:addmodel.weiboInfo.stageInfo ScreenImage:image delgate:self];
            [ShareView show];
        }
        
        

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
          //  [self sendFeedBackWithStageInfo: stageInfo];

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
*/
/*- (void)sendFeedBackWithStageInfo:(stageInfoModel *)stageInfo
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
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];/*MFMailComposeViewController邮件发送选择器
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
    
    //[self presentViewController:picker animated:YES completion:nil];
    //        [self.navigationController presentViewController:picker animated:YES completion:nil];
    //        [self.navigationController pushViewController:picker animated:YES];
//}
/*
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
*/
#pragma mark   ---
#pragma mark   ----stageViewDelegate   -----------
#pragma mark    ---
/*-(void)StageViewHandClickMark:(weiboInfoModel *)weiboDict withmarkView:(id)markView StageInfoDict:(stageInfoModel *)stageInfoDict
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
    
}*/


//重新布局markview
/*-(void)layoutMarkViewWithMarkView:(MarkView  *) markView WeiboInfo:(WeiboModel *) weibodict
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
    
}*/
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
