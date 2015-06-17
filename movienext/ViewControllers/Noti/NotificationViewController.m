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
static const CGFloat MJDuration = 1.0;

@interface NotificationViewController ()<UITableViewDataSource,UITableViewDelegate,LoadingViewDelegate,NotificationTableViewCellDelegate>
{
    LoadingView         *loadView;
    //UITableView         *_myTableView;
    NSMutableArray      *_dataArray;
    int page;
    int pageSize;
    int pageCount;
}

@property(nonatomic,strong) UITableView   *myTableView;
@end

@implementation NotificationViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden=NO;
    self.navigationController.navigationBar.alpha=1;
    self.tabBarController.tabBar.hidden=NO;
    
    //    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(changeUser) name:@"initUser" object:nil];
    
    
}
/*-(void)changeUser
 {
 if (_myTableView) {
 [self headerRereshing];
 }
 }*/

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"tabbar_backgroud_color.png"] forBarMetrics:UIBarMetricsDefault];
    
    UILabel  *titleLable=[ZCControl createLabelWithFrame:CGRectMake(0, 0, 100, 20) Font:16 Text:@"消息"];
    titleLable.textColor=VGray_color;
    titleLable.font=[UIFont boldSystemFontOfSize:16];
    titleLable.textAlignment=NSTextAlignmentCenter;
    self.navigationItem.titleView=titleLable;
    
    [self initData];
    [self initUI];
    [self creatLoadView];
    [self requestData];
    
}
-(void)creatLoadView
{
    loadView =[[LoadingView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    loadView.delegate=self;
    [self.myTableView addSubview:loadView];
    
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
    [self steupRefresh];
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
- (void)steupRefresh
{
    // 添加传统的下拉刷新
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    [self.myTableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    // 设置文字
    [self.myTableView.header setTitle:@"下拉刷新..." forState:MJRefreshHeaderStateIdle];
    [self.myTableView.header setTitle:@"释放刷新..." forState:MJRefreshHeaderStatePulling];
    [self.myTableView.header setTitle:@"正在刷新..." forState:MJRefreshHeaderStateRefreshing];
    //隐藏时间
    self.myTableView.header.updatedTimeHidden=YES;
    
    // 设置字体
    self.myTableView.header.font = [UIFont systemFontOfSize:12];
    
    // 设置颜色
    self.myTableView.header.textColor = VGray_color;
    
    // 马上进入刷新状态
    // [self.myTableView.header beginRefreshing];
    
    // 此时self.tableView.header == self.tableView.legendHeader
    
    
#pragma mark UITableView + 上拉刷新 自定义文字
    // 添加传统的上拉刷新
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    [self.myTableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    // 设置文字
    [self.myTableView.footer setTitle:@"点击加载更多..." forState:MJRefreshFooterStateIdle];
    [self.myTableView.footer setTitle:@"加载更多..." forState:MJRefreshFooterStateRefreshing];
    [self.myTableView.footer setTitle:@"THE END" forState:MJRefreshFooterStateNoMoreData];
    
    // 设置字体
    self.myTableView.footer.font = [UIFont systemFontOfSize:12];
    
    // 设置颜色
    self.myTableView.footer.textColor = VGray_color;
    
    // 此时self.tableView.footer == self.tableView.legendFooter
}
- (void)example14
{
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadLastData方法）
  //  self.myTableView.footer = [footerWithRefreshingTarget:self refreshingAction:@selector(loadLastData)];
    
    
}
//下拉刷新
-(void)loadNewData
{   //[self.myTableView.footer resetNoMoreData];
    page=1;
    if (_dataArray.count>0) {
        [_dataArray removeAllObjects];
    }
    [self requestData];
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.myTableView reloadData];
        
        // 拿到当前的下拉刷新控件，结束刷新状态
        [self.myTableView.header endRefreshing];
    });
}
// 加载更多
-(void)loadMoreData
{
    
    if (pageCount>page) {
        page++;
        [self  requestData];
    }
    else
    {
        [self.myTableView.footer noticeNoMoreData];
        [self.myTableView.footer setTextColor:VLight_GrayColor];
    }
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        //[self.myTableView reloadData];
        
        // 拿到当前的上拉刷新控件，结束刷新状态
       // [self.myTableView.footer endRefreshing];
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
            pageCount=[[responseObject objectForKey:@"pageCount"] intValue];
//            if (page==pageCount-1) {
//                [self.myTableView.footer noticeNoMoreData];
//                [self.myTableView.footer setTextColor:VLight_GrayColor];
//            }
//            
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
                    if (user) {
                        [user setValuesForKeysWithDictionary:[noDcit objectForKey:@"user"]];
                        model.userInfo=user;
                    }
                    [_dataArray addObject:model];
                }
            }
            // 拿到当前的上拉刷新控件，结束刷新状态
            
            if ([_dataArray count]==0) {
                [loadView showNullView:@"还没有消息"];
                return ;
            }
            else
            {
                [loadView stopAnimation];
                [loadView removeFromSuperview];
                [_myTableView reloadData];
                [self.myTableView.footer endRefreshing];

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
        cell.selectionStyle=UITableViewCellSelectionStyleGray;
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ShowStageViewController *vc = [[ShowStageViewController alloc] init];
    userAddmodel  *model =[_dataArray objectAtIndex:indexPath.row];
    vc.stageInfo=model.weiboInfo.stageInfo;
    vc.weiboInfo=model.weiboInfo;
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
        myVC.author_id=[NSString stringWithFormat:@"%@",model.userInfo.Id];
        UIBarButtonItem  *item =[[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        myVC.pageType=NSMyPageTypeOthersController;
        self.navigationItem.backBarButtonItem=item;
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
