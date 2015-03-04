//
//  NewViewController.m
//  movienext
//
//  Created by 风之翼 on 15/2/27.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "NewViewController.h"
#import "AppDelegate.h"
#import "Constant.h"
#import  "UserDataCenter.h"
#import "LoadingView.h"
#import "UserDataCenter.h"
#import "ZCControl.h"
#import "MJRefresh.h"
#import "AFNetworking.h"
#import "CommonStageCell.h"
@interface NewViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    AppDelegate  *appdelegate;
    UISegmentedControl *segment;
    UITableView   *_HotMoVieTableView;
    UITableView   *_NewMoviewTableView;
    LoadingView   *loadView;
    NSMutableArray    *_hotDataArray;
    NSMutableArray    *_newDataArray;
    int page;
}
@end

@implementation NewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor =[UIColor redColor];
    appdelegate =(AppDelegate *)[[UIApplication sharedApplication]delegate ];
    UserDataCenter  *userInfo=  [UserDataCenter shareInstance];
   NSLog(@"-------登陆成功  user=======%@ ",  userInfo.username);
    [self creatNavigation];
    [self initData];
    [self createHotView];
    [self createNewView];
    [self creatLoadView];
    [self requestData];
    
    
}
-(void)initData{
    _hotDataArray = [[NSMutableArray alloc]init];
    _newDataArray=[[NSMutableArray alloc]init];
    page=0;
}
#pragma  mark   ------
#pragma  mark  -------CreatUI;
-(void)creatNavigation
{
    
    NSArray *segmentedArray = [[NSArray alloc] initWithObjects:@"热门", @"最新", nil];

    segment = [[UISegmentedControl alloc] initWithItems:segmentedArray];
    segment.frame = CGRectMake(0, 0, kDeviceWidth, 25);
    segment.selectedSegmentIndex = 0;
    segment.backgroundColor = [UIColor clearColor];
    segment.tintColor = kAppTintColor;
    [segment addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventValueChanged];
    [self.navigationItem setTitleView:segment];
}
-(void)segmentClick:(UISegmentedControl *)seg
{
      if(seg.selectedSegmentIndex==0)
      {
          _NewMoviewTableView.hidden=YES;
          _HotMoVieTableView.hidden=NO;
          if (_hotDataArray.count==0) {
              [self requestData];
          }
      }
     else if(seg.selectedSegmentIndex==1)
     {
        _HotMoVieTableView.hidden=YES;
         _NewMoviewTableView.hidden=NO;
         if (_newDataArray.count==0) {
             [self requestData];
         }
     }

}
-(void)createHotView
{
    _HotMoVieTableView=[[UITableView alloc]initWithFrame:CGRectMake(0,0, kDeviceWidth, kDeviceHeight)];
    _HotMoVieTableView.delegate=self;
    _HotMoVieTableView.dataSource=self;
    //_HotMoVieTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_HotMoVieTableView];
}
-(void)createNewView
{
    _NewMoviewTableView=[[UITableView alloc]initWithFrame:CGRectMake(0,kHeightNavigation, kDeviceWidth, kDeviceHeight)];
    _NewMoviewTableView.delegate=self;
    _NewMoviewTableView.dataSource=self;
    _NewMoviewTableView.hidden=YES;
    //_HotMoVieTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_NewMoviewTableView];
}
-(void)creatLoadView
{
    loadView =[[LoadingView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    [self.view addSubview:loadView];
    
}

#pragma  mark -----
#pragma  mark ------  DataRequest 
#pragma  mark ----
- (void)requestData{
    UserDataCenter  *userCenter=[UserDataCenter shareInstance];
    NSDictionary *parameters = @{@"user_id":@"18", @"page":[NSString stringWithFormat:@"%d",page]};
    NSString * section;
    if (segment.selectedSegmentIndex==1) {  // 最新
        section=@"movieStage/listRecently";
    }
    else if(segment.selectedSegmentIndex==0) //热门
    {
        section= @"hot/list";
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //    [manager POST:[NSString stringWithFormat:@"%@/movieStage/listRecently", kApiBaseUrl] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    [manager POST:[NSString stringWithFormat:@"%@/%@", kApiBaseUrl, section] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [loadView stopAnimation];
        loadView.hidden=YES;
        NSMutableArray  *Detailarray=[responseObject objectForKey:@"detail"];
        if (segment.selectedSegmentIndex==0) {
            if (_hotDataArray ==nil) {
                _hotDataArray=[[NSMutableArray alloc]init];
            }
            NSLog(@"热门数据 JSON: %@", responseObject);
            [_hotDataArray addObjectsFromArray:Detailarray];
            [_HotMoVieTableView reloadData];

        }
        else if(segment.selectedSegmentIndex==1)
        {
            if (_newDataArray==nil) {
                _newDataArray=[[NSMutableArray alloc]init];
            }
            NSLog(@"最新数据 JSON: %@", responseObject);
            [_newDataArray addObjectsFromArray:Detailarray];
            [_NewMoviewTableView reloadData];
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
        if (tableView==_HotMoVieTableView) {
           
            return  10;
        }
    }
    else if (segment.selectedSegmentIndex==1)
    {
        if (tableView==_NewMoviewTableView) {
            return 10;
        }
    }
    return 0;
}
-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (segment.selectedSegmentIndex==0) {
        if (tableView==_HotMoVieTableView) {
            float hight;
            if (_hotDataArray.count>indexPath.row) {
                

            float  h=   [[[[_hotDataArray  objectAtIndex:indexPath.row]  objectForKey:@"stageinfo"] objectForKey:@"h"] floatValue];
            float w=   [[[[_hotDataArray  objectAtIndex:indexPath.row]  objectForKey:@"stageinfo"] objectForKey:@"w"] floatValue];
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
            return hight;
        }
    }
    else if (segment.selectedSegmentIndex==1)
    {
        if (tableView==_NewMoviewTableView) {
            float hight;
            if (_newDataArray.count>indexPath.row) {
            
          //  return 200;
            float  h=   [[[[_newDataArray  objectAtIndex:indexPath.row]  objectForKey:@"stageinfo"] objectForKey:@"h"] floatValue];
            float w=   [[[[_newDataArray  objectAtIndex:indexPath.row]  objectForKey:@"stageinfo"] objectForKey:@"w"] floatValue];
            if (w==0||h==0) {
                hight= kDeviceWidth+90;
            }
            if (w>h) {
                hight= kDeviceWidth+90;
            }
            else if(h>w)
            {
                hight=  (h/w) *kDeviceWidth+90;
            }
            }
            NSLog(@"============  hight  for  row  =====%f",hight);

            return hight;

        }
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

        if (_hotDataArray.count>indexPath.row) {
            cell.pageType=NSPageSourceTypeMainHotController;
        //[cell setCellValue:[[_hotDataArray  objectAtIndex:indexPath.row]  objectForKey:@"stageinfo"]];
            [cell setCellValue:[[_hotDataArray objectAtIndex:indexPath.row]  objectForKey:@"stageinfo"] indexPath:indexPath.row];
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
        if (_newDataArray.count>indexPath.row) {
            cell.pageType=NSPageSourceTypeMainNewController;
         //[cell setCellValue:[[_newDataArray objectAtIndex:indexPath.row ] objectForKey:@"stageinfo"]];
            [cell setCellValue:[[_newDataArray objectAtIndex:indexPath.row]  objectForKey:@"stageinfo"]indexPath:indexPath.row];
        }
        return  cell;
    }
    //cell.textLabel.text=@"1212";
    return nil;
    
}

#pragma  mark  =====ButtonClick 

-(void)dealMovieButtonClick:(UIButton  *) button{
    
}
-(void)ScreenButtonClick:(UIButton  *) button
{
    
}
-(void)addMarkButtonClick:(UIButton  *) button
{
    
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
