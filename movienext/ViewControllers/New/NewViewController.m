//
//  NewViewController.m
//  movienext
//
//  Created by 风之翼 on 15/2/27.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "NewViewController.h"
#import "AppDelegate.h"
#import "Constant.h"
#import "UserDataCenter.h"
#import "LoadingView.h"
#import "UserDataCenter.h"
#import "ZCControl.h"
#import "MJRefresh.h"
#import "AFNetworking.h"
#import "CommonStageCell.h"
#import "AddMarkViewController.h"
#import "MovieDetailViewController.h"
#import "MyViewController.h"
#import "ModelsModel.h"
#import "stageInfoModel.h"
#import "movieInfoModel.h"
#import "weiboInfoModel.h"
#import "weiboUserInfoModel.h"
#import "UpweiboModel.h"
#import "UserDataCenter.h"
#import "Function.h"
#import "UMSocial.h"
#import "NSDate+Additions.h"
//#import "UMShareView.h"
#import "UMSocialControllerService.h"
#import "UIImageView+WebCache.h"
#import "UMShareViewController.h"
#import "UMShareViewController2.h"
#import "UIImage+ImageWithColor.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "ScanMovieInfoViewController.h"
#import "netRequest.h"
#import "MobClick.h"
#import "TagModel.h"
#import "TagToStageViewController.h"

//友盟分享
//#import "UMSocial.h"
@interface NewViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,StageViewDelegate,ButtomToolViewDelegate,UIScrollViewDelegate,UMSocialDataDelegate,UMSocialUIDelegate,LoadingViewDelegate,UIActionSheetDelegate,CommonStageCellDelegate,AddMarkViewControllerDelegate,UMShareViewControllerDelegate,UMShareViewController2Delegate,MFMailComposeViewControllerDelegate>
{
    AppDelegate  *appdelegate;
    UISegmentedControl *segment;
    UITableView   *_HotMoVieTableView;
    LoadingView   *loadView;
    NSMutableArray    *_hotDataArray;
    NSMutableArray    *_newDataArray;
    int page1;
    int page2;
    
    int pagesize;
    int pageCount1;
    int pageCount2;
    BOOL  isShowMark;
    
    ButtomToolView *_toolBar;
    MarkView       *_mymarkView;
     UIImageView   *ShareimageView;
   // UMShareView   *shareView;
    stageInfoModel  *_TStageInfo;
    weiboInfoModel      *_TweiboInfo;
    //用于移除推荐使用
    NSString        *_hot_Id;
    ///屏蔽剧照使用
    NSNumber        *_stage_Id;
    NSMutableArray  *_upWeiboArray;
    NSInteger Rowindex;
}
@end

@implementation NewViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"最新热门"];
    
    self.navigationController.navigationBar.hidden=NO;
  self.navigationController.navigationBar.alpha=1;
//    self.navigationController.navigationBar.translucent=NO;
//
    self.tabBarController.tabBar.hidden=NO;
    //if (_HotMoVieTableView) {
      //  [self setupRefresh];
    //}
    //修改tabbar 的黑色线的颜色
    NSArray  *tabArray=self.tabBarController.tabBar.subviews;
    for ( id obj  in tabArray) {
        if ([obj isKindOfClass:[UIImageView class]]) {
            UIImageView *imageView=(UIImageView *) obj;
            imageView.backgroundColor=tabBar_line;
        }
    }
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"最新热门"];
}

//遇到上面的问题 最直接的解决方法就是在controller的viewDidAppear里面去调用present。这样可以确保view hierarchy的层次结构不乱。

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    appdelegate =(AppDelegate *)[[UIApplication sharedApplication]delegate ];
    UserDataCenter  *userInfo=  [UserDataCenter shareInstance];
    NSLog(@"-------登陆成功  user=======%@ ",  userInfo.username);
    [self creatNavigation];
    [self initData];
    [self createHotView];
    [self setupRefresh];
    [self creatLoadView];
    //  [self requestData];
    [self createToolBar];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableView) name:@"RefeshTableview" object:nil];
    
    
}
-(void)initData{
    _hotDataArray = [[NSMutableArray alloc]init];
    _newDataArray=[[NSMutableArray alloc]init];
    _upWeiboArray=[[NSMutableArray alloc]init];
    page1=1;
    page2=1;
    pagesize=10;
    pageCount1=1;
    pageCount2=1;
    isShowMark=YES;
 }
#pragma  mark   ------
#pragma  mark  -------CreatUI;
-(void)creatNavigation
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"tabbar_backgroud_color.png"] forBarMetrics:UIBarMetricsDefault];
    NSArray *segmentedArray = [[NSArray alloc] initWithObjects:@"热门", @"最新", nil];
    segment = [[UISegmentedControl alloc] initWithItems:segmentedArray];
    segment.frame = CGRectMake(kDeviceWidth/4, 0, kDeviceWidth/2, 28);
    segment.selectedSegmentIndex = 0;
    segment.backgroundColor = [UIColor clearColor];
    segment.tintColor = kAppTintColor;
    
    NSDictionary* selectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:14]
                                             };
    [segment setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];
    NSDictionary* unselectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:14]
                                               };
    [segment setTitleTextAttributes:unselectedTextAttributes forState:UIControlStateNormal];
    
    [segment addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventValueChanged];
    [self.navigationItem setTitleView:segment];
    
//    
//    UIButton  *button=[UIButton buttonWithType:UIButtonTypeCustom];
//    //[button setTitle:@"设置" forState:UIControlStateNormal];
//    [button setBackgroundImage:[UIImage imageNamed:@"setting.png"] forState:UIControlStateNormal];
//    button.frame=CGRectMake(kDeviceWidth-30, 10, 18, 18);
//    [button addTarget:self action:@selector(refreshTableView) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem  *barButton=[[UIBarButtonItem alloc]initWithCustomView:button];
//    self.navigationItem.rightBarButtonItem=barButton;

    
}
//点击可刷新
-(void)refreshTableView
{
    [_HotMoVieTableView  headerBeginRefreshing];
}

-(void)segmentClick:(UISegmentedControl *)seg
{
    
    
      if(seg.selectedSegmentIndex==0)
      {
          if (_hotDataArray.count==0) {
              [self requestData];
          }
      [_HotMoVieTableView reloadData];

      }
     else if(seg.selectedSegmentIndex==1)
     {
         if (_newDataArray.count==0) {
             [self requestData];
         }
         [_HotMoVieTableView reloadData];

     }

}
-(void)createHotView
{
    _HotMoVieTableView=[[UITableView alloc]initWithFrame:CGRectMake(0,0,kDeviceWidth, kDeviceHeight-kHeightNavigation)];
    _HotMoVieTableView.delegate=self;
    _HotMoVieTableView.backgroundColor = View_BackGround;
    _HotMoVieTableView.dataSource=self;
    _HotMoVieTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_HotMoVieTableView];
}



-(void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [_HotMoVieTableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    
    //  #warning 自动刷新(一进入程序就下拉刷新)
    [_HotMoVieTableView headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [_HotMoVieTableView addFooterWithTarget:self action:@selector(footerRereshing)];
}
#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
 

    if (segment.selectedSegmentIndex==0) {
        if (_hotDataArray.count>0) {
            page1=1;
            [_hotDataArray removeAllObjects];
        }
    }
    else if (segment.selectedSegmentIndex==1)
    {
        if (_newDataArray.count>0) {
            page2=1;
            [_newDataArray removeAllObjects];
        }
    }
    [self requestData];
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
     //   [_HotMoVieTableView reloadData];
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [_HotMoVieTableView headerEndRefreshing];
    });
}

- (void)footerRereshing
{
    
    if (segment.selectedSegmentIndex==0) {
        if (pageCount1>page1) {
            page1=page1+1;
            [self requestData];
         }
    }
    else if (segment.selectedSegmentIndex==1)
    {
        if (pageCount2>page2) {
            page2=page2+1;
            [self requestData];
         }
    }

    
    // 2.2秒后刷新表格UI
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
      //  [_HotMoVieTableView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [_HotMoVieTableView footerEndRefreshing];
    });
}



-(void)creatLoadView
{
    loadView =[[LoadingView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    loadView.delegate=self;
    [self.view addSubview:loadView];
}

//创建底部的视图
-(void)createToolBar
{
    _toolBar=[[ButtomToolView alloc]initWithFrame:CGRectMake(0,0,kDeviceWidth,kDeviceHeight)];
    _toolBar.delegete=self;
 
}
#pragma  mark -----
#pragma  mark ------  DataRequest －－－－－－－－－－－－－－－－－－－－－－－－－－
#pragma  mark ----
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


//屏幕剧照
-(void)requestRemoveStage
{
    UserDataCenter *usercenter=[UserDataCenter shareInstance];
    NSDictionary *parameters = @{@"stage_id":_stage_Id,@"user_id":usercenter.user_id};
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

 //举报剧情
-(void)requestReportSatge
{
     NSString  *stageId=@"";
    NSString  *author_id=@"";
    if (segment.selectedSegmentIndex==0) {
        ModelsModel  *model =[_hotDataArray objectAtIndex:Rowindex];
        stageId=model.stage_id;
        author_id=model.stageInfo.created_by;
    }
    else if (segment.selectedSegmentIndex==1)
    {
        weiboInfoModel  *weibomodel =[_newDataArray objectAtIndex:Rowindex];
        stageId=weibomodel.stage_id;
        author_id=[NSString stringWithFormat:@"%@",weibomodel.uerInfo.Id];
    }
    UserDataCenter *userCenter =[UserDataCenter shareInstance];
    NSDictionary *parameters = @{@"reported_user_id":author_id,@"stage_id":stageId,@"reason":@"",@"user_id":userCenter.user_id};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/report-stage/create", kApiBaseUrl] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject  objectForKey:@"code"]  intValue]==0) {
            UIAlertView  *Al =[[UIAlertView alloc]initWithTitle:nil message:@"你的举报已成功,我们会在24小时内处理" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [Al show];
            
         }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}


//举报剧情
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

//变身请求的随机数种子
-(void)requestChangeUserRand4
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
    
}
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


//移除微博推荐接口
-(void)requestrecommendDeleteDataWithHotId:(NSString *) hot_id
{

    UserDataCenter  *userCenter=[UserDataCenter shareInstance];
    NSDictionary *parameters = @{@"hot_id":hot_id,@"user_id":userCenter.user_id};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //manager.requestSerializer=[AFHTTPRequestSerializer serializer];
   // manager.responseSerializer=[AFHTTPResponseSerializer serializer];
  //  manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:[NSString stringWithFormat:@"%@/hot/delete", kApiBaseUrl] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject  objectForKey:@"code"]  intValue]==0) {
            NSLog(@"移除推荐成功=======%@",responseObject);
            UIAlertView  *Al=[[UIAlertView alloc]initWithTitle:nil message:@"移除推荐成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [Al show];
            [self requestData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}


//推荐微博的接口
-(void)requestrecommendData
{
    UserDataCenter  *userCenter =[UserDataCenter shareInstance];
    NSDictionary *parameters = @{@"weibo_id":_TweiboInfo.Id,@"stage_id":_TStageInfo.Id,@"user_id":userCenter.user_id};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/hot/create", kApiBaseUrl] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject  objectForKey:@"code"]  intValue]==0) {
            NSLog(@"推荐成功=======%@",responseObject);
            UIAlertView  *Al=[[UIAlertView alloc]initWithTitle:nil message:@"推荐成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [Al show];
            [self requestData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

//删除微博的接口
-(void)requestDelectData
{
    UserDataCenter *userCenter=[UserDataCenter shareInstance];
     NSDictionary *parameters = @{@"weibo_id":_TweiboInfo.Id,@"user_id":userCenter.user_id};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/weibo/remove", kApiBaseUrl] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject  objectForKey:@"code"]  intValue]==0) {
            NSLog(@"删除数据成功=======%@",responseObject);
            UIAlertView  *Al=[[UIAlertView alloc]initWithTitle:nil message:@"删除成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [Al show];
            [self requestData];
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

-(void)requestData{
    UserDataCenter  *userCenter=[UserDataCenter shareInstance];
     NSString *userId=userCenter.user_id;
    
    NSDictionary *parameters;
    parameters = @{@"user_id":userId,@"Version":Version};
    NSString * section;
    int page;
    if (segment.selectedSegmentIndex==0) {  // 热门
        page=page1;
        section= @"hot/list";

    }
    else if(segment.selectedSegmentIndex==1)//最新
    {
        page=page2;
        section=@"new-stage/list";

    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *urlString=[NSString stringWithFormat:@"%@/%@?per-page=%d&page=%d", kApiBaseUrl, section,pagesize,page];
    
     [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
       
        //返回0表示返回成功
        if ([[responseObject objectForKey:@"code"] intValue]==0) {
            [loadView stopAnimation];
            loadView.hidden=YES;
        NSMutableArray  *Detailarray=[responseObject objectForKey:@"models"];
            if (segment.selectedSegmentIndex==0) {
                pageCount1=[[responseObject objectForKey:@"pageCount"] intValue];
            }
            else if (segment.selectedSegmentIndex==1)
            {
                pageCount2=[[responseObject objectForKey:@"pageCount"] intValue];
            }
            
        if (segment.selectedSegmentIndex==0) {
            if (_hotDataArray ==nil) {
                _hotDataArray=[[NSMutableArray alloc]init];
            }
            for (NSDictionary  *hotDict in Detailarray) {
                ModelsModel  *model =[[ModelsModel alloc]init];
                if(model)
                {
                    [model setValuesForKeysWithDictionary:hotDict];
                    //stageinfo
                    stageInfoModel  *stagemodel =[[stageInfoModel alloc]init];
                    if (stagemodel) {
                        if(![[hotDict objectForKey:@"stage"] isKindOfClass:[NSNull class]])
                     {
                        [stagemodel setValuesForKeysWithDictionary:[hotDict objectForKey:@"stage"]];
                        
                        //weiboinfo
                        NSMutableArray  *weibosarray=[[NSMutableArray alloc]init];
                        for (NSDictionary  *weibodict  in [[hotDict objectForKey:@"stage"] objectForKey:@"weibos"]) {
                             weiboInfoModel *weibomodel=[[weiboInfoModel alloc]init];
                            if (weibomodel) {
                                [weibomodel setValuesForKeysWithDictionary:weibodict];
                                //weibouserInfo
                                weiboUserInfoModel  *usermodel =[[weiboUserInfoModel alloc]init];
                                    if (usermodel) {
                                         [usermodel setValuesForKeysWithDictionary:[weibodict objectForKey:@"user"]];
                                        weibomodel.uerInfo=usermodel;
                                   }
                                //tag
                                NSMutableArray  *tagArray = [[NSMutableArray alloc]init];
                                for (NSDictionary  *tagDict  in [weibodict objectForKey:@"tags"]) {
                                  TagModel *tagmodel =[[TagModel alloc]init];
                                  if (tagmodel) {
                                      [tagmodel setValuesForKeysWithDictionary:tagDict];
                                      TagDetailModel *tagedetail = [[TagDetailModel alloc]init];
                                      if (tagedetail) {
                                          if (![[tagDict objectForKey:@"tag"] isKindOfClass:[NSNull class]]) {
                                          [tagedetail setValuesForKeysWithDictionary:[tagDict  objectForKey:@"tag"]];
                                          tagmodel.tagDetailInfo=tagedetail;}
                                      }
                                      [tagArray addObject:tagmodel];}}
                                weibomodel.tagArray=tagArray;
                                [weibosarray addObject:weibomodel];
                            }
                        }
                        stagemodel.weibosArray=weibosarray;
                        //moviemodel
                        movieInfoModel *moviemodel =[[movieInfoModel alloc]init];
                        if (moviemodel) {
                            [moviemodel setValuesForKeysWithDictionary:[[hotDict objectForKey:@"stage"] objectForKey:@"movie"]];
                            stagemodel.movieInfo=moviemodel;
                        }
                    }
                    model.stageInfo=stagemodel;
                    
                    }
                    if(_hotDataArray==nil)
                    {
                        _hotDataArray =[[NSMutableArray alloc]init];
                        
                    }
                    [_hotDataArray addObject:model];
                }
             }
            //点赞的数组
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
          [_HotMoVieTableView reloadData];
        }
        else if(segment.selectedSegmentIndex==1)
        {
            NSLog(@"最新数据 JSON: %@", responseObject);
            for (NSDictionary  *newDict in Detailarray) {
                ModelsModel  *model =[[ModelsModel alloc]init];
                if(model)
                {
                    [model setValuesForKeysWithDictionary:newDict];
                    //stageinfo
                    stageInfoModel  *stagemodel =[[stageInfoModel alloc]init];
                    if (stagemodel) {
                        if(![[newDict objectForKey:@"stage"] isKindOfClass:[NSNull class]])
                        {
                            [stagemodel setValuesForKeysWithDictionary:[newDict objectForKey:@"stage"]];
                            //weiboinfo
                            NSMutableArray  *weibosarray=[[NSMutableArray alloc]init];
                            for (NSDictionary  *weibodict  in [[newDict objectForKey:@"stage"] objectForKey:@"weibos"]) {
                                weiboInfoModel *weibomodel=[[weiboInfoModel alloc]init];
                                if (weibomodel) {
                                    [weibomodel setValuesForKeysWithDictionary:weibodict];
                                    //weibouserInfo
                                    weiboUserInfoModel  *usermodel =[[weiboUserInfoModel alloc]init];
                                    if (usermodel) {
                                        [usermodel setValuesForKeysWithDictionary:[weibodict objectForKey:@"user"]];
                                        weibomodel.uerInfo=usermodel;
                                    }
                                    //tag
                                    NSMutableArray  *tagArray = [[NSMutableArray alloc]init];
                                    for (NSDictionary  *tagDict  in [weibodict objectForKey:@"tags"]) {
                                        TagModel *tagmodel =[[TagModel alloc]init];
                                        if (tagmodel) {
                                            [tagmodel setValuesForKeysWithDictionary:tagDict];
                                            TagDetailModel *tagedetail = [[TagDetailModel alloc]init];
                                            if (tagedetail) {
                                                if (![[tagDict objectForKey:@"tag"] isKindOfClass:[NSNull class]]) {
                                                    [tagedetail setValuesForKeysWithDictionary:[tagDict  objectForKey:@"tag"]];
                                                    tagmodel.tagDetailInfo=tagedetail;}
                                            }
                                            [tagArray addObject:tagmodel];}}
                                    weibomodel.tagArray=tagArray;
                                    [weibosarray addObject:weibomodel];
                                }
                            }
                            stagemodel.weibosArray=weibosarray;
                            //moviemodel
                            movieInfoModel *moviemodel =[[movieInfoModel alloc]init];
                            if (moviemodel) {
                                [moviemodel setValuesForKeysWithDictionary:[[newDict objectForKey:@"stage"] objectForKey:@"movie"]];
                                stagemodel.movieInfo=moviemodel;
                            }
                        }
                        model.stageInfo=stagemodel;
                    }
                    if(_newDataArray==nil)
                    {
                        _newDataArray =[[NSMutableArray alloc]init];
                        
                    }
                    [_newDataArray addObject:model];
                }
            }
//            //点赞的数组
//            for (NSDictionary  *updict in [responseObject objectForKey:@"upweibos"]) {
//                UpweiboModel *upmodel =[[UpweiboModel alloc]init];
//                if (upmodel) {
//                    [upmodel setValuesForKeysWithDictionary:updict];
//                    if (_upWeiboArray==nil) {
//                        _upWeiboArray =[[NSMutableArray alloc]init];
//                    }
//                    [_upWeiboArray addObject:upmodel];
//                }
//            }

            
            
//            for (NSDictionary  *newDict in Detailarray) {
//            weiboInfoModel  *weibomodel =[[weiboInfoModel alloc]init];
//            if(weibomodel)
//            {
//                [weibomodel setValuesForKeysWithDictionary:newDict];
//                
//                //1.userInfo
//                weiboUserInfoModel *usermodel =[[weiboUserInfoModel alloc]init];
//                if (usermodel) {
//                    [usermodel setValuesForKeysWithDictionary:[newDict objectForKey:@"user"]];
//                    weibomodel.uerInfo=usermodel;
//                }
//                //2.stageInfo
//                stageInfoModel  *stageInfo =[[stageInfoModel alloc]init];
//                if(![[newDict  objectForKey:@"stage"]isKindOfClass:[NSNull class]])
//                {
//                if (stageInfo) {
//                    [stageInfo setValuesForKeysWithDictionary:[newDict objectForKey:@"stage"]];
//                    movieInfoModel  *moviemodel =[[movieInfoModel alloc]init];
//                    if (moviemodel) {
//                        if (![[[newDict objectForKey:@"stage"] objectForKey:@"movie"] isKindOfClass:[NSNull class]]) {
//                        [moviemodel setValuesForKeysWithDictionary:[[newDict objectForKey:@"stage"] objectForKey:@"movie"]];
//                        stageInfo.movieInfo=moviemodel;
//                        }
//                    }
//                    weibomodel.stageInfo=stageInfo;
//                  }
//                }
//                //3.tagsInfo
//                NSMutableArray  *tagArray =[[NSMutableArray alloc]init];
//
//                if (![[newDict objectForKey:@"tags"] isKindOfClass:[NSNull class]]) {
//                    for (NSDictionary  *tagDict  in [newDict objectForKey:@"tags"]) {
//                        TagModel  *tagmodel =[[TagModel alloc]init];
//                        [tagmodel setValuesForKeysWithDictionary:tagDict];
//                        
//                        TagDetailModel  *tagDetailmodel =[[TagDetailModel alloc]init];
//                        if (tagDetailmodel) {
//                            [tagDetailmodel setValuesForKeysWithDictionary:[tagDict objectForKey:@"tag"]];
//                            tagmodel.tagDetailInfo=tagDetailmodel;
//                        }
//                        [tagArray addObject:tagmodel];
//                        
//                    }
//                    
//                }
//                weibomodel.tagArray=tagArray;
//                
//                if (_newDataArray==nil) {
//                    _newDataArray =[[NSMutableArray alloc]init];
//                }
//                 [_newDataArray addObject:weibomodel];
//            }
//            }
          
           [_HotMoVieTableView reloadData];
        }
        
        }
         //请求失败
         else
         {
         // [loadView showFailLoadData];'
             [loadView  showNullView:@"没有数据..."];
         }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [loadView showFailLoadData];
        
        
    }];
}
//数据下载失败的时候执行这个方法
-(void)reloadDataClick
{
    [self requestData];
    //点击完之后，动画又要开始旋转，同时隐藏了加载失败的背景
    [loadView hidenFailLoadAndShowAnimation];
    
}
#pragma mark  -----
#pragma mark --------UItableViewDelegate
#pragma mark  -------
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (segment.selectedSegmentIndex==0) {
        return _hotDataArray.count;
    }
    else if (segment.selectedSegmentIndex==1)
    {
        return _newDataArray.count;
    }
    return 0;
}

-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (segment.selectedSegmentIndex==0) {
        
        float hight;
        if (_hotDataArray.count>indexPath.row) {
            hight=kStageWidth+45;
        }
        return hight+10;
    }
    else if (segment.selectedSegmentIndex==1)
    {
        float hight;
        if (_newDataArray.count>indexPath.row) {
             hight= kStageWidth+45;
        }
        return hight+10;
    }
    return 200.0f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if  (segment.selectedSegmentIndex==0) {
            static NSString *cellID=@"CELL1";
            CommonStageCell  *cell= (CommonStageCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
            if (!cell) {
                cell=[[CommonStageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                cell.backgroundColor=View_BackGround;
            }
        
        
        if (_hotDataArray.count>indexPath.row) {
            ModelsModel  *model =[_hotDataArray objectAtIndex:indexPath.row];
            cell.pageType=NSPageSourceTypeMainHotController;
            cell.delegate=self;
            cell.stageView.delegate=self;
            cell.cellModel=model;
            cell.stageInfo=model.stageInfo;
            cell.weibosArray=model.stageInfo.weibosArray;
            cell.weiboInfo=nil;
            [cell ConfigsetCellindexPath:indexPath.row];
        }
        return cell;
    }
    else if (segment.selectedSegmentIndex==1)
    {
        static NSString *cellID=@"CELL2";
        CommonStageCell  *cell= (CommonStageCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell=[[CommonStageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.backgroundColor=View_BackGround;
        }
        if (_newDataArray.count>indexPath.row) {
//            weiboInfoModel  *model =[_newDataArray  objectAtIndex:indexPath.row];
//            cell.pageType=NSPageSourceTypeMainNewController;
//            cell.weiboInfo=model;
//            cell.stageView.delegate=self;
//            cell.stageInfo=model.stageInfo;
//            cell.delegate=self;
//            [cell ConfigsetCellindexPath:indexPath.row];
            
            ModelsModel  *model =[_newDataArray objectAtIndex:indexPath.row];
            cell.pageType=NSPageSourceTypeMainNewController;
            cell.delegate=self;
            cell.stageView.delegate=self;
            cell.cellModel=model;
            cell.stageInfo=model.stageInfo;
            cell.weibosArray=model.stageInfo.weibosArray;
            //cell.weiboInfo=nil;
            [cell ConfigsetCellindexPath:indexPath.row];
            
        }
        return  cell;
    }
    return nil;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        //点击cell 隐藏弹幕，再点击隐藏
        //NSLog(@"didDeselectRowAtIndexPath  =====%ld",indexPath.row);
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
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
   // CommonStageCell  *Cell =(CommonStageCell *)[tableView cellForRowAtIndexPath:indexPath];
    ///[Cell.stageView ];
    
}
//开始现实cell 的时候执行这个方法，执行动画
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"willDisplayCell ==== 当前显示的cell %ld",(long)indexPath.row);
    if (segment.selectedSegmentIndex==0) {
        CommonStageCell *commonStageCell = (CommonStageCell *)cell;
         [commonStageCell.stageView performSelector:@selector(startAnimation) withObject:nil afterDelay:0.1];
    }
    else if (segment.selectedSegmentIndex==1)
    {
        //开始了闪现
        CommonStageCell *commonStageCell = (CommonStageCell *)cell;
        [commonStageCell.stageView performSelector:@selector(startAnimation) withObject:nil afterDelay:0.1];

        
    }
}

//结束显示cell的时候执行这个方法
-(void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (segment.selectedSegmentIndex==0) {
#warning 为什么这里用上面的那句代码就不行
        //CommonStageCell *commonStageCell = (CommonStageCell *)[tableView cellForRowAtIndexPath:indexPath];
        CommonStageCell *commonStageCell = (CommonStageCell *)cell;
        [commonStageCell.stageView stopAnimation];
    }
    else if (segment.selectedSegmentIndex==1)
    {
        //结束闪现
        CommonStageCell *commonStageCell = (CommonStageCell *)cell;
        [commonStageCell.stageView stopAnimation];

    }
}

#pragma  mark -------------
#pragma mark   -----CommonStageCelldelegate  ---------------------------------------------

-(void)commonStageCellToolButtonClick:(UIButton *)button Rowindex:(NSInteger)index
{
    Rowindex=index;
     ModelsModel  *model;
    if (segment.selectedSegmentIndex==0) {
        model =[_hotDataArray objectAtIndex:index];
    }
    else  {
        model=[_newDataArray objectAtIndex:index];
    }
    if (button.tag==1000) {
        //电影按钮
        MovieDetailViewController *vc =  [MovieDetailViewController new];
        vc.movieId =  model.stageInfo.movie_id;
        vc.moviename=model.stageInfo.movieInfo.name;
        vc.movielogo=model.stageInfo.movieInfo.logo;
//        NSMutableString  *backstr=[[NSMutableString alloc]initWithString:model.stageInfo.movieInfo.name];
//        NSString *str;
//        if(backstr.length>5)
//        {
//            str=[backstr substringToIndex:5];
//            str =[NSString stringWithFormat:@"%@...",str];
//        }
//        UIBarButtonItem  *item =[[UIBarButtonItem alloc]initWithTitle:str style:UIBarButtonItemStylePlain target:nil action:nil];
//        self.navigationItem.backBarButtonItem=item;
        [self.navigationController pushViewController:vc animated:YES];

    }
    else if (button.tag==2000)
    {
        //分享
        CommonStageCell *cell = (CommonStageCell *)(button.superview.superview.superview.superview);
       // CommonStageCell  *cell=(CommonStageCell *)[_HotMoVieTableView cellForRowAtIndexPath:index];
        UIImage  *image=[Function getImage:cell.stageView WithSize:CGSizeMake(kDeviceWidth, kDeviceWidth)];
        UMShareViewController  *shareVC=[[UMShareViewController alloc]init];
        shareVC.StageInfo=model.stageInfo;
        shareVC.screenImage=image;
        shareVC.delegate=self;
         UINavigationController  *na =[[UINavigationController alloc]initWithRootViewController:shareVC];
        [self presentViewController:na animated:YES completion:nil];
        
     }
    else if(button.tag==3000)
    {
        //添加弹幕
        AddMarkViewController  *AddMarkVC=[[AddMarkViewController alloc]init];
        AddMarkVC.stageInfo=model.stageInfo;
        AddMarkVC.model=model;
        AddMarkVC.delegate=self;
        //AddMarkVC.pageSoureType=NSAddMarkPageSourceDefault;
        [self.navigationController pushViewController:AddMarkVC animated:NO];

    }
    else if (button.tag==4000)
    {
        //点击用户头像
        MyViewController  *myVC=[[MyViewController alloc]init];
        weiboInfoModel *model = [_newDataArray objectAtIndex:index];
        myVC.author_id =[NSString stringWithFormat:@"%@",model.uerInfo.Id];
        [self.navigationController pushViewController:myVC animated:YES];
    
    }
    else if (button.tag==6000)
    {
        UserDataCenter  *userCenter =[UserDataCenter shareInstance];
        //点击了更多
        if ([userCenter.is_admin intValue]>0) {
            
            if (segment.selectedSegmentIndex==0) {
                UIActionSheet  *Act=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"内容投诉",@"版权投诉",@"图片信息",@"切换剧照到(审核/正式)",@"移除推荐", nil];
                Act.tag=507;
                [Act showInView:Act];

            }
            else if(segment.selectedSegmentIndex==1)
            {
            UIActionSheet  *Act=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"内容投诉",@"版权投诉",@"图片信息",@"切换剧照到(审核/正式)", nil];
              Act.tag=507;
            [Act showInView:Act];
            }
        }
        else
        {
            UIActionSheet  *Act=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"内容投诉",@"版权投诉",@"图片信息", nil];
            Act.tag=507;
            [Act showInView:Act];
        }
        
    }
}
////长安剧情推荐和剧情移除
//-(void)commonStageCellLoogPressClickindex:(NSInteger)indexrow
//{
//    //HotMovieModel  *hotmovie;
//    ModelsModel  *moviemodel;
//    if  (segment.selectedSegmentIndex==0) {
//        
//        moviemodel =[_hotDataArray objectAtIndex:indexrow];
//        _hot_Id=moviemodel.Id;
//        
//        UIActionSheet  *ash =[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"移除推荐" otherButtonTitles:nil, nil];
//        ash.tag=503;
//        [ash showInView:self.view];
//    }
//    else if(segment.selectedSegmentIndex==1)
//    {
//        moviemodel=[_newDataArray objectAtIndex:indexrow];
//        _stage_Id=moviemodel.stageInfo.Id;
//        UIActionSheet  *ash =[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"屏蔽剧照" otherButtonTitles:nil, nil];
//        ash.tag=505;
//        [ash showInView:self.view];
//
//    }
//    
//}
#pragma mark  -----AddMarkViewControllerDelegate----
-(void)AddMarkViewControllerReturn
{
    [_HotMoVieTableView reloadData];
    
}

#pragma  mark  -----UMButtomViewshareViewDlegate------------------------

-(void)UMShareViewControllerHandClick:(UIButton *)button ShareImage:(UIImage *)shareImage StageInfoModel:(stageInfoModel *)StageInfo
{
    
    
    NSArray  *sharearray =[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQzone, UMShareToSina, nil];
    
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
    
    [[UMSocialControllerService defaultControllerService] setShareText:StageInfo.movieInfo.name shareImage:shareImage socialUIDelegate:self];
    //设置分享内容和回调对象
    
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

//#pragma mark  --UMShareDelegate 友盟分享实现的功能

-(void)didCloseUIViewController:(UMSViewControllerType)fromViewControllerType
{
}
//根据有的view 上次一张图片
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{

}
-(void)didFinishGetUMSocialDataResponse:(UMSocialResponseEntity *)response;
{
    NSLog(@"didFinishGetUMSocialDataResponse第二部执行这个");
}


#pragma mark  -----
#pragma mark  ---//点击了弹幕StaegViewDelegate
#pragma mark  ----
-(void)StageViewHandClickMark:(weiboInfoModel *)weiboDict withmarkView:(id)markView StageInfoDict:(stageInfoModel *)stageInfoDict
{
    ///执行buttonview 弹出
    //获取markview的指针
    MarkView   *mv=(MarkView *)markView;
    //把当前的markview 给存储在了controller 里面
     _mymarkView=mv;
    if (mv.isSelected==YES) {  //当前已经选中的状态
        //设置工具栏的值，并且，弹出工具栏
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
        //设置工具栏的值
        _toolBar.alertView.frame=CGRectMake(15,0,kStageWidth-20, 100);
        _toolBar.weiboInfo=weiboDict;
        _toolBar.stageInfo=stageInfo;
        _toolBar.markView=markView;
        _toolBar.upweiboArray=_upWeiboArray;
        [_toolBar configToolBar];
        [AppView addSubview:_toolBar];
      //  UIWindow  *window =[[[UIApplication sharedApplication] delegate] window];
        //[window addSubview:_toolBar];
        //弹出工具栏
        [_toolBar ShowButtomView];
        
    }
    else if (isselect==NO)
    {
        if (_toolBar) {
        [_toolBar HidenButtomView];
        //从父视图中除掉工具栏
        [_toolBar removeFromSuperview];
        }
    }
    
    
}
#pragma mark   ------
#pragma mark   -------- ButtomToolViewDelegate－－－－－－－－－－－－－－－－－－－－－-----------
#pragma  mark  -------
-(void)ToolViewHandClick:(UIButton *)button :(MarkView *)markView weiboDict:(weiboInfoModel *)weiboDict StageInfo:(stageInfoModel *)stageInfoDict
{
    //把值全局化，有利于下面进行一系列的删除变身操作
    _TStageInfo=stageInfoDict;
    _TweiboInfo=weiboDict;
    
    NSLog(@"ToolViewHandClick  weibo dict ===%@",weiboDict);
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
        [_mymarkView CancelMarksetSelect];
         if (_toolBar) {
            [_toolBar HidenButtomView];
            [_toolBar removeFromSuperview];
        }
        UMShareViewController2  *shareVC=[[UMShareViewController2 alloc]init];
        shareVC.StageInfo=stageInfoDict;
        shareVC.weiboInfo=weiboDict;
        shareVC.delegate=self;
        UINavigationController  *na =[[UINavigationController alloc]initWithRootViewController:shareVC];
        [self presentViewController:na animated:YES completion:nil];

    }
#pragma mark  ----------点赞--------------
    else  if(button.tag==10002)
    {
         //点击了赞
        //点赞遍历，如果能在数组中能发现这个weibo，那么删除掉，如果没有发现这个微博，那么添加这个微博
        NSNumber  *operation;
        int tag=0;//已经赞的走这里
        for (int i=0; i<_upWeiboArray.count; i++) {
            //已赞的
            UpweiboModel *upmodel =_upWeiboArray[i];
            if ([upmodel.weibo_id intValue]==[weiboDict.Id intValue]) {
                tag=1;
                operation =[NSNumber numberWithInt:0];
                int like=[weiboDict.like_count intValue];
                like=like-1;
                weiboDict.like_count=[NSNumber numberWithInt:like];
                //从数组中移除当前对象
                 [_upWeiboArray removeObjectAtIndex:i];
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
            [_upWeiboArray addObject:upmodel];
        }
        [self layoutMarkViewWithMarkView:markView WeiboInfo:weiboDict];
        ////发送到服务器
        [self LikeRequstData:weiboDict withOperation:operation];
        
    }
    else if(button.tag==10003)
    {
       
        UserDataCenter  *userCenter =[UserDataCenter shareInstance];
        
        
        if ([userCenter.is_admin  intValue]>0) {
        UIActionSheet   *ash=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"删除",@"变身",@"推荐", nil];
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
    [self.navigationController pushViewController:vc animated:YES];
    
}


#pragma mark  ----actionSheetDelegate----------------------------------------------
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (actionSheet.tag==500) {
        if (buttonIndex==0) {
            //删除
            UIActionSheet   *ash=[[UIActionSheet alloc]initWithTitle:@"确定删除" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:nil,nil];
            ash.tag=501;
            [ash showInView:self.view];
            
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
            UIActionSheet   *ash=[[UIActionSheet alloc]initWithTitle:@"确定推荐" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil,nil];
            ash.tag=502;
            [ash showInView:self.view];
        }
    }
    // 确定删除
    else if(actionSheet.tag==501)
    {
        if (buttonIndex==0) {
            //删除了
            [self requestDelectData];
        }
        
    }
    else if(actionSheet.tag==502)
    {
        if (buttonIndex==0) {
            //推荐了
            [self requestrecommendData];
        }
        
    }
    else if (actionSheet.tag==503)
    {
        if (buttonIndex==0) {
            //[self requestrecommendDeleteDataWith];
        }
    }

    else if(actionSheet.tag==504)
    {
        if (buttonIndex==0) {
            //确认举报
            [self requestReportweibo];
         
        }
    }
    else if (actionSheet.tag==505)
    {
        if (buttonIndex==0) {
            //删除
            UIActionSheet   *ash=[[UIActionSheet alloc]initWithTitle:@"确定屏蔽" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"移除" otherButtonTitles:nil,nil];
            ash.tag=506;
            [ash showInView:self.view];
        }
    }
    else if (actionSheet.tag==506)
    {
        if (buttonIndex==0) {
        [self requestRemoveStage];
        }
        
    }
    else if (actionSheet.tag==507)
    {
        if (buttonIndex==0) {
            //举报剧情
            [self requestReportSatge];
          
        }
        else if(buttonIndex==1)
        {
            
            stageInfoModel  *stageInfo;
            if (segment.selectedSegmentIndex==0) {
                ModelsModel   *model =[_hotDataArray objectAtIndex:Rowindex];
                stageInfo=model.stageInfo;

             }
            else if (segment.selectedSegmentIndex==1)
            {
                weiboInfoModel  *weibomodel =[_newDataArray objectAtIndex:Rowindex];
                stageInfo=weibomodel.stageInfo;

       
             }
        
            //版权问题
            [self sendFeedBackWithStageInfo: stageInfo];

        }
        else if(buttonIndex==2)
        {
          // 查看图片信息
            ScanMovieInfoViewController * scanvc =[ScanMovieInfoViewController new];
            if (segment.selectedSegmentIndex==0) {
                ModelsModel   *model =[_hotDataArray objectAtIndex:Rowindex];
                scanvc.stageInfo=model.stageInfo;
            
            }
            else if (segment.selectedSegmentIndex==1)
            {
             
                weiboInfoModel  *weibomodel =[_newDataArray objectAtIndex:Rowindex];
                scanvc.stageInfo=weibomodel.stageInfo;
            }
            
            [self presentViewController:scanvc animated:YES completion:nil];
            
        }
        else if (buttonIndex==3)
        {
            NSString  *stageId;
            if (segment.selectedSegmentIndex==0) {
              ModelsModel  * model =[_hotDataArray objectAtIndex:Rowindex];
                stageId=model.stage_id;
            }
            else if  (segment.selectedSegmentIndex==1) {
                weiboInfoModel *   model=[_newDataArray objectAtIndex:Rowindex];
                stageId=model.stage_id;
            }

            //移动到审核版或者正常
            [self requestmoveReviewToNormal:stageId];
        
        }
        else if (buttonIndex==4)
        {
            if (segment.selectedSegmentIndex==0) {
            //移除推荐
             ModelsModel    *moviemodel =[_hotDataArray objectAtIndex:Rowindex];
             [self requestrecommendDeleteDataWithHotId:moviemodel.Id];
            }
            
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
    
    //feedback@redianying.comfeedback@redianying.com
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
   // NSString *emailBody = [NSString stringWithFormat:@"\n附属信息：\n\n%@ %@(%@)\n%@ / %@ / %@ IOS%@", appCurName, appCurVersion, appCurVersionNum, @"", @"", @"",  sysVersion];
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
#pragma mark  -----
#pragma mark  ------ToolbuttomView隐藏工具栏的方法
#pragma mark  -------
////点击屏幕，隐藏工具栏
//-(void)topViewTouchBengan
//{
//    NSLog(@"controller touchbegan  中 执行了隐藏工具栏的方法");
//    //取消当前的选中的那个气泡
//    [_mymarkView CancelMarksetSelect];
//    self.tabBarController.tabBar.hidden=NO;
//    if (_toolBar) {
//        [_toolBar HidenButtomView];
//         [_toolBar removeFromSuperview];
//        
//    }
//}
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
