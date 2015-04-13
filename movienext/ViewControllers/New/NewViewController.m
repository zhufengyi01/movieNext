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

#import "Function.h"
#import "UMSocial.h"
//#import "UMShareView.h"
#import "UMSocialControllerService.h"
#import "UIImageView+WebCache.h"
#import "UMShareViewController.h"


//友盟分享
//#import "UMSocial.h"
@interface NewViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,StageViewDelegate,ButtomToolViewDelegate,UIScrollViewDelegate,UMSocialDataDelegate,UMSocialUIDelegate,LoadingViewDelegate,UIActionSheetDelegate,CommonStageCellDelegate,AddMarkViewControllerDelegate,UMShareViewControllerDelegate>
{
    AppDelegate  *appdelegate;
    UISegmentedControl *segment;
    UITableView   *_HotMoVieTableView;
    LoadingView   *loadView;
    NSMutableArray    *_hotDataArray;
    NSMutableArray    *_newDataArray;
    int page;
    int pagesize;
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
}
@end

@implementation NewViewController
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden=NO;
  self.navigationController.navigationBar.alpha=1;
//    self.navigationController.navigationBar.translucent=NO;
//
    self.tabBarController.tabBar.hidden=NO;
    //if (_HotMoVieTableView) {
      //  [self setupRefresh];
    //}
    
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
    //  [self createShareView];
   
    
}
-(void)initData{
    _hotDataArray = [[NSMutableArray alloc]init];
    _newDataArray=[[NSMutableArray alloc]init];
    _upWeiboArray=[[NSMutableArray alloc]init];
    page=1;
    pagesize=10;
 }
#pragma  mark   ------
#pragma  mark  -------CreatUI;
-(void)creatNavigation
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"tabbar_backgroud_color.png"] forBarMetrics:UIBarMetricsDefault];
    NSArray *segmentedArray = [[NSArray alloc] initWithObjects:@"热门", @"最新", nil];
    segment = [[UISegmentedControl alloc] initWithItems:segmentedArray];
    segment.frame = CGRectMake(kDeviceWidth/4, 0, kDeviceWidth/2, 30);
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
    _HotMoVieTableView=[[UITableView alloc]initWithFrame:CGRectMake(0,0, kDeviceWidth, kDeviceHeight-kHeightNavigation)];
    _HotMoVieTableView.delegate=self;
    _HotMoVieTableView.dataSource=self;
    _HotMoVieTableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
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
    page=1;
    
    if (segment.selectedSegmentIndex==0) {
        if (_hotDataArray.count>0) {
            [_hotDataArray removeAllObjects];
        }
    }
    else if (segment.selectedSegmentIndex==1)
    {
        if (_newDataArray.count>0) {
            [_newDataArray removeAllObjects];
        }
    }
    [self requestData];
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
     //   [_HotMoVieTableView reloadData];
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [_HotMoVieTableView headerEndRefreshing];
    });
}

- (void)footerRereshing
{
    page++;
    [self  requestData];
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
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
//屏幕剧照
-(void)requestRemoveStage
{
    UserDataCenter *usercenter=[UserDataCenter shareInstance];
    
    NSDictionary *parameters = @{@"id":_stage_Id,@"user_id":usercenter.user_id};
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

 //举报某人
-(void)requestReport
{
    NSString *type=@"1";
    UserDataCenter *userCenter =[UserDataCenter shareInstance];
    NSDictionary *parameters = @{@"reported_user_id":_TweiboInfo.uerInfo.Id,@"reported_id":_TweiboInfo.Id,@"reason":@"",@"type":type,@"created_by":userCenter.user_id};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/report/create", kApiBaseUrl] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/user/fakeUser", kApiBaseUrl] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject  objectForKey:@"code"]  intValue]==0) {
            NSLog(@"随机数种子请求成功=======%@",responseObject);
            
            [self  requestChangeUser:[responseObject objectForKey:@"detail"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}
//跟换用户的数据请求
-(void)requestChangeUser:(NSDictionary  *) dict
 {
    
     NSDictionary *parameters = @{@"weibo_id":_TweiboInfo.Id,@"user_id":[dict objectForKey:@"id"]};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/weibo/switch", kApiBaseUrl] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject  objectForKey:@"code"]  intValue]==0) {
            NSLog(@"推荐成功=======%@",responseObject);
            UIAlertView  *Al=[[UIAlertView alloc]initWithTitle:nil message:@"变身成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [Al show];
            _TweiboInfo.uerInfo.Id=[dict objectForKey:@"id"];
             [ _mymarkView.LeftImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kUrlAvatar, [dict objectForKey:@"avatar"] ]]];
           
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}


//移除微博推荐接口
-(void)requestrecommendDeleteDataWith
{
    //  NSLog(@"hotmodel  ==weibiid ==%@   hotmodel stageinfo id ==%@ ",hotmodel.weibo.Id,hotmodel.stageinfo.Id);
    NSDictionary *parameters = @{@"id":_hot_Id};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //manager.requestSerializer=[AFHTTPRequestSerializer serializer];
   // manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:[NSString stringWithFormat:@"%@/hot/delete", kApiBaseUrl] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject  objectForKey:@"return_code"]  intValue]==10000) {
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
    //  NSLog(@"hotmodel  ==weibiid ==%@   hotmodel stageinfo id ==%@ ",hotmodel.weibo.Id,hotmodel.stageinfo.Id);
    NSDictionary *parameters = @{@"id":_TweiboInfo.Id,@"stage_id":_TStageInfo.Id};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/hot/create", kApiBaseUrl] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject  objectForKey:@"return_code"]  intValue]==10000) {
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
    //  NSLog(@"hotmodel  ==weibiid ==%@   hotmodel stageinfo id ==%@ ",hotmodel.weibo.Id,hotmodel.stageinfo.Id);
    NSDictionary *parameters = @{@"id":_TweiboInfo.Id,@"stage_id":_TStageInfo.Id};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/weibo/remove", kApiBaseUrl] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject  objectForKey:@"return_code"]  intValue]==10000) {
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
    NSString  *userId=@"18";
    
   
    NSDictionary *parameters=@{@"weibo_id":weiboId,@"user_id":userId,@"operation":operation};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *urlString = [NSString stringWithFormat:@"%@/weiboUp/up", kApiBaseUrl];
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
    
    NSDictionary *parameters = @{@"user_id":userId};

    NSString * section;
    if (segment.selectedSegmentIndex==1) {  // 最新
        section=@"weibo/listrecently";
    }
    else if(segment.selectedSegmentIndex==0) //热门
    {
        section= @"hot/list";
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
            if (_hotDataArray ==nil) {
                _hotDataArray=[[NSMutableArray alloc]init];
            }
            NSLog(@"热门数据 gaga JSON: %@", responseObject);
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
                            
                            NSLog(@"=====weibo dict =======%@",weibodict);
                            weiboInfoModel *weibomodel=[[weiboInfoModel alloc]init];
                            if (weibomodel) {
                                [weibomodel setValuesForKeysWithDictionary:weibodict];
                                
                                weiboUserInfoModel  *usermodel =[[weiboUserInfoModel alloc]init];
                                    if (usermodel) {
                                         [usermodel setValuesForKeysWithDictionary:[weibodict objectForKey:@"user"]];
                                        weibomodel.uerInfo=usermodel;
                                   }
        
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
                NSNumber  *iD=model.stageInfo.Id;
                NSLog(@"=====%@",iD);
                
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
            if (_newDataArray==nil) {
                _newDataArray=[[NSMutableArray alloc]init];
            }
            NSLog(@"最新数据 JSON: %@", responseObject);
            
            for (NSDictionary  *newDict in Detailarray) {
            weiboInfoModel  *weibomodel =[[weiboInfoModel alloc]init];
            if(weibomodel)
            {
                [weibomodel setValuesForKeysWithDictionary:newDict];
                
                weiboUserInfoModel *usermodel =[[weiboUserInfoModel alloc]init];
                if (usermodel) {
                    [usermodel setValuesForKeysWithDictionary:[newDict objectForKey:@"user"]];
                    weibomodel.uerInfo=usermodel;
                }
                stageInfoModel  *stageInfo =[[stageInfoModel alloc]init];
                if (stageInfo) {
                    [stageInfo setValuesForKeysWithDictionary:[newDict objectForKey:@"stage"]];
                    movieInfoModel  *moviemodel =[[movieInfoModel alloc]init];
                    if (moviemodel) {
                        [moviemodel setValuesForKeysWithDictionary:[[newDict objectForKey:@"stage"] objectForKey:@"movie"]];
                        stageInfo.movieInfo=moviemodel;
                    }
                    weibomodel.stageInfo=stageInfo;
                }
                if (_newDataArray==nil) {
                    _newDataArray =[[NSMutableArray alloc]init];
                }
                 [_newDataArray addObject:weibomodel];
            }
            }
          
           [_HotMoVieTableView reloadData];
        }
        
        }
         //请求失败
         else
         {
          [loadView showFailLoadData];
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
            hight=kDeviceWidth+45;
        }
        return hight+10;
    }
    else if (segment.selectedSegmentIndex==1)
    {
        float hight;
        if (_newDataArray.count>indexPath.row) {
             hight= kDeviceWidth+90;
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
//             //HotMovieModel  *hotModel=[_hotDataArray objectAtIndex:indexPath.row];
//            cell.pageType=NSPageSourceTypeMainHotController;
//            //小闪动标签的数组
//            cell.WeibosArray =hotModel.weibos;
//            cell.weiboDict=nil;
//            cell.delegate=self;
//            cell.StageInfoDict=hotModel.stageinfo;
//            [cell ConfigsetCellindexPath:indexPath.row];
//            //遵守stagview的协议，点击事件在controller里面响应
//            cell.stageView.delegate=self;
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
           
//            HotMovieModel   *hotmodel=[_newDataArray  objectAtIndex:indexPath.row];
//            //配置cell的类型。
//            cell.pageType=NSPageSourceTypeMainNewController;
//            //根据类型配置cell的气泡数据
//            cell.weiboDict =hotmodel.weibo; //[[_newDataArray  objectAtIndex:indexPath.row]  objectForKey:@"weibo"];
//            //配置stage的数据
//            cell.WeibosArray=nil;
//            cell.delegate=self;
//            cell.StageInfoDict=hotmodel.stageinfo;
//            [cell ConfigsetCellindexPath:indexPath.row];
// 
//            //遵守了stageview的协议，点击事件在这里执行
//            cell.stageView.delegate=self;
            weiboInfoModel  *model =[_newDataArray  objectAtIndex:indexPath.row];
            cell.pageType=NSPageSourceTypeMainNewController;
            cell.weiboInfo=model;
            cell.stageView.delegate=self;
            cell.stageInfo=model.stageInfo;
            cell.delegate=self;
            [cell ConfigsetCellindexPath:indexPath.row];
            
        }
        return  cell;
    }
    return nil;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        //点击cell 隐藏弹幕，再点击隐藏
        NSLog(@"didDeselectRowAtIndexPath  =====%ld",indexPath.row);
     //   CommonStageCell   *cell=(CommonStageCell *)[tableView cellForRowAtIndexPath:indexPath];
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
//开始现实cell 的时候执行这个方法，执行动画
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"willDisplayCell ==== 当前显示的cell %ld",(long)indexPath.row);
    if (segment.selectedSegmentIndex==0) {
        CommonStageCell *commonStageCell = (CommonStageCell *)cell;
      // [commonStageCell.stageView startAnimation];
        [commonStageCell.stageView performSelector:@selector(startAnimation) withObject:nil afterDelay:0.1];
    }
    else if (segment.selectedSegmentIndex==1)
    {
        //开始了闪现
        
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
        
    }
}

#pragma  mark -------------
#pragma mark   -----CommonStageCelldelegate  ---------------------------------------------

-(void)commonStageCellToolButtonClick:(UIButton *)button Rowindex:(NSInteger)index
{
  //  HotMovieModel  *hotmovie;
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
        [self.navigationController pushViewController:vc animated:YES];

    }
    else if (button.tag==2000)
    {
        //分享
        CommonStageCell *cell = (CommonStageCell *)(button.superview.superview.superview);
        UIImage  *image=[Function getImage:cell.stageView WithSize:CGSizeMake(kDeviceWidth, kDeviceWidth)];
        UMShareViewController  *shareVC=[[UMShareViewController alloc]init];
        shareVC.StageInfo=model.stageInfo;
        shareVC.screenImage=image;
        shareVC.delegate=self;
         UINavigationController  *na =[[UINavigationController alloc]initWithRootViewController:shareVC];
        [self presentViewController:na animated:YES completion:nil];
//        [self.navigationController presentViewController:shareVC animated:YES completion:nil];
    }
    else if(button.tag==3000)
    {
        //添加弹幕
        AddMarkViewController  *AddMarkVC=[[AddMarkViewController alloc]init];
        AddMarkVC.stageInfo=model.stageInfo;
        AddMarkVC.model=model;
        AddMarkVC.delegate=self;
        //AddMarkVC.pageSoureType=NSAddMarkPageSourceDefault;
        NSLog(@"dict.stageinfo = %@", AddMarkVC.stageInfo);
        [self.navigationController pushViewController:AddMarkVC animated:NO];
        

    }
    else if (button.tag==4000)
    {
        //点击用户头像
        MyViewController  *myVC=[[MyViewController alloc]init];
        HotMovieModel *hotMovieModel = [_newDataArray objectAtIndex:index];
        myVC.author_id = hotMovieModel.weibo.user_id;
        [self.navigationController pushViewController:myVC animated:YES];
        

    }
}
//长安剧情推荐和剧情移除
-(void)commonStageCellLoogPressClickindex:(NSInteger)indexrow
{
    //HotMovieModel  *hotmovie;
    ModelsModel  *moviemodel;
    if  (segment.selectedSegmentIndex==0) {
        
        moviemodel =[_hotDataArray objectAtIndex:indexrow];
        _hot_Id=moviemodel.Id;
        
        UIActionSheet  *ash =[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"移除推荐" otherButtonTitles:nil, nil];
        ash.tag=503;
        [ash showInView:self.view];
    }
    else if(segment.selectedSegmentIndex==1)
    {
        moviemodel=[_newDataArray objectAtIndex:indexrow];
        _stage_Id=moviemodel.stageInfo.Id;
        UIActionSheet  *ash =[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"屏蔽剧照" otherButtonTitles:nil, nil];
        ash.tag=505;
        [ash showInView:self.view];

    }
    
}
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
    NSLog(@"分享");
    
 
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
        NSLog(@" new viewController SetToolBarValueWithDict  执行了出现工具栏的方法");
        
        //设置工具栏的值
        //[_toolBar setToolBarValue:weiboDict :markView WithStageInfo:stageInfo];
        _toolBar.weiboInfo=weiboDict;
        _toolBar.stageInfo=stageInfo;
        _toolBar.markView=markView;
        _toolBar.upweiboArray=_upWeiboArray;
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
#pragma mark   -------- ButtomToolViewDelegate－－－－－－－－－－－－－－－－－－－－－
#pragma  mark  -------
-(void)ToolViewHandClick:(UIButton *)button :(MarkView *)markView weiboDict:(weiboInfoModel *)weiboDict StageInfo:(stageInfoModel *)stageInfoDict
{
    //把值全局化，有利于下面进行一系列的删除变身操作
    _TStageInfo=stageInfoDict;
    _TweiboInfo=weiboDict;
    
    NSLog(@"ToolViewHandClick  weibo dict ===%@",weiboDict);
    if (button.tag==10000) {
        ///点击了头像//进入个人页面
        MyViewController   *myVc=[[MyViewController alloc]init];
        myVc.author_id=weiboDict.created_by;
        [self.navigationController pushViewController:myVc animated:YES];
    }
#pragma mark     -----------分享
    else if (button.tag==10001)
    {
        NSLog(@" 点击了分享按钮");
        CommonStageCell *cell = (CommonStageCell *)(markView.superview.superview.superview);
         UIImage  *image=[Function getImage:cell.stageView WithSize:CGSizeMake(kDeviceWidth, kDeviceWidth)];
         UMShareViewController  *shareVC=[[UMShareViewController alloc]init];
        shareVC.StageInfo=stageInfoDict;
        shareVC.screenImage=image;
        shareVC.delegate=self;
        UINavigationController  *na =[[UINavigationController alloc]initWithRootViewController:shareVC];
        [self presentViewController:na animated:YES completion:nil];

        
        
    }
#pragma mark  ----------点赞--------------
    else  if(button.tag==10002)
    {
         //点击了赞
    /* if ([weiboDict.uped intValue]==0)
       {
         // weiboDict.uped=[NSNumber numberWithInt:1];
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
        }*/
        //点赞遍历，如果能在数组中能发现这个weibo，那么删除掉，如果没有发现这个微博，那么添加这个微博
        NSNumber  *operation;
        int tag=0;// 标志是否含有weiboid
        for (int i=0; i<_upWeiboArray.count; i++) {
            //已赞的
            UpweiboModel *upmodel =_upWeiboArray[i];
            if ([upmodel.Id intValue]==[weiboDict.Id intValue]) {
                tag=1;
                operation =[NSNumber numberWithInt:0];
                int like=[weiboDict.like_count intValue];
                like=like-1;
                weiboDict.like_count=[NSNumber numberWithInt:like];
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

#pragma mark  ----actionSheetDelegate--
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
            [self requestrecommendDeleteDataWith];
        }
    }

    else if(actionSheet.tag==504)
    {
        if (buttonIndex==0) {
            //确认举报
            [self requestReport];
         
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
}

//重新布局markview
-(void)layoutMarkViewWithMarkView:(MarkView  *) markView WeiboInfo:(weiboInfoModel *) weibodict
{
    
#pragma mark   缩放整体的弹幕大小
    [Function BasicAnimationwithkey:@"transform.scale" Duration:0.25 repeatcont:1 autoresverses:YES fromValue:1.0 toValue:1.05 View:markView];

    
    //NSLog(@" 点赞 后 微博dict  ＝====uped====%@    ups===%@",weibodict.uped,weibodict.ups);

      NSString  *weiboTitleString=weibodict.content;
      NSString  *UpString=[NSString stringWithFormat:@"%@",weibodict.like_count];//weibodict.ups;
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
#pragma mark 设置气泡的大小和位置
    markView.frame=CGRectMake(markView.frame.origin.x, markView.frame.origin.y, markViewWidth, markViewHeight);
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
//点击屏幕，隐藏工具栏

-(void)topViewTouchBengan
{
    NSLog(@"controller touchbegan  中 执行了隐藏工具栏的方法");
    //取消当前的选中的那个气泡
    [_mymarkView CancelMarksetSelect];
    self.tabBarController.tabBar.hidden=NO;
    if (_toolBar) {
        [_toolBar HidenButtomView];
       //  [_toolBar performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.5];
        [_toolBar removeFromSuperview];
        
    }
}
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
