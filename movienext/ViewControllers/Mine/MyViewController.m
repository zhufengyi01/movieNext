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
#import "StageView.h"
#import "StageInfoModel.h"
#import "ButtomToolView.h"
#import "MovieDetailViewController.h"
#import "UMSocial.h"
#import "AddMarkViewController.h"
@interface MyViewController ()<UITableViewDataSource, UITableViewDelegate,StageViewDelegate,MarkViewDelegate,StageViewDelegate,ButtomToolViewDelegate>
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
    
    ButtomToolView *_toolBar;
    MarkView       *_mymarkView;

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
    [self createToolBar];
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

//创建底部的视图
-(void)createToolBar

{
    _toolBar=[[ButtomToolView alloc]initWithFrame:CGRectMake(0,0,kDeviceWidth,kDeviceHeight)];
    _toolBar.delegete=self;
    
}


#pragma  mark -----
#pragma  mark ------  DataRequest 
#pragma  mark ----
- (void)requestData{
#warning  这里需要替换用户id
    UserDataCenter  *userCenter=[UserDataCenter shareInstance];
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
            cell.stageView.delegate=self;
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
            cell.stageView.delegate=self;
          //  [cell setCellValue:[[_upedDataArray objectAtIndex:indexPath.row]  objectForKey:@"stageinfo"]indexPath:indexPath.row];
        }
        return  cell;
    }
    return nil;
    
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
    if (segment.selectedSegmentIndex==0) {
        hotmovie =[_addedDataArray objectAtIndex:button.tag-1000];
    }
    else  {
        hotmovie=[_upedDataArray objectAtIndex:button.tag-1000];
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
    
    CommonStageCell *cell = (CommonStageCell *)(button.superview.superview.superview);
    
    UIGraphicsBeginImageContextWithOptions(_tableView.bounds.size, YES, [UIScreen mainScreen].scale);
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
    HotMovieModel  *hotmovie=[[HotMovieModel alloc]init];
    if (segment.selectedSegmentIndex==0) {
        hotmovie =[_addedDataArray objectAtIndex:button.tag-3000];
    }
    else
    {
        hotmovie=[_upedDataArray objectAtIndex:button.tag-3000];
    }
    AddMarkVC.stageInfoDict=hotmovie.stageinfo;
    NSLog(@"dict.stageinfo = %@", AddMarkVC.stageInfoDict);
    [self.navigationController pushViewController:AddMarkVC animated:NO];
    
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
        CommonStageCell *cell = (CommonStageCell *)(markView.superview.superview.superview);
        
        UIGraphicsBeginImageContextWithOptions(_tableView.bounds.size, YES, [UIScreen mainScreen].scale);
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
    float markViewX = (x*kDeviceWidth)/100-markViewWidth;
    markViewX = MIN(MAX(markViewX, 1.0f), kDeviceWidth-markViewWidth-1);
    
    float markViewY = (y*kDeviceWidth)/100+(Msize.height/2);
#warning    kDeviceWidth 目前计算的是正方形的，当图片高度>屏幕的宽度的实际，需要使用图片的高度
    markViewY = MIN(MAX(markViewY, 1.0f), kDeviceWidth-markViewHeight-1);
#pragma mark 设置气泡的大小和位置
    markView.frame=CGRectMake(markViewX, markViewY, markViewWidth, markViewHeight);
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
