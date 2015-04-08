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
#import "WeiboModel.h"
#import "HotMovieModel.h"
#import "Function.h"
#import "UMSocial.h"
#import "UMShareView.h"
#import "UMSocialControllerService.h"
#import "UIImageView+WebCache.h"
#import "UMShareViewController.h"
//友盟分享
//#import "UMSocial.h"
@interface NewViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,StageViewDelegate,ButtomToolViewDelegate,UIScrollViewDelegate,UMSocialDataDelegate,UMSocialUIDelegate,UMShareViewDelegate,LoadingViewDelegate,UIActionSheetDelegate,CommonStageCellDelegate,AddMarkViewControllerDelegate>
{
    AppDelegate  *appdelegate;
    UISegmentedControl *segment;
    UITableView   *_HotMoVieTableView;
    LoadingView   *loadView;
    NSMutableArray    *_hotDataArray;
    NSMutableArray    *_newDataArray;
    int page;
    ButtomToolView *_toolBar;
    MarkView       *_mymarkView;
    
    BOOL isMarkViewsShow;
    UIImageView   *ShareimageView;
    UMShareView   *shareView;
    StageInfoModel  *_TStageInfo;
    WeiboModel      *_TweiboInfo;
    //用于移除推荐使用
    NSString        *_hot_Id;
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
    [self createShareView];
    
}
-(void)initData{
    _hotDataArray = [[NSMutableArray alloc]init];
    _newDataArray=[[NSMutableArray alloc]init];
    page=0;
    isMarkViewsShow=YES;
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
    page=0;
    
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
//创建分享视图
-(void)createShareView
{
    shareView=[[UMShareView alloc]initWithFrame:CGRectMake(0,0, kDeviceWidth, kDeviceHeight)];
    shareView.delegate=self;
}
#pragma  mark -----
#pragma  mark ------  DataRequest －－－－－－－－－－－－－－－－－－－－－－－－－－
#pragma  mark ----
#warning  举报某人，未实现
//举报某人
-(void)requestReport
{
    NSString *type=@"1";
    UserDataCenter *userCenter =[UserDataCenter shareInstance];
    NSDictionary *parameters = @{@"reported_user_id":_TweiboInfo.user_id,@"reported_id":_TweiboInfo.Id,@"reason":@"",@"type":type,@"created_by":userCenter.user_id};

    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/report/create", kApiBaseUrl] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject  objectForKey:@"return_code"]  intValue]==10000) {
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
        if ([[responseObject  objectForKey:@"return_code"]  intValue]==10000) {
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
        if ([[responseObject  objectForKey:@"return_code"]  intValue]==10000) {
            NSLog(@"推荐成功=======%@",responseObject);
            UIAlertView  *Al=[[UIAlertView alloc]initWithTitle:nil message:@"变身成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [Al show];
            _TweiboInfo.user_id=[dict objectForKey:@"id"];
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
            NSLog(@"推荐成功=======%@",responseObject);
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
-(void)LikeRequstData:(WeiboModel  *) weiboDict StageInfo :(StageInfoModel *) stageInfoDict
{
    
    UserDataCenter  *userCenter=[UserDataCenter shareInstance];
    NSNumber  *weiboId=weiboDict.Id;
    NSNumber  *stageId=stageInfoDict.Id;
    NSString  *movieId=stageInfoDict.movie_id;
    NSString  *movieName=stageInfoDict.movie_name;
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
- (void)requestData{
  
    UserDataCenter  *userCenter=[UserDataCenter shareInstance];
    NSDictionary *parameters = @{@"user_id":userCenter.user_id, @"page":[NSString stringWithFormat:@"%d",page]};
    NSString * section;
    if (segment.selectedSegmentIndex==1) {  // 最新
        section=@"weibo/listRecently";
    }
    else if(segment.selectedSegmentIndex==0) //热门
    {
        section= @"hot/list";
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/%@", kApiBaseUrl, section] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"return_code"] intValue]==10000) {
            [loadView stopAnimation];
            loadView.hidden=YES;

        NSMutableArray  *Detailarray=[responseObject objectForKey:@"detail"];
        if (segment.selectedSegmentIndex==0) {
            if (_hotDataArray ==nil) {
                _hotDataArray=[[NSMutableArray alloc]init];
            }
            NSLog(@"热门数据 JSON: %@", responseObject);
            for (NSDictionary  *hotDict in Detailarray) {
                HotMovieModel  *hotModel=[[HotMovieModel alloc]init];
                if (hotModel) {
                    [hotModel setValuesForKeysWithDictionary:hotDict];
                    
                    NSMutableArray  *weibosArray=[[NSMutableArray alloc]init];
                    for (NSDictionary  *weiboDict in [hotDict objectForKey:@"weibos"]) {
                        WeiboModel *weiboModel=[[WeiboModel alloc]init];
                        [weiboModel setValuesForKeysWithDictionary:weiboDict];
                        [weibosArray addObject:weiboModel];
                    }
                    hotModel.weibos=weibosArray;
                     StageInfoModel  *stageModel=[[StageInfoModel alloc]init];
                    [stageModel setValuesForKeysWithDictionary:[hotDict objectForKey:@"stageinfo"]];
                    hotModel.stageinfo=stageModel;
                    
                  //  NSLog(@"热门数据的 hotmodel     ====%@",hotModel);
                    [_hotDataArray addObject:hotModel];
                    
                }
            }
          [_HotMoVieTableView reloadData];
           // NSLog(@"打印出来的热门数据，没有weibo ＝＝====%@",_hotDataArray);

        }
        else if(segment.selectedSegmentIndex==1)
        {
            if (_newDataArray==nil) {
                _newDataArray=[[NSMutableArray alloc]init];
            }
            //NSLog(@"最新数据 JSON: %@", responseObject);
            for (NSDictionary  *newdict  in Detailarray) {
                HotMovieModel *model =[[HotMovieModel alloc]init];
                if (model) {
                    [model setValuesForKeysWithDictionary:newdict];
                     StageInfoModel  *stagemodel=[[StageInfoModel alloc]init];
                    if (stagemodel) {
                        [stagemodel setValuesForKeysWithDictionary:[newdict objectForKey:@"stageinfo"]];
                        model.stageinfo=stagemodel;
                    }
                     WeiboModel  *weibomodel =[[WeiboModel alloc]init];
                    if (weibomodel) {
                        [weibomodel setValuesForKeysWithDictionary:[newdict objectForKey:@"weibo"]];
                        model.weibo=weibomodel;
                    }
                    [_newDataArray addObject:model];
                }
            }
          
           [_HotMoVieTableView reloadData];
        }
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
            HotMovieModel *hotModel=[_hotDataArray objectAtIndex:indexPath.row];

           // float  h=[hotModel.stageinfo.h floatValue];
            //float w=  [hotModel.stageinfo.w floatValue];
            hight=kDeviceWidth+45;
          //  if(h>w)
          // {
            // hight=  (h/w) *kDeviceWidth+45;
            //}
        }
        return hight+10;
    }
    else if (segment.selectedSegmentIndex==1)
    {
        float hight;
        if (_newDataArray.count>indexPath.row) {
            HotMovieModel   *hotmodel=[_newDataArray objectAtIndex:indexPath.row];
           // float  h=[hotmodel.stageinfo.h  floatValue];
            //float w=[hotmodel.stageinfo.w floatValue];
             hight= kDeviceWidth+90;
//             if(h>w)
//            {
//                hight=  (h/w)*kDeviceWidth+90;
//            }
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
             HotMovieModel  *hotModel=[_hotDataArray objectAtIndex:indexPath.row];
            cell.pageType=NSPageSourceTypeMainHotController;
            //小闪动标签的数组
            cell.WeibosArray =hotModel.weibos;
            cell.weiboDict=nil;
            cell.delegate=self;
            cell.StageInfoDict=hotModel.stageinfo;
            [cell ConfigsetCellindexPath:indexPath.row];
            //遵守stagview的协议，点击事件在controller里面响应
            cell.stageView.delegate=self;
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
           
            HotMovieModel   *hotmodel=[_newDataArray  objectAtIndex:indexPath.row];
            //配置cell的类型。
            cell.pageType=NSPageSourceTypeMainNewController;
            //根据类型配置cell的气泡数据
            cell.weiboDict =hotmodel.weibo; //[[_newDataArray  objectAtIndex:indexPath.row]  objectForKey:@"weibo"];
            //配置stage的数据
            cell.WeibosArray=nil;
            cell.delegate=self;
            cell.StageInfoDict=hotmodel.stageinfo;
            [cell ConfigsetCellindexPath:indexPath.row];
 
            //遵守了stageview的协议，点击事件在这里执行
            cell.stageView.delegate=self;
        }
        return  cell;
    }
    return nil;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        //点击cell 隐藏弹幕，再点击隐藏
        NSLog(@"didDeselectRowAtIndexPath  =====%ld",indexPath.row);
        CommonStageCell   *cell=(CommonStageCell *)[tableView cellForRowAtIndexPath:indexPath];
        if (isMarkViewsShow==YES) {
            isMarkViewsShow=NO;
            [cell.stageView  hidenAndShowMarkView:YES];

        }
        else{
              isMarkViewsShow=YES;
              [cell.stageView  hidenAndShowMarkView:NO];
        }
   
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
    
    HotMovieModel  *hotmovie;
    if (segment.selectedSegmentIndex==0) {
        hotmovie =[_hotDataArray objectAtIndex:index];
    }
    else  {
        hotmovie=[_newDataArray objectAtIndex:index];
    }
    if (button.tag==1000) {
        //电影按钮
        MovieDetailViewController *vc =  [MovieDetailViewController new];
        vc.movieId =  hotmovie.stageinfo.movie_id;
        [self.navigationController pushViewController:vc animated:YES];

    }
    else if (button.tag==2000)
    {
        //分享
        float hight= kDeviceWidth;
        float  ImageWith=[hotmovie.stageinfo.w intValue];
        float  ImgeHight=[hotmovie.stageinfo.h intValue];
        if(ImgeHight>ImageWith)
        {
            hight=  (ImgeHight/ImageWith) *kDeviceWidth;
        }
        CommonStageCell *cell = (CommonStageCell *)(button.superview.superview.superview);
        UIImage  *image=[Function getImage:cell.stageView WithSize:CGSizeMake(kDeviceWidth, hight)];
        //创建UMshareView 后必须配备这三个方法
        shareView.StageInfo=hotmovie.stageinfo;
        shareView.screenImage=image;
        [shareView configShareView];
        [self.view addSubview:shareView];
        self.tabBarController.tabBar.hidden=YES;
        if ([shareView respondsToSelector:@selector(showShareButtomView)]) {
            [shareView showShareButtomView];
            
        }

    }
    else if(button.tag==3000)
    {
        //添加弹幕
        AddMarkViewController  *AddMarkVC=[[AddMarkViewController alloc]init];
        AddMarkVC.stageInfoDict=hotmovie.stageinfo;
        AddMarkVC.model=hotmovie;
        AddMarkVC.delegate=self;
        //AddMarkVC.pageSoureType=NSAddMarkPageSourceDefault;
        NSLog(@"dict.stageinfo = %@", AddMarkVC.stageInfoDict);
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
#pragma mark  -----AddMarkViewControllerDelegate----
-(void)AddMarkViewControllerReturn
{
    [_HotMoVieTableView reloadData];
    
}


#pragma  mark  -----UMButtomViewshareViewDlegate------------------------
-(void)UMshareViewHandClick:(UIButton *)button ShareImage:(UIImage *)shareImage MoviewModel:(StageInfoModel *)StageInfo
{
    NSArray  *sharearray =[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQzone, UMShareToSina, nil];
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
    
        [[UMSocialControllerService defaultControllerService] setShareText:StageInfo.movie_name shareImage:shareImage socialUIDelegate:self];        //设置分享内容和回调对象
        [UMSocialSnsPlatformManager getSocialPlatformWithName:[sharearray  objectAtIndex:button.tag-10000]].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
        NSLog(@"分享到微信");
        self.tabBarController.tabBar.hidden=NO;
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
    //[_mymarkView CancelMarksetSelect];
    if (shareView) {
        [shareView HidenShareButtomView];
        [shareView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.5];
        self.tabBarController.tabBar.hidden=NO;

    }

}
//#pragma mark  --UMShareDelegate 友盟分享实现的功能

-(void)didCloseUIViewController:(UMSViewControllerType)fromViewControllerType
{
    //返回到app执行的方法，移除的时候应该写在这里
    NSLog(@"didCloseUIViewController第一步执行这个");
    if (shareView) {
        [shareView removeFromSuperview];

    }
    
}
//根据有的view 上次一张图片
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    NSLog(@"didFinishGetUMSocialDataInViewController第二部执行这个");
    if (shareView) {
        [shareView removeFromSuperview];
    }
   
}
-(void)didFinishGetUMSocialDataResponse:(UMSocialResponseEntity *)response;
{
    NSLog(@"didFinishGetUMSocialDataResponse第二部执行这个");
    if (shareView) {
        [shareView removeFromSuperview];
    }
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
-(void)ToolViewHandClick:(UIButton *)button :(MarkView *)markView weiboDict:(WeiboModel *)weiboDict StageInfo:(StageInfoModel *)stageInfoDict
{
    //把值全局化，有利于下面进行一系列的删除变身操作
    _TStageInfo=stageInfoDict;
    _TweiboInfo=weiboDict;
    
    NSLog(@"ToolViewHandClick  weibo dict ===%@",weiboDict);
    if (button.tag==10000) {
        ///点击了头像//进入个人页面
        MyViewController   *myVc=[[MyViewController alloc]init];
        myVc.author_id=weiboDict.user_id;
        [self.navigationController pushViewController:myVc animated:YES];
    }
#pragma mark     -----------分享
    else if (button.tag==10001)
    {
        NSLog(@" 点击了分享按钮");
        
        float hight= kDeviceWidth;
        float  ImageWith=[stageInfoDict.w intValue];
        float  ImgeHight=[stageInfoDict.h intValue];
        if(ImgeHight>ImageWith)
        {
            hight=  (ImgeHight/ImageWith) *kDeviceWidth;
        }
        CommonStageCell *cell = (CommonStageCell *)(markView.superview.superview.superview);
         UIImage  *image=[Function getImage:cell.stageView WithSize:CGSizeMake(kDeviceWidth, hight)];
       
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
#warning  确定举报
    else if(actionSheet.tag==504)
    {
        if (buttonIndex==0) {
            //确认举报
            [self requestReport];
         
        }
    }
}

//重新布局markview
-(void)layoutMarkViewWithMarkView:(MarkView  *) markView WeiboInfo:(WeiboModel *) weibodict
{
    
#pragma mark   缩放整体的弹幕大小
    [Function BasicAnimationwithkey:@"transform.scale" Duration:0.25 repeatcont:1 autoresverses:YES fromValue:1.0 toValue:1.05 View:markView];

    
    NSLog(@" 点赞 后 微博dict  ＝====uped====%@    ups===%@",weibodict.uped,weibodict.ups);

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
