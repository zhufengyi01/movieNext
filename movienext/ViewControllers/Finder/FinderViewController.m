//
//  FinderViewController.m
//  movienext
//
//  Created by 风之翼 on 15/5/22.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "FinderViewController.h"
#import "ZCControl.h"
#import "Constant.h"
#import "AFNetworking.h"
#import "FindDatailViewController.h"
#import "ModelsModel.h"
#import "MovieViewController.h"
#import "UserDataCenter.h"
#import "weiboInfoModel.h"
#import "MJExtension.h"
#import "LoadingView.h"
#import "UIButton+Block.h"
@interface FinderViewController ()<UIPageViewControllerDataSource,UIPageViewControllerDelegate,LoadingViewDelegate>
{
    LoadingView         *loadView;
    //当前的detailcontroller
    FindDatailViewController *CenterViewController;
    
}
@property (strong, nonatomic) UIPageViewController *pageController;

@property (strong, nonatomic) NSMutableArray *pageContent;

@property(strong,nonatomic) NSMutableArray   *indexArray; //存储每个页面的索引

@end

@implementation FinderViewController
-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden=NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =View_BackGround;
    // Do any additional setup after loading the view.
    [self createNavigation];
    [self initData];
    [self requestData];// 初始化所有数据
    [self creatLoadView];
    
}
-(void)creatLoadView
{
    loadView =[[LoadingView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    loadView.delegate=self;
    [self.view addSubview:loadView];
    
}

-(void)createNavigation
{
    
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"tabbar_backgroud_color.png"] forBarMetrics:UIBarMetricsDefault];
    
    UILabel  *titleLable=[ZCControl createLabelWithFrame:CGRectMake(0, 0, 100, 20) Font:16 Text:@"发现详细"];
    titleLable.textColor=VBlue_color;
    
    titleLable.font=[UIFont boldSystemFontOfSize:18];
    titleLable.textAlignment=NSTextAlignmentCenter;
    self.navigationItem.titleView=titleLable;
    
    UIButton  *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"返回" forState:UIControlStateNormal];
   // [button setBackgroundImage:[UIImage imageNamed:@"setting.png"] forState:UIControlStateNormal];
    button.frame=CGRectMake(0, 0, 40, 40);
    button.tag=1000;
    [button setTitleColor:VBlue_color forState:UIControlStateNormal];
    [button addTarget:self action:@selector(naviagetionItemClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem  *barButton=[[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem=barButton;
    
    
//    
    UIButton  *sharebtn=[UIButton buttonWithType:UIButtonTypeCustom];
     [sharebtn setBackgroundImage:[UIImage imageNamed:@"find_share.png"] forState:UIControlStateNormal];
    sharebtn.frame=CGRectMake(0, 0, 25, 25);
    sharebtn.tag=1001;
    //[sharebtn setTitleColor:VBlue_color forState:UIControlStateNormal];
    [sharebtn addTarget:self action:@selector(naviagetionItemClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem  *rigthbarButton=[[UIBarButtonItem alloc]initWithCustomView:sharebtn];
    self.navigationItem.rightBarButtonItem=rigthbarButton;

    
    
    
    
}
//返回 取消
-(void)naviagetionItemClick:(UIButton *) btn
{
    if (btn.tag==1000) {
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }
    else if(btn.tag==1001)
    {
        //分享
        [CenterViewController shareButtonClick];
        
    }
}

-(void)initData
{
    self.pageContent =[[NSMutableArray alloc]init];
    self.indexArray =[[NSMutableArray alloc]init];
 }
// 初始化所有数据
- (void)requestData {
    UserDataCenter  *userCenter=[UserDataCenter shareInstance];
    NSString *userId=userCenter.user_id;
    NSDictionary *parameters= @{@"user_id":userId};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *urlString=[NSString stringWithFormat:@"%@/weibo/discover", kApiBaseUrl];
    
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"code"] intValue]==0) {
        
           // NSMutableArray  *Array =[[NSMutableArray alloc]initWithArray:[responseObject objectForKey:@"models"]];
            self.pageContent= [[NSMutableArray alloc] initWithArray:[weiboInfoModel objectArrayWithKeyValuesArray:[responseObject objectForKey:@"models"]]];
            
            if (self.pageContent.count==0) {
                [loadView showNullView:@"没有发现了..."];
            }
            else
            {
                [loadView stopAnimation];
                [loadView removeFromSuperview];
            }
            //存储页面的索引
            for (int i=0; i<self.pageContent.count;i++) {
                NSString  *index =[NSString stringWithFormat:@"%d",i];
                [self.indexArray  addObject:index];
            }
            [self createUI];
        }
        
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [loadView showFailLoadData];
         
        NSLog(@"Error: %@", error);
    }];
 }

-(void)reloadDataClick
{
    [self requestData];
    [loadView hidenFailLoadAndShowAnimation];
}
-(void)createUI
{
    // 设置UIPageViewController的配置项
    NSDictionary *options =[NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMax]
                                                       forKey: UIPageViewControllerOptionSpineLocationKey];
    
    // 实例化UIPageViewController对象，根据给定的属性
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                          navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                        options: options];
    // 设置UIPageViewController对象的代理
    _pageController.dataSource = self;
    _pageController.delegate=self;
    // 定义“这本书”的尺寸
    [[_pageController view] setFrame:[[self view] bounds]];
    
    // 让UIPageViewController对象，显示相应的页数据。
    // UIPageViewController对象要显示的页数据封装成为一个NSArray。
    // 因为我们定义UIPageViewController对象显示样式为显示一页（options参数指定）。
    // 如果要显示2页，NSArray中，应该有2个相应页数据。
    FindDatailViewController *initialViewController =[self viewControllerAtIndex:0];// 得到第一页
    
    //初始化的时候记录了当前的第一个viewcontroller  以后每次都在代理里面获取当前的viewcontroller
    CenterViewController=initialViewController;
    
    NSArray *viewControllers =[NSArray arrayWithObject:initialViewController];
    [_pageController setViewControllers:viewControllers
                              direction:UIPageViewControllerNavigationDirectionForward
                               animated:NO
                             completion:nil];
    // 在页面上，显示UIPageViewController对象的View
    [self addChildViewController:_pageController];
    [[self view] addSubview:[_pageController view]];

}


//根据下标值获取上一个控制器或者下一个控制器  得到相应的VC对象
- (FindDatailViewController *)viewControllerAtIndex:(NSUInteger)index {
    if (([self.pageContent count] == 0) || (index >= [self.pageContent count])) {
        return nil;
    }
    // 创建一个新的控制器类，并且分配给相应的数据
   FindDatailViewController * dataViewController =[[FindDatailViewController alloc] init];
    dataViewController.weiboInfo=[self.pageContent objectAtIndex:index];
    dataViewController.index=[self.indexArray objectAtIndex:index];
      return dataViewController;
}
 // 根据数组元素值，得到下标值
- (NSUInteger)indexOfViewController:(FindDatailViewController *)viewController {
    FindDatailViewController *dataViewController=(FindDatailViewController *)viewController;
    
    
    return [self.indexArray indexOfObject:dataViewController.index];
 }


// 返回上一个ViewController对象
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    //获取当前控制器
    
    CenterViewController =(FindDatailViewController *)viewController;
    
    NSUInteger index = [self indexOfViewController:(FindDatailViewController *)viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    index--;
    // 返回的ViewController，将被添加到相应的UIPageViewController对象上。
    // UIPageViewController对象会根据UIPageViewControllerDataSource协议方法，自动来维护次序。
    // 不用我们去操心每个ViewController的顺序问题。
    
    return [self viewControllerAtIndex:index];
    
}



// 返回下一个ViewController对象
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    
    
    CenterViewController =(FindDatailViewController *)viewController;

    NSUInteger index = [self indexOfViewController:(FindDatailViewController *)viewController];
    
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    if (index == [self.pageContent count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
    
    
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
