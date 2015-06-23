//
//  ChangeSelfViewController.m
//  movienext
//
//  Created by 风之翼 on 15/4/1.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "ChangeSelfViewController.h"
#import "ZCControl.h"
#import "AFNetworking.h"
#import "Constant.h"
#import "ZCControl.h"
#import "UIImageView+WebCache.h"
#import "AddUserViewController.h"
#import "UserDataCenter.h"
#import "Function.h"
#import "ChangeSelfTableViewCell.h"
@interface ChangeSelfViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
{
    NSMutableArray   *_DataArray;
    NSMutableArray   *_detailArray;
    NSMutableArray   *_searchArray;
    UISearchBar      *_searchBar;
    UITableView      *_myTableView;
}

@end

@implementation ChangeSelfViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNavigation];
    [self initData];
    [self createUI];
    
    [self requestData];
    
}
-(void)createNavigation
{
    UILabel  *titleLable=[ZCControl createLabelWithFrame:CGRectMake(0, 0, 100, 20) Font:16 Text:@"搜索并添加用户"];
    titleLable.textColor=VBlue_color;
    
    titleLable.font=[UIFont fontWithName:kFontDouble size:18];
    titleLable.textAlignment=NSTextAlignmentCenter;
    self.navigationItem.titleView=titleLable;
    
    UIButton  *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"添加" forState:UIControlStateNormal];
    button.frame=CGRectMake(kDeviceWidth-30, 10, 18, 18);
    [button addTarget:self action:@selector(addCustomClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem  *barButton=[[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem=barButton;
    
}
-(void)addCustomClick
{
    
    [self.navigationController pushViewController:[AddUserViewController new] animated:YES];
    
}
-(void)initData
{
    _detailArray =[[NSMutableArray alloc]init];
    _DataArray=[[NSMutableArray alloc]init];
    
}
#pragma  mark  -----
#pragma  mark  -------requstData
#pragma  mark  ---
-(void)requestData
{
    UserDataCenter *userCenter=[UserDataCenter shareInstance];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString  *urlString =[NSString stringWithFormat:@"%@/user/fakelist", kApiBaseUrl];
    NSString *tokenSting =[Function getURLtokenWithURLString:urlString];
    NSDictionary  *parameters=@{@"user_id":userCenter.user_id,KURLTOKEN:tokenSting};
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject  objectForKey:@"return_code"]  intValue]==0) {
            NSLog(@"虚拟用户请求成功=======%@",responseObject);
            if (_DataArray ==nil) {
                _DataArray=[[NSMutableArray alloc]init];
            }
            _detailArray =[responseObject objectForKey:@"models"];
            _DataArray=[NSMutableArray arrayWithArray:_detailArray];
            [_myTableView reloadData];
            
        }
        else
        {
            NSLog(@"Error: ");
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}
-(void)createUI
{
    
    _searchBar =[[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 40)];
    _searchBar.delegate=self;
    _searchBar.placeholder=@"请输入用户";
    _searchBar.searchBarStyle=UISearchBarStyleMinimal;
    [_searchBar becomeFirstResponder];
    _searchBar.delegate=self;
    [self.view addSubview:_searchBar];
    
    _myTableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 40, kDeviceWidth, kDeviceHeight-40-kHeightNavigation)];
    _myTableView.delegate=self;
    _myTableView.dataSource=self;
    [self.view addSubview:_myTableView];
}
#pragma mark      ------
#pragma  mark    ------  UITableViewDelegate
#pragma  mark    ----
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==_myTableView) {
        return _DataArray.count;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==_myTableView) {
        return 60.0f;
    }
    return 60.0f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static  NSString  *cellID=@"CELL";
    ChangeSelfTableViewCell   *cell;
    if (tableView==_myTableView) {
        if (_DataArray.count>indexPath.row) {
            cell=[tableView dequeueReusableCellWithIdentifier:cellID];
            if (!cell) {
                cell=[[ChangeSelfTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            }
            
            NSDictionary  *dict =[_DataArray objectAtIndex:indexPath.row];
            [cell configCellWithdict:dict];
            
        }
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView==_myTableView) {
        
        UIActionSheet   *ash=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定变身" otherButtonTitles:nil, nil];
        ash.tag=indexPath.row+100;
        [ash showInView:self.view];
    }
}

#pragma mark ----------
#pragma mark  ------uisearchBarDelegate
#pragma mark  -------
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [_DataArray removeAllObjects];
    if (searchBar.text.length==0||[searchBar.text isEqualToString:@""]) {
        _DataArray =[NSMutableArray arrayWithArray:_detailArray];
    }
    else
    {
        for (int i=0;i<_detailArray.count;i++) {
            NSMutableString  *nameStr =[[_detailArray  objectAtIndex:i] objectForKey:@"username"];
            if ([nameStr rangeOfString:[searchBar text]].location!=NSNotFound) {
                if (_DataArray==nil) {
                    _DataArray =[NSMutableArray array];
                }
                [_DataArray addObject:[_detailArray objectAtIndex:i]];
                
            }
        }
    }
    [_myTableView reloadData];
}
-(void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_searchBar resignFirstResponder];
}
-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [_searchBar resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark  ------
#pragma mark  ------UIActionSheetDelegate
#pragma mark  -------
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        NSDictionary   *dict =[_DataArray objectAtIndex:actionSheet.tag-100];
        UserDataCenter *userCenter=[UserDataCenter shareInstance];
        userCenter.user_id=[dict objectForKey:@"id"];
        userCenter.logo=[dict objectForKey:@"logo"];
        //  userCenter.is_admin=[dict objectForKey:@"level"];
        userCenter.verified=[dict objectForKey:@"verified"];
        userCenter.fake=[dict objectForKey:@"fake"];
        userCenter.sex=[dict objectForKey:@"sex"];
        userCenter.signature =[dict objectForKey:@"brief"];
        //需要使用通知去刷新个人页的信息，这里同时需要去更改本地存储的用户
        [[NSNotificationCenter defaultCenter]  postNotificationName:@"initUser" object:nil];
        [Function saveUser:userCenter];
        [self.navigationController popViewControllerAnimated:YES];
        
    }
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
