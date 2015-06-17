//
//  MovieSearchViewController.m
//  movienext
//
//  Created by 风之翼 on 15/3/2.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "MovieSearchViewController.h"
//导入图片处理引擎框架
#import "UIImageView+WebCache.h"
//导入常量
#import "Constant.h"
//导入App delegate
#import "AppDelegate.h"
//导入网络请求引擎框架
#import "AFNetworking.h"
//导入图片加载框架
#import "UIImageView+WebCache.h"
//导入豆瓣Model
//#import "DoubanInfo.h"
//导入豆瓣扩展
#import "DoubanService.h"
//导入字符串扩展
#import "NSString+Additions.h"
//导入功能类
#import "Function.h"
//导入常量类
#import "Constant.h"
//导入电影页的视图
#import "LoadingView.h"
#import "SearchmovieTableViewCell.h"
#import "UIImage+ImageWithColor.h"
#import "MovieDetailViewController.h"
#import "ShowSelectPhotoViewController.h"

@interface MovieSearchViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate, LoadingViewDelegate>
{
    LoadingView   *loadView;
    UISearchBar  *search;
}
@property(nonatomic,strong) UITableView  *myTableView;
@property(nonatomic,strong) NSMutableArray *dataArray;


@property(nonatomic, retain) UITableView *historyTableView;
@property(nonatomic, retain) NSMutableArray *historyMovieNames;
@end

@implementation MovieSearchViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[UINavigationBar appearance] setShadowImage:[UIImage imageWithColor:tabBar_line size:CGSizeMake(kDeviceWidth, 1)]];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=View_BackGround;
    [self createNavigation];
    [self initData];
    [self initUI];
    //[self creatLoadView];
}

-(void)creatLoadView
{
    loadView =[[LoadingView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    loadView.delegate=self;
    loadView.hidden=YES;
    [self.view addSubview:loadView];
    
}

-(void)createNavigation
{
    
    
    UIView  *v =[[UIView alloc]init];
    self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc]initWithCustomView:v];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"tabbar_backgroud_color.png"] forBarMetrics:UIBarMetricsDefault];
    search=[[UISearchBar alloc]initWithFrame:CGRectMake(30, 10, 0, 28)];
    search.placeholder=@"搜索电影";
    if (self.pageType==NSSearchSourceTypeAddCard) {
        search.placeholder=@"搜索要添加的电影";
    }
    search.delegate=self;
    search.searchBarStyle=UISearchBarStyleMinimal;
    //search.showsCancelButton=YES;
    [search becomeFirstResponder];
    self.navigationItem.titleView=search;
    
    UIButton  *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"取消" forState:UIControlStateNormal];
    [button setTitleColor:VBlue_color forState:UIControlStateNormal];
    button.frame=CGRectMake(0, 0, 40, 30);
    button.titleLabel.font =[UIFont systemFontOfSize:16];
    [button setTitleColor:VGray_color forState:UIControlStateNormal];
    button.titleEdgeInsets=UIEdgeInsetsMake(0,5, 0, -5);
    [button addTarget:self action:@selector(CancleClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem  *barButton=[[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem=barButton;
    
    
}
-(void)CancleClick
{
    
    [search resignFirstResponder];
    if (self.pageType==NSSearchSourceTypeAddCard) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        [self.navigationController popViewControllerAnimated:NO];
        
    }
}
-(void)initData
{
    _dataArray=[[NSMutableArray alloc]init];
}
-(void)initUI
{
    _myTableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0,kDeviceWidth, kDeviceHeight-kHeightNavigation)];
    _myTableView.delegate=self;
    _myTableView.dataSource=self;
    _myTableView.separatorInset=UIEdgeInsetsMake(0, -110, 0, 0);
    //    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_myTableView];
    
    _historyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 400) style:UITableViewStylePlain];
    _historyTableView.delegate = self;
    _historyTableView.dataSource = self;
    //    _historyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //[_myTableView addSubview:_historyTableView];
    
    _historyMovieNames = [[NSUserDefaults standardUserDefaults] objectForKey:@"history"];
    for (NSString *name in _historyMovieNames) {
        NSLog(@"name = %@", name);
    }
    [_historyTableView reloadData];
    [self createFooterView];
    
}
-(void)createFooterView
{
 
    UIView  *foot =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth,40)];
    foot.backgroundColor=[UIColor whiteColor];
    
    UIView  *line =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 0.5)];
    line.backgroundColor =VGray_color;
    [foot addSubview:line];
    UILabel  *labefoot =[[UILabel alloc]initWithFrame:CGRectMake(0, 1, kDeviceWidth, 39)];
    labefoot.textColor=VGray_color;
    labefoot.font=[UIFont systemFontOfSize:12];
    labefoot.textAlignment=NSTextAlignmentCenter;
    labefoot.text=@"THE END";
    [foot addSubview:labefoot];
    [self.myTableView setTableFooterView:foot];
}

#pragma  mark   -------------------数据请求
//根据豆瓣id  请求movieid
-(void)requestMovieIdWithdoubanId:(NSString *) douban_Id
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"douban_id": douban_Id};
    
    [manager POST:[NSString stringWithFormat:@"%@/movie/create", kApiBaseUrl] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject  objectForKey:@"code"] intValue]==0) {
            
            NSLog(@"responseobject = %@", responseObject);
            NSDictionary *detail = [responseObject objectForKey:@"model"];
            NSString * movie_id = [detail objectForKey:@"id"];
            
            //请求完成后执行跳转页面
            ShowSelectPhotoViewController  *vc =[[ShowSelectPhotoViewController alloc]init];
            vc.douban_id=douban_Id;
            vc.movie_id=movie_id;
            vc.movie_name=[detail objectForKey:@"name"];
            UIBarButtonItem  *item =[[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
            if (self.pageType==NSSearchSourceTypeAddCard) {
                vc.pageType=NSShowSelectViewSoureTypeAddCard;
            }
            self.navigationItem.backBarButtonItem=item;
            [self.navigationController pushViewController:vc  animated:YES];
            
            
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        //[loadView showNullView:@"没有数据..."];
        
    }];
    
}



-(void)requestData
{
    //    if ([search.text isEqualToString:@"00"]) {
    //        return;
    //    }
    
    //存储历史搜索开始
    NSMutableArray *history = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"history"]];
    if ([history containsObject:search.text]) { // 存在则移除
        [history removeObject:search.text];
    }
    [history insertObject:search.text atIndex:0];
    
    if ([history count] > 6) {
        [history removeLastObject];
    }
    [[NSUserDefaults standardUserDefaults] setObject:history forKey:@"history"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //存储历史搜索结束
    
    _historyTableView.hidden = YES;
    
    loadView.hidden=NO;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString *urlStr = [NSString stringWithFormat:@"http://movie.douban.com/subject_search?search_text=%@&cat=1002", [search.text URLEncodedString] ];
    [request setURL:[NSURL URLWithString:urlStr]];
    [request setHTTPMethod:@"GET"];
    NSOperationQueue * queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        //NSLog(@"response start");
        if (connectionError) {
            NSLog(@"httpresponse code error %@", connectionError);
            [loadView showFailLoadData];
        } else {
            loadView.hidden=YES;
            NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
            NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            if (responseCode == 200) {
                if ( responseString == nil ) {
                    NSLog(@"没有数据");
                    //添加一个无内容的笑脸
                    [loadView showFailLoadData];
                } else {
                    responseString = [Function getNoNewLine:responseString];
                    
                    NSString     * pattern = @"<a class=\"nbg\" href=\"http://movie\\.douban\\.com/subject/(\\d+)/\".*>\n.*<img src=\"(.*)\" alt=\"(.*?)\".*?/>";
                    NSMutableArray *doubanInfos = [[DoubanService shareInstance] getDoubanInfosByResponse:responseString withpattern:pattern type:NServiceTypeSearch];
                    _dataArray = doubanInfos;
                    if (_dataArray.count>0) {
                        // NSLog(@"------_dataArray -=====%@",_dataArray);
                        [_myTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
                    } else {
                        //添加一个无内容的笑脸
                        [loadView showNullView:@"没有数据"];
                    }
                }
            } else {
                [loadView showFailLoadData];
                
                NSLog(@"error");
            }
        }
    }];
}
-(void)reloadDataClick
{
    [loadView hidenFailLoadAndShowAnimation];
    [self requestData];
}

#pragma mark --
#pragma mark  -UITableViewDelegate
#pragma  mark --
//表格的区间数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
//表格的行高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return tableView==_myTableView ? 90 : 44;
}
//表格的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return tableView==_myTableView ? _dataArray.count : _historyMovieNames.count;
}

//配置Cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _myTableView) {
        static NSString  *cellID=@"CELL";
        SearchmovieTableViewCell  *cell=(SearchmovieTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell=[[SearchmovieTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        if (_dataArray.count > indexPath.row) {
            [cell setCellValue:[_dataArray  objectAtIndex:(long)indexPath.row]];
            
        }
        return cell;
    } else if (tableView == _historyTableView) {
        static NSString *historyCell = @"historyCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:historyCell];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:historyCell];
        }else{
            for (UIView *view in [cell.contentView subviews]){
                [view removeFromSuperview];
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.imageView.image = [UIImage imageNamed:@"make_searchbar_history"];
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
        cell.textLabel.text = [_historyMovieNames objectAtIndex:indexPath.row];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 43, 320, 1)];
        lineView.backgroundColor  = [UIColor colorWithRed:227.0f/255.0f green:227.0f/255.0f blue:227.0f/255.0f alpha:1];
        [cell.contentView addSubview:lineView];
        return cell;
    }
    
    return nil;
}

//选择了cell之后
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [search resignFirstResponder];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView==_myTableView) {
        if (_dataArray.count > indexPath.row) {
            if (self.pageType==NSSearchSourceTypeMovieList) {
                MovieDetailViewController  *mvdetail =[[MovieDetailViewController alloc]init];
                mvdetail.douban_Id=[[_dataArray objectAtIndex:indexPath.row]  objectForKey:@"doubanId"];
                mvdetail.pageSourceType=NSMovieSourcePageSearchListController; //从电影列表页今日电影详细页面
                mvdetail.pageSourceType=NSMovieSourcePageSearchListController;
                mvdetail.movielogo=[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"smallimage"];
                mvdetail.moviename=[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"title"];
                
                UIBarButtonItem  *item =[[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
                self.navigationItem.backBarButtonItem=item;
                [self.navigationController pushViewController:mvdetail animated:YES];
            }
            else if(self.pageType==NSSearchSourceTypeAddCard) //从添加电影进入  直接进去添加
            {
                NSDictionary  *dict =[_dataArray objectAtIndex:indexPath.row];
                //根据豆瓣id 请求电影信息
                [self requestMovieIdWithdoubanId:[dict objectForKey:@"doubanId"]];
            }
        }
    } else if (tableView == _historyTableView) {
        search.text = [_historyMovieNames objectAtIndex:indexPath.row];
        [self requestData];
    }
    
}

#pragma  mark ----
#pragma  mark  ---UISearchBarDelegate
#pragma  mark  ----
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    //    [self requestData];
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self requestData];
    [searchBar resignFirstResponder];
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (search.text.length>0) {
        [search resignFirstResponder];
        
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
