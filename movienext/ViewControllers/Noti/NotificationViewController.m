//
//  NotificationViewController.m
//  movienext
//
//  Created by 风之翼 on 15/2/27.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "NotificationViewController.h"
//导入网络处理引擎框架
#import "AFNetworking.h"
//导入图片处理引擎框架
#import "UIImageView+WebCache.h"
//导入常量
#import "Constant.h"
//导入App delegate
#import "AppDelegate.h"
#import "NotificationTableViewCell.h"
#import "MyViewController.h"
//导入功能类
#import "Function.h"
#import "LoadingView.h"
#import "UserDataCenter.h"
#import "ZCControl.h"
#import "MJRefresh.h"
#import "userAddmodel.h"
#import "ShowStageViewController.h"
@interface NotificationViewController ()<UITableViewDataSource,UITableViewDelegate,LoadingViewDelegate,NotificationTableViewCellDelegate>
{
    LoadingView         *loadView;
    UITableView         *_myTableView;
    NSMutableArray      *_dataArray;
    int page;
    int pageSize;
    int pageCount;
}
@end

@implementation NotificationViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden=NO;
    self.navigationController.navigationBar.alpha=1;
    self.tabBarController.tabBar.hidden=NO;
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(changeUser) name:@"initUser" object:nil];
 

}
-(void)changeUser
{
    if (_myTableView) {
        [self headerRereshing];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"tabbar_backgroud_color.png"] forBarMetrics:UIBarMetricsDefault];

    UILabel  *titleLable=[ZCControl createLabelWithFrame:CGRectMake(0, 0, 100, 20) Font:16 Text:@"消息"];
    titleLable.textColor=VGray_color;
    titleLable.font=[UIFont boldSystemFontOfSize:18];
    titleLable.textAlignment=NSTextAlignmentCenter;
    self.navigationItem.titleView=titleLable;
   
    [self initData];
    [self initUI];
     [self creatLoadView];
    //[self requestData];
    
}
-(void)creatLoadView
{
    loadView =[[LoadingView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    loadView.delegate=self;
    [self.view addSubview:loadView];
    
}
-(void)initData
{
    page=1;
    pageSize=20;
    pageCount=1;
    _dataArray=[[NSMutableArray alloc]init];
}
-(void)initUI
{
    _myTableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0,kDeviceWidth, kDeviceHeight-kHeightNavigation)];
    _myTableView.delegate=self;
    _myTableView.dataSource=self;
    _myTableView.backgroundColor=[UIColor whiteColor];
    //_myTableView.separatorInset=UIEdgeInsetsMake(0, -110, 0, 0);
    [self.view addSubview:_myTableView];
    [self tablefootView];
    //集成mjrefresh
    [self setupRefresh];
    /**
     *  集成刷新控件
     */
}
-(void)tablefootView;
{
    UIView  *footView=[[UIView alloc]init];
    footView.backgroundColor=[UIColor clearColor];
    [_myTableView setTableFooterView:footView];
}
-(void)setupRefresh
{
        // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
        [_myTableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    //  #warning 自动刷新(一进入程序就下拉刷新)
        [_myTableView headerBeginRefreshing];
        // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
        [_myTableView addFooterWithTarget:self action:@selector(footerRereshing)];
}
#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    page=1;
    if (_dataArray.count>0) {
        [_dataArray removeAllObjects];
    }
    
    [self requestData];
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        //[_myTableView reloadData];
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [_myTableView headerEndRefreshing];
    });
}

- (void)footerRereshing
{
    if (pageCount>page) {
    page++;
    [self  requestData];
    }
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        //[_myTableView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [_myTableView footerEndRefreshing];
    });
}


-(void)requestData
{
    UserDataCenter *userCenter=[UserDataCenter shareInstance];
    NSDictionary *parameters = @{@"user_id":userCenter.user_id};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
     NSString  *urlString=[NSString stringWithFormat:@"%@/noti-up/list?per-page=%d&page=%d", kApiBaseUrl,pageSize,page];
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"code"] intValue]==0) {
            NSLog(@"消息通知返回的数据====%@",responseObject);
            if (_dataArray==nil) {
                _dataArray=[[NSMutableArray alloc]init];
            }
            //解析数据[_dataArray addObjectsFromArray:[responseObject objectForKey:@"models"]];
            NSMutableArray  *array =[[NSMutableArray alloc]initWithArray:[responseObject objectForKey:@"models"]];
            
            if (_dataArray==nil) {
                _dataArray =[[NSMutableArray alloc]init];
            }
            for (NSDictionary  *noDcit in array) {
                userAddmodel  *model =[[userAddmodel alloc]init];
                if (model) {
                    [model setValuesForKeysWithDictionary:noDcit];
                    weiboInfoModel *weibomodel =[[weiboInfoModel alloc]init];
                    if (weibomodel) {
                        if (![[noDcit objectForKey:@"weibo"] isKindOfClass:[NSNull class]]) {
                        [weibomodel setValuesForKeysWithDictionary:[noDcit objectForKey:@"weibo"]];
                            
                        weiboUserInfoModel *user =[[weiboUserInfoModel alloc]init];
                        [user setValuesForKeysWithDictionary:[[noDcit objectForKey:@"weibo"] objectForKey:@"user"]];
                        weibomodel.uerInfo=user;
                        
                        stageInfoModel *stagemodel =[[stageInfoModel alloc]init];
                        [stagemodel setValuesForKeysWithDictionary:[[noDcit objectForKey:@"weibo"] objectForKey:@"stage"]];
                        weibomodel.stageInfo=stagemodel;
                        model.weiboInfo=weibomodel;
                     }
                    }
                    weiboUserInfoModel  *user =[[weiboUserInfoModel alloc]init];
                    model.userInfo=user;
                    [_dataArray addObject:model];
                }
            }
         
            if ([_dataArray count]==0) {
                [loadView showNullView:@"还没有消息"];
                return ;
            }
            else
            {
              [loadView stopAnimation];
              [loadView removeFromSuperview];
              [_myTableView reloadData];
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

#pragma mark ----  UITableViewDelegate
-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==_myTableView) {
        return _dataArray.count;
    }
    return 0;
}
-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==_myTableView) {
        return 60.0f;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static  NSString  *cellID=@"cell";
    NotificationTableViewCell  *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell=[[NotificationTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    if (_dataArray.count>indexPath.row) {
        //[cell setValueforCell:[_dataArray  objectAtIndex:indexPath.row] index:indexPath.row];
        userAddmodel  *model =[_dataArray objectAtIndex:indexPath.row];
        [cell setValueforCell:model index:indexPath.row];
        cell.delegate=self;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShowStageViewController *vc = [[ShowStageViewController alloc] init];
    userAddmodel  *model =[_dataArray objectAtIndex:indexPath.row];
    vc.stageInfo=model.weiboInfo.stageInfo;
    UIBarButtonItem  *item =[[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem=item;
    [self.navigationController pushViewController:vc animated:YES];
    
}
////这个方法
//-(void)dealHeadClick:(UIButton  *)button
//{
//    NSLog(@"button.tag = %ld", button.tag);
//    MyViewController  *myVC=[[MyViewController alloc]init];
//    NSDictionary *dict = [_dataArray objectAtIndex:button.tag-6000];
//    myVC.author_id = [dict valueForKey:@"user_id"];
//    NSLog(@"dict = %@", dict);
//    NSLog(@"dict.user_id = %@", [dict valueForKey:@"user_id"]);
//    [self.navigationController pushViewController:myVC animated:YES];
//    
//}
//
#pragma  mark NotificationTableViewCellDelegate ----------------------------
-(void)NotificationClick:(UIButton *)button indexPath:(NSInteger)index
{
    if (button.tag==100||button.tag==101) {
      //  NSLog(@"button.tag = %ld", button.tag);
        
        MyViewController  *myVC=[[MyViewController alloc]init];
        userAddmodel *model =[_dataArray objectAtIndex:index];
        myVC.author_id=[NSString stringWithFormat:@"%@",model.weiboInfo.uerInfo.Id];
         [self.navigationController pushViewController:myVC animated:YES];
    }
   
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:nil name:@"initUser" object:nil];
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
