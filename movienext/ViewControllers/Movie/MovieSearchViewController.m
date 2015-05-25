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
#import "LoadingView.h"

#import "Constant.h"
//导入电影页的视图
#import "LoadingView.h"
#import "SearchmovieTableViewCell.h"
#import "UIImage+ImageWithColor.h"
#import "MovieDetailViewController.h"
@interface MovieSearchViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,LoadingViewDelegate>
{
    LoadingView   *loadView;
    UISearchBar  *search;
    

}
@property(nonatomic,strong) UITableView  *myTableView;
@property(nonatomic,strong) NSMutableArray *dataArray;
@end

@implementation MovieSearchViewController

 -(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[UINavigationBar appearance] setShadowImage:[UIImage imageWithColor:tabBar_line size:CGSizeMake(kDeviceWidth, 1)]];
    if (search) {
        [search becomeFirstResponder];
    }
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
    _myTableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0,kDeviceWidth, kDeviceHeight)];
    _myTableView.delegate=self;
    _myTableView.dataSource=self;
    _myTableView.separatorInset=UIEdgeInsetsMake(0, -110, 0, 0);
    [self.view addSubview:_myTableView];
}
-(void)creatLoadView
{
    loadView =[[LoadingView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kHeightNavigation)];
    loadView.delegate=self;
    [self.view addSubview:loadView];
}

-(void)requestData
{
    if ([search.text isEqualToString:@"00"]) {
        return;
    }
     //[self.view addSubview:loadView];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString *urlStr = [NSString stringWithFormat:@"http://movie.douban.com/subject_search?search_text=%@&cat=1002", [search.text URLEncodedString] ];
    [request setURL:[NSURL URLWithString:urlStr]];
    [request setHTTPMethod:@"GET"];
    NSOperationQueue * queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        //NSLog(@"response start");
        if (connectionError) {
            
            NSLog(@"httpresponse code error %@", connectionError);
           // [loadView showFailLoadData];
            
            
        } else {
             NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
            NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            if (responseCode == 200) {
                responseString = [Function getNoNewLine:responseString];
                NSString     * pattern = @"<a class=\"nbg\" href=\"http://movie\\.douban\\.com/subject/(\\d+)/\".*>\n.*<img src=\"(.*)\" alt=\"(.*?)\".*?/>";
                NSMutableArray *doubanInfos = [[DoubanService shareInstance] getDoubanInfosByResponse:responseString withpattern:pattern type:NServiceTypeSearch];
                _dataArray = doubanInfos;
                //if (_dataArray.count>0) {
                  //   [loadView stopAnimation];
                   // [loadView removeFromSuperview];
                    //loadView=nil;
                //}
                //else if(_dataArray.count==0)
                //{
                    //需要显示笑脸
                  //  [loadView showNullView:@"没搜索到电影"];
                    //return;
                //}
                [_myTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
            } else {
                NSLog(@"error");
              //  [loadView showFailLoadData];
                
            }
        }
    }];

}
-(void)reloadDataClick
{
    [self requestData];
    [loadView hidenFailLoadAndShowAnimation];
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
    return 90;

}

//表格的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return _dataArray.count;
 }

//配置Cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
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
}

//选择了cell之后
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [search resignFirstResponder];
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView==_myTableView) {
       if (_dataArray.count > indexPath.row) {
            MovieDetailViewController  *mvdetail =[[MovieDetailViewController alloc]init];
            mvdetail.douban_Id=[[_dataArray objectAtIndex:indexPath.row]  objectForKey:@"doubanId"];
            mvdetail.pageSourceType=NSMovieSourcePageSearchListController; //从电影列表页今日电影详细页面
           mvdetail.pageSourceType=NSMovieSourcePageSearchListController;
           mvdetail.movielogo=[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"smallimage"];
           
           mvdetail.moviename=[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"title"];
           UIBarButtonItem  *item =[[UIBarButtonItem alloc]initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:nil action:nil];
           self.navigationItem.backBarButtonItem=item;
            [self.navigationController pushViewController:mvdetail animated:YES];
           
        }
    }

}

#pragma  mark ----
#pragma  mark  ---UISearchBarDelegate
#pragma  mark  ----
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (self.dataArray.count>0) {
        [self.dataArray removeAllObjects];
        [self.myTableView reloadData];
    }
    if (searchBar.text.length==0) {
        [loadView removeFromSuperview];
    }
    [self requestData];
 }
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
}
-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    //[self creatLoadView];
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
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
