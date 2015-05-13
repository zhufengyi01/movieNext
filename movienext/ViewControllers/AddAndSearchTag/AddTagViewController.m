//
//  AddTagViewController.m
//  movienext
//
//  Created by 风之翼 on 15/4/28.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "AddTagViewController.h"
#import "ZCControl.h"
#import "Constant.h"
#import "AFNetworking.h"
#import "UserDataCenter.h"
@interface AddTagViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    UISearchBar  *search;
}
@end

@implementation AddTagViewController
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationItem.leftBarButtonItem=nil;
    self.navigationController.navigationBar.hidden=NO;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNavigation];
    [self initData];
    [self createUI];
}

-(void)createNavigation
{
    //[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"tabbar_backgroud_color.png"] forBarMetrics:UIBarMetricsDefault];
//    UIView  *navView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 64)];
//    navView.userInteractionEnabled=YES;
//    [self.view addSubview:navView];
    
    search=[[UISearchBar alloc]initWithFrame:CGRectMake(10, 30, kDeviceWidth-20, 28)];
    search.placeholder=@"请输入标签";
    search.delegate=self;
    search.showsCancelButton=YES;
    search.searchBarStyle = UISearchBarStyleMinimal;
    [search becomeFirstResponder];
    search.backgroundColor=[UIColor clearColor];
    //[navView addSubview:search];
    self.navigationItem.titleView=search;
}
-(void)initData
{
    _dataArray =[[NSMutableArray alloc]init];
}
-(void) createUI
{
    self.myTableView =[[UITableView alloc]initWithFrame:CGRectMake(0,0, kDeviceWidth, kDeviceHeight)];
    self.myTableView.delegate=self;
    self.myTableView.dataSource=self;
    [self.view addSubview:self.myTableView];

}
#pragma  mark -----
#pragma  mark ------  DataRequest －－－－－－－－－－－－－－－－－－－－－－－－－－
#pragma  mark ----
//屏幕剧照
-(void)RequestsearchData
{
    NSDictionary *parameters = @{@"title":search.text};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *urlString =[NSString stringWithFormat:@"%@/tag/search", kApiBaseUrl];
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject  objectForKey:@"code"]  intValue]==0) {
            NSLog(@"sdsd=======%@",responseObject);
            if (_dataArray==nil) {
                _dataArray= [[NSMutableArray alloc]init];
            }
            if (_dataArray.count>0) {
                [_dataArray removeAllObjects];
            }
            _dataArray =[[NSMutableArray alloc]initWithArray: [responseObject objectForKey:@"models"]];
            NSString *title0 =[NSString stringWithFormat:@"%@",search.text];
            NSMutableDictionary   *array0 =[NSMutableDictionary  dictionaryWithObject:title0 forKey:@"title"];
           [_dataArray insertObject:array0 atIndex:0];
            [self.myTableView reloadData];

            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}



#pragma  mark  -----searchBarDelegate --------

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self dismissViewControllerAnimated:NO completion:nil];
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    //[self dismissViewControllerAnimated:YES completion:nil];
    
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (search.text.length>0) {
     [search resignFirstResponder];
    }
}
-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    //[search resignFirstResponder];
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
 
    [_dataArray removeAllObjects];
    [self RequestsearchData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _dataArray.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString  *cellID=@"CELL";
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
     }
    if (_dataArray.count>indexPath.row) {
        if (indexPath.row==0) {
            cell.textLabel.text=[NSString stringWithFormat:@"添加 “%@” ",[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"title"]];
        }
        else
        {
        cell.textLabel.text=[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"title"];
        }
        cell.textLabel.font =[UIFont systemFontOfSize:14];
        
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //选择之后传递一个tag到添加微博页
    NSDictionary  *dict =[_dataArray objectAtIndex:indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(AddTagViewHandClickWithTag:)]) {
        [self.delegate AddTagViewHandClickWithTag:[dict objectForKey:@"title"]];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
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
