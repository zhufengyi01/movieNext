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
#import "MJRefresh.h"

//#import  "SearchMovieViewController.h"
@interface MovieViewController ()<UISearchBarDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,LoadingViewDelegate>
{
    //UICollectionView    *_myConllectionView;
    LoadingView         *loadView;
    NSMutableArray      *_dataArray;
    //int page;
    NSString  *startId;
}

@end

@implementation MovieViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden=NO;
    self.navigationController.navigationBar.alpha=1;
    //self.tabBarController.tabBar.hidden=NO;
   // if (self.myConllectionView) {
     //[  self.myConllectionView headerBeginRefreshing];
    //}
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    self.tabBarController.tabBar.hidden=NO;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //创建导航
    //self.view.backgroundColor=[UIColor whiteColor];
    [self createNavigation];
    [self createSegmentView];
    [self initData];
    [self initUI];
    [self creatLoadView];
    //[self requestData];
       
}
-(void)createNavigation
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"tabbar_backgroud_color.png"] forBarMetrics:UIBarMetricsDefault];
    UISearchBar  *search=[[UISearchBar alloc]initWithFrame:CGRectMake(20, 10, kDeviceWidth-40, 28)];
    search.placeholder=@"搜索电影";
    search.delegate=self;
    search.searchBarStyle = UISearchBarStyleMinimal;
    //search.barStyle=UIBarStyleDefault;
    //search.barTintColor=VGray_color;
    //search.alpha=0.3;
     search.backgroundColor=[UIColor clearColor];
//    [[search.subviews objectAtIndex:0]removeFromSuperview];
    self.navigationItem.titleView=search;
    
}
-(void)createSegmentView
{
    UIImageView   *TopImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0,0, kDeviceWidth, 30)];
    ///TopImageView.image=[UIImage imageNamed:@"tab_switch.png"];
    TopImageView.backgroundColor=[UIColor whiteColor];
    UILabel  *lable=[ZCControl createLabelWithFrame:CGRectMake(0, 0, kDeviceWidth, 30) Font:14 Text:@"下面是添加了很多弹幕的电影"];
    lable.textColor=VGray_color;
    lable.textAlignment=NSTextAlignmentCenter;
    [TopImageView addSubview:lable];
    [self.view addSubview:TopImageView];
}
-(void)creatLoadView
{
    loadView =[[LoadingView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    loadView.delegate=self;
    [self.view addSubview:loadView];
    
}
-(void)initData
{
    //page=0;
    _dataArray=[[NSMutableArray alloc]init];
}
-(void)initUI
{
    
    UICollectionViewFlowLayout    *layout=[[UICollectionViewFlowLayout alloc]init];
    layout.minimumInteritemSpacing=10; //cell之间左右的
    layout.minimumLineSpacing=10;      //cell上下间隔
    //layout.itemSize=CGSizeMake(80,140);  //cell的大小
    layout.sectionInset=UIEdgeInsetsMake(10, 10, 10, 10); //整个偏移量 上左下右
    
    _myConllectionView =[[UICollectionView alloc]initWithFrame:CGRectMake(0, 30,kDeviceWidth, kDeviceHeight-30-kHeightNavigation-kHeigthTabBar) collectionViewLayout:layout];
    _myConllectionView.backgroundColor=View_BackGround;
    [_myConllectionView registerClass:[MovieCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    _myConllectionView.delegate=self;
    _myConllectionView.dataSource=self;
    [self.view addSubview:_myConllectionView];
    [self setupHeadView];
    [self setupFootView];
    
    /**
     *  集成刷新控件
     */
}
- (void)setupHeadView
{
    __unsafe_unretained typeof(self) vc = self;
    // 添加下拉刷新头部控件
    [_myConllectionView addHeaderWithCallback:^{
        // 进入刷新状态就会回调这个Block
        [vc requestData];
        
        // 模拟延迟加载数据，因此2秒后才调用）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [vc.myConllectionView reloadData];
            // 结束刷新
            [vc.myConllectionView headerEndRefreshing];
        });
    }];
    
#warning 自动刷新(一进入程序就下拉刷新)
    [vc.myConllectionView headerBeginRefreshing];
}

- (void)setupFootView
{
    __unsafe_unretained typeof(self) vc = self;
    // 添加上拉刷新尾部控件
    [vc.myConllectionView addFooterWithCallback:^{
        // 进入刷新状态就会回调这个Block
        
        [vc requestData];
        // 增加5条假数据
      ///  for (int i = 0; i<5; i++) {
         //   [vc.fakeColors addObject:MJRandomColor];
        //}
        
        // 模拟延迟加载数据，因此2秒后才调用）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [vc.myConllectionView reloadData];
            // 结束刷新
            [vc.myConllectionView footerEndRefreshing];
        });
    }];
}

/**
 为了保证内部不泄露，在dealloc中释放占用的内存
 */
- (void)dealloc
{
    NSLog(@"MJCollectionViewController--dealloc---");
}

#pragma  mark  ---
#pragma  mark  ----RequestData
#pragma  mark  ---
-(void)requestData
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //NSString  *startid =[[_dataArray lastObject]  objectForKey:@"create_time"];
    NSDictionary  *parameter;
    if (_dataArray.count==0) {
        parameter=nil;
    }
    else
    {
        parameter=@{@"start_id":startId};

    }
    [manager POST:[NSString stringWithFormat:@"%@/feed/list", kApiBaseUrl] parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"return_code"] intValue]==10000) {

        NSLog(@"  电影首页数据JSON: %@", responseObject);
            [loadView stopAnimation];
            [loadView removeFromSuperview];
        if (_dataArray==nil) {
            _dataArray=[[NSMutableArray alloc]init];
        }
        if ([responseObject objectForKey:@"detail"]) {
            
        }
        if ([[responseObject objectForKey:@"detail"] lastObject]) {
            startId=[[[responseObject objectForKey:@"detail"] lastObject] objectForKey:@"create_time"];
         
            NSArray  *detailarray=[responseObject objectForKey:@"detail"];
            if (detailarray.count>0) {
                [_dataArray addObjectsFromArray:detailarray];
                //NSLog(@"=-=======dataArray =====%@",_dataArray);
                [_myConllectionView reloadData];
                
            }

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
     cell.backgroundColor=[UIColor whiteColor];
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
  //  MovieCollectionViewCell    *cell=(MovieCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
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
