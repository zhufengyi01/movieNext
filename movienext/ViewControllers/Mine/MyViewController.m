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
#import "UserDataCenter.h"
#import "SettingViewController.h"
#import "UIImageView+WebCache.h"
#import "HotMovieModel.h"
#import "StageInfoModel.h"
#import "WeiboModel.h"
@interface MyViewController ()<UITableViewDataSource, UITableViewDelegate,StageViewDelegate,MarkViewDelegate>
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
    UILabel *lblZanCout;
    UILabel *lblBrief;//简介
    UserDataCenter  *userCenter;
}
@end

@implementation MyViewController
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden=NO;
    self.navigationController.navigationBar.alpha=1;
    self.navigationController.navigationBar.translucent=NO;

    self.tabBarController.tabBar.hidden=NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor yellowColor];
    
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
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kHeightNavigation)];
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    
    userCenter=[UserDataCenter shareInstance];
    
    int BodyConut=[userCenter.product_count intValue];
    int  ZanCount= [userCenter.like_count  intValue];

    NSString  *signature=[NSString stringWithFormat:@"%@",userCenter.signature];
    if (signature==nil) {
        signature=@"";
    }
   /// NSLog(@"   ==========用户信息===body count %d   zanCount ===%d   signatuer ===%@,头像 =====%@",BodyConut,ZanCount,signature,    userCenter.avatar);
    
    UIView *viewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 130)];
    viewHeader.backgroundColor =View_BackGround;
    
    int ivAvatarWidth = 50;
    ivAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(25, 20, ivAvatarWidth, ivAvatarWidth)];
    ivAvatar.layer.cornerRadius = ivAvatarWidth * 0.5;
    ivAvatar.layer.masksToBounds = YES;
   // ivAvatar.backgroundColor = [UIColor redColor];
    

   // ivAvatar.image=[UIImage imageNamed:[]];
    [ivAvatar sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@!thumb",kUrlAvatar,userCenter.avatar]] placeholderImage:[UIImage imageNamed:@"loading_image_all.png"]];
    NSLog(@"avatar url = %@/%@!thumb", kUrlAvatar, userCenter.avatar );

    [viewHeader addSubview:ivAvatar];
    
    lblUsername = [[UILabel alloc] initWithFrame:CGRectMake(ivAvatar.frame.origin.x+ivAvatar.frame.size.width+10, ivAvatar.frame.origin.y, 200, 20)];
    lblUsername.font = [UIFont systemFontOfSize:15];
    lblUsername.textColor = VBlue_color;
    //lblUsername.backgroundColor = [UIColor blueColor];
    lblUsername.text=[NSString stringWithFormat:@"%@",userCenter.username];
    [viewHeader addSubview:lblUsername];
    
    UILabel  *lbl1=[ZCControl createLabelWithFrame:CGRectMake(lblUsername.frame.origin.x,lblUsername.frame.origin.y+lblUsername.frame.size.height+10, 40, 20) Font:14 Text:@"内容"];
    lbl1.textColor=VBlue_color;
    [viewHeader addSubview:lbl1];
    
    //内容的数量
    lblCount = [[UILabel alloc] initWithFrame:CGRectMake(lbl1.frame.origin.x+lbl1.frame.size.width, lblUsername.frame.origin.y+lblUsername.frame.size.height+10, 60, 20)];
    lblCount.font = [UIFont systemFontOfSize:14];
    lblCount.text=[NSString stringWithFormat:@"%d",BodyConut];//BodyConut;]
    lblCount.textColor = VGray_color;
    //lblCount.backgroundColor = [UIColor purpleColor];
    [viewHeader addSubview:lblCount];
    
    
    UILabel  *lbl2=[ZCControl createLabelWithFrame:CGRectMake(lblCount.frame.origin.x+lblCount.frame.size.width+10,lblUsername.frame.origin.y+lblUsername.frame.size.height+10, 40, 20) Font:14 Text:@"赞"];
    lbl2.textColor=VBlue_color;
    [viewHeader addSubview:lbl2];

    //赞的数量
    lblZanCout = [[UILabel alloc] initWithFrame:CGRectMake(lbl2.frame.origin.x+lbl2.frame.size.height+10,lblCount.frame.origin.y , 50, 20)];
    lblZanCout.font = [UIFont systemFontOfSize:14];
    lblZanCout.textColor = VGray_color;
    lblZanCout.text=[NSString stringWithFormat:@"%d",ZanCount];
    
    //lblZanCout.backgroundColor = [UIColor purpleColor];
    [viewHeader addSubview:lblZanCout];
    
   //简介
    lblBrief = [[UILabel alloc] initWithFrame:CGRectMake(ivAvatar.frame.origin.x+ivAvatar.frame.size.width+10,lblCount.frame.origin.y+lblCount.frame.size.height+10, kDeviceWidth-ivAvatar.frame.origin.x-ivAvatar.frame.size.width-20, 20)];
    lblBrief.font = [UIFont systemFontOfSize:12];
    CGSize  Msize= [signature boundingRectWithSize:CGSizeMake(kDeviceWidth-80, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:lblBrief.font forKey:NSFontAttributeName] context:nil].size;
    lblBrief.textColor = VGray_color;
   // lblBrief.backgroundColor = [UIColor orangeColor];
    lblBrief.text=signature;
    lblBrief.frame=CGRectMake(ivAvatar.frame.origin.x+ivAvatar.frame.size.width+10,lblCount.frame.origin.y+lblCount.frame.size.height+10, kDeviceWidth-ivAvatar.frame.origin.x-ivAvatar.frame.size.width-20, Msize.height);
      [viewHeader addSubview:lblBrief];
    
    NSArray *segmentedArray = [[NSArray alloc] initWithObjects:@"添加", @"被赞", nil];
    segment = [[UISegmentedControl alloc] initWithItems:segmentedArray];
    segment.frame = CGRectMake(0, lblBrief.frame.origin.y+lblBrief.frame.size.height+10, kDeviceWidth, 30);
    segment.selectedSegmentIndex = 0;
    segment.tintColor = kAppTintColor;
    segment.backgroundColor = [UIColor clearColor];
    
    NSDictionary* selectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:14]
                                             };
    [segment setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];
    NSDictionary* unselectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:14]
                                               };
    [segment setTitleTextAttributes:unselectedTextAttributes forState:UIControlStateNormal];
    [segment addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventValueChanged];
    [viewHeader addSubview:segment];
    
    viewHeader.frame=CGRectMake(0, 0, kDeviceWidth,segment.frame.origin.y+segment.frame.size.height);

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
    if ( !_author_id ) {
        _author_id = userCenter.user_id;
    }
    //user_id是当前用户的ID
    NSDictionary *parameters = @{@"user_id":userCenter.user_id, @"page":[NSString stringWithFormat:@"%d",page], @"author_id":_author_id};
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
           // [_addedDataArray addObjectsFromArray:Detailarray];
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
                    
                }
                [_addedDataArray addObject:model];
            }
            [_tableView reloadData];

        }
        else if(segment.selectedSegmentIndex==1)
        {
            if (_upedDataArray==nil) {
                _upedDataArray=[[NSMutableArray alloc]init];
            }
           NSLog(@"用户赞过的数据 JSON: %@", responseObject);
           // [_upedDataArray addObjectsFromArray:Detailarray];
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
                    
                }
                [_upedDataArray addObject:model];
            }

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
        HotMovieModel *model =[_addedDataArray objectAtIndex:indexPath.row];
        float hight;
        if (_addedDataArray.count>indexPath.row) {
            float  h= [model.stageinfo.h floatValue]; // [[[[_addedDataArray  objectAtIndex:indexPath.row]  objectForKey:@"stageinfo"] objectForKey:@"h"] floatValue];
            float w=  [model.stageinfo.w floatValue]; //[[[[_addedDataArray  objectAtIndex:indexPath.row]  objectForKey:@"stageinfo"] objectForKey:@"w"] floatValue];
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
    else if (segment.selectedSegmentIndex==1)
    {
        HotMovieModel  *model =[_upedDataArray objectAtIndex:indexPath.row];
        float hight;
        if (_upedDataArray.count>indexPath.row) {
        
            float  h=[model.stageinfo.h floatValue];  // [[[[_upedDataArray  objectAtIndex:indexPath.row]  objectForKey:@"stageinfo"] objectForKey:@"h"] floatValue];
            float w= [model.stageinfo.w floatValue]; // [[[[_upedDataArray  objectAtIndex:indexPath.row]  objectForKey:@"stageinfo"] objectForKey:@"w"] floatValue];
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
        HotMovieModel  *model =[_addedDataArray objectAtIndex:indexPath.row];
        static NSString *cellID=@"CELL1";
        CommonStageCell  *cell= (CommonStageCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell=[[CommonStageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.backgroundColor=View_BackGround;
        }
     
        if (_addedDataArray.count>indexPath.row) {
            cell.pageType=NSPageSourceTypeMyAddedViewController;
            //小闪动标签的数组
            cell.weiboDict=model.weibo;//[[_addedDataArray objectAtIndex:indexPath.row]  objectForKey:@"weibo"];
           // [cell setCellValue:[[_addedDataArray objectAtIndex:indexPath.row]  objectForKey:@"stageinfo"] indexPath:indexPath.row];
            cell.StageInfoDict=model.stageinfo;
            [cell ConfigsetCellindexPath:indexPath.row];
        }
        return cell;
    }
    else if (segment.selectedSegmentIndex==1)
    {
        HotMovieModel  *model =[_upedDataArray objectAtIndex:indexPath.row];
        static NSString *cellID=@"CELL2";
        CommonStageCell  *cell= (CommonStageCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell=[[CommonStageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.backgroundColor=View_BackGround;
        }
        if (_upedDataArray.count>indexPath.row) {
            cell.pageType=NSPageSourceTypeMainNewController;
            cell.weiboDict =model.weibo;    //[[_upedDataArray  objectAtIndex:indexPath.row]  objectForKey:@"weibo"];
            cell.StageInfoDict=model.stageinfo;
            [cell ConfigsetCellindexPath:indexPath.row];
          //  [cell setCellValue:[[_upedDataArray objectAtIndex:indexPath.row]  objectForKey:@"stageinfo"]indexPath:indexPath.row];
        }
        return  cell;
    }
    return nil;
    
}

-(void)GotoSettingClick:(UIButton  *) button
{
    
    [self.navigationController pushViewController:[SettingViewController new] animated:YES];
}

#pragma mark   ---
#pragma mark   ----stageViewDelegate   --
#pragma mark    ---
-(void)StageViewHandClickMark:(NSDictionary *)weiboDict withStageView:(id)stageView
{
    NSLog(@"点击了一个标签，标签的内容为   =====%@",weiboDict);
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
