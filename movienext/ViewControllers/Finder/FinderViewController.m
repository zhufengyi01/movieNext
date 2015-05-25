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
#import "UserDataCenter.h"
#import "weiboInfoModel.h"
@interface FinderViewController ()<UIPageViewControllerDataSource,UIPageViewControllerDelegate>

{
    int pagesize;
    int page;
}
@property (strong, nonatomic) UIPageViewController *pageController;

@property (strong, nonatomic) NSMutableArray *pageContent;

@end

@implementation FinderViewController
-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden=NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNavigation];
    self.view.backgroundColor =View_BackGround;
    [self initData];
    [self createContentPages];// 初始化所有数据
    
   // [self createUI];
    
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
    //[button setBackgroundImage:[UIImage imageNamed:@"setting.png"] forState:UIControlStateNormal];
    button.frame=CGRectMake(0, 0, 40, 40);
    [button setTitleColor:VBlue_color forState:UIControlStateNormal];
    [button addTarget:self action:@selector(GotoSettingClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem  *barButton=[[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem=barButton;
    
    
}
-(void)GotoSettingClick
{
    self.tabBarController.tabBar.hidden=NO;
    
}

-(void)initData
{
    self.pageContent =[[NSMutableArray alloc]init];
    page=1;
    pagesize=20;
}
// 初始化所有数据
- (void) createContentPages {
    UserDataCenter  *userCenter=[UserDataCenter shareInstance];
    NSString *userId=userCenter.user_id;
    
    NSDictionary *parameters;
    parameters = @{@"user_id":userId,@"Version":Version};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *urlString=[NSString stringWithFormat:@"%@/hot/list?per-page=%d&page=%d", kApiBaseUrl,pagesize,page];
    [manager  POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"code"] intValue]==0) {
            
            
            NSMutableArray  *Detailarray=[responseObject objectForKey:@"models"];
            for (NSDictionary  *hotDict in Detailarray) {
                ModelsModel  *model =[[ModelsModel alloc]init];
                if(model)
                {
                    [model setValuesForKeysWithDictionary:hotDict];
                    //stageinfo
                    stageInfoModel  *stagemodel =[[stageInfoModel alloc]init];
                    if (stagemodel) {
                        if(![[hotDict objectForKey:@"stage"] isKindOfClass:[NSNull class]])
                        {
                            [stagemodel setValuesForKeysWithDictionary:[hotDict objectForKey:@"stage"]];
                            //weiboinfo
                            NSMutableArray  *weibosarray=[[NSMutableArray alloc]init];
                            for (NSDictionary  *weibodict  in [[hotDict objectForKey:@"stage"] objectForKey:@"weibos"]) {
                                weiboInfoModel *weibomodel=[[weiboInfoModel alloc]init];
                                if (weibomodel) {
                                    [weibomodel setValuesForKeysWithDictionary:weibodict];
                                    //weibouserInfo
                                    weiboUserInfoModel  *usermodel =[[weiboUserInfoModel alloc]init];
                                    if (usermodel) {
                                        [usermodel setValuesForKeysWithDictionary:[weibodict objectForKey:@"user"]];
                                        weibomodel.uerInfo=usermodel;
                                    }
                                    //tag
                                    NSMutableArray  *tagArray = [[NSMutableArray alloc]init];
                                    for (NSDictionary  *tagDict  in [weibodict objectForKey:@"tags"]) {
                                        TagModel *tagmodel =[[TagModel alloc]init];
                                        if (tagmodel) {
                                            [tagmodel setValuesForKeysWithDictionary:tagDict];
                                            TagDetailModel *tagedetail = [[TagDetailModel alloc]init];
                                            if (tagedetail) {
                                                if (![[tagDict objectForKey:@"tag"] isKindOfClass:[NSNull class]]) {
                                                    [tagedetail setValuesForKeysWithDictionary:[tagDict  objectForKey:@"tag"]];
                                                    tagmodel.tagDetailInfo=tagedetail;}
                                            }
                                            [tagArray addObject:tagmodel];}}
                                    weibomodel.tagArray=tagArray;
                                    [weibosarray addObject:weibomodel];
                                }
                            }
                            stagemodel.weibosArray=weibosarray;
                            //moviemodel
                            movieInfoModel *moviemodel =[[movieInfoModel alloc]init];
                            if (moviemodel) {
                                [moviemodel setValuesForKeysWithDictionary:[[hotDict objectForKey:@"stage"] objectForKey:@"movie"]];
                                stagemodel.movieInfo=moviemodel;
                            }
                        }
                        model.stageInfo=stagemodel;
                        
                    }
                    if(self.pageContent==nil)
                    {
                        self.pageContent =[[NSMutableArray alloc]init];
                        
                    }
                    [self.pageContent addObject:model];
                }
            }
            
            [self createUI];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}
// 得到相应的VC对象
- (FindDatailViewController *)viewControllerAtIndex:(NSUInteger)index {
    if (([self.pageContent count] == 0) || (index >= [self.pageContent count])) {
        return nil;
    }
    // 创建一个新的控制器类，并且分配给相应的数据
    FindDatailViewController *dataViewController =[[FindDatailViewController alloc] init];
    ModelsModel *model =[self.pageContent objectAtIndex:index];
    
    dataViewController.stageInfo =model.stageInfo;
    
    return dataViewController;
}

-(void)createUI
{
    // 设置UIPageViewController的配置项
    NSDictionary *options =[NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin]
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
    NSArray *viewControllers =[NSArray arrayWithObject:initialViewController];
    [_pageController setViewControllers:viewControllers
                              direction:UIPageViewControllerNavigationDirectionForward
                               animated:NO
                             completion:nil];
    // 在页面上，显示UIPageViewController对象的View
    [self addChildViewController:_pageController];
    [[self view] addSubview:[_pageController view]];

}
// 根据数组元素值，得到下标值
- (NSUInteger)indexOfViewController:(FindDatailViewController *)viewController {
    FindDatailViewController *dataViewController=(FindDatailViewController *)viewController;
    
    return [self.pageContent indexOfObject:dataViewController.stageInfo];
}


// 返回上一个ViewController对象
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    
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
