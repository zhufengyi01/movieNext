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
#import "AFHTTPRequestOperationManager.h"
#import "CommonStageCell.h"
#import "UserDataCenter.h"
#import "SettingViewController.h"
#import "UIImageView+WebCache.h"
#import "HotMovieModel.h"
#import "StageInfoModel.h"
#import "WeiboModel.h"
#import "StageView.h"
#import "StageInfoModel.h"
#import "ButtomToolView.h"
#import "MovieDetailViewController.h"
#import "UMSocial.h"
#import "MJRefresh.h"
#import "AddMarkViewController.h"
#import "Function.h"
#import "UMShareView.h"
@interface MyViewController ()<UITableViewDataSource, UITableViewDelegate,StageViewDelegate,StageViewDelegate,ButtomToolViewDelegate,UIActionSheetDelegate,UMSocialDataDelegate,UMSocialUIDelegate,UMShareViewDelegate>
{
    //UISegmentedControl *segment;
    UITableView   *_tableView;
    NSMutableArray    *_addedDataArray;
    NSMutableArray    *_upedDataArray;
    NSMutableDictionary  *_userInfoDict;
    LoadingView   *loadView;
    int page;
    
    UIImageView *ivAvatar;//头像
    UILabel *lblUsername;//用户名
    UILabel *lblCount;//统计信息
    UILabel *lblZanCout;
    UILabel *lblBrief;//简介
    UserDataCenter  *userCenter;
    
    ButtomToolView *_toolBar;
    MarkView       *_mymarkView;
    BOOL isMarkViewsShow;
    UMShareView  *shareView;
    int  productCount;
    //保存头部视图按钮的状态
    NSMutableDictionary  *buttonStateDict;
    NSMutableDictionary  *IsNullStateDict; //纪录添加还是赞的数据为空


}
@end

@implementation MyViewController
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden=NO;
    self.navigationController.navigationBar.alpha=1;
    self.tabBarController.tabBar.hidden=NO;
    self.navigationController.navigationBar.translucent=NO;
    if (self.author_id.length>0&&![self.author_id isEqualToString:@"0"]) {
        self.tabBarController.tabBar.hidden=YES;
    }
    else
    {
        self.tabBarController.tabBar.hidden=NO;
   
    }
   // if (_tableView) {
     //   [self setupRefresh];
    //}
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNavigation];
    [self initData];

     [self requestUserInfo];
    
    //[self requestData];
    [self createToolBar];
    [self createShareView];


    if (self.author_id&&![self.author_id isEqualToString:@"0"]) {
        //如果有用户id 并且用户的id 不为0
        self.navigationItem.rightBarButtonItem=nil;
        self.navigationItem.titleView=nil;
    }
   
}

-(void)initData {
    _addedDataArray = [[NSMutableArray alloc] init];
    _upedDataArray = [[NSMutableArray alloc] init];
    buttonStateDict=[[NSMutableDictionary alloc]init];
    [buttonStateDict setValue:@"YES" forKey:@"100"];
    //纪录那个数据为空
    IsNullStateDict =[[NSMutableDictionary  alloc]init];
    [IsNullStateDict setValue:@"NO" forKey:@"ONE"];
    [IsNullStateDict setValue:@"NO" forKey:@"TWO"];
    
    if (self.author_id&&![self.author_id isEqualToString:@"0"]) {
        //如果有用户id 并且用户的id 不为0
        _userInfoDict =[[NSMutableDictionary alloc]init];
    }

}
#pragma mark - CreateUI
-(void)createNavigation
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"tabbar_backgroud_color.png"] forBarMetrics:UIBarMetricsDefault];

    UILabel  *titleLable=[ZCControl createLabelWithFrame:CGRectMake(0, 0, 100, 20) Font:16 Text:@"我的"];
    titleLable.textColor=VBlue_color;
    
    titleLable.font=[UIFont boldSystemFontOfSize:16];
    titleLable.textAlignment=NSTextAlignmentCenter;
    self.navigationItem.titleView=titleLable;
    
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
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kHeightNavigation-kHeigthTabBar)];
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    //是从别人的页面进来的不是自己的
    if (self.author_id.length>0&&![self.author_id isEqualToString:@"0"]) {
        _tableView.frame=CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kHeightNavigation);
    }

    userCenter=[UserDataCenter shareInstance];
    NSString  *signature=[NSString stringWithFormat:@"%@",  [_userInfoDict  objectForKey:@"brief"]];
    if (signature==nil) {
        signature=@"";
    }
     UIView *viewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 130)];
     int ivAvatarWidth = 50;
    ivAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, ivAvatarWidth, ivAvatarWidth)];
    ivAvatar.layer.cornerRadius = ivAvatarWidth * 0.5;
    ivAvatar.layer.masksToBounds = YES;
    ivAvatar.layer.borderColor=VBlue_color.CGColor;
    ivAvatar.layer.borderWidth=2;

    //ivAvatar.backgroundColor = [UIColor redColor];
    NSURL   *imageURL;
    if (_userInfoDict) {
        imageURL =[NSURL URLWithString:[NSString stringWithFormat:@"%@%@!thumb",kUrlAvatar,[_userInfoDict  objectForKey:@"avatar"]]];
    }
  
    [ivAvatar sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"loading_image_all.png"]];
  //  NSLog(@"avatar url = %@/%@!thumb", kUrlAvatar, userCenter.avatar );

    [viewHeader addSubview:ivAvatar];
    
    lblUsername = [[UILabel alloc] initWithFrame:CGRectMake(ivAvatar.frame.origin.x+ivAvatar.frame.size.width+10, ivAvatar.frame.origin.y, 200, 20)];
    lblUsername.font = [UIFont systemFontOfSize:15];
    lblUsername.textColor = VGray_color;
    if (_userInfoDict) {
        lblUsername.text=[NSString stringWithFormat:@"%@",[_userInfoDict objectForKey:@"username"]];
    }
     [viewHeader addSubview:lblUsername];
    
    UILabel  *lbl1=[ZCControl createLabelWithFrame:CGRectMake(lblUsername.frame.origin.x,lblUsername.frame.origin.y+lblUsername.frame.size.height+5, 40, 20) Font:14 Text:@"内容"];
    lbl1.textColor=VBlue_color;
    [viewHeader addSubview:lbl1];
    
    //内容的数量
    lblCount = [[UILabel alloc] initWithFrame:CGRectMake(lbl1.frame.origin.x+lbl1.frame.size.width, lblUsername.frame.origin.y+lblUsername.frame.size.height+5, 25, 20)];
    lblCount.font = [UIFont systemFontOfSize:14];

    if (_userInfoDict) {
        lblCount.text=[NSString stringWithFormat:@"%@",[_userInfoDict objectForKey:@"product_count"]];
    }
     lblCount.textColor = VGray_color;
    //lblCount.backgroundColor = [UIColor purpleColor];
    [viewHeader addSubview:lblCount];
    
    
    UILabel  *lbl2=[ZCControl createLabelWithFrame:CGRectMake(lblCount.frame.origin.x+lblCount.frame.size.width+10,lblUsername.frame.origin.y+lblUsername.frame.size.height+5, 40, 20) Font:14 Text:@"被赞"];
    lbl2.textColor=VBlue_color;
    [viewHeader addSubview:lbl2];

    //赞的数量
    lblZanCout = [[UILabel alloc] initWithFrame:CGRectMake(lbl2.frame.origin.x+lbl2.frame.size.width+5,lblCount.frame.origin.y , 50, 20)];
    lblZanCout.font = [UIFont systemFontOfSize:14];
    lblZanCout.textColor = VGray_color;
    if (_userInfoDict) {
        lblZanCout.text  =[NSString stringWithFormat:@"%@",[_userInfoDict objectForKey:@"uped_count"]];
    }
     [viewHeader addSubview:lblZanCout];
    
   //简介
    lblBrief = [[UILabel alloc] initWithFrame:CGRectMake(ivAvatar.frame.origin.x+ivAvatar.frame.size.width+10,lblCount.frame.origin.y+lblCount.frame.size.height+10, kDeviceWidth-ivAvatar.frame.origin.x-ivAvatar.frame.size.width-20, 20)];
    lblBrief.numberOfLines=0;
    lblBrief.font = [UIFont systemFontOfSize:12];
    
    CGSize  Msize= [signature boundingRectWithSize:CGSizeMake(kDeviceWidth-80, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:lblBrief.font forKey:NSFontAttributeName] context:nil].size;
    lblBrief.textColor = VGray_color;
   // lblBrief.backgroundColor = [UIColor orangeColor];
    lblBrief.text=signature;
    lblBrief.frame=CGRectMake(ivAvatar.frame.origin.x+ivAvatar.frame.size.width+10,lblCount.frame.origin.y+lblCount.frame.size.height+10, kDeviceWidth-ivAvatar.frame.origin.x-ivAvatar.frame.size.width-20, Msize.height);
      [viewHeader addSubview:lblBrief];
    
    
    UIButton  *addButton=[ZCControl createButtonWithFrame:CGRectMake(0,  lblBrief.frame.origin.y+lblBrief.frame.size.height+25, kDeviceWidth/2, 40) ImageName:nil Target:self Action:@selector(dealSegmentClick:) Title:@"添加"];
    [addButton setTitleColor:VGray_color forState:UIControlStateNormal];
    [addButton setTitleColor:VBlue_color forState:UIControlStateSelected];
    if ([[buttonStateDict objectForKey:@"100"] isEqualToString:@"YES"]) {
        [addButton setSelected:YES];
    }
    else{
        [addButton setSelected:NO];
    }
    addButton.titleLabel.font=[UIFont systemFontOfSize:16];
    //addButton.backgroundColor=VLight_GrayColor;
    addButton.tag=100;
    [viewHeader addSubview:addButton];
    
    UIView  *lineView=[[UIView alloc]initWithFrame:CGRectMake(kDeviceWidth/2,addButton.frame.origin.y+10,0.5,20)];
    lineView.backgroundColor=VLight_GrayColor;
    [viewHeader addSubview:lineView];
    
    UIButton  *zanButton=[ZCControl createButtonWithFrame:CGRectMake(kDeviceWidth/2,  lblBrief.frame.origin.y+lblBrief.frame.size.height+25, kDeviceWidth/2, 40) ImageName:nil Target:self Action:@selector(dealSegmentClick:) Title:@"赞"];
    [zanButton setTitleColor:VGray_color forState:UIControlStateNormal];
    [zanButton setTitleColor:VBlue_color forState:UIControlStateSelected];
    if ([[buttonStateDict objectForKey:@"101"] isEqualToString:@"YES"]) {
        [zanButton setSelected:YES];
    }
    else{
        [zanButton setSelected:NO];
    }
    zanButton.titleLabel.font=[UIFont systemFontOfSize:16];
    zanButton.tag=101;
    [viewHeader addSubview:zanButton];

    [self createLoadview];
    //修改了loadview的frame
    if (loadView) {
        float  y=zanButton.frame.origin.y+zanButton.frame.size.height;
        loadView.frame=CGRectMake(0, y, kDeviceWidth, kDeviceHeight-y-kHeightNavigation);
    }
    
    viewHeader.frame=CGRectMake(0, 0, kDeviceWidth,addButton.frame.origin.y+addButton.frame.size.height);
    [_tableView setTableHeaderView:viewHeader];
    [self setupRefresh];

}


-(void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [_tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    //  #warning 自动刷新(一进入程序就下拉刷新)
    [_tableView headerBeginRefreshing];
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [_tableView addFooterWithTarget:self action:@selector(footerRereshing)];
}
#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    page=0;
    for (int i=100; i<102;i++ ) {
        UIButton  *btn =(UIButton *)[self.view viewWithTag:i];
        if (btn.tag==100&&btn.selected==YES) {
            if (_addedDataArray.count>0) {
                [_addedDataArray removeAllObjects];
            }
            
        }
        else if (btn.tag==101&&btn.selected==YES)
        {
            if (_upedDataArray.count>0) {
                [_upedDataArray removeAllObjects];
            }
        }
    }
    [self requestData];
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [_tableView reloadData];
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [_tableView headerEndRefreshing];
    });
}

- (void)footerRereshing
{
    page++;
    [self  requestData];
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [_tableView reloadData];
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [_tableView footerEndRefreshing];
    });
}



-(void)dealSegmentClick:(UIButton *) button
{
    if(button.tag==100)
    {
        NSLog(@"点击了第一个按钮");
        if (button.selected==YES) {
            //已经选择的情况下，点击这个没有反应
        }
        else if(button.selected==NO)
        {
            button.selected=YES;
            [buttonStateDict setValue:@"YES" forKey:@"100"];
            //把赞设置为选择状态
            UIButton  *btn =(UIButton *)[self.view viewWithTag:101];
            btn.selected=NO;
            [buttonStateDict setValue:@"NO" forKey:@"101"];
            [_tableView reloadData];
            if (_addedDataArray.count==0) {
                [self requestData];
            }
            if ( [[IsNullStateDict objectForKey:@"ONE"] isEqualToString:@"YES"]) {
                [_tableView addSubview:loadView];
            }
            else
            {
                [loadView removeFromSuperview];
            }
        }
    }
    else if(button.tag==101)
    {
        NSLog(@"点击了第er个按钮");

        if (button.selected==YES) {
            
        }
        else if(button.selected==NO)
        {
           button.selected=YES;
         
          [buttonStateDict setValue:@"YES" forKey:@"101"];
         //把赞设置为选择状态
          UIButton  *btn =(UIButton *)[self.view viewWithTag:100];
          [buttonStateDict setValue:@"NO" forKey:@"100"];
          btn.selected=NO;
          [_tableView reloadData];
           if (_upedDataArray.count==0) {
            [self requestData];
           }
          if ( [[IsNullStateDict objectForKey:@"TWO"] isEqualToString:@"YES"]) {
                [_tableView addSubview:loadView];
            }
            else
            {
                [loadView removeFromSuperview];
            }

        }
    }
    
    NSLog(@"buttonStateDict=======%@",buttonStateDict);
}
- (void)createLoadview
{
    loadView =[[LoadingView alloc]initWithFrame:CGRectMake(0, 200, kDeviceWidth, kDeviceHeight-kHeightNavigation-200)];
}

//创建底部的视图
-(void)createToolBar

{
    _toolBar=[[ButtomToolView alloc]initWithFrame:CGRectMake(0,0,kDeviceWidth,kDeviceHeight)];
    _toolBar.delegete=self;
    
}

-(void)createShareView
{
    shareView=[[UMShareView alloc]initWithFrame:CGRectMake(0,0, kDeviceWidth, kDeviceHeight)];
    shareView.delegate=self;
}



#pragma  mark -----
#pragma  mark ------  DataRequest 
#pragma  mark ----
-(void)requestUserInfo
{
    NSString  *userId;
    if (self.author_id>0&&![self.author_id isEqualToString:@"0"]) {
        userId=self.author_id;
    }
    else
    {
        UserDataCenter  *user=[UserDataCenter shareInstance];
        userId=user.user_id;
    }
    NSDictionary *parameters = @{@"user_id":userId};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/user/info", kApiBaseUrl] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject  objectForKey:@"return_code"]  intValue]==10000) {
            NSLog(@"请求的用户数据========%@",responseObject);
            if (_userInfoDict ==nil){
                _userInfoDict=[[NSMutableDictionary alloc]init];
            }
            _userInfoDict =[responseObject objectForKey:@"detail"];
            productCount=[[_userInfoDict objectForKey:@"product_count"]  intValue];
            [self createTableView];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        

    }];
    

}
- (void)requestData{
    NSString  *autorid;
    if (self.author_id>0&&![self.author_id isEqualToString:@"0"]) {
        autorid=self.author_id;
    }
    else
    {
        UserDataCenter  *user=[UserDataCenter shareInstance];
        autorid=user.user_id;
    }
    //user_id是当前用户的ID
    NSDictionary *parameters = @{@"user_id":userCenter.user_id, @"page":[NSString stringWithFormat:@"%d",page], @"author_id":autorid};
    NSString * section;
    for (int i=100; i<102;i++ ) {
        UIButton  *btn =(UIButton *)[self.view viewWithTag:i];
        if (btn.tag==101&&btn.selected==YES) {
            section=@"weibo/upedListByUserId";
        }
        else if (btn.tag==100&&btn.selected==YES)
        {
            section= @"weibo/listByUserId";
        }
        
    }
    NSLog(@" parameters  ====%@",parameters);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    //manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    [manager POST:[NSString stringWithFormat:@"%@/%@", kApiBaseUrl, section] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"return_code"] intValue]==10000) {
            NSLog(@"个人页面返回的数据====%@",responseObject);
             NSMutableArray  *Detailarray=[responseObject objectForKey:@"detail"];
        for (int i=100; i<102;i++ ) {
            UIButton  *btn =(UIButton *)[self.view viewWithTag:i];
        if (btn.tag==100&&btn.selected==YES) {
            if (_addedDataArray ==nil) {
                _addedDataArray=[[NSMutableArray alloc]init];
            }
            for (NSDictionary  *addDict  in Detailarray) {
                HotMovieModel  *model =[[HotMovieModel alloc]init];
                if (model) {
                    [model setValuesForKeysWithDictionary:addDict];
                    StageInfoModel  *stagemodel =[[StageInfoModel alloc]init];
                    if (stagemodel) {
                        [stagemodel setValuesForKeysWithDictionary:[addDict objectForKey:@"stageinfo"]];
                         model.stageinfo=stagemodel;
                    }
                   
                    WeiboModel  *weibomodel =[[WeiboModel alloc]init];
                    if (weibomodel) {
                        [weibomodel setValuesForKeysWithDictionary:[addDict objectForKey:@"weibo"]];
                        model.weibo=weibomodel;
                    }
                      [_addedDataArray addObject:model];
                }
            }
            if (_addedDataArray.count==0) {
                [IsNullStateDict setValue:@"YES" forKey:@"ONE"];
                [_tableView addSubview:loadView];
                [loadView showNullView:@"没有数据"];
            }
            else
            {
                [IsNullStateDict setValue:@"NO" forKey:@"ONE"];
                [loadView stopAnimation];
                [loadView removeFromSuperview];
                [_tableView reloadData];

            }
        }
        else if(btn.tag==101&&btn.selected==YES)
        {
            if (_upedDataArray==nil) {
                _upedDataArray=[[NSMutableArray alloc]init];
            }
            for (NSDictionary  *addDict  in Detailarray) {
                HotMovieModel  *model =[[HotMovieModel alloc]init];
                if (model) {
                    [model setValuesForKeysWithDictionary:addDict];
                    StageInfoModel  *stagemodel =[[StageInfoModel alloc]init];
                    if (stagemodel) {
                        [stagemodel setValuesForKeysWithDictionary:[addDict objectForKey:@"stageinfo"]];
                        model.stageinfo=stagemodel;
                    }
                    WeiboModel  *weibomodel =[[WeiboModel alloc]init];
                    if (weibomodel) {
                        [weibomodel setValuesForKeysWithDictionary:[addDict objectForKey:@"weibo"]];
                        model.weibo=weibomodel;
                    }
                    [_upedDataArray addObject:model];
                }
            }
            if (_upedDataArray.count==0) {
                  [IsNullStateDict setValue:@"YES" forKey:@"TWO"];
                [_tableView addSubview:loadView];
                [loadView showNullView:@"没有数据"];
            }
            else
            {
                  [IsNullStateDict setValue:@"NO" forKey:@"TWO"];
                [loadView stopAnimation];
                [loadView removeFromSuperview];
                [_tableView reloadData];
                
            }
            [_tableView reloadData];
        }
       }
     }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"下载失败 Error: %@", error);
        [loadView stopAnimation];
        [loadView showFailLoadData];
     
    }];
}


-(void)requestDelectData:(HotMovieModel *) hotmodel
{
  //  NSLog(@"hotmodel  ==weibiid ==%@   hotmodel stageinfo id ==%@ ",hotmodel.weibo.Id,hotmodel.stageinfo.Id);
    NSDictionary *parameters = @{@"id":hotmodel.weibo.Id,@"stage_id":hotmodel.stageinfo.Id};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/weibo/remove", kApiBaseUrl] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject  objectForKey:@"return_code"]  intValue]==10000) {
            NSLog(@"删除数据成功=======%@",responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
   
}
//微博点赞请求
-(void)LikeRequstData:(WeiboModel  *) weiboDict StageInfo :(StageInfoModel *) stageInfoDict
{
    
    UserDataCenter  *userCenter=[UserDataCenter shareInstance];
    NSNumber  *weiboId=weiboDict.Id;  //[upDict objectForKey:@"id"];
    NSNumber  *stageId=stageInfoDict.Id;//[stageInfoDict objectForKey:@"id"];
    NSString  *movieId=stageInfoDict.movie_id; //[stageInfoDict objectForKey:@"movie_id"];
    NSString  *movieName=stageInfoDict.movie_name;//[stageInfoDict objectForKey:@"movie_name"];
    NSString  *userId=userCenter.user_id;
    NSString  *autorId =weiboDict.user_id; // [upDict objectForKey:@"user_id"];
    NSNumber  *uped;
    //if ([[upDict objectForKey:@"uped"]  intValue]==0) {
    //uped =[NSString stringWithFormat:@"%d",1];
    //}
    if ([weiboDict.uped  integerValue] ==0) {
        uped=[NSNumber numberWithInt:0];
    }
    else
    {
        uped=[NSNumber numberWithInt:1];
    }
    
    NSDictionary *parameters = @{@"weibo_id":weiboId, @"stage_id":stageId,@"movie_id":movieId,@"movie_name":movieName,@"user_id":userId,@"author_id":autorId,@"operation":uped};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/weiboUp/up", kApiBaseUrl] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject  objectForKey:@"return_code"]  intValue]==10000) {
            NSLog(@"点赞成功========%@",responseObject);
            
            
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
//    if (segment.selectedSegmentIndex==0) {
//        return _addedDataArray.count;
//    }
//    else if (segment.selectedSegmentIndex==1)
//    {
//        return _upedDataArray.count;
//    }
    
    for (int i=100; i<102;i++ ) {
        UIButton  *btn =(UIButton *)[self.view viewWithTag:i];
        if (btn.tag==100&&btn.selected==YES) {
            return _addedDataArray.count;

        }
        else if (btn.tag==101&&btn.selected==YES)
        {
            return _upedDataArray.count;
        }
        
    }

    return 0;
}

-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    for (int i=100; i<102;i++ ) {
    
        UIButton  *btn =(UIButton *)[self.view viewWithTag:i];

    if (btn.tag==100&&btn.selected==YES) {
        HotMovieModel *model =[_addedDataArray objectAtIndex:indexPath.row];
        float hight;
        if (_addedDataArray.count>indexPath.row) {
            float  h= [model.stageinfo.h floatValue];
            float w=  [model.stageinfo.w floatValue];
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
        return hight+10;
    }
    else if (btn.tag==101&&btn.selected==YES)
    {
        HotMovieModel  *model =[_upedDataArray objectAtIndex:indexPath.row];
        float hight;
        if (_upedDataArray.count>indexPath.row) {
        float  h=[model.stageinfo.h floatValue];
            float w= [model.stageinfo.w floatValue];
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
    for (int i=100; i<102;i++ ) {
        UIButton  *btn =(UIButton *)[self.view viewWithTag:i];

    if  (btn.tag==100&&btn.selected==YES) {

        
        if (_addedDataArray.count>indexPath.row) {
            
        HotMovieModel  *model =[_addedDataArray objectAtIndex:indexPath.row];
        static NSString *cellID=@"CELL1";
        CommonStageCell  *cell= (CommonStageCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell=[[CommonStageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.backgroundColor=View_BackGround;
        }
                 cell.pageType=NSPageSourceTypeMyAddedViewController;
            //个人页面的来源
          //  UserDataCenter  *userCenter=[UserDataCenter shareInstance];
            if (self.author_id.length==0||[self.author_id isEqualToString:@"0"]) {  //表示直接进入这个页面的话，这个为空
                cell.userPage=NSUserPageTypeMySelfController;
            }
            else {
                cell.userPage=NSUserPageTypeOthersController;
            }

            //小闪动标签的数组
            cell.weiboDict=model.weibo;
            cell.StageInfoDict=model.stageinfo;
            [cell ConfigsetCellindexPath:indexPath.row];
            cell.stageView.delegate=self;
            return cell;
        }
        return nil;
    }
    else if (btn.tag==101&&btn.selected==YES)
    {
        if (_upedDataArray.count>indexPath.row) {
        HotMovieModel  *model =[_upedDataArray objectAtIndex:indexPath.row];
        static NSString *cellID=@"CELL2";
        CommonStageCell  *cell= (CommonStageCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell=[[CommonStageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.backgroundColor=View_BackGround;
        }
        
            cell.pageType=NSPageSourceTypeMainNewController;
            cell.weiboDict =model.weibo;    //[[_upedDataArray  objectAtIndex:indexPath.row]  objectForKey:@"weibo"];
            cell.StageInfoDict=model.stageinfo;
            [cell ConfigsetCellindexPath:indexPath.row];
            cell.stageView.delegate=self;
          //  [cell setCellValue:[[_upedDataArray objectAtIndex:indexPath.row]  objectForKey:@"stageinfo"]indexPath:indexPath.row];
            return  cell;
        }
      }
    }
    return nil;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didDeselectRowAtIndexPath  =====%ld",indexPath.row);
    CommonStageCell   *cell=(CommonStageCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (isMarkViewsShow==YES) {
        isMarkViewsShow=NO;
        [cell.stageView  hidenAndShowMarkView:YES];
        
    }
    else{
        isMarkViewsShow=YES;
        [cell.stageView  hidenAndShowMarkView:NO];
    }

}
//设置页面
-(void)GotoSettingClick:(UIButton  *) button
{
    
    [self.navigationController pushViewController:[SettingViewController new] animated:YES];
}

#pragma  mark  =====ButtonClick

//点击左下角的电影按钮
-(void)dealMovieButtonClick:(UIButton  *) button{
    HotMovieModel  *hotmovie;
    for (int i=100; i<102;i++ ) {
        UIButton  *btn =(UIButton *)[self.view viewWithTag:i];
        if (btn.tag==100&&btn.selected==YES) {
            hotmovie =[_addedDataArray objectAtIndex:button.tag-1000];}
        else if (btn.tag==101&&btn.selected==YES)
        {
            hotmovie=[_upedDataArray objectAtIndex:button.tag-1000];
        }
        
    }
     MovieDetailViewController *vc =  [MovieDetailViewController new];
    vc.movieId =  hotmovie.stageinfo.movie_id;
    [self.navigationController pushViewController:vc animated:YES];
}
//分享
-(void)ScreenButtonClick:(UIButton  *) button
{
    NSLog(@" ==ScreenButtonClick  ====%ld",button.tag);
    //获取cell
#pragma mark 暂时把sharetext设置成null
    HotMovieModel  *hotmovie;
    
    for (int i=100; i<102;i++ ) {
        UIButton  *btn =(UIButton *)[self.view viewWithTag:i];
        if (btn.tag==100&&btn.selected==YES) {
            hotmovie =[_addedDataArray objectAtIndex:button.tag-2000];
            
        }
        else if (btn.tag==101&&btn.selected==YES)
        {
            hotmovie=[_upedDataArray objectAtIndex:button.tag-2000];
        }
        
    }
//    if (segment.selectedSegmentIndex==0) {
//        hotmovie =[_addedDataArray objectAtIndex:button.tag-2000];
//    }
//    else  {
//        hotmovie=[_upedDataArray objectAtIndex:button.tag-2000];
//    }
    
    float hight= kDeviceWidth;
    float  ImageWith=[hotmovie.stageinfo.w intValue]; //[[self.StageInfoDict objectForKey:@"w"]  floatValue];
    float  ImgeHight=[hotmovie.stageinfo.h intValue];//[[self.StageInfoDict objectForKey:@"h"]  floatValue];
    if(ImgeHight>ImageWith)
    {
        hight=  (ImgeHight/ImageWith) *kDeviceWidth;
    }

    
    CommonStageCell *cell = (CommonStageCell *)(button.superview.superview.superview);
    
    
    UIImage  *image=[Function getImage:cell.stageView WithSize:CGSizeMake(kDeviceWidth, hight)];
    

     //创建UMshareView 后必须配备这三个方法
    shareView.StageInfo=hotmovie.stageinfo;
    shareView.screenImage=image;
    [shareView configShareView];
    [self.view addSubview:shareView];
    self.tabBarController.tabBar.hidden=YES;
    if ([shareView respondsToSelector:@selector(showShareButtomView)]) {
        [shareView showShareButtomView];
        
    }

}
#pragma  mark  -----UMButtomViewshareViewDlegate-------
-(void)UMshareViewHandClick:(UIButton *)button ShareImage:(UIImage *)shareImage MoviewModel:(StageInfoModel *)StageInfo
{
    NSArray  *sharearray =[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQzone, UMShareToSina, nil];
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
    
    [[UMSocialControllerService defaultControllerService] setShareText:StageInfo.movie_name shareImage:shareImage socialUIDelegate:self];        //设置分享内容和回调对象
    [UMSocialSnsPlatformManager getSocialPlatformWithName:[sharearray  objectAtIndex:button.tag-10000]].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
    NSLog(@"分享到微信");
    self.tabBarController.tabBar.hidden=NO;
    if (shareView) {
        [shareView HidenShareButtomView];
        [shareView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.5];
        
    }
}
///点击分享的屏幕，收回分享的背景
-(void)SharetopViewTouchBengan
{
    NSLog(@"controller touchbegan  中 执行了隐藏工具栏的方法");
    //取消当前的选中的那个气泡
    [_mymarkView CancelMarksetSelect];
    if (shareView) {
        [shareView HidenShareButtomView];
        [shareView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.5];
        self.tabBarController.tabBar.hidden=NO;
        
    }
    
}
-(void)didCloseUIViewController:(UMSViewControllerType)fromViewControllerType
{
    //返回到app执行的方法，移除的时候应该写在这里
    NSLog(@"didCloseUIViewController第一步执行这个");
    if (shareView) {
        [shareView removeFromSuperview];
        
    }
    
}
//根据有的view 上次一张图片
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    NSLog(@"didFinishGetUMSocialDataInViewController第二部执行这个");
    if (shareView) {
        [shareView removeFromSuperview];
    }
    
}
-(void)didFinishGetUMSocialDataResponse:(UMSocialResponseEntity *)response;
{
    NSLog(@"didFinishGetUMSocialDataResponse第二部执行这个");
    if (shareView) {
        [shareView removeFromSuperview];
    }
    
    
}
//点击增加弹幕
-(void)addMarkButtonClick:(UIButton  *) button
{
    NSLog(@" ==addMarkButtonClick  ====%ld",button.tag);
    AddMarkViewController  *AddMarkVC=[[AddMarkViewController alloc]init];
    HotMovieModel  *hotmovie=[[HotMovieModel alloc]init];
    for (int i=100; i<102;i++ ) {
        UIButton  *btn =(UIButton *)[self.view viewWithTag:i];
        if (btn.tag==100&&btn.selected==YES) {
            if (_addedDataArray.count>button.tag-3000) {
                hotmovie =[_addedDataArray objectAtIndex:button.tag-3000];

            }
            
        }
        else if (btn.tag==101&&btn.selected==YES)
        {
            if (_upedDataArray.count>button.tag-3000) {
            hotmovie=[_upedDataArray objectAtIndex:button.tag-3000];
            }
        }
        
    }

//    if (segment.selectedSegmentIndex==0) {
//        hotmovie =[_addedDataArray objectAtIndex:button.tag-3000];
//    }
//    else
//    {
//        hotmovie=[_upedDataArray objectAtIndex:button.tag-3000];
//    }
    AddMarkVC.stageInfoDict=hotmovie.stageinfo;
    //AddMarkVC.pageSoureType=NSAddMarkPageSourceDefault;
    NSLog(@"dict.stageinfo = %@", AddMarkVC.stageInfoDict);
    [self.navigationController pushViewController:AddMarkVC animated:NO];
    
}

-(void)delectButtonClick:(UIButton *) button
{
    //删除按钮
    NSLog(@"点击了删除 button tag＝＝＝＝ %ld",button.tag);
    
    UIActionSheet   *ash=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除弹幕" otherButtonTitles:nil, nil];
    ash.tag=button.tag;
    [ash showInView:self.view];
    
    

    
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    NSLog(@" button Index ===%ld",(long)buttonIndex);
    if (actionSheet.tag<7000) {
      if (buttonIndex==0) {          
          UIActionSheet   *ash=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil, nil];
          ash.tag=actionSheet.tag+1000;
          [ash showInView:self.view];
     }
    }
    else
    {
        if (buttonIndex==0) {
               HotMovieModel  *model =[_addedDataArray objectAtIndex:actionSheet.tag-7000];
               [_addedDataArray removeObjectAtIndex:actionSheet.tag-7000];
                productCount=productCount-1;
            lblCount.text=[NSString stringWithFormat:@"%d",productCount];
                [_tableView reloadData];
                [self requestDelectData:model];
        }

    }
    
}



#pragma mark   ---
#pragma mark   ----stageViewDelegate   --
#pragma mark    ---
-(void)StageViewHandClickMark:(WeiboModel *)weiboDict withmarkView:(id)markView StageInfoDict:(StageInfoModel *)stageInfoDict
{
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
-(void)SetToolBarValueWithDict:(WeiboModel  *)weiboDict markView:(id) markView isSelect:(BOOL ) isselect StageInfo:(StageInfoModel *) stageInfo
{
    //先对它赋值，然后让他弹出到界面
    if (isselect==YES) {
        NSLog(@" new viewController SetToolBarValueWithDict  执行了出现工具栏的方法");
        
        //设置工具栏的值
        //[_toolBar setToolBarValue:weiboDict :markView WithStageInfo:stageInfo];
        _toolBar.weiboDict=weiboDict;
        _toolBar.StageInfoDict=stageInfo;
        _toolBar.markView=markView;
        [_toolBar configToolBar];
        
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
-(void)ToolViewHandClick:(UIButton *)button :(MarkView *)markView weiboDict:(WeiboModel *)weiboDict StageInfo:(StageInfoModel *)stageInfoDict
{
    NSLog(@"点击头像  微博dict  ＝====%@ ======出现的stageinfo  ＝＝＝＝＝＝%@",weiboDict,stageInfoDict);
    
    if (button.tag==10000) {
        ///点击了头像//进入个人页面
        NSLog(@"点击头像  微博dict  ＝====%@ ======出现的stageinfo  ＝＝＝＝＝＝%@",weiboDict,stageInfoDict);
        
    }
#pragma mark     -----------分享
    else if (button.tag==10001)
    {
        //点击了分享
        //分享文字
        NSString  *shareText=weiboDict.topic;//[weiboDict objectForKey:@"topic"];
        NSLog(@" 点击了分享按钮");
        
        float hight= kDeviceWidth;
        float  ImageWith=[stageInfoDict.w intValue]; //[[self.StageInfoDict objectForKey:@"w"]  floatValue];
        float  ImgeHight=[stageInfoDict.h intValue];//[[self.StageInfoDict objectForKey:@"h"]  floatValue];
        if(ImgeHight>ImageWith)
        {
            hight=  (ImgeHight/ImageWith) *kDeviceWidth;
        }
        
        
        CommonStageCell *cell = (CommonStageCell *)(markView.superview.superview.superview);
        
        /*UIGraphicsBeginImageContextWithOptions(CGSizeMake(kDeviceWidth, hight), YES, [UIScreen mainScreen].scale);
        [cell.stageView drawViewHierarchyInRect:cell.stageView.bounds afterScreenUpdates:YES];
        
        // old style [self.layer renderInContext:UIGraphicsGetCurrentContext()];
        
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        */
        
        UIImage  *image=[Function getImage:cell.stageView WithSize:CGSizeMake(kDeviceWidth, hight)];
        
        //创建UMshareView 后必须配备这三个方法
        shareView.StageInfo=stageInfoDict;
        shareView.screenImage=image;
        [shareView configShareView];
        [self.view addSubview:shareView];
        self.tabBarController.tabBar.hidden=YES;
        if ([shareView respondsToSelector:@selector(showShareButtomView)]) {
            [shareView showShareButtomView];
            
        }


        
    }
#pragma mark  ----------点赞--------------
    else  if(button.tag==10002)
    {
        //改变赞的状态
        //点击了赞
        
        NSLog(@" 点赞 前 微博dict  ＝====uped====%@    ups===%@",weiboDict.uped,weiboDict.ups);
        if ([weiboDict.uped intValue]==0)
        {
            weiboDict.uped=[NSNumber numberWithInt:1];
            int ups=[weiboDict.ups intValue];
            ups =ups+[weiboDict.uped intValue];
            weiboDict.ups=[NSNumber numberWithInt:ups];
            //重新给markview 赋值，改变markview的frame
            [self layoutMarkViewWithMarkView:markView WeiboInfo:weiboDict];
            
            
            
        }
        else  {
            
            weiboDict.uped=[NSNumber numberWithInt:0];
            int ups=[weiboDict.ups intValue];
            ups =ups-1;
            weiboDict.ups=[NSNumber numberWithInt:ups];
            [self layoutMarkViewWithMarkView:markView WeiboInfo:weiboDict];
        }
        
        ////发送到服务器
        [self LikeRequstData:weiboDict StageInfo:stageInfoDict];
        
    }
}
//重新布局markview
-(void)layoutMarkViewWithMarkView:(MarkView  *) markView WeiboInfo:(WeiboModel *) weibodict
{
    
    
    NSLog(@" 点赞 后 微博dict  ＝====uped====%@    ups===%@",weibodict.uped,weibodict.ups);
    
    float  x=[weibodict.x floatValue];
    float  y=[weibodict.y floatValue];
    NSString  *weiboTitleString=weibodict.topic;
    NSString  *UpString=[NSString stringWithFormat:@"%@",weibodict.ups];//weibodict.ups;
    //计算标题的size
    CGSize  Msize=[weiboTitleString boundingRectWithSize:CGSizeMake(kDeviceWidth/2,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:markView.TitleLable.font forKey:NSFontAttributeName] context:nil].size;
    // 计算赞数量的size
    CGSize Usize=[UpString boundingRectWithSize:CGSizeMake(40,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:markView.ZanNumLable.font forKey:NSFontAttributeName] context:nil].size;
    
    // NSLog(@"size= %f %f", Msize.width, Msize.height);
    //计算赞数量的长度
    float  Uwidth=[UpString floatValue]==0?0:Usize.width;
    //宽度=字的宽度+左头像图片的宽度＋赞图片的宽度＋赞数量的宽度+中间两个空格2+2
    float markViewWidth = Msize.width+23+Uwidth+5+5+11+5;
    float markViewHeight = Msize.height+6;
    if(IsIphone6)
    {
        markViewWidth=markViewWidth+10;
        markViewHeight=markViewHeight+4;
    }
#pragma mark 设置气泡的大小和位置
    markView.frame=CGRectMake(markView.frame.origin.x,markView.frame.origin.y, markViewWidth, markViewHeight);
#pragma mark 设置标签的内容
    // markView.TitleLable.text=weiboTitleString;
    markView.ZanNumLable.text =[NSString stringWithFormat:@"%@",weibodict.ups];
    if ([weibodict.ups intValue]==0) {
        markView.ZanNumLable.hidden=YES;
    }
    else
    {
        markView.ZanNumLable.hidden=NO;
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


/*-(void)StageViewHandClickMark:(NSDictionary *)weiboDict withStageView:(id)stageView
{
    NSLog(@"点击了一个标签，标签的内容为   =====%@",weiboDict);
}*/
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
