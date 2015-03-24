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
#import "MovieDetailViewController.h"
@interface MovieSearchViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    LoadingView   *loadView;
    UITableView   *_myTableView;
    NSMutableArray    *_dataArray;
    UISearchBar  *search;

}
@end

@implementation MovieSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=View_BackGround;
    [self createNavigation];
    [self initData];
    [self initUI];
    
  //  [self requestData];
    

}
-(void)createNavigation
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"tabbar_backgroud_color.png"] forBarMetrics:UIBarMetricsDefault];
    search=[[UISearchBar alloc]initWithFrame:CGRectMake(30, 10, 0, 28)];
    search.placeholder=@"搜索电影";
    search.delegate=self;
    search.searchBarStyle=UISearchBarStyleMinimal;
    search.showsCancelButton=YES;
    [search becomeFirstResponder];
    self.navigationItem.titleView=search;
    
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
    [self.view addSubview:_myTableView];
}
-(void)requestData
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString *urlStr = [NSString stringWithFormat:@"http://movie.douban.com/subject_search?search_text=%@&cat=1002", [search.text URLEncodedString] ];
    [request setURL:[NSURL URLWithString:urlStr]];
    [request setHTTPMethod:@"GET"];
    NSOperationQueue * queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSLog(@"response start");
        if (connectionError) {
            NSLog(@"httpresponse code error %@", connectionError);
        } else {
            NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
            NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            if (responseCode == 200) {
                responseString = [Function getNoNewLine:responseString];
                
                NSMutableArray *doubanInfos = [[DoubanService shareInstance] getDoubanInfosByResponse:responseString];
                _dataArray = doubanInfos;
                NSLog(@"------_dataArray -=====%@",_dataArray);
                [_myTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
            } else {
                NSLog(@"error");
            }
        }
    }];

}
#pragma mark --
#pragma mark  -UITableViewDelegate
#pragma  mark --
//表格的区间数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView==_myTableView) {
      return 1;
    }
    return 0;
}

//表格的行高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   if (tableView==_myTableView) {
    return 90;
    }
    return 0;
}

//表格的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView==_myTableView) {
        return _dataArray.count;
    }
    return 0;
}

//配置Cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString  *cellID=@"CELL";
    SearchmovieTableViewCell  *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell=[[SearchmovieTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (_dataArray.count > indexPath.row) {
     [cell setCellValue:[_dataArray  objectAtIndex:(long)indexPath.row]];
    }
    NSLog(@"======== cell for row  =====%@",[_dataArray  objectAtIndex:indexPath.row]);
    
    return cell;
}

//选择了cell之后
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView==_myTableView) {
        if (_dataArray.count > indexPath.row) {
            MovieDetailViewController  *mvdetail =[[MovieDetailViewController alloc]init];
            mvdetail.douban_Id=[[_dataArray objectAtIndex:indexPath.row]  objectForKey:@"doubanId"];
            mvdetail.pageSourceType=NSMovieSourcePageSearchListController; //从电影列表页今日电影详细页面
            [self.navigationController pushViewController:mvdetail animated:YES];
        }
    }
 
}

#pragma  mark ----
#pragma  mark  ---UISearchBarDelegate
#pragma  mark  ----
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self requestData];
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self requestData];
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [search resignFirstResponder];
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
