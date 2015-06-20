//
//  NewAddViewController.m
//  movienext
//
//  Created by 风之翼 on 15/5/29.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "NewAddViewController.h"
#import "Function.h"
#import "UserDataCenter.h"

#import "ShowStageViewController.h"

#import "SmallImageCollectionViewCell.h"

#import "AFNetworking.h"

#import "ZCControl.h"

#import "Constant.h"

#import "LoadingView.h"

#import "MJRefresh.h"

#import "weiboInfoModel.h"

#import "UIImageView+WebCache.h"

#import "UpweiboModel.h"

#import "StageViewController.h"

#import "NSDate+Extension.h"
#import "ShareModel.h"

static const CGFloat MJDuration = 0.1;


@interface NewAddViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,LoadingViewDelegate>
{
    UICollectionViewFlowLayout    *layout;
    
    int pageSize;
    int page;
    int pageCount;
    LoadingView         *loadView;
    UserDataCenter     *userCenter;
    // NSMutableArray     *weiboUpArray;
    
    
}

@property(nonatomic,strong) NSMutableArray   *upWeiboArray;
@end

@implementation NewAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self initUI];
    [self createNavigation];
    // [self requestData];
    
}
-(void)createNavigation
{
    NSString  *titleString=@"微博正常";
    if (self.pageType==NSNewAddPageSoureTypeCloseWeiboList) {
        titleString =@"微博屏蔽";
    }
    else if(self.pageType==NSNewAddPageSoureTypeDecorver)
    {
        titleString=@"微博发现";
    }
    else if (self.pageType==NSNewAddPageSoureTypeRecommed)
    {
        titleString=@"微博热门";
    }
    else if (self.pageType==NSNewAddPageSoureTypeTiming)
    {
        titleString=@"微博已定时";
    }
    else if (self.pageType==NSNewAddPageSoureTypeNotReview)
    {
        titleString=@"微博未审核";
    }
    else if(self.pageType ==NSNewAddPageSoureTypeShare)
    {
        titleString = @"微博分享";
    }
    UILabel  *titleLable=[ZCControl createLabelWithFrame:CGRectMake(0, 0, 100, 20) Font:16 Text:titleString];
    titleLable.textColor=VGray_color;
    
    titleLable.font=[UIFont fontWithName:kFontDouble size:18];
    titleLable.textAlignment=NSTextAlignmentCenter;
    self.navigationItem.titleView=titleLable;
}
-(void)initData
{
    page=1;
    pageSize=20;
    pageCount=1;
    userCenter=[UserDataCenter shareInstance];
    _dataArray =[[NSMutableArray alloc]init];
    self.upWeiboArray  =[[NSMutableArray alloc]init];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)initUI
{
    layout=[[UICollectionViewFlowLayout alloc]init];
    //layout.minimumInteritemSpacing=10; //cell之间左右的
    //layout.minimumLineSpacing=10;      //cell上下间隔
    //layout.itemSize=CGSizeMake(80,140);  //cell的大小
    layout.sectionInset=UIEdgeInsetsMake(0,0,64, 0); //整个偏移量 上左下右
    _myConllectionView =[[UICollectionView alloc]initWithFrame:CGRectMake(0,0,kDeviceWidth, kDeviceHeight-kHeightNavigation-0) collectionViewLayout:layout];
    //[layout setHeaderReferenceSize:CGSizeMake(_myConllectionView.frame.size.width, kDeviceHeight/3+64+110)];
    
    _myConllectionView.backgroundColor=View_BackGround;
    //注册大图模式
    //[_myConllectionView registerClass:[BigImageCollectionViewCell class] forCellWithReuseIdentifier:@"bigcell"];
    
    //注册小图模式
    [_myConllectionView registerClass:[SmallImageCollectionViewCell class] forCellWithReuseIdentifier:@"smallcell"];
    // 注册头部视图
    //[_myConllectionView registerClass:[MovieHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView"];
    _myConllectionView.delegate=self;
    _myConllectionView.dataSource=self;
    
    [self.view addSubview:_myConllectionView];
    [self setUprefresh];
    //    [self setupHeadView];
    //    [self setupFootView];
}
- (void)setUprefresh
{
    __weak typeof(self) weakSelf = self;
    
    // 下拉刷新
    [self.myConllectionView addLegendHeaderWithRefreshingBlock:^{
        // 增加5条假数据
        /*for (int i = 0; i<10; i++) {
         [weakSelf.colors insertObject:MJRandomColor atIndex:0];
         }*/
        page=1;
        if (weakSelf.dataArray.count>0) {
            [weakSelf.dataArray removeAllObjects];
        }
        // 进入刷新状态就会回调这个Block
        [weakSelf requestData];
        
        // 设置文字
        [weakSelf.myConllectionView.header setTitle:@"下拉刷新..." forState:MJRefreshHeaderStateIdle];
        [weakSelf.myConllectionView.header setTitle:@"释放刷新..." forState:MJRefreshHeaderStatePulling];
        [weakSelf.myConllectionView.header setTitle:@"正在刷新..." forState:MJRefreshHeaderStateRefreshing];
        //隐藏时间
        weakSelf.myConllectionView.header.updatedTimeHidden=YES;
        
        // 设置字体
        //weakSelf.myConllectionView.header.font = [UIFont fontWithName:kFontRegular size:12];
        
        // 设置颜色
        // weakSelf.myConllectionView.header.textColor = VGray_color;
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.myConllectionView reloadData];
            
            // 结束刷新
            [weakSelf.myConllectionView.header endRefreshing];
        });
    }];
    [self.myConllectionView.header beginRefreshing];
    
    // 上拉刷新
    [self.myConllectionView addLegendFooterWithRefreshingBlock:^{
        // 增加5条假数据
        /*for (int i = 0; i<5; i++) {
         [weakSelf.colors addObject:MJRandomColor];
         }*/
        // 进入刷新状态就会回调这个Block
        if (pageCount>page) {
            page=page+1;
            [weakSelf requestData];
        }else {
            [weakSelf.myConllectionView.footer noticeNoMoreData];
        }
        // 设置文字
        [weakSelf.myConllectionView.footer setTitle:@"点击加载更多..." forState:MJRefreshFooterStateIdle];
        [weakSelf.myConllectionView.footer setTitle:@"加载更多..." forState:MJRefreshFooterStateRefreshing];
        [weakSelf.myConllectionView.footer setTitle:@"THE END" forState:MJRefreshFooterStateNoMoreData];
        
        // 设置字体
        // weakSelf.myConllectionView.footer.font = [UIFont fontWithName:kFontRegular size:12];
        
        // 设置颜色
        //weakSelf.myConllectionView.footer.textColor = VGray_color;
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //  [weakSelf.myConllectionView reloadData];
            // 结束刷新
            //[weakSelf.myConllectionView.footer endRefreshing];
        });
    }];
    // 默认先隐藏footer
    // self.myConllectionView.footer.hidden = YES;
}
-(void)creatLoadView
{
    loadView =[[LoadingView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    loadView.delegate=self;
    [self.view addSubview:loadView];
}

-(void)requestData
{
    //UserDataCenter *userCenter =[UserDataCenter shareInstance];
    NSDictionary *parameters;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString  *urlString =[NSString stringWithFormat:@"%@/weibo/list-by-status?per-page=%d&page=%d", kApiBaseUrl,pageSize,page];
    if (self.pageType==NSNewAddPageSoureTypeNewList) {
        parameters = @{@"user_id":userCenter.user_id, @"status":@"1"};
    }
    else if(self.pageType==NSNewAddPageSoureTypeCloseWeiboList)
    {
        parameters = @{@"user_id":userCenter.user_id, @"status":@"0"};
    }
    else if (self.pageType==NSNewAddPageSoureTypeDecorver)
    {
        parameters = @{@"user_id":userCenter.user_id, @"status":@"2"};
    }
    else if (self.pageType==NSNewAddPageSoureTypeRecommed)
    {
        parameters = @{@"user_id":userCenter.user_id, @"status":@"3"};
    }
    else if (self.pageType==NSNewAddPageSoureTypeTiming)
    {
        parameters = @{@"user_id":userCenter.user_id, @"status":@"4"};
    }
    else if (self.pageType==NSNewAddPageSoureTypeNotReview)
    {
        parameters = @{@"user_id":userCenter.user_id, @"status":@"5"};
    }
    else if (self.pageType==NSNewAddPageSoureTypeShare)
    {
        urlString =[NSString stringWithFormat:@"%@/share/list?per-page=%d&page=%d", kApiBaseUrl,pageSize,page];
        parameters=@{@"user_id":userCenter.user_id};
    }
    
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject  objectForKey:@"code"]  intValue]==0) {
            pageCount=[[responseObject objectForKey:@"pageCount"] intValue];
            NSMutableArray   *array  = [[NSMutableArray alloc]initWithArray:[responseObject objectForKey:@"models"]];
            if (self.pageType==NSNewAddPageSoureTypeShare) {
                //分享列表
                for (int i=0; i<array.count; i++) {
                    NSDictionary  *sharedict =[NSDictionary dictionaryWithDictionary:[array objectAtIndex:i]];
                    ShareModel  *sharemodel =[[ShareModel alloc]init];
                    if (sharemodel){
                        [sharemodel setValuesForKeysWithDictionary:sharedict];
                        weiboUserInfoModel *user =[[weiboUserInfoModel alloc]init];
                        if (user) {
                            [user setValuesForKeysWithDictionary:[sharedict objectForKey:@"user"]];
                            sharemodel.userInfo=user;
                        }
                        weiboInfoModel  *weibomodel =[[weiboInfoModel alloc]init];
                        if (weibomodel) {
                            [weibomodel setValuesForKeysWithDictionary:[sharedict objectForKey:@"weibo"]];
                            weiboUserInfoModel  *weibouser =[[weiboUserInfoModel alloc]init];
                            if (weibouser) {
                                [weibouser setValuesForKeysWithDictionary:[[sharedict objectForKey:@"weibo"] objectForKey:@"user"]];
                                weibomodel.uerInfo =weibouser;
                            }
                            stageInfoModel  *stagmodel =[[stageInfoModel alloc]init];
                            if (stagmodel) {
                                [stagmodel setValuesForKeysWithDictionary:[[sharedict objectForKey:@"weibo"] objectForKey:@"stage"]];
                                
                                movieInfoModel *moviemoel =[[movieInfoModel alloc]init];
                                if (moviemoel) {
                                    [moviemoel setValuesForKeysWithDictionary:[[[sharedict objectForKey:@"weibo"] objectForKey:@"stage"] objectForKey:@"movie"]];
                                    stagmodel.movieInfo =moviemoel;
                                }
                                weibomodel.stageInfo =stagmodel;
                            }
                
                            //标签数组
                            NSMutableArray  *tagArray =[[NSMutableArray alloc]init];
                            //标签数组
                            for ( NSDictionary  *tagdict in [[sharedict objectForKey:@"weibo"] objectForKey:@"tags"]) {
                                TagModel *tagmodel=[[TagModel alloc]init];
                                if (tagmodel) {
                                    [tagmodel setValuesForKeysWithDictionary:tagdict];
                                    
                                    TagDetailModel *tagdetail =[[TagDetailModel alloc]init];
                                    if (tagdetail) {
                                        [tagdetail setValuesForKeysWithDictionary:[tagdict objectForKey:@"tag"]];
                                        tagmodel.tagDetailInfo=tagdetail;
                                    }
                                    [tagArray addObject:tagmodel];
                                }
                            }
                            weibomodel.tagArray=tagArray;
                            sharemodel.weiboInfo =weibomodel;
                        }
                        if (self.dataArray==nil) {
                            self.dataArray =[[NSMutableArray alloc]init];
                        }
                        [self.dataArray addObject:sharemodel];
                    }
                }
                
            }
            else {
                for ( int i=0 ; i<array.count; i++) {
                    NSDictionary  *newdict  =[array objectAtIndex:i];
                    weiboInfoModel *weibomodel =[[weiboInfoModel alloc]init];
                    if (weibomodel) {
                        [weibomodel setValuesForKeysWithDictionary:newdict];
                        //用户的信息
                        weiboUserInfoModel  *usermodel =[[weiboUserInfoModel alloc]init];
                        if (usermodel) {
                            if (![[newdict objectForKey:@"user"] isKindOfClass:[NSNull class]]) {
                                [usermodel setValuesForKeysWithDictionary:[newdict objectForKey:@"user"]];
                                weibomodel.uerInfo=usermodel;
                            }
                        }
                        // 剧情信息
                        stageInfoModel  *stagemodel =[[stageInfoModel alloc]init];
                        if (stagemodel) {
                            if (![[newdict objectForKey:@"stage"]  isKindOfClass:[NSNull class]]) {
                                [stagemodel setValuesForKeysWithDictionary:[newdict objectForKey:@"stage"]];
                                weibomodel.stageInfo=stagemodel;
                                movieInfoModel *moviemodel =[[movieInfoModel alloc]init];
                                if (moviemodel) {
                                    if (![[[newdict objectForKey:@"stage"] objectForKey:@"movie"]isKindOfClass:[NSNull class]]) {
                                    [moviemodel  setValuesForKeysWithDictionary:[[newdict objectForKey:@"stage"] objectForKey:@"movie"]];
                                    stagemodel.movieInfo=moviemodel;
                                    }
                                }
                            }
                        }
                        NSMutableArray  *tagArray =[[NSMutableArray alloc]init];
                        //标签数组
                        for ( NSDictionary  *tagdict in [newdict objectForKey:@"tags"]) {
                            TagModel *tagmodel=[[TagModel alloc]init];
                            if (tagmodel) {
                                [tagmodel setValuesForKeysWithDictionary:tagdict];
                                
                                TagDetailModel *tagdetail =[[TagDetailModel alloc]init];
                                if (tagdetail) {
                                    [tagdetail setValuesForKeysWithDictionary:[tagdict objectForKey:@"tag"]];
                                    tagmodel.tagDetailInfo=tagdetail;
                                }
                                [tagArray addObject:tagmodel];
                            }
                        }
                        weibomodel.tagArray=tagArray;
                        [self.dataArray addObject:weibomodel];
                    }
                }
                //点赞的数组
                for (NSDictionary  *updict in [responseObject objectForKey:@"upweibos"]) {
                    UpweiboModel *upmodel =[[UpweiboModel alloc]init];
                    if (upmodel) {
                        [upmodel setValuesForKeysWithDictionary:updict];
                        
                        if (_upWeiboArray==nil) {
                            _upWeiboArray =[[NSMutableArray alloc]init];
                        }
                        [_upWeiboArray addObject:upmodel];
                    }
                }
            }
            [self.myConllectionView reloadData];
            [self.myConllectionView.footer endRefreshing];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}


#pragma  mark
#pragma mark - UICollectionViewDataSource ----

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (collectionView==_myConllectionView) {
        return 1;
    }
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView==_myConllectionView) {
        return _dataArray.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SmallImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"smallcell" forIndexPath:indexPath];
    //在这里先将内容给清除一下, 然后再加载新的, 添加完内容之后先动画, 在cell消失的时候做清理工作
    if (_dataArray.count>indexPath.row) {
        if (self.pageType==NSNewAddPageSoureTypeShare) {
            ShareModel *model =[self.dataArray objectAtIndex:indexPath.row];
            NSURL  *url =[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",kUrlStage,model.weiboInfo.stageInfo.photo,KIMAGE_SMALL]];
            [cell.imageView sd_setImageWithURL:url placeholderImage:nil options:(SDWebImageRetryFailed|SDWebImageLowPriority)];
            NSDate  *comfromTimesp =[NSDate dateWithTimeIntervalSince1970:[model.created_at intValue]];
            NSString  *da = [NSDate timeInfoWithDate:comfromTimesp];
            cell.lblTime.text =model.userInfo.username;
            NSURL  *logourl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kUrlAvatar, model.userInfo.logo]];
            [cell.ivAvatar sd_setImageWithURL:logourl placeholderImage:[UIImage imageNamed:@"user_normal.png"]];
            cell.titleLab.font = [UIFont fontWithName:kFontDouble size:12];
             cell.titleLab.text=[NSString stringWithFormat:@"%@%@",da,[Function getSharePlatformwithSting:model.method]];
        }
        else {
            
            weiboInfoModel  *model=[_dataArray objectAtIndex:indexPath.row];
            cell.imageView.backgroundColor=VStageView_color;
            NSURL  *url =[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",kUrlStage,model.stageInfo.photo,KIMAGE_SMALL]];
            
            [cell.imageView sd_setImageWithURL:url placeholderImage:nil options:(SDWebImageRetryFailed|SDWebImageLowPriority)];
            cell.titleLab.text=[NSString stringWithFormat:@"%@",model.content];
            if (self.pageType==NSNewAddPageSoureTypeTiming) {
                //定时出来的,显示具体的时间
                NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[model.updated_at intValue]];
                NSLog(@"1296035591  = %@",confromTimesp);
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
                [formatter setDateStyle:NSDateFormatterMediumStyle];
                [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT+0800"]];
                [formatter setTimeStyle:NSDateFormatterShortStyle];
                [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
                NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
                cell.lblTime.frame=CGRectMake(10, 10, 160, 20);
                cell.lblTime.font =[UIFont fontWithName:kFontRegular size:10];
                cell.lblTime.text = [NSString stringWithFormat:@"定时时间：%@",confromTimespStr];
            }
        }
        return cell;
        
    }
    return cell;
}
//点击小图模式的时候，跳转到大图模式
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    //    ShowStageViewController *vc = [[ShowStageViewController alloc] init];
    //    weiboInfoModel *model=[_dataArray objectAtIndex:indexPath.row];
    //    //vc.upweiboArray=_upWeiboArray;
    //    if(self.pageType==NSNewAddPageSoureTypeNewList)
    //    {
    //        //最新添加
    //        vc.pageType=NSStagePapeTypeAdmin_New_Add;
    //    }
    //    else if (self.pageType==NSNewAddPageSoureTypeCloseWeiboList)
    //    {
    //        //微博屏蔽
    //        vc.pageType=NSStagePapeTypeAdmin_Close_Weibo;
    //    }
    //    else if (self.pageType==NSNewAddPageSoureTypeDecorver)
    //    {
    //        vc.pageType=NSStagePapeTypeAdmin_Dscorver;
    //    }
    //    else if (self.pageType==NSNewAddPageSoureTypeRecommed)
    //    {
    //        vc.pageType=NSStagePapeTypeAdmin_Recommed;
    //    }
    //    else if (self.pageType==NSNewAddPageSoureTypeTiming)
    //    {
    //        vc.pageType=NSStagePapeTypeAdmin_Timing;
    //    }
    //    else if (self.pageType==NSNewAddPageSoureTypeNotReview)
    //    {
    //        vc.pageType=NSStagePapeTypeAdmin_Not_Review;
    //    }
    //
    //    vc.stageInfo = model.stageInfo;
    //    vc.weiboInfo=model;
    //    UIBarButtonItem  *item =[[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    //    self.navigationItem.backBarButtonItem=item;
    //    [self.navigationController pushViewController:vc animated:YES];
    if (self.pageType ==NSNewAddPageSoureTypeShare) {
        ShowStageViewController *vc = [[ShowStageViewController alloc] init];
        ShareModel *model =[self.dataArray objectAtIndex:indexPath.row];
        vc.upweiboArray=_upWeiboArray;
        vc.stageInfo =model.weiboInfo.stageInfo;
        vc.weiboInfo = model.weiboInfo;
        UIBarButtonItem  *item =[[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        self.navigationItem.backBarButtonItem=item;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
     StageViewController  *stageVC =[[StageViewController alloc]init];
    stageVC.upWeiboArray= self.upWeiboArray;
    stageVC.WeiboDataArray = self.dataArray;
    stageVC.pageType = NSStagePapeTypeAdminOperation;
    stageVC.indexOfItem = indexPath.row;
    [self.navigationController pushViewController:stageVC animated:YES];
    }
}


//设置头尾部内容
/*-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
 {
 UICollectionReusableView *reusableView = nil;
 
 if (kind == UICollectionElementKindSectionHeader) {
 //定制头部视图的内容
 MovieHeadView *headerV = (MovieHeadView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView" forIndexPath:indexPath];
 headerV.delegate=self;
 headerV.movieInfo=moviedetailmodel;
 [headerV setCollectionHeaderValue];
 reusableView = headerV;
 }
 return reusableView;
 }*/
#pragma  mark ----
#pragma  mark -----UICollectionViewLayoutDelegate
#pragma  mark ----

// 设置每个item的尺寸
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    // return CGSizeMake((kDeviceWidth-5)/2,(kDeviceWidth-10)/3);
    double  w = (kDeviceWidth-5)/2;
    double  h= w*(9.0/16);
    return CGSizeMake(w,h);
    
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0,0, 5,0);
}
//左右间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
//上下
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
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
