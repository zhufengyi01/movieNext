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
#import "UIButton+Block.h"
#import "UIImage-Helpers.h"
#import "AdmListViewController.h"
//#import "SearchMovieViewController.h"
#define  BUTTON_COUNT  3
static const CGFloat MJDuration = 0.6;

@interface MovieViewController ()<UISearchBarDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,LoadingViewDelegate,MovieCollectionViewCellDelegate,UIActionSheetDelegate>
{
    LoadingView         *loadView;
    int pageSize;
    NSString  *startId;
    int page1;
    int page2;
    int page3;
    int pageCount1;
    int pageCount2;
    int pageCount3;
    
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
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"tabbar_backgroud_color.png"] forBarMetrics:UIBarMetricsDefault];

 
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
}
-(void)createNavigation
{
    UserDataCenter  *userCenter =[UserDataCenter shareInstance];
    if ([userCenter.is_admin intValue ]>0) {
        UIButton  *button=[UIButton buttonWithType:UIButtonTypeCustom];
        //[button setTitle:@"管理员" forState:UIControlStateNormal];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
         [button setImage:[UIImage imageNamed:@"guanliyuan.png"] forState:UIControlStateNormal];
        [button setTitleColor:VBlue_color forState:UIControlStateNormal];
        button.frame=CGRectMake(0, 0, 40, 30);
        button.imageEdgeInsets =UIEdgeInsetsMake(0, -10, 0, 10);
        //[button addTarget:self action:@selector(adminClick:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem  *barButton=[[UIBarButtonItem alloc]initWithCustomView:button];
        self.navigationItem.leftBarButtonItem=barButton;
        [button addActionHandler:^(NSInteger tag) {
            UIBarButtonItem  *item =[[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
            self.navigationItem.backBarButtonItem=item;
            [self.navigationController pushViewController:[AdmListViewController new] animated:YES];
        }];
    }
 
    UIButton  *searchbutton=[UIButton buttonWithType:UIButtonTypeCustom];
      [searchbutton setImage:[UIImage imageNamed:@"search_icon.png"] forState:UIControlStateNormal];
    searchbutton.frame=CGRectMake(0, 0, 40, 30);
    searchbutton.imageEdgeInsets=UIEdgeInsetsMake(0, 10, 0, -10);
     UIBarButtonItem  *barButton=[[UIBarButtonItem alloc]initWithCustomView:searchbutton];
    self.navigationItem.rightBarButtonItem=barButton;
    [searchbutton addActionHandler:^(NSInteger tag) {
        UIBarButtonItem  *item =[[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        self.navigationItem.backBarButtonItem=item;
        MovieSearchViewController *vc= [MovieSearchViewController new];
        vc.pageType=NSSearchSourceTypeMovieList;
        UINavigationController  *search=[[UINavigationController alloc]initWithRootViewController:vc];
        search.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
        [self presentViewController:search animated:YES completion:nil];
    }];
}

-(void)adminClick:(UIButton *) btn
{
}
//点击可刷新
-(void)refreshTableView
{
 //   [self.myConllectionView  headerBeginRefreshing];
}


-(void)createSegmentView
{
    UIImageView   *TopImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0,0, kDeviceWidth, 30)];
   // TopImageView.backgroundColor=VGray_color;
    ///TopImageView.image=[UIImage imageNamed:@"tab_switch.png"];
    TopImageView.backgroundColor=[UIColor whiteColor];
    TopImageView.userInteractionEnabled=YES;
    [self.view addSubview:TopImageView];
    
    NSArray  *titleArray =@[@"热门电影",@"热门剧集",@"热门动漫"];
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
     page1=1;
     page2=1;
     page3=1;
     pageCount1=1;
     pageCount2=1;
     pageCount3=1;
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
    [self setUprefresh];
     /**
     *  集成刷新控件
     */
}
- (void)setUprefresh
{
    __weak typeof(self) weakSelf = self;
    
    // 下拉刷新
    [self.myConllectionView addLegendHeaderWithRefreshingBlock:^{
        // 增加5条假数据
        /*for (int i = 0; i<10; i++) {
            [weakSelf.colors insertObject:MJRandomColor atIndex:0];
        }*/
        for (int i=0;i<3;i++) {
            UIButton  *btn=(UIButton *) [weakSelf.view viewWithTag:100+i];
            if (i==0&&btn.selected==YES) {
                
                if (_dataArray1.count>0) {
                    [weakSelf.dataArray1 removeAllObjects];
                }
                page1=1;
                [weakSelf requestData];
            }
            else if(i==1&&btn.selected==YES)
            {
                if (_dataArray2.count>0) {
                    [weakSelf.dataArray2 removeAllObjects];
                }
                page2=1;
                [weakSelf requestData];
            }
            else if (i==2&&btn.selected==YES)
            {
                if (_dataArray3.count>0) {
                    [weakSelf.dataArray3 removeAllObjects];
                }
                page3=1;
                [weakSelf requestData];
            }
        }
        // 设置文字
        [weakSelf.myConllectionView.header setTitle:@"下拉刷新..." forState:MJRefreshHeaderStateIdle];
        [weakSelf.myConllectionView.header setTitle:@"释放刷新..." forState:MJRefreshHeaderStatePulling];
        [weakSelf.myConllectionView.header setTitle:@"正在刷新..." forState:MJRefreshHeaderStateRefreshing];
        //隐藏时间
        weakSelf.myConllectionView.header.updatedTimeHidden=YES;
        
        // 设置字体
        //weakSelf.myConllectionView.header.font = [UIFont systemFontOfSize:12];
        
        // 设置颜色
       // weakSelf.myConllectionView.header.textColor = VGray_color;
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
        /*for (int i = 0; i<5; i++) {
            [weakSelf.colors addObject:MJRandomColor];
        }*/
        // 设置文字
        [weakSelf.myConllectionView.footer setTitle:@"点击加载更多..." forState:MJRefreshFooterStateIdle];
        [weakSelf.myConllectionView.footer setTitle:@"加载更多..." forState:MJRefreshFooterStateRefreshing];
        [weakSelf.myConllectionView.footer setTitle:@"THE END" forState:MJRefreshFooterStateNoMoreData];
        
        // 设置字体
       // weakSelf.myConllectionView.footer.font = [UIFont systemFontOfSize:12];
        
        // 设置颜色
        //weakSelf.myConllectionView.footer.textColor = VGray_color;
        for (int i=0;i<3;i++) {
            UIButton  *btn=(UIButton *) [weakSelf.view viewWithTag:100+i];
            if (i==0&&btn.selected==YES) {
                if (pageCount1>page1) {
                    page1=page1+1;
                    [weakSelf requestData];
                }
            
            }
            else if(i==1&&btn.selected==YES)
            {
                if (pageCount2>page2) {
                    page2=page2+1;
                    [weakSelf requestData];
                }
            }
            else if (i==2&&btn.selected==YES)
            {
                if (pageCount3>page3) {
                    page3=page3+1;
                    [weakSelf requestData];
                }
            }
        }
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.myConllectionView reloadData];
            
            // 结束刷新
            [weakSelf.myConllectionView.footer endRefreshing];
        });
    }];
    // 默认先隐藏footer
   // self.myConllectionView.footer.hidden = YES;
}


 //为了保证内部不泄露，在dealloc中释放占用的内存
// */
- (void)dealloc
{
    NSLog(@"MJCollectionViewController--dealloc---");
}

#pragma  mark  ---
#pragma  mark  ----RequestData
#pragma  mark  ---

//跳换电影的位置
-(void)requestOrderMovieWithforwardId:(NSString *) forward_id AndbehindId:(NSString *)behindId
{
    
    UserDataCenter  *userCenter=[UserDataCenter shareInstance];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters=@{@"user_id":userCenter.user_id,@"feed_id":behindId,@"up_feed_id":forward_id};
    [manager POST:[NSString stringWithFormat:@"%@/feed/change-order", kApiBaseUrl] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject  objectForKey:@"code"]  intValue]==0) {
            NSLog(@"删除成功=======%@",responseObject);
            UIAlertView *al =[[UIAlertView alloc]initWithTitle:nil message:@"移动成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [al show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}



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
    int PAGE;
    for (int i=0;i<3;i++) {
        UIButton  *btn=(UIButton *) [self.view viewWithTag:100+i];
        if (i==0&&btn.selected==YES) {
            type=@"1";
            PAGE=page1;
        }
        else if(i==1&&btn.selected==YES)
        {
            type=@"2";
            PAGE=page2;
         }
        else if (i==2&&btn.selected==YES)
        {
            type=@"3";
            PAGE=page3;
            
        }
    }
    
    
    NSDictionary  *parameters =@{@"type":type};
    NSString  *urlString=[NSString stringWithFormat:@"%@/feed/list?per-page=%d&page=%d",kApiBaseUrl,pageSize,PAGE];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"return_code"] intValue]==0) {

        //NSLog(@"  电影首页数据JSON: %@", responseObject);
            [loadView stopAnimation];
            [loadView removeFromSuperview];
            
            for (int i=0;i<3;i++) {
                UIButton  *btn=(UIButton *) [self.view viewWithTag:100+i];
                if (i==0&&btn.selected==YES) {
                    if (_dataArray1==nil) {
                        _dataArray1=[[NSMutableArray alloc]init];
                    }
                    NSArray  *detailarray=[responseObject objectForKey:@"models"];
                    pageCount1 =[[responseObject objectForKey:@"pageCount"] intValue];
                    
                  
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
                    pageCount2 =[[responseObject objectForKey:@"pageCount"] intValue];
                    if (page2==pageCount2) {
                        [self.myConllectionView.footer noticeNoMoreData];
                    }
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
                    pageCount3 =[[responseObject objectForKey:@"pageCount"] intValue];
                    if (page3==pageCount3) {
                        [self.myConllectionView.footer noticeNoMoreData];
                    }
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
        vc.moviename=[dict objectForKey:@"title"];
        vc.pageSourceType=NSMovieSourcePageMovieListController;
        vc.movielogo =[dict objectForKey:@"photo"];
//        NSMutableString  *backstr=[[NSMutableString alloc]initWithString:[dict objectForKey:@"title"]];
//        NSString *str=backstr;
//        if(backstr.length>5)
//        {
//            str=[backstr substringToIndex:5];
//            str =[NSString stringWithFormat:@"%@...",str];
//        }
        UIBarButtonItem  *item =[[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
       self.navigationItem.backBarButtonItem=item;
    }
   [self.navigationController pushViewController:vc animated:YES];
}
-(void)MovieCollectionViewlongPress:(NSInteger)cellRowIndex
{
    Rowindex=cellRowIndex;
    UIActionSheet  *ash =[[UIActionSheet alloc]initWithTitle:@"管理员操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:@"[前移]",@"[后移]", nil];
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
    else if (buttonIndex==1)
    {
        //向前移动
        NSString *forward_Id;
        NSString *behaind_Id;
        for (int i=0;i<3;i++) {
            UIButton  *btn=(UIButton *) [self.view viewWithTag:100+i];
            if (i==0&&btn.selected==YES) {
                if (Rowindex==0) {
                    UIAlertView  *Al =[[UIAlertView alloc]initWithTitle:nil message:@"不能前移了" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [Al show];
                    return;
                }
                forward_Id =[[_dataArray1 objectAtIndex:Rowindex-1]  objectForKey:@"id"];
                behaind_Id =[[_dataArray1 objectAtIndex:Rowindex]  objectForKey:@"id"];
                [_dataArray1 exchangeObjectAtIndex:Rowindex-1 withObjectAtIndex:Rowindex];
                [self.myConllectionView reloadData];
                 break;
                
            }
            else if(i==1&&btn.selected==YES)
            {
                
                if (Rowindex==0) {
                    UIAlertView  *Al =[[UIAlertView alloc]initWithTitle:nil message:@"不能前移了" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [Al show];
                    return;
                }
                forward_Id =[[_dataArray2 objectAtIndex:Rowindex-1]  objectForKey:@"id"];
                behaind_Id =[[_dataArray2 objectAtIndex:Rowindex]  objectForKey:@"id"];
                [_dataArray2 exchangeObjectAtIndex:Rowindex-1 withObjectAtIndex:Rowindex];
                [self.myConllectionView reloadData];
   
                 break;
            }
            else if (i==2&&btn.selected==YES)
            {
                if (Rowindex==0) {
                    UIAlertView  *Al =[[UIAlertView alloc]initWithTitle:nil message:@"不能前移了" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [Al show];
                    return;
                }
                forward_Id =[[_dataArray3 objectAtIndex:Rowindex-1]  objectForKey:@"id"];
                behaind_Id =[[_dataArray3 objectAtIndex:Rowindex]  objectForKey:@"id"];
                [_dataArray3 exchangeObjectAtIndex:Rowindex-1 withObjectAtIndex:Rowindex];
                [self.myConllectionView reloadData];
                 break;
            }
        }
        [self requestOrderMovieWithforwardId:forward_Id AndbehindId:behaind_Id];
        
    }
    else if (buttonIndex==2)
    {
        //向后移动
        //向前移动
        NSString *forward_Id;
        NSString *behaind_Id;
        for (int i=0;i<3;i++) {
            UIButton  *btn=(UIButton *) [self.view viewWithTag:100+i];
            if (i==0&&btn.selected==YES) {
                if (Rowindex==self.dataArray1.count-1) {
                    UIAlertView  *Al =[[UIAlertView alloc]initWithTitle:nil message:@"不能后移了" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [Al show];
                    return;
                }
                forward_Id =[[_dataArray1 objectAtIndex:Rowindex]  objectForKey:@"id"];
                behaind_Id =[[_dataArray1 objectAtIndex:Rowindex+1]  objectForKey:@"id"];
                [_dataArray1 exchangeObjectAtIndex:Rowindex withObjectAtIndex:Rowindex+1];
                [self.myConllectionView reloadData];
                break;
                
            }
            else if(i==1&&btn.selected==YES)
            {
                if (Rowindex==self.dataArray2.count-1) {
                    UIAlertView  *Al =[[UIAlertView alloc]initWithTitle:nil message:@"不能后移了" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [Al show];
                    return;
                }
                forward_Id =[[_dataArray2 objectAtIndex:Rowindex]  objectForKey:@"id"];
                behaind_Id =[[_dataArray2 objectAtIndex:Rowindex+1]  objectForKey:@"id"];
                [_dataArray2 exchangeObjectAtIndex:Rowindex withObjectAtIndex:Rowindex+1];
                [self.myConllectionView reloadData];
                
                break;
            }
            else if (i==2&&btn.selected==YES)
            {
                if (Rowindex==self.dataArray3.count-1) {
                    UIAlertView  *Al =[[UIAlertView alloc]initWithTitle:nil message:@"不能后移了" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [Al show];
                    return;
                }
                forward_Id =[[_dataArray3 objectAtIndex:Rowindex]  objectForKey:@"id"];
                behaind_Id =[[_dataArray3 objectAtIndex:Rowindex+1]  objectForKey:@"id"];
                [_dataArray3 exchangeObjectAtIndex:Rowindex withObjectAtIndex:Rowindex+1];
                [self.myConllectionView reloadData];
                break;
            }
        }
        [self requestOrderMovieWithforwardId:forward_Id AndbehindId:behaind_Id];
      }
    }

}

#pragma  mark  ------
#pragma  mark  ------- searchBardelgate------------
/*-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    
     MovieSearchViewController *vc= [MovieSearchViewController new];
     vc.pageType=NSSearchSourceTypeMovieList;
     UINavigationController  *search=[[UINavigationController alloc]initWithRootViewController:vc];
     search.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
      [self presentViewController:search animated:YES completion:nil];
    return NO;
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
