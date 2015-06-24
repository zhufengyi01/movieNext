//
//  StageListViewController.m
//  movienext
//
//  Created by 朱封毅 on 24/06/15.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "StageListViewController.h"
//导入网络处理引擎框架
#import "AFNetworking.h"
//导入图片处理引擎框架
#import "UIImageView+WebCache.h"
//导入常量
#import "Constant.h"
//导入App delegate
#import "AppDelegate.h"
#import "NotificationTableViewCell.h"
//导入功能类
#import "Function.h"
#import "LoadingView.h"
#import "UserDataCenter.h"
#import "ZCControl.h"
#import "MJRefresh.h"
#import "MovieSearchViewController.h"
#import "MovieCollectionViewCell.h"
#import "MovieDetailViewController.h"
#import "MJRefresh.h"
#import "UIButton+Block.h"
#import "UIImage-Helpers.h"
#import "AdmListViewController.h"
#import "SmallImageCollectionViewCell.h"
#import "ShowStageViewController.h"
#import "NSDate+Extension.h"
#import "UpweiboModel.h"
#import "ShowSelectPhotoViewController.h"
#import "StageViewController.h"
@interface StageListViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,LoadingViewDelegate,UIAlertViewDelegate>
{
    UICollectionViewFlowLayout    *layout;
    int pageSize;
    int page;
    int pageCount;
    LoadingView         *loadView;
    UserDataCenter     *userCenter;
    UIButton  *upLoadimageBtn;
}
@property(nonatomic,strong)NSMutableArray *upWeiboArray;
@end

@implementation StageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNavigation];
    [self initData];
    [self initUI];
}
-(void)createNavigation
{
    UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth-120, 40)];
    //电影图片
    UIImageView *    MovieLogoImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0,5,30, 30)];
    MovieLogoImageView.layer.cornerRadius=4;
    MovieLogoImageView.contentMode=UIViewContentModeScaleAspectFill;
    MovieLogoImageView.clipsToBounds=YES;
   // MovieLogoImageView.image =[UIImage imageNamed:@"Moments.png"];
    MovieLogoImageView.layer.masksToBounds = YES;
    [titleView addSubview:MovieLogoImageView];
    //电影名
    UILabel  *movieNameLable =[[UILabel alloc]initWithFrame:CGRectMake(35,0, 120, 30)];
    movieNameLable.font=[UIFont fontWithName:kFontDouble size:16];
    movieNameLable.textColor=VGray_color;
    // movieNameLable.numberOfLines=1;
    movieNameLable.lineBreakMode=NSLineBreakByTruncatingTail;
    [titleView addSubview:movieNameLable];
    NSString  *logoString;
    logoString =[NSString stringWithFormat:@"%@%@!poster",kUrlFeed,self.movielogo];
    [MovieLogoImageView sd_setImageWithURL:[NSURL URLWithString:logoString] placeholderImage:[UIImage imageNamed:@"Moments.png"]];
    NSString  *nameStr=self.moviename;
     nameStr =[Function htmlString:nameStr];
    float nameW=kDeviceWidth*0.6;
    CGSize   Nsize =[nameStr boundingRectWithSize:CGSizeMake(nameW, 25) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:[NSDictionary dictionaryWithObject:movieNameLable.font forKey:NSFontAttributeName] context:nil].size;
    movieNameLable.text=[NSString stringWithFormat:@"%@",nameStr];
    movieNameLable.frame=CGRectMake(35,8,Nsize.width+5, 25);
    titleView.frame=CGRectMake(0, 0, 30+5+movieNameLable.frame.size.width, 40);
    self.navigationItem.titleView=titleView;
    [self.navigationItem.titleView setContentMode:UIViewContentModeCenter];
    
    upLoadimageBtn=[ZCControl createButtonWithFrame:CGRectMake(0,0,50,25) ImageName:nil Target:self Action:@selector(uploadImageFromAbumdAndDouban) Title:@"添加"];
    upLoadimageBtn.tag=201;
    [upLoadimageBtn.titleLabel setFont:[UIFont fontWithName:kFontRegular size:16]];
    //upLoadimageBtn.backgroundColor = [UIColor redColor];
    [upLoadimageBtn setTitleColor:VGray_color forState:UIControlStateNormal];
    upLoadimageBtn.titleEdgeInsets =UIEdgeInsetsMake(0, 15, 0, -15);
    // upLoadimageBtn.imageEdgeInsets= UIEdgeInsetsMake(5, 20, 0, -20);
    //    [upLoadimageBtn setImage:[UIImage imageNamed:@"up_picture_blue.png"] forState:UIControlStateNormal];
    UIBarButtonItem  *rigthbar =[[UIBarButtonItem alloc]initWithCustomView:upLoadimageBtn];
    self.navigationItem.rightBarButtonItem=rigthbar;
}
-(void)uploadImageFromAbumdAndDouban
{
    [self requestMovieInfoData];
    
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
    //注册小图模式
    [_myConllectionView registerClass:[SmallImageCollectionViewCell class] forCellWithReuseIdentifier:@"smallcell"];
    // 注册头部视图
    //[_myConllectionView registerClass:[MovieHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView"];
    _myConllectionView.delegate=self;
    _myConllectionView.dataSource=self;
    
    [self.view addSubview:_myConllectionView];
    [self setUprefresh];
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
        //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //[weakSelf.myConllectionView reloadData];
            
            // 结束刷新
            [weakSelf.myConllectionView.header endRefreshing];
       // });
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
        //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //  [weakSelf.myConllectionView reloadData];
            // 结束刷新
            //[weakSelf.myConllectionView.footer endRefreshing];
       // });
    }];
    // 默认先隐藏footer
    // self.myConllectionView.footer.hidden = YES;
}
-(void)requestMovieInfoData
{
    if (!_movie_id || _movie_id<=0) {
        return;
    }
    NSDictionary *parameter = @{@"movie_id": self.movie_id};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/movie/info", kApiBaseUrl] parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //  NSLog(@"  电影详情页面的电影信息数据JSON: %@", responseObject);
        if ([[responseObject  objectForKey:@"code"]  intValue]==0) {
            NSDictionary  *dict =[responseObject objectForKey:@"model"];
            
            ShowSelectPhotoViewController  *vc =[[ShowSelectPhotoViewController alloc]init];
            vc.douban_id=[dict objectForKey:@"douban_id"];
            vc.movie_id=self.movie_id;
            vc.movie_name=self.moviename;
            UIBarButtonItem  *item =[[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
            self.navigationItem.backBarButtonItem=item;
            // UINavigationController  *na =[[UINavigationController alloc]initWithRootViewController:vc];
            ///[self presentViewController:na animated:YES completion:nil];
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
    }];
}

-(void)requestData
{
    
    NSDictionary *parameters;
    NSString  *urlString =[NSString stringWithFormat:@"%@/weibo/list?per-page=%d&page=%d", kApiBaseUrl,pageSize,page];
    NSString *tokenString =[Function getURLtokenWithURLString:urlString];
    parameters =@{@"movie_id":self.movie_id,@"user_id":userCenter.user_id,KURLTOKEN:tokenString};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject  objectForKey:@"code"]  intValue]==0) {
            pageCount=[[responseObject objectForKey:@"pageCount"] intValue];
            NSMutableArray   *array  = [[NSMutableArray alloc]initWithArray:[responseObject objectForKey:@"models"]];
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
            [self.myConllectionView reloadData];
            [self.myConllectionView.footer endRefreshing];

            }
     
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}
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
    weiboInfoModel *model =[self.dataArray objectAtIndex:indexPath.row];
    if (_dataArray.count>indexPath.row) {
        cell.backgroundColor =[UIColor redColor];
        NSURL  *url =[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",kUrlStage,model.stageInfo.photo,KIMAGE_SMALL]];
        [cell.imageView sd_setImageWithURL:url placeholderImage:nil options:(SDWebImageRetryFailed|SDWebImageLowPriority)];
        cell.ivLike.image = [UIImage imageNamed:@"tiny_like"];
        cell.lblLikeCount.adjustsFontSizeToFitWidth=YES;
        cell.lblLikeCount.text = [NSString stringWithFormat:@"%d", [model.like_count intValue]];
        cell.titleLab.text=[NSString stringWithFormat:@"%@",model.content];
        
    }
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    StageViewController  *stageVC =[[StageViewController alloc]init];
    stageVC.upWeiboArray= self.upWeiboArray;
    stageVC.WeiboDataArray = self.dataArray;
    stageVC.pageType = NSStagePapeTypeDefult;
    stageVC.indexOfItem = indexPath.row;
    [self.navigationController pushViewController:stageVC animated:YES];

}


#pragma mark -collectionviewlayout

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
