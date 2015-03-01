//
//  MovieViewController.m
//  movienext
//
//  Created by 风之翼 on 15/2/27.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "MovieViewController.h"
#import "Constant.h"
//#import  "SearchMovieViewController.h"
@interface MovieViewController ()<UISearchBarDelegate>
{
    UICollectionView   *_myCollectionView;
    
}

@end

@implementation MovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    //创建导航
    [self createNavigation];
    
}
-(void)createNavigation
{
    UISearchBar  *search=[[UISearchBar alloc]initWithFrame:CGRectMake(20, 10, kDeviceWidth-40, 28)];
    search.placeholder=@"搜索电影";
    search.delegate=self;
    //search.backgroundColor=[UIColor redColor];
    self.navigationItem.titleView=search;
    
}

#pragma  mark  ------
#pragma  mark  ------- searchBardelgate
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
  //  [self.navigationController pushViewController:[SearchMovieViewController new] animated:YES];
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
