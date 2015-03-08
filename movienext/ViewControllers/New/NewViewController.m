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
<<<<<<< HEAD
#import "AddSubtitleViewController.h"
=======
#import "UMSocial.h"
>>>>>>> a8506f9499113dd1bf4c4d6ce079dddca617f324
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
    segment.frame = CGRectMake(kDeviceWidth/4, 0, kDeviceWidth/2, 30);
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
          [_HotMoVieTableView reloadData];
          if (_hotDataArray.count==0) {
              [self requestData];
          }
      }
     else if(seg.selectedSegmentIndex==1)
     {
        _HotMoVieTableView.hidden=YES;
         _NewMoviewTableView.hidden=NO;
         [_NewMoviewTableView reloadData];
         
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
        section=@"weibo/listRecently";
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
           
            return _hotDataArray.count;
        }
    }
    else if (segment.selectedSegmentIndex==1)
    {
        if (tableView==_NewMoviewTableView) {
            return _newDataArray.count;
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
            return hight+10;
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
                hight=  (h/w)*kDeviceWidth+90;
            }
            }
            NSLog(@"============  hight  for  row  =====%f",hight);

            return hight+10;

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
            //小闪动标签的数组
            cell.WeibosArray=[[_hotDataArray objectAtIndex:indexPath.row]  objectForKey:@"weibos"];
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
            cell.weiboDict =[[_newDataArray  objectAtIndex:indexPath.row]  objectForKey:@"weibo"];
            [cell setCellValue:[[_newDataArray objectAtIndex:indexPath.row]  objectForKey:@"stageinfo"]indexPath:indexPath.row];
        }
        return  cell;
    }
    //cell.textLabel.text=@"1212";
    return nil;
    
}
//开始现实cell 的时候执行这个方法，执行动画
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (segment.selectedSegmentIndex==0) {
        if (tableView==_HotMoVieTableView) {
            CommonStageCell *commonStageCell = (CommonStageCell *)cell;
            [commonStageCell.BgView1 startAnimation];
        }
        
    }
    else if (segment.selectedSegmentIndex==1)
    {
        if (tableView==_NewMoviewTableView) {
            
        }
        
    }
}
//结束显示cell的时候执行这个方法
-(void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (segment.selectedSegmentIndex==0) {
        if (tableView==_HotMoVieTableView) {
#warning 为什么这里用上面的那句代码就不行
            //CommonStageCell *commonStageCell = (CommonStageCell *)[tableView cellForRowAtIndexPath:indexPath];
            CommonStageCell *commonStageCell = (CommonStageCell *)cell;
            [commonStageCell.BgView1 stopAnimation];
        }
        
    }
    else if (segment.selectedSegmentIndex==1)
    {
        if (tableView==_NewMoviewTableView) {
            
        }
        
    }
}


#pragma  mark  =====ButtonClick

//点击左下角的电影按钮
-(void)dealMovieButtonClick:(UIButton  *) button{
    NSLog(@" ==dealMovieButtonClick  ====%ld",button.tag);
}
//分享
-(void)ScreenButtonClick:(UIButton  *) button
{
    NSLog(@" ==ScreenButtonClick  ====%ld",button.tag);
    CommonStageCell *cell = (CommonStageCell *)(button.superview.superview.superview.class);
    
    UIGraphicsBeginImageContextWithOptions(_HotMoVieTableView.bounds.size, YES, [UIScreen mainScreen].scale);
    [cell.BgView1 drawViewHierarchyInRect:cell.BgView1.bounds afterScreenUpdates:YES];
    
    // old style [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:kUmengKey
                                      shareText:@"index share image"
                                     shareImage: image
                                shareToSnsNames:[NSArray arrayWithObjects: UMShareToWechatSession, UMShareToWechatTimeline, UMShareToQzone, UMShareToSina, nil]
                                       delegate:nil];
}
//点击增加弹幕
-(void)addMarkButtonClick:(UIButton  *) button
{
    NSLog(@" ==addMarkButtonClick  ====%ld",button.tag);
    AddSubtitleViewController  *AddMarkVC=[[AddSubtitleViewController alloc]init];
    [self.navigationController pushViewController:AddMarkVC animated:NO];
   //[self presentViewController:AddMarkVC animated:NO completion:nil]

}
//点击头像
-(void)UserLogoButtonClick:(UIButton *) button
{
    NSLog(@" ==UserLogoButtonClick  ====%ld",button.tag);

}
//点赞
-(void)ZanButtonClick:(UIButton *)button
{
    NSLog(@" ==ZanButtonClick  ====%ld",button.tag);

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
