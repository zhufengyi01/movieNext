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
#import "SmallImageCollectionViewCell.h"
#import "ShowStageViewController.h"
#import "NSDate+Extension.h"
#import "UpweiboModel.h"
//#import "SearchMovieViewController.h"
#define  BUTTON_COUNT  3
#define  NaviTitle_Width  160
#define  NaviTitle_Height 46
#define  Lable_Line_Height 3

static const CGFloat MJDuration = 0.6;

@interface MovieViewController ()<UISearchBarDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,LoadingViewDelegate,MovieCollectionViewCellDelegate,UIActionSheetDelegate,UIAlertViewDelegate>
{
    LoadingView         *loadView;
    int pageSize;
    NSString  *startId;
    int page0;  //推荐
    int page1;
    int page2;
    int page3;
    int pageCount0;
    int pageCount1;
    int pageCount2;
    int pageCount3;
    NSInteger Rowindex;
    NSMutableArray  *_upWeiboArray;
}
@property(nonatomic,strong) UIScrollView   *myScorollerView;

@property(nonatomic,strong) UIView *RecommentView;   //推荐

@property(nonatomic,strong)UIView  *feedView;     //电影

@property(nonatomic,strong) UIButton  *recommentBtn;  //推荐按钮

@property(nonatomic,strong) UIButton  *feedBtn;

@property(nonatomic,strong)UILabel  *nav_line_lable;

//@property(nonatomic,strong) NSString  *IS_CHECK;  //是否是审核版 1  代表是审核版   0代表是正式版

@end

@implementation MovieViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden=NO;
    //self.navigationController.navigationBar.alpha=1;
    //  self.tabBarController.tabBar.hidden=NO;
    // if (self.myConllectionView) {
    //[  self.myConllectionView headerBeginRefreshing];
    //}
    // [[UINavigationBar appearance] setShadowImage:[UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(kDeviceWidth, 1)]];
    
    //[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"tabbar_backgroud_color.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar  setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:243.0/255 green:243.0/255 blue:243.0/255 alpha:1]] forBarMetrics:UIBarMetricsDefault];
    
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    self.tabBarController.tabBar.hidden=NO;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
#warning 上线审核的时候需要注视掉
    //[self requestUpdate];
    //创建导航
    //self.view.backgroundColor=[UIColor whiteColor];
    //判断是否是审核版
    [self createNavigation];
    [self initData];
    [self createMyScrollerView];
    [self createSegmentView];
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
    UIView *naviTitleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, NaviTitle_Width, NaviTitle_Height)];
    //naviTitleView.backgroundColor =[UIColor yellowColor];
    naviTitleView.userInteractionEnabled=YES;
    self.navigationItem.titleView=naviTitleView;
    
    if ([userCenter.Is_Check intValue]==1) {
        UILabel  *titleLable=[ZCControl createLabelWithFrame:CGRectMake(0, 0, 100, 30) Font:30 Text:@"热门"];
        titleLable.textColor=VBlue_color;
        titleLable.font=[UIFont boldSystemFontOfSize:18];
        titleLable.textColor=VGray_color;
        titleLable.textAlignment=NSTextAlignmentCenter;
        self.navigationItem.titleView=titleLable;
    } else {
        //创建两个按钮  //推荐和电影
        self.recommentBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        self.recommentBtn.frame=CGRectMake(0, 0, NaviTitle_Width/2, NaviTitle_Height);
        [self.recommentBtn setTitle:@"热门" forState:UIControlStateNormal];
        [self.recommentBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
        [self.recommentBtn setTitleColor:VLight_GrayColor forState:UIControlStateNormal];
        [self.recommentBtn setTitleColor:VBlue_color forState:UIControlStateSelected];
        self.recommentBtn.selected=YES;
        //self.recommentBtn.backgroundColor =[UIColor redColor];
        __weak typeof(self) weakSelf = self;
        
        [self.recommentBtn addActionHandler:^(NSInteger tag) {
            [weakSelf.myScorollerView setContentOffset:CGPointMake(0, 0) animated:YES];
        }];
        [naviTitleView addSubview:self.recommentBtn];
        
        
        self.feedBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        self.feedBtn.frame=CGRectMake(NaviTitle_Width/2, 0, NaviTitle_Width/2, NaviTitle_Height);
        [self.feedBtn setTitle:@"电影" forState:UIControlStateNormal];
        [self.feedBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
        self.feedBtn.selected=NO;
        //self.feedBtn.backgroundColor =[UIColor blueColor];
        [self.feedBtn setTitleColor:VLight_GrayColor forState:UIControlStateNormal];
        [self.feedBtn setTitleColor:VBlue_color forState:UIControlStateSelected];
        [self.feedBtn addActionHandler:^(NSInteger tag) {
            [weakSelf.myScorollerView setContentOffset:CGPointMake(kDeviceWidth, 0) animated:YES];
        }];
        [naviTitleView addSubview:self.feedBtn];
        
        self.nav_line_lable =[[UILabel alloc]initWithFrame:CGRectMake(0,NaviTitle_Height-Lable_Line_Height, NaviTitle_Width/2,Lable_Line_Height )];
        self.nav_line_lable.backgroundColor =VBlue_color;
        [naviTitleView addSubview:self.nav_line_lable];
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
        //UINavigationController  *search=[[UINavigationController alloc]initWithRootViewController:vc];
        // search.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
        //[self presentViewController:search animated:YES completion:nil];
        [self.navigationController pushViewController:vc animated:NO];
    }];
    
    if ([userCenter.Is_Check intValue]==1) {
        searchbutton.hidden=YES;
    }
}

-(void)createMyScrollerView
{
    UserDataCenter  *userCenter =[UserDataCenter shareInstance];
    self.myScorollerView =[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kHeigthTabBar)];
    self.myScorollerView.contentSize=CGSizeMake(kDeviceWidth*2, kDeviceHeight-kHeigthTabBar-kHeightNavigation);
    if ([userCenter.Is_Check  intValue]==1) {
        self.myScorollerView.contentSize=CGSizeMake(kDeviceWidth, kDeviceHeight-kHeigthTabBar-kHeightNavigation);
    }
    self.myScorollerView.delegate=self;
    self.myScorollerView.bounces=NO;
    self.myScorollerView.pagingEnabled=YES;
    [self.view addSubview:self.myScorollerView];
    
    self.RecommentView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kHeigthTabBar)];
    //self.RecommentView.backgroundColor =[UIColor redColor];
    self.RecommentView.userInteractionEnabled=YES;
    [self.myScorollerView addSubview:self.RecommentView];
    
    self.feedView=[[UIView alloc] initWithFrame:CGRectMake(kDeviceWidth, 0, kDeviceWidth, kDeviceHeight-kHeigthTabBar)];
    //self.feedView.backgroundColor =[UIColor yellowColor];
    self.feedView.userInteractionEnabled=YES;
    [self.myScorollerView addSubview:self.feedView];
    
}

-(void)createSegmentView
{
    UIImageView   *TopImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0,0, kDeviceWidth, 30)];
    // TopImageView.backgroundColor=VGray_color;
    ///TopImageView.image=[UIImage imageNamed:@"tab_switch.png"];
    TopImageView.backgroundColor=[UIColor whiteColor];
    TopImageView.userInteractionEnabled=YES;
    [self.feedView addSubview:TopImageView];
    
    NSArray  *titleArray =@[@"热门电影",@"热门剧集",@"热门动漫"];
    for (int i =0; i<BUTTON_COUNT; i++) {
        double  x=i*(kDeviceWidth/3);
        double  y=0;
        double  width=kDeviceWidth/3;
        double  height=40;
        UIButton  *btn=[ZCControl createButtonWithFrame:CGRectMake(x,y,width,height) ImageName:nil Target:self Action:@selector(dealSegmentClick:) Title:titleArray[i]];
        //=View_BackGround;
        [btn setTitleColor:VLight_GrayColor forState:UIControlStateNormal];
        [btn setTitleColor:VBlue_color forState:UIControlStateSelected];
        btn.titleLabel.font=[UIFont systemFontOfSize:15];
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
                UIButton  *button=(UIButton *)[self.feedView viewWithTag:i+100];
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
                UIButton  *button=(UIButton *)[self.feedView viewWithTag:i+100];
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
                UIButton  *button=(UIButton *)[self.feedView viewWithTag:i+100];
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
    page0=1;
    page1=1;
    page2=1;
    page3=1;
    pageCount0=1;
    pageCount1=1;
    pageCount2=1;
    pageCount3=1;
    pageSize=12;
    _dataArray0=[[NSMutableArray alloc]init];
    _dataArray1=[[NSMutableArray alloc]init];
    _dataArray2=[[NSMutableArray alloc]init];
    _dataArray3=[[NSMutableArray alloc]init];
    _upWeiboArray=[[NSMutableArray alloc]init];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(refreshRecommend)
                                                 name: @"requestRecommendData"
                                               object: nil];
    
}
//已经选中了tabbar的时候刷新
-(void)refreshRecommend
{
    if (self.recommentBtn.selected==YES) {
        [self.RecommendCollectionView.header beginRefreshing];
    }
    else if (self.feedBtn.selected==YES)
    {
        [self.myConllectionView.header beginRefreshing];
    }
    
}

-(void)initUI
{
    ///创建推荐的collectionview
    UICollectionViewFlowLayout  *   Relayout=[[UICollectionViewFlowLayout alloc]init];
    Relayout.minimumInteritemSpacing=0; //cell之间左右的
    Relayout.minimumLineSpacing=5;      //cell上下间隔
    Relayout.sectionInset=UIEdgeInsetsMake(5,0,0, 0); //整个偏移量 上左下右
    self.RecommendCollectionView =[[UICollectionView alloc]initWithFrame:CGRectMake(0,0,kDeviceWidth, kDeviceHeight-kHeightNavigation-kHeigthTabBar-0) collectionViewLayout:Relayout];
    //[layout setHeaderReferenceSize:CGSizeMake(_myConllectionView.frame.size.width, kDeviceHeight/3+64+110)];
    
    self.RecommendCollectionView.backgroundColor=[UIColor whiteColor];
    //注册小图模式
    [self.RecommendCollectionView registerClass:[SmallImageCollectionViewCell class] forCellWithReuseIdentifier:@"smallcell"];
    
    self.RecommendCollectionView.delegate=self;
    self.RecommendCollectionView.dataSource=self;
    [self.RecommentView addSubview:self.RecommendCollectionView];
    [self setRecommtUprefresh];
    
    
    
    //创建电影的collectionview
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
    [self.feedView addSubview:_myConllectionView];
    
    [self setUprefresh];
    /**
     *  集成刷新控件
     */
}

-(void)setRecommtUprefresh
{
    __weak typeof(self) weakSelf = self;
    // 下拉刷新
    [self.RecommendCollectionView addLegendHeaderWithRefreshingBlock:^{
        // 增加5条假数据
        /*for (int i = 0; i<10; i++) {
         [weakSelf.colors insertObject:MJRandomColor atIndex:0];
         }*/
        page0=1;
        if (weakSelf.dataArray0.count>0) {
            [weakSelf.dataArray0 removeAllObjects];
        }
        // 进入刷新状态就会回调这个Block
        [weakSelf requestRecommendData];
        // 设置文字
        [weakSelf.RecommendCollectionView.header setTitle:@"下拉刷新..." forState:MJRefreshHeaderStateIdle];
        [weakSelf.RecommendCollectionView.header setTitle:@"释放刷新..." forState:MJRefreshHeaderStatePulling];
        [weakSelf.RecommendCollectionView.header setTitle:@"正在刷新..." forState:MJRefreshHeaderStateRefreshing];
        //隐藏时间
        weakSelf.RecommendCollectionView.header.updatedTimeHidden=YES;
        // 设置字体
        //weakSelf.myConllectionView.header.font = [UIFont systemFontOfSize:12];
        
        // 设置颜色
        // weakSelf.myConllectionView.header.textColor = VGray_color;
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.RecommendCollectionView reloadData];
            
            // 结束刷新
            [weakSelf.RecommendCollectionView.header endRefreshing];
        });
    }];
    [self.RecommendCollectionView.header beginRefreshing];
    
    // 上拉刷新
    [self.RecommendCollectionView addLegendFooterWithRefreshingBlock:^{
        // 增加5条假数据
        /*for (int i = 0; i<5; i++) {
         [weakSelf.colors addObject:MJRandomColor];
         }*/
        // 进入刷新状态就会回调这个Block
        if (pageCount0>page0) {
            page0=page0+1;
            [weakSelf requestRecommendData];
        }
        else
        {
            [weakSelf.RecommendCollectionView.footer noticeNoMoreData];
        }
        // 设置文字
        [weakSelf.RecommendCollectionView.footer setTitle:@"点击加载更多..." forState:MJRefreshFooterStateIdle];
        [weakSelf.RecommendCollectionView.footer setTitle:@"加载更多..." forState:MJRefreshFooterStateRefreshing];
        [weakSelf.RecommendCollectionView.footer setTitle:@"THE END" forState:MJRefreshFooterStateNoMoreData];
        // 设置字体
        // weakSelf.myConllectionView.footer.font = [UIFont systemFontOfSize:12];
        // 设置颜色
        //weakSelf.myConllectionView.footer.textColor = VGray_color;
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.RecommendCollectionView reloadData];
            // 结束刷新
            [weakSelf.RecommendCollectionView.footer endRefreshing];
        });
    }];
    // 默认先隐藏footer
    // self.myConllectionView.footer.hidden = YES;
    
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
                else
                {
                    [weakSelf.myConllectionView.footer noticeNoMoreData];
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

-(void)requestRecommendData
{
    UserDataCenter *userCenter =[UserDataCenter shareInstance];
    NSDictionary *parameters = @{@"user_id":userCenter.user_id, @"status":@"3", @"Version":Version};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString  *urlString =[NSString stringWithFormat:@"%@/weibo/list-by-status?per-page=%d&page=%d", kApiBaseUrl,pageSize,page0];
    
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [loadView stopAnimation];
        [loadView removeFromSuperview];
        if ([[responseObject  objectForKey:@"code"]  intValue]==0) {
            pageCount0=[[responseObject objectForKey:@"pageCount"] intValue];
            if (page0==pageCount0) {
                [self.RecommendCollectionView.footer noticeNoMoreData];
            }
            NSMutableArray   *array  = [[NSMutableArray alloc]initWithArray:[responseObject objectForKey:@"models"]];
            for ( int i=0 ; i<array.count; i++) {
                NSDictionary  *newdict  =[array objectAtIndex:i];
                weiboInfoModel *weibomodel =[[weiboInfoModel alloc]init];
                if (weibomodel) {
                    [weibomodel setValuesForKeysWithDictionary:newdict];
                    //用户的信息
                    weiboUserInfoModel  *usermodel =[[weiboUserInfoModel alloc]init];
                    if (usermodel) {
                        if (![[newdict objectForKey:@"user"] isKindOfClass:[NSNull class]]) {
                            [usermodel setValuesForKeysWithDictionary:[newdict objectForKey:@"user"]];
                            weibomodel.uerInfo=usermodel;
                        }
                    }
                    // 剧情信息
                    stageInfoModel  *stagemodel =[[stageInfoModel alloc]init];
                    if (stagemodel) {
                        if (![[newdict objectForKey:@"stage"]  isKindOfClass:[NSNull class]]) {
                            [stagemodel setValuesForKeysWithDictionary:[newdict objectForKey:@"stage"]];
                            movieInfoModel *moviemodel = [[movieInfoModel alloc]init];
                            if (moviemodel) {
                                [moviemodel setValuesForKeysWithDictionary:[[newdict objectForKey:@"stage"] objectForKey:@"movie"]];
                                stagemodel.movieInfo=moviemodel;
                            }
                            weibomodel.stageInfo=stagemodel;
                        }
                    }
                    NSMutableArray  *tagArray =[[NSMutableArray alloc]init];
                    //标签数组
                    for ( NSDictionary  *tagdict in [newdict objectForKey:@"tags"]) {
                        TagModel *tagmodel=[[TagModel alloc]init];
                        if (tagmodel) {
                            [tagmodel setValuesForKeysWithDictionary:tagdict];
                            
                            TagDetailModel *tagdetail =[[TagDetailModel alloc]init];
                            if (tagdetail) {
                                [tagdetail setValuesForKeysWithDictionary:[tagdict objectForKey:@"tag"]];
                                tagmodel.tagDetailInfo=tagdetail;
                            }
                            [tagArray addObject:tagmodel];
                        }
                    }
                    weibomodel.tagArray=tagArray;
                    [self.dataArray0 addObject:weibomodel];
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
                }}
            
            
            [self.RecommendCollectionView reloadData];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [loadView showFailLoadData];
    }];
    
}

-(void)requestData
{
    
    NSString  *type;
    int PAGE;
    for (int i=0;i<3;i++) {
        UIButton  *btn=(UIButton *) [self.feedView viewWithTag:100+i];
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
    [self requestRecommendData];
    [self requestData];
    //点击完之后，动画又要开始旋转，同时隐藏了加载失败的背景
    [loadView hidenFailLoadAndShowAnimation];
}

-(void)requestUpdate
{
    //  https://fir.im/mov
    //删除电影
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://fir.im/api/v2/app/version/557a8f0b9bb7dc3e6c00285b?token=260fc3700aaf11e597435eaa6f4fb53848e89872"]] queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data) {
            @try {
                NSDictionary *result= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                
                NSLog(@"=====%@",result);
                //对比版本
                NSString * version=result[@"version"]; //对应 CFBundleVersion, 对应Xcode项目配置"General"中的 Build
                NSString * versionShort=result[@"versionShort"]; //对应 CFBundleShortVersionString, 对应Xcode项目配置"General"中的 Version
                
                NSString * localVersion=[[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"];
                NSString * localVersionShort=[[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
                
                NSString *url=result[@"update_url"]; //如果有更新 需要用Safari打开的地址
                NSString *changelog=result[@"changelog"]; //如果有更新 需要用Safari打开的地址
                
                
                //这里放对比版本的逻辑  每个 app 对版本更新的理解都不同
                //有的对比 version, 有的对比 build
                
                if (![versionShort isEqualToString:localVersionShort]) {
                    UIAlertView  *al =[[UIAlertView alloc]initWithTitle:@"版本更新提示" message:@"电影卡片分享图增加App水印" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:@"去下载", nil];
                    al.tag=100;
                    [al show];
                }
                
            }
            @catch (NSException *exception) {
                //返回格式错误 忽略掉
            }
        }
        
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView==self.myConllectionView) {
        for (int i=0;i<3;i++) {
            UIButton  *btn=(UIButton *) [self.feedView viewWithTag:100+i];
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
    }
    else if(collectionView==self.RecommendCollectionView)
    {
        return self.dataArray0.count;
    }
    return 0;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView==self.myConllectionView) {
        NSMutableArray  *array=[[NSMutableArray alloc]init];;
        for (int i=0;i<3;i++) {
            UIButton  *btn=(UIButton *) [self.feedView viewWithTag:100+i];
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
    else if (collectionView==self.RecommendCollectionView)
    {
        SmallImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"smallcell" forIndexPath:indexPath];
        //在这里先将内容给清除一下, 然后再加载新的, 添加完内容之后先动画, 在cell消失的时候做清理工作
        if (self.dataArray0.count>indexPath.row) {
            weiboInfoModel  *model=[self.dataArray0 objectAtIndex:indexPath.row];
            cell.imageView.backgroundColor=VStageView_color;
            NSURL  *url =[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",kUrlStage,model.stageInfo.photo ,KIMAGE_SMALL]];
            [cell.imageView sd_setImageWithURL:url placeholderImage:nil options:(SDWebImageRetryFailed|SDWebImageLowPriority)];
            cell.titleLab.text=[NSString stringWithFormat:@"%@",model.content];
            NSDate  *comfromTimesp =[NSDate dateWithTimeIntervalSince1970:[model.updated_at intValue]];
            NSString  *da = [NSDate timeInfoWithDate:comfromTimesp];
            //dateLable.text=da;
            cell.lblTime.text = da;
            cell.lblLikeCount.text = [NSString stringWithFormat:@"%d", [model.like_count intValue]];
            [cell.ivAvatar sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kUrlAvatar, model.uerInfo.logo]]];
            cell.ivLike.image = [UIImage imageNamed:@"tiny_like"];
            return cell;
            
        }
        return cell;
        
    }
    return nil;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView==self.myConllectionView) {
        int width = ((kDeviceWidth-6*16)/3);
        int movieNameMarginTop = 10;
        int movieNameHeight = 10;
        return CGSizeMake( width, width*1.5 + movieNameMarginTop + movieNameHeight);
    }
    else
    {
        double  w = (kDeviceWidth-5)/2;
        double  h= w*(9.0/16);
        return CGSizeMake(w,h);
    }
    return CGSizeMake(0, 0);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView==self.myConllectionView) {
        NSMutableArray  *array=[[NSMutableArray alloc]init];;
        for (int i=0;i<3;i++) {
            UIButton  *btn=(UIButton *) [self.feedView viewWithTag:100+i];
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
        [self.navigationController hidesBottomBarWhenPushed];
        MovieDetailViewController *vc =  [MovieDetailViewController new];
        if (array.count > indexPath.row) {
            NSDictionary *dict = [array  objectAtIndex:(long)indexPath.row];
            vc.movieId = [dict objectForKey:@"movie_id"];
            vc.moviename=[dict objectForKey:@"title"];
            vc.pageSourceType=NSMovieSourcePageMovieListController;
            vc.movielogo =[dict objectForKey:@"photo"];
            UIBarButtonItem  *item =[[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
            self.navigationItem.backBarButtonItem=item;
        }
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (collectionView==self.RecommendCollectionView)
    {
        ShowStageViewController *vc = [[ShowStageViewController alloc] init];
        vc.pageType=NSStagePapeTypeHotStageList;//热门页进入
        weiboInfoModel *model=[self.dataArray0 objectAtIndex:indexPath.row];
        
        //    movieInfoModel  *moviemodel =[[movieInfoModel alloc]init];
        
        vc.stageInfo = model.stageInfo;
        vc.upweiboArray=_upWeiboArray;
        vc.weiboInfo=model;
        UIBarButtonItem  *item =[[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        self.navigationItem.backBarButtonItem=item;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
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
                UIButton  *btn=(UIButton *) [self.feedView viewWithTag:100+i];
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
                UIButton  *btn=(UIButton *) [self.feedView viewWithTag:100+i];
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
                UIButton  *btn=(UIButton *) [self.feedView viewWithTag:100+i];
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

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView==self.myScorollerView) {
        int index=scrollView.contentOffset.x/kDeviceWidth;
        if (index==0) {
            self.recommentBtn.selected=YES;
            self.feedBtn.selected=NO;
        }
        else{
            self.feedBtn.selected=YES;
            self.recommentBtn.selected=NO;
        }
        float x=self.nav_line_lable.frame.origin.x;
        x=((NaviTitle_Width/2)/kDeviceWidth)*scrollView.contentOffset.x;
        self.nav_line_lable.frame=CGRectMake(x, self.nav_line_lable.frame.origin.y, self.nav_line_lable.frame.size.width, self.nav_line_lable.frame.size.height);
        NSLog(@"~~~~~~%f",scrollView.contentOffset.x);
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==100) {
        if (buttonIndex==0) {
        }
        else
        {
            [[UIApplication  sharedApplication] openURL:[NSURL URLWithString:@"https://fir.im/mcard"]];
        }
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
