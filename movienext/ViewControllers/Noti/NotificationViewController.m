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
//导入功能类
#import "Function.h"
#import "LoadingView.h"
#import "UserDataCenter.h"
#import "ZCControl.h"
#import "MJRefresh.h"
@interface NotificationViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    LoadingView         *loadView;
    UITableView         *_myTableView;
    NSMutableArray      *_dataArray;
    int page;
}
@end

@implementation NotificationViewController
-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden=NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor =View_BackGround;
    UILabel  *titleLable=[ZCControl createLabelWithFrame:CGRectMake(0, 0, 100, 20) Font:16 Text:@"消息"];
    titleLable.textColor=VBlue_color;
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
    [self.view addSubview:loadView];
    
}
-(void)initData
{
    page=0;
    _dataArray=[[NSMutableArray alloc]init];
}
-(void)initUI
{
    _myTableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0,kDeviceWidth, kDeviceHeight)];
    _myTableView.delegate=self;
    _myTableView.dataSource=self;
    _myTableView.separatorInset=UIEdgeInsetsMake(0, -110, 0, 0);
    [self.view addSubview:_myTableView];
    //集成mjrefresh
    [self setupRefresh];
    /**
     *  集成刷新控件
     */
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
    page=0;
    [self requestData];
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [_myTableView reloadData];
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [_myTableView headerEndRefreshing];
    });
}

- (void)footerRereshing
{
    page++;
    [self  requestData];
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [_myTableView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [_myTableView footerEndRefreshing];
    });
}



-(void)requestData
{
    UserDataCenter *userCenter=[UserDataCenter shareInstance];
    NSDictionary *parameters = @{@"author_id":@"18",@"page":[NSString stringWithFormat:@"%d",page]};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/notiUp/list", kApiBaseUrl] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (page==0) {
            [loadView stopAnimation];
            [loadView removeFromSuperview];
        }
        if (_dataArray==nil) {
            _dataArray=[[NSMutableArray alloc]init];
        }
        [_dataArray addObjectsFromArray:[responseObject objectForKey:@"detail"]];
       // NSLog(@"=-=======dataArray =====%@",_dataArray);
        [_myTableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

    
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
        return 80.0f;
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
        [cell setValueforCell:[_dataArray  objectAtIndex:indexPath.row] index:indexPath.row];
    }
    return cell;
}
//这个方法
-(void)dealHeadClick:(UIButton  *)button
{
    
    
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
