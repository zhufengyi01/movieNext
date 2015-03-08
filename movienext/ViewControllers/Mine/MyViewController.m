//
//  MyViewController.m
//  movienext
//
//  Created by 风之翼 on 15/2/27.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "MyViewController.h"
#import "Constant.h"
#import "ZCControl.h"
#import "LoadingView.h"
#import "UserDataCenter.h"
#import "AFNetworking.h"
#import "CommonStageCell.h"
#import "SettingViewController.h"
@interface MyViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UISegmentedControl *segment;
    UITableView   *_tableView;
    NSMutableArray    *_addedDataArray;
    NSMutableArray    *_upedDataArray;
    LoadingView   *loadView;
    int page;
    
    UIImageView *ivAvatar;//头像
    UILabel *lblUsername;//用户名
    UILabel *lblCount;//统计信息
    UILabel *lblBrief;//简介
}
@end

@implementation MyViewController
-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden=NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor yellowColor];
    UILabel  *titleLable=[ZCControl createLabelWithFrame:CGRectMake(0, 0, 100, 20) Font:16 Text:@"我的"];
    titleLable.textColor=VBlue_color;
    titleLable.font=[UIFont boldSystemFontOfSize:16];
    titleLable.textAlignment=NSTextAlignmentCenter;
    self.navigationItem.titleView=titleLable;

    [self createNavigation];
    [self initData];
    [self createTableView];
    [self createLoadview];
    [self requestData];
}

-(void)initData {
    _addedDataArray = [[NSMutableArray alloc] init];
    _upedDataArray = [[NSMutableArray alloc] init];
}
#pragma mark - CreateUI
-(void)createNavigation
{
    self.navigationController.navigationItem.title=@"我的";
    
    UIButton  *button=[UIButton buttonWithType:UIButtonTypeCustom];
    //[button setTitle:@"设置" forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"setting.png"] forState:UIControlStateNormal];
    button.frame=CGRectMake(kDeviceWidth-30, 10, 18, 18);
    [button addTarget:self action:@selector(GotoSettingClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem  *barButton=[[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem=barButton;
    
    
}

-(void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    
    UIView *viewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 130)];
    viewHeader.backgroundColor = [UIColor greenColor];
    
    int ivAvatarWidth = 50;
    ivAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(25, 20, ivAvatarWidth, ivAvatarWidth)];
    ivAvatar.layer.cornerRadius = ivAvatarWidth * 0.5;
    ivAvatar.layer.masksToBounds = YES;
    ivAvatar.backgroundColor = [UIColor redColor];
    [viewHeader addSubview:ivAvatar];
    
    lblUsername = [[UILabel alloc] initWithFrame:CGRectMake(85, 25, 200, 20)];
    lblUsername.font = [UIFont systemFontOfSize:15];
    lblUsername.textColor = [UIColor grayColor];
    lblUsername.backgroundColor = [UIColor blueColor];
    [viewHeader addSubview:lblUsername];
    
    lblCount = [[UILabel alloc] initWithFrame:CGRectMake(85, 45, 200, 20)];
    lblCount.font = [UIFont systemFontOfSize:10];
    lblCount.textColor = [UIColor grayColor];
    lblCount.backgroundColor = [UIColor purpleColor];
    [viewHeader addSubview:lblCount];
    
    lblBrief = [[UILabel alloc] initWithFrame:CGRectMake(ivAvatar.frame.origin.x, 70, kDeviceWidth-50, 20)];
    lblBrief.font = [UIFont systemFontOfSize:12];
    lblBrief.textColor = [UIColor grayColor];
    lblBrief.backgroundColor = [UIColor orangeColor];
    [viewHeader addSubview:lblBrief];
    
    NSArray *segmentedArray = [[NSArray alloc] initWithObjects:@"添加", @"赞", nil];

    segment = [[UISegmentedControl alloc] initWithItems:segmentedArray];
    segment.frame = CGRectMake(kDeviceWidth/4, 95, kDeviceWidth/2, 30);
    segment.selectedSegmentIndex = 0;
    segment.backgroundColor = [UIColor clearColor];
    segment.tintColor = kAppTintColor;
    [segment addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventValueChanged];
    [viewHeader addSubview:segment];
    [_tableView setTableHeaderView:viewHeader];
}

-(void)segmentClick:(UISegmentedControl *)seg
{
    if(seg.selectedSegmentIndex==0)
    {
        [_tableView reloadData];
        if (_addedDataArray.count==0) {
            [self requestData];
        }
    }
    else if(seg.selectedSegmentIndex==1)
    {
        [_tableView reloadData];
        
        if (_upedDataArray.count==0) {
            [self requestData];
        }
    }
    
}
- (void)createLoadview
{
    loadView =[[LoadingView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    [self.view addSubview:loadView];
}

#pragma  mark -----
#pragma  mark ------  DataRequest 
#pragma  mark ----
- (void)requestData{
    UserDataCenter  *userCenter=[UserDataCenter shareInstance];
    NSDictionary *parameters = @{@"user_id":@"18", @"page":[NSString stringWithFormat:@"%d",page], @"author_id":@"54"};
    NSString * section;
    if (segment.selectedSegmentIndex==1) {  // 赞过的
        section=@"weibo/upedListByUserId";
    }
    else if(segment.selectedSegmentIndex==0) // 用户添加的
    {
        section= @"weibo/listByUserId";
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //    [manager POST:[NSString stringWithFormat:@"%@/movieStage/listRecently", kApiBaseUrl] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    [manager POST:[NSString stringWithFormat:@"%@/%@", kApiBaseUrl, section] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [loadView stopAnimation];
        loadView.hidden=YES;
        NSMutableArray  *Detailarray=[responseObject objectForKey:@"detail"];
        if (segment.selectedSegmentIndex==0) {
            if (_addedDataArray ==nil) {
                _addedDataArray=[[NSMutableArray alloc]init];
            }
            NSLog(@"用户添加的数据 JSON: %@", responseObject);
            [_addedDataArray addObjectsFromArray:Detailarray];
            [_tableView reloadData];

        }
        else if(segment.selectedSegmentIndex==1)
        {
            if (_upedDataArray==nil) {
                _upedDataArray=[[NSMutableArray alloc]init];
            }
            NSLog(@"用户赞过的数据 JSON: %@", responseObject);
            [_upedDataArray addObjectsFromArray:Detailarray];
            [_tableView reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}
#pragma mark  -----
#pragma mark --------UItableViewDelegate
#pragma mark  -------
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (segment.selectedSegmentIndex==0) {
        return _addedDataArray.count;
    }
    else if (segment.selectedSegmentIndex==1)
    {
        return _upedDataArray.count;
    }
    return 0;
}

-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (segment.selectedSegmentIndex==0) {
            float hight;
            if (_addedDataArray.count>indexPath.row) {
            float  h=   [[[[_addedDataArray  objectAtIndex:indexPath.row]  objectForKey:@"stageinfo"] objectForKey:@"h"] floatValue];
            float w=   [[[[_addedDataArray  objectAtIndex:indexPath.row]  objectForKey:@"stageinfo"] objectForKey:@"w"] floatValue];
            if (w==0||h==0) {
                 hight= kDeviceWidth+45;
            }
             if (w>h) {
                hight= kDeviceWidth+45;
            }
            else if(h>w)
            {
                 hight=  (h/w) *kDeviceWidth;
            }
            }
            NSLog(@"============  hight  for  row  =====%f",hight);
            return hight+10;
    }
    else if (segment.selectedSegmentIndex==1)
    {
            float hight;
            if (_upedDataArray.count>indexPath.row) {
            
          //  return 200;
            float  h=   [[[[_upedDataArray  objectAtIndex:indexPath.row]  objectForKey:@"stageinfo"] objectForKey:@"h"] floatValue];
            float w=   [[[[_upedDataArray  objectAtIndex:indexPath.row]  objectForKey:@"stageinfo"] objectForKey:@"w"] floatValue];
            if (w==0||h==0) {
                hight= kDeviceWidth+90;
            }
            if (w>h) {
                hight= kDeviceWidth+90;
            }
            else if(h>w)
            {
                hight=  (h/w)*kDeviceWidth+90;
            }
            }
            NSLog(@"============  hight  for  row  =====%f",hight);

            return hight+10;
    }
    return 200.0f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if  (segment.selectedSegmentIndex==0) {
        static NSString *cellID=@"CELL1";
        CommonStageCell  *cell= (CommonStageCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell=[[CommonStageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.backgroundColor=View_BackGround;
        }
     
        if (_addedDataArray.count>indexPath.row) {
            cell.pageType=NSPageSourceTypeMainHotController;
            //小闪动标签的数组
            cell.WeibosArray=[[_addedDataArray objectAtIndex:indexPath.row]  objectForKey:@"weibos"];
            [cell setCellValue:[[_addedDataArray objectAtIndex:indexPath.row]  objectForKey:@"stageinfo"] indexPath:indexPath.row];
        }
        return cell;
    }
    else if (segment.selectedSegmentIndex==1)
    {
        static NSString *cellID=@"CELL2";
        CommonStageCell  *cell= (CommonStageCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell=[[CommonStageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.backgroundColor=View_BackGround;
        }
        if (_upedDataArray.count>indexPath.row) {
            cell.pageType=NSPageSourceTypeMainNewController;
            cell.weiboDict =[[_upedDataArray  objectAtIndex:indexPath.row]  objectForKey:@"weibo"];
            [cell setCellValue:[[_upedDataArray objectAtIndex:indexPath.row]  objectForKey:@"stageinfo"]indexPath:indexPath.row];
        }
        return  cell;
    }
    return nil;
    
}

-(void)GotoSettingClick:(UIButton  *) button
{
    
    [self.navigationController pushViewController:[SettingViewController new] animated:YES];
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
