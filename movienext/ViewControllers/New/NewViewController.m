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
#import "UserDataCenter.h"
#import "LoadingView.h"
#import "UserDataCenter.h"
#import "ZCControl.h"
#import "MJRefresh.h"
#import "AFNetworking.h"
#import "CommonStageCell.h"
#import "AddMarkViewController.h"
#import "MovieDetailViewController.h"

//友盟分享
#import "UMSocial.h"
@interface NewViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,StageViewDelegate,ButtomToolViewDelegate,UIScrollViewDelegate>
{
    AppDelegate  *appdelegate;
    UISegmentedControl *segment;
    UITableView   *_HotMoVieTableView;
    LoadingView   *loadView;
    NSMutableArray    *_hotDataArray;
    NSMutableArray    *_newDataArray;
    int page;
    ButtomToolView *_toolBar;
    MarkView       *_mymarkView;
}
@end

@implementation NewViewController
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden=NO;
  self.navigationController.navigationBar.alpha=1;
//    self.navigationController.navigationBar.translucent=NO;
//
    self.tabBarController.tabBar.hidden=NO;
}

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
    [self creatLoadView];
    [self requestData];
    [self createToolBar];
    
    
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
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"tabbar_backgroud_color.png"] forBarMetrics:UIBarMetricsDefault];
    NSArray *segmentedArray = [[NSArray alloc] initWithObjects:@"热门", @"最新", nil];
    segment = [[UISegmentedControl alloc] initWithItems:segmentedArray];
    segment.frame = CGRectMake(kDeviceWidth/4, 0, kDeviceWidth/2, 30);
    segment.selectedSegmentIndex = 0;
    segment.backgroundColor = [UIColor clearColor];
    segment.tintColor = kAppTintColor;
    
    NSDictionary* selectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:14]
                                             };
    [segment setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];
    NSDictionary* unselectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:14]
                                               };
    [segment setTitleTextAttributes:unselectedTextAttributes forState:UIControlStateNormal];
    
    [segment addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventValueChanged];
    [self.navigationItem setTitleView:segment];
}
-(void)segmentClick:(UISegmentedControl *)seg
{
      if(seg.selectedSegmentIndex==0)
      {
          [_HotMoVieTableView reloadData];
          if (_hotDataArray.count==0) {
              [self requestData];
          }
      }
     else if(seg.selectedSegmentIndex==1)
     {
         [_HotMoVieTableView reloadData];
         
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
    _HotMoVieTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_HotMoVieTableView];
}
-(void)creatLoadView
{
    loadView =[[LoadingView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    [self.view addSubview:loadView];
}

//创建底部的视图
-(void)createToolBar

{
    _toolBar=[[ButtomToolView alloc]initWithFrame:CGRectMake(0,0,kDeviceWidth,kDeviceHeight)];
    _toolBar.delegete=self;
   // [self.view addSubview:_toolBar];
    

}
#pragma  mark -----
#pragma  mark ------  DataRequest 
#pragma  mark ----
//微博点赞请求
-(void)LikeRequstData:(NSDictionary  *) upDict StageInfo :(NSDictionary *) stageInfoDict
{
    
    UserDataCenter  *userCenter=[UserDataCenter shareInstance];
    NSString  *weiboId=[upDict objectForKey:@"id"];
    NSString  *stageId=[stageInfoDict objectForKey:@"id"];
    NSString  *movieId=[stageInfoDict objectForKey:@"movie_id"];
    NSString  *movieName=[stageInfoDict objectForKey:@"movie_name"];
    NSString  *userId=userCenter.user_id;
    NSString  *autorId=[upDict objectForKey:@"user_id"];
    NSString  *uped;
    if ([[upDict objectForKey:@"uped"]  intValue]==0) {
        uped =[NSString stringWithFormat:@"%d",1];
    }
    else
    {
        uped =[NSString stringWithFormat:@"%d",0];
    }
    
    NSDictionary *parameters = @{@"weibo_id":weiboId, @"stage_id":stageId,@"movie_id":movieId,@"movie_name":movieName,@"user_id":userId,@"author_id":autorId,@"operation":uped};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/weiboUp/up", kApiBaseUrl] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject  objectForKey:@"return_code"]  intValue]==10000) {
            NSLog(@"点赞成功========%@",responseObject);
            //_mymarkView.ZanNumLable
            //[_toolBar SetZanButtonSelected];

         }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

}
- (void)requestData{
  #warning  暂时设置为18
    UserDataCenter  *userCenter=[UserDataCenter shareInstance];
    NSDictionary *parameters = @{@"user_id":userCenter.user_id, @"page":[NSString stringWithFormat:@"%d",page]};
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
            [_HotMoVieTableView reloadData];
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
        return _hotDataArray.count;
    }
    else if (segment.selectedSegmentIndex==1)
    {
        return _newDataArray.count;
    }
    return 0;
}

-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (segment.selectedSegmentIndex==0) {
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
       // NSLog(@"============  hight  for  row  =====%f",hight);
        return hight+10;
    }
    else if (segment.selectedSegmentIndex==1)
    {
        float hight;
        if (_newDataArray.count>indexPath.row) {
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
      //
        //NSLog(@"============  hight  for  row  =====%f",hight);

        return hight+10;
    }
    return 200.0f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellID=@"CELL1";
    CommonStageCell  *cell= (CommonStageCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell=[[CommonStageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.backgroundColor=View_BackGround;
    }
    
    if  (segment.selectedSegmentIndex==0) {
        if (_hotDataArray.count>indexPath.row) {
            cell.pageType=NSPageSourceTypeMainHotController;
            //小闪动标签的数组
            cell.WeibosArray=[[_hotDataArray objectAtIndex:indexPath.row]  objectForKey:@"weibos"];
            cell.weiboDict=nil;
            [cell setCellValue:[[_hotDataArray objectAtIndex:indexPath.row]  objectForKey:@"stageinfo"] indexPath:indexPath.row];
            //遵守stagview的协议，点击事件在controller里面响应
            cell.stageView.delegate=self;
        }
        return cell;
    }
    else if (segment.selectedSegmentIndex==1)
    {
        if (_newDataArray.count>indexPath.row) {
            //配置cell的类型。
            cell.pageType=NSPageSourceTypeMainNewController;
            //根据类型配置cell的气泡数据
            cell.weiboDict =[[_newDataArray  objectAtIndex:indexPath.row]  objectForKey:@"weibo"];
            //配置stage的数据
            [cell setCellValue:[[_newDataArray objectAtIndex:indexPath.row]  objectForKey:@"stageinfo"]indexPath:indexPath.row];
            //遵守了stageview的协议，点击事件在这里执行
            cell.stageView.delegate=self;
            
        }
        return  cell;
    }
    return nil;
    
}
//开始现实cell 的时候执行这个方法，执行动画
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (segment.selectedSegmentIndex==0) {
        CommonStageCell *commonStageCell = (CommonStageCell *)cell;
        [commonStageCell.stageView startAnimation];
    }
    else if (segment.selectedSegmentIndex==1)
    {
        
    }
}
//结束显示cell的时候执行这个方法
-(void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (segment.selectedSegmentIndex==0) {
#warning 为什么这里用上面的那句代码就不行
        //CommonStageCell *commonStageCell = (CommonStageCell *)[tableView cellForRowAtIndexPath:indexPath];
        CommonStageCell *commonStageCell = (CommonStageCell *)cell;
        [commonStageCell.stageView stopAnimation];
    }
    else if (segment.selectedSegmentIndex==1)
    {
        
    }
}


#pragma  mark  =====ButtonClick

//点击左下角的电影按钮
-(void)dealMovieButtonClick:(UIButton  *) button{
    NSLog(@" ==dealMovieButtonClick  ====%d",button.tag);
    
    MovieDetailViewController *vc =  [MovieDetailViewController new];
    NSDictionary *dict = segment.selectedSegmentIndex==0 ? [_hotDataArray objectAtIndex:button.tag-1000] : [_newDataArray objectAtIndex:button.tag-1000];
    NSLog(@"dict = %@", dict);
    vc.movieId = [[dict objectForKey:@"stageinfo"] objectForKey:@"movie_id"];
   [self.navigationController pushViewController:vc animated:YES];
}
//分享
-(void)ScreenButtonClick:(UIButton  *) button
{
    NSLog(@" ==ScreenButtonClick  ====%d",button.tag);
    //获取cell
#pragma mark 暂时把sharetext设置成null

    CommonStageCell *cell = (CommonStageCell *)(button.superview.superview.superview);
    
    UIGraphicsBeginImageContextWithOptions(_HotMoVieTableView.bounds.size, YES, [UIScreen mainScreen].scale);
    [cell.stageView drawViewHierarchyInRect:cell.stageView.bounds afterScreenUpdates:YES];
    
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
    AddMarkViewController  *AddMarkVC=[[AddMarkViewController alloc]init];
    //CommonStageCell *cell = (CommonStageCell *)button.superview.superview.superview;
    NSDictionary *dict = [_hotDataArray objectAtIndex:button.tag-3000];
    AddMarkVC.stageDict = [dict valueForKey:@"stageinfo"];
    //NSLog(@"dict = %@", dict);
    NSLog(@"dict.stageinfo = %@", [dict valueForKey:@"stageinfo"]);
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
#pragma mark  -----
#pragma mark  ---StaegViewDelegate
#pragma mark  ----
-(void)StageViewHandClickMark:(NSDictionary *)weiboDict withmarkView:(id)markView StageInfoDict:(NSDictionary *)stageInfoDict
{

    NSLog(@"在new view controller  里面响应了这个方法 weibo dict  ====%@",    weiboDict) ;
    ///执行buttonview 弹出
    //获取markview的指针
    MarkView   *mv=(MarkView *)markView;
    //把当前的markview 给存储在了controller 里面
    _mymarkView=mv;
    if (mv.isSelected==YES) {  //当前已经选中的状态
        //设置工具栏的值，并且，弹出工具栏
         // NSLog(@"出现工具栏,   ======stageinfo =====%@",stageInfoDict);
        [self SetToolBarValueWithDict:weiboDict markView:markView isSelect:YES StageInfo:stageInfoDict];
    }
    else if(mv.isSelected==NO)
    {
        NSLog(@"隐藏工具栏工具栏");
        [self SetToolBarValueWithDict:weiboDict markView:markView isSelect:NO StageInfo:stageInfoDict];
        
    }
    
}
#pragma mark  ----- toolbar 上面的按钮，执行给toolbar 赋值，显示，弹出工具栏
-(void)SetToolBarValueWithDict:(NSDictionary  *)weiboDict markView:(id) markView isSelect:(BOOL ) isselect StageInfo:(NSDictionary *) stageInfo
{
   //先对它赋值，然后让他弹出到界面
    if (isselect==YES) {
        NSLog(@" new viewController SetToolBarValueWithDict  执行了出现工具栏的方法");
        
        //设置工具栏的值
        [_toolBar setToolBarValue:weiboDict :markView WithStageInfo:stageInfo];
        //把工具栏添加到当前视图
        self.tabBarController.tabBar.hidden=YES;
        [self.view addSubview:_toolBar];
        //弹出工具栏
        [_toolBar ShowButtomView];
        
    }
    else if (isselect==NO)
    {
        //隐藏toolbar
        NSLog(@" 执行了隐藏工具栏的方法");
        self.tabBarController.tabBar.hidden=NO;
        //隐藏工具栏
        if (_toolBar) {
        
        [_toolBar HidenButtomView];
        //从父视图中除掉工具栏
        [_toolBar removeFromSuperview];
        }
    }
    
    
}
#pragma mark   ------
#pragma mark   -------- ButtomToolViewDelegate
#pragma  mark  -------
-(void)ToolViewHandClick:(UIButton *)button :(MarkView *)markView weiboDict:(NSDictionary *)weiboDict StageInfo:(NSDictionary *)stageInfoDict
//-(void)ToolViewHandClick:(UIButton *)button :(MarkView *)markView weiboDict:(NSDictionary *)weiboDict
{
    if (button.tag==10000) {
        ///点击了头像//进入个人页面
        NSLog(@"点击头像  微博dict  ＝====%@ ======出现的stageinfo  ＝＝＝＝＝＝%@",weiboDict,stageInfoDict);
        
    }
#pragma mark     -----------分享
    else if (button.tag==10001)
    {
        //点击了分享
        //分享文字
        NSString  *shareText=[weiboDict objectForKey:@"topic"];
        NSLog(@" 点击了分享按钮");
        CommonStageCell *cell = (CommonStageCell *)(markView.superview.superview.superview);
        
        UIGraphicsBeginImageContextWithOptions(_HotMoVieTableView.bounds.size, YES, [UIScreen mainScreen].scale);
        [cell.stageView drawViewHierarchyInRect:cell.stageView.bounds afterScreenUpdates:YES];
        
        // old style [self.layer renderInContext:UIGraphicsGetCurrentContext()];
        
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
        [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:kUmengKey
                                          shareText:shareText
                                         shareImage: image
                                    shareToSnsNames:[NSArray arrayWithObjects: UMShareToWechatSession, UMShareToWechatTimeline, UMShareToQzone, UMShareToSina, nil]
                                           delegate:nil];
    }
#pragma mark  ----------点赞--------------
    else  if(button.tag==10002)
    {
        //改变赞的状态
        [_toolBar SetZanButtonSelected];

        //点击了赞
        NSLog(@" 点赞  微博dict  ＝====%@",weiboDict);
        if ([[weiboDict  objectForKey:@"uped"]  intValue]==0) {///没有赞的话
            [weiboDict setValue:@"1" forKey:@"uped"];
            int ups=[[weiboDict objectForKey:@"ups"] intValue];
            ups =ups+1;
            [weiboDict setValue:[NSString stringWithFormat:@"%d",ups] forKey:@"ups"];
        }
        else  {
            [weiboDict setValue:@"0" forKey:@"uped"];
            int ups=[[weiboDict objectForKey:@"ups"] intValue];
            ups =ups-1;
            [weiboDict setValue:[NSString stringWithFormat:@"%d",ups] forKey:@"ups"];
        }
        
        //获取赞的数量
        //点赞执行这个方法
        //先去改变数组的内容
        if (segment.selectedSegmentIndex==0) {
            //先匹配stageid
            int  stageId;
            int  weiboId=[[weiboDict  objectForKey:@"id"]  intValue];
            if([stageInfoDict  objectForKey:@"id"])
            {
                stageId= [[stageInfoDict  objectForKey:@"id"] intValue];
               
                ///dict 包含热门 weibo，， weibos 的信息
                for (int i=0 ; i<_hotDataArray.count; i++)  {
                    NSDictionary  *dict=[_hotDataArray  objectAtIndex:i];
                    //如果stageid ＝＝stageid
                    if ([[[dict objectForKey:@"stageinfo"] objectForKey:@"id"] intValue]==stageId) {
                        
                        //再遍历跟stageid 同一个字典的weibos 数组
                        NSMutableArray  *weibosArray=[[NSMutableArray alloc]initWithArray:[dict  objectForKey:@"weibos"]];
                        for (int j=0; j<weibosArray.count; j++) {
                            //weibo id == weiboId
                            if ([[[weibosArray  objectAtIndex:j] objectForKey:@"id"]  intValue]==weiboId) {
                                
                             //   if ([[weiboDict objectForKey:@"uped"] intValue]==0) {
                                    // 替代了字典里面一个数据,
#warning   替代整个weibo的字典
                               //     [[[weibosArray  objectAtIndex:j] objectForKey:@"uped"] setObject:@"1" forKey:@"id"];
                                //替代原来的数组
                                [weibosArray replaceObjectAtIndex:j withObject:weiboDict];
                            
                            }
                        }
                        
                    }
                    
                }
                
            }
            
            
        }else if(segment.selectedSegmentIndex==1)
        {
            
        }
        
        
        //发送到服务器
        [self LikeRequstData:weiboDict StageInfo:stageInfoDict];
        //点赞成功后，要把赞设置为
        
        
        
    }

    
}
#pragma mark  -----
#pragma mark  -------隐藏工具栏的方法
#pragma mark  -------
//点击屏幕，隐藏工具栏

-(void)topViewTouchBengan
{
    NSLog(@"controller touchbegan  中 执行了隐藏工具栏的方法");
    //取消当前的选中的那个气泡
    [_mymarkView CancelMarksetSelect];
    self.tabBarController.tabBar.hidden=NO;
    if (_toolBar) {
        [_toolBar HidenButtomView];
       //  [_toolBar performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.5];
        [_toolBar removeFromSuperview];
        
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
