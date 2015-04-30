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
#import "UIImage-Helpers.h"
#define  BUTTON_COUNT  3
@interface MovieViewController ()<UISearchBarDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,LoadingViewDelegate,MovieCollectionViewCellDelegate,UIActionSheetDelegate>
{
    LoadingView         *loadView;
    int page;
    int pageSize;
    NSString  *startId;
    int pageCount;
    NSInteger Rowindex;
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
   // [[UINavigationBar appearance] setShadowImage:[UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(kDeviceWidth, 1)]];

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
   
     search.backgroundColor=[UIColor clearColor];
     self.navigationItem.titleView=search;
}
-(void)createSegmentView
{
    UIImageView   *TopImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0,0, kDeviceWidth, 30)];
   // TopImageView.backgroundColor=VGray_color;
    ///TopImageView.image=[UIImage imageNamed:@"tab_switch.png"];
    TopImageView.backgroundColor=[UIColor whiteColor];
    TopImageView.userInteractionEnabled=YES;
    [self.view addSubview:TopImageView];
    
    NSArray  *titleArray =@[@"影院热映",@"网上热门",@"经典"];
    for (int i =0; i<BUTTON_COUNT; i++) {
        
        double  x=i*(kDeviceWidth/3);
        double  y=0;
        double  width=kDeviceWidth/3;
        double  height=40;
        UIButton  *btn=[ZCControl createButtonWithFrame:CGRectMake(x,y,width,height) ImageName:nil Target:self Action:@selector(dealSegmentClick:) Title:titleArray[i]];
        //=View_BackGround;
        [btn setTitleColor:VGray_color forState:UIControlStateNormal];
        [btn setTitleColor:VBlue_color forState:UIControlStateSelected];
        btn.titleLabel.font=[UIFont boldSystemFontOfSize:15];
       // [btn setBackgroundImage:[UIImage imageNamed:@"tabbar_backgroud_color.png"] forState:UIControlStateNormal];
        btn.backgroundColor=  [UIColor colorWithPatternImage:[UIImage imageNamed:@"tabbar_backgroud_color.png"]];
        btn.tag=100+i;
        if (i==0) {
            btn.selected=YES;
        }
        [TopImageView addSubview:btn];
    }
    
}
-(void)dealSegmentClick:(UIButton *) btn
{
 
    if (btn.tag==100) {
        if(btn.selected==NO)
        {
           for ( int i=0; i<3; i++) {
             UIButton  *button=(UIButton *)[self.view viewWithTag:i+100];
             button.selected=NO;
            }
            btn.selected=YES;
        }
        else if (btn.selected==YES)
        {
        }
        
    }
    else if (btn.tag==101)
    {
     
        if(btn.selected==NO)
        {
            for ( int i=0; i<3; i++) {
                UIButton  *button=(UIButton *)[self.view viewWithTag:i+100];
                button.selected=NO;
            }
            btn.selected=YES;
            if (self.dataArray2.count==0) {
                [self requestData];
            }
        }
        else if (btn.selected==YES)
        {
            
        }
        

    }
    else if(btn.tag==102)
    {
        if(btn.selected==NO)
        {
            for ( int i=0; i<3; i++) {
                UIButton  *button=(UIButton *)[self.view viewWithTag:i+100];
                button.selected=NO;
            }
            btn.selected=YES;
            if (self.dataArray3.count==0) {
                [self requestData];
            }
        }
        else if (btn.selected==YES)
        {
            
        }
        
    }
   [self.myConllectionView reloadData];
    
}
-(void)creatLoadView
{
    loadView =[[LoadingView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    loadView.delegate=self;
    [self.view addSubview:loadView];
    
}
-(void)initData
{
    page=0;
    pageSize=12;
    _dataArray1=[[NSMutableArray alloc]init];
    _dataArray2=[[NSMutableArray alloc]init];
    _dataArray3=[[NSMutableArray alloc]init];

}
-(void)initUI
{
    
    UICollectionViewFlowLayout    *layout=[[UICollectionViewFlowLayout alloc]init];
    layout.minimumInteritemSpacing=20; //cell之间左右的
    layout.minimumLineSpacing=20;      //cell上下间隔
    //layout.itemSize=CGSizeMake(80,140);  //cell的大小
    layout.sectionInset=UIEdgeInsetsMake(10, 20, 10, 20); //整个偏移量 上左下右
    
    _myConllectionView =[[UICollectionView alloc]initWithFrame:CGRectMake(0, 40,kDeviceWidth, kDeviceHeight-40-kHeightNavigation-kHeigthTabBar) collectionViewLayout:layout];
    _myConllectionView.backgroundColor=[UIColor whiteColor];
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
        page=1;
        for (int i=0;i<3;i++) {
            UIButton  *btn=(UIButton *) [vc.view viewWithTag:100+i];
            if (i==0&&btn.selected==YES) {
                if (_dataArray1.count>0) {
                    [vc.dataArray1 removeAllObjects];
                }
                break;

            }
            else if(i==1&&btn.selected==YES)
            {
                if (_dataArray2.count>0) {
                    [vc.dataArray2 removeAllObjects];
                }
                break;

                
            }
            else if (i==2&&btn.selected==YES)
            {
                
                if (_dataArray3.count>0) {
                    [vc.dataArray3 removeAllObjects];
                }
                break;

            }
            
        }
        // 进入刷新状态就会回调这个Block
        [vc requestData];

        // 模拟延迟加载数据，因此2秒后才调用）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
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
        if (pageCount>page) {
            page ++;
            [vc requestData];

        }
        
        // 进入刷新状态就会回调这个Block
        //page++;

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
//删除电影
-(void)requestDeletMovieWithMovieId:(NSString *) movie_id
{
    
    UserDataCenter  *userCenter=[UserDataCenter shareInstance];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters=@{@"user_id":userCenter.user_id,@"feed_id":movie_id};
    [manager POST:[NSString stringWithFormat:@"%@/feed/delete", kApiBaseUrl] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject  objectForKey:@"code"]  intValue]==0) {
            NSLog(@"删除成功=======%@",responseObject);
            UIAlertView *al =[[UIAlertView alloc]initWithTitle:@"删除成功" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [al show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

-(void)requestData
{
    
    NSString  *type;
    for (int i=0;i<3;i++) {
        UIButton  *btn=(UIButton *) [self.view viewWithTag:100+i];
        if (i==0&&btn.selected==YES) {
            type=@"1";
            break;
        }
        else if(i==1&&btn.selected==YES)
        {
            type=@"2";
            break;
        }
        else if (i==2&&btn.selected==YES)
        {
            type=@"3";
            break;
            
        }
        
    }
    NSDictionary  *parameters =@{@"type":type};
    NSString  *urlString=[NSString stringWithFormat:@"%@/feed/list?per-page=%d&page=%d",kApiBaseUrl,pageSize,page];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"return_code"] intValue]==0) {

        NSLog(@"  电影首页数据JSON: %@", responseObject);
            [loadView stopAnimation];
            [loadView removeFromSuperview];
            
            for (int i=0;i<3;i++) {
                UIButton  *btn=(UIButton *) [self.view viewWithTag:100+i];
                if (i==0&&btn.selected==YES) {
                    
                    if (_dataArray1==nil) {
                        _dataArray1=[[NSMutableArray alloc]init];
                    }
                    NSArray  *detailarray=[responseObject objectForKey:@"models"];
                    pageCount =[[responseObject objectForKey:@"pageCount"] intValue];
                    if (detailarray.count>0) {
                        [_dataArray1 addObjectsFromArray:detailarray];
                    }
                }
                else if (i==1&&btn.selected==YES)
                {
                    
                    if (_dataArray2==nil) {
                        _dataArray2=[[NSMutableArray alloc]init];
                    }
                    NSArray  *detailarray=[responseObject objectForKey:@"models"];
                    pageCount =[[responseObject objectForKey:@"pageCount"] intValue];
                    if (detailarray.count>0) {
                        [_dataArray2 addObjectsFromArray:detailarray];
                    }
                }
                else if (i==2&&btn.selected==YES)
                {
                    
                    if (_dataArray3==nil) {
                        _dataArray3=[[NSMutableArray alloc]init];
                    }
                    NSArray  *detailarray=[responseObject objectForKey:@"models"];
                    pageCount =[[responseObject objectForKey:@"pageCount"] intValue];
                    if (detailarray.count>0) {
                        [_dataArray3 addObjectsFromArray:detailarray];
                    }
                }
            }
            
            [_myConllectionView reloadData];

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
    
    for (int i=0;i<3;i++) {
        UIButton  *btn=(UIButton *) [self.view viewWithTag:100+i];
        if (i==0&&btn.selected==YES) {
            return _dataArray1.count;
            break;
            
        }
        else if(i==1&&btn.selected==YES)
        {
            return _dataArray2.count;
            break;
        }
        else if (i==2&&btn.selected==YES)
        {
            return _dataArray3.count;
            break;
        }
    
    }
    return 0;

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    NSMutableArray  *array=[[NSMutableArray alloc]init];;
    for (int i=0;i<3;i++) {
        UIButton  *btn=(UIButton *) [self.view viewWithTag:100+i];
        if (i==0&&btn.selected==YES) {
            array=_dataArray1;
            break;
        }
        else if(i==1&&btn.selected==YES)
        {
            array=_dataArray2;
            break;
         }
        else if (i==2&&btn.selected==YES)
        {
            array=_dataArray3;
            break;
            
        }
    }
    MovieCollectionViewCell    *cell=(MovieCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
     if (array.count > indexPath.row) {
    
     [cell setValueforCell:[array  objectAtIndex:(long)indexPath.row] inRow:indexPath.row];
      cell.delegate=self;
     cell.Cellindex=indexPath.row;
     cell.backgroundColor=[UIColor whiteColor];
    }
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    int width = ((kDeviceWidth-6*16)/3);
    int movieNameMarginTop = 10;
    int movieNameHeight = 10;
    return CGSizeMake( width, width*1.5 + movieNameMarginTop + movieNameHeight);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray  *array=[[NSMutableArray alloc]init];;
    for (int i=0;i<3;i++) {
        UIButton  *btn=(UIButton *) [self.view viewWithTag:100+i];
        if (i==0&&btn.selected==YES) {
            array=_dataArray1;
            break;
        }
        else if(i==1&&btn.selected==YES)
        {
            array=_dataArray2;
            break;
        }
        else if (i==2&&btn.selected==YES)
        {
            array=_dataArray3;
            break;
        }
    }
    [self hidesBottomBarWhenPushed];
    MovieDetailViewController *vc =  [MovieDetailViewController new];
    if (array.count > indexPath.row) {
         NSDictionary *dict = [array  objectAtIndex:(long)indexPath.row];
        vc.movieId = [dict objectForKey:@"movie_id"];
    }
   [self.navigationController pushViewController:vc animated:YES];
}
-(void)MovieCollectionViewlongPress:(NSInteger)cellRowIndex
{
    Rowindex=cellRowIndex;
    UIActionSheet  *ash =[[UIActionSheet alloc]initWithTitle:@"确定删除电影" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:nil, nil];
    ash.tag=1000;
    [ash showInView:self.view];
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag==1000) {
        if (buttonIndex==0) {
            NSString *movie_id;
            for (int i=0;i<3;i++) {
                UIButton  *btn=(UIButton *) [self.view viewWithTag:100+i];
                if (i==0&&btn.selected==YES) {
                    //请求删除接口
                    movie_id =[[_dataArray1 objectAtIndex:Rowindex]  objectForKey:@"id"];
                    [_dataArray1 removeObjectAtIndex:Rowindex];
                    break;
                
                 }
                else if(i==1&&btn.selected==YES)
                {
                    movie_id =[[_dataArray2 objectAtIndex:Rowindex]  objectForKey:@"id"];
                    [_dataArray2 removeObjectAtIndex:Rowindex];
                    break;
                 }
                else if (i==2&&btn.selected==YES)
                {
                    movie_id =[[_dataArray3 objectAtIndex:Rowindex]  objectForKey:@"id"];
                    [_dataArray3 removeObjectAtIndex:Rowindex];
                    break;
                    
                 }
            }
            
            [self requestDeletMovieWithMovieId:movie_id];
            
        }
    }
}

#pragma  mark  ------
#pragma  mark  ------- searchBardelgate------------
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    UINavigationController  *search=[[UINavigationController alloc]initWithRootViewController:[MovieSearchViewController new]];
      search.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
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
