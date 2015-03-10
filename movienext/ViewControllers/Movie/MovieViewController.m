//
//  MovieViewController.m
//  movienext
//
//  Created by 风之翼 on 15/2/27.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "MovieViewController.h"
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
#import "MovieSearchViewController.h"
#import "MovieCollectionViewCell.h"
#import "MovieDetailViewController.h"
#warning  等下要删掉
#import "MovieDetailViewController.h"

//#import  "SearchMovieViewController.h"
@interface MovieViewController ()<UISearchBarDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    UICollectionView    *_myConllectionView;
    LoadingView         *loadView;
    NSMutableArray      *_dataArray;
    int page;
}

@end

@implementation MovieViewController
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden=NO;
    self.tabBarController.tabBar.hidden=NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=View_BackGround;
    
    //创建导航
    [self createNavigation];
    [self createSegmentView];
    [self initData];
    [self initUI];
    [self creatLoadView];
    [self requestData];
       
}
-(void)createNavigation
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"tabbar_backgroud_color.png"] forBarMetrics:UIBarMetricsDefault];
    UISearchBar  *search=[[UISearchBar alloc]initWithFrame:CGRectMake(20, 10, kDeviceWidth-40, 28)];
    search.placeholder=@"搜索电影";
    search.delegate=self;
    self.navigationItem.titleView=search;
    
}
-(void)createSegmentView
{
    UIImageView   *TopImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0,0, kDeviceWidth, 30)];
    TopImageView.image=[UIImage imageNamed:@"kind_swtich.png"];
    [self.view addSubview:TopImageView];
    
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
    
    UICollectionViewFlowLayout    *layout=[[UICollectionViewFlowLayout alloc]init];
    layout.minimumInteritemSpacing=10; //cell之间左右的
    layout.minimumLineSpacing=10;      //cell上下间隔
    //layout.itemSize=CGSizeMake(80,140);  //cell的大小
    layout.sectionInset=UIEdgeInsetsMake(20, 10, 10, 10); //整个偏移量 上左下右
    
    _myConllectionView =[[UICollectionView alloc]initWithFrame:CGRectMake(0, 30,kDeviceWidth, kDeviceHeight-30-kHeightNavigation-kHeigthTabBar) collectionViewLayout:layout];
    _myConllectionView.backgroundColor=View_BackGround;
    [_myConllectionView registerClass:[MovieCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    _myConllectionView.delegate=self;
    _myConllectionView.dataSource=self;
    [self.view addSubview:_myConllectionView];
    [self setupRefresh];
    /**
     *  集成刷新控件
     */
}
-(void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    //[_myTableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    //  #warning 自动刷新(一进入程序就下拉刷新)
    //[_myTableView headerBeginRefreshing];
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
  //  [_myTableView addFooterWithTarget:self action:@selector(footerRereshing)];
}
#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    page=0;
    [self requestData];
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
      //  [_myTableView reloadData];
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        //[_myTableView headerEndRefreshing];
    });
}

- (void)footerRereshing
{
    page++;
    [self  requestData];
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        //[_myTableView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        //[_myTableView footerEndRefreshing];
    });
}
#pragma  mark  ---
#pragma  mark  ----RequestData
#pragma  mark  ---
-(void)requestData
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/feed/list", kApiBaseUrl] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"  电影首页数据JSON: %@", responseObject);
            [loadView stopAnimation];
            [loadView removeFromSuperview];
        
        if (_dataArray==nil) {
            _dataArray=[[NSMutableArray alloc]init];
        }
        [_dataArray addObjectsFromArray:[responseObject objectForKey:@"detail"]];
        NSLog(@"=-=======dataArray =====%@",_dataArray);
        [_myConllectionView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (collectionView==_myConllectionView) {
        return 1;
    }
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView==_myConllectionView) {
        return _dataArray.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //在这里先将内容给清除一下, 然后再加载新的, 添加完内容之后先动画, 在cell消失的时候做清理工作
    MovieCollectionViewCell    *cell=(MovieCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    NSLog(@"   圣诞节可视电话首都华盛顿老师=======index.item  %ld --- index.row  ==%ld",indexPath.item,indexPath.row);
    if (_dataArray.count > indexPath.row) {
     [cell setValueforCell:[_dataArray  objectAtIndex:(long)indexPath.row]];
     //cell.backgroundColor=[UIColor whiteColor];
    }
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    int width = ((kDeviceWidth-4*12)/3);
    int movieNameMarginTop = 10;
    int movieNameHeight = 20;
    return CGSizeMake( width, width*1.5 + movieNameMarginTop + movieNameHeight);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"=====点击了那个cell ===%ld",indexPath.row);
    [self hidesBottomBarWhenPushed];
    
    MovieDetailViewController *vc =  [MovieDetailViewController new];
    MovieCollectionViewCell    *cell=(MovieCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (_dataArray.count > indexPath.row) {
         NSDictionary *dict = [_dataArray  objectAtIndex:(long)indexPath.row];
        vc.movieId = [dict objectForKey:@"movie_id"];
    }
   [self.navigationController pushViewController:vc animated:YES];
}


#pragma  mark  ------
#pragma  mark  ------- searchBardelgate
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    UINavigationController  *search=[[UINavigationController alloc]initWithRootViewController:[MovieSearchViewController new]];
      [self presentViewController:search animated:YES completion:nil];
    return NO;
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
