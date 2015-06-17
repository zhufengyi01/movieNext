//
//  TagToStageViewController.m
//  movienext
//
//  Created by 风之翼 on 15/4/27.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "TagToStageViewController.h"
#import "LoadingView.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "ZCControl.h"
#import "Constant.h"
#import "MJRefresh.h"
#import "TagModel.h"
#import "UserDataCenter.h"
#import "TapStageCollectionViewCell.h"
#import "ModelsModel.h"
#import "ShowStageViewController.h"
static const CGFloat MJDuration = 0.2;


@interface TagToStageViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate>
{
    LoadingView   *loadView;
    int page;
    int pageSize;
    int pageCount;
    
}
//私有的
@property(nonatomic,strong)UICollectionView  *myConllectionView;
@property(nonatomic,strong) NSMutableArray      *dataArray;


@end

@implementation TagToStageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNavigation];
    [self initData];
    [self initUI];
    [self requestData];
    
    
}
-(void)createNavigation
{
    
    UILabel  *titleLable=[ZCControl createLabelWithFrame:CGRectMake(0, 0, 100, 20) Font:16 Text:self.tagInfo.tagDetailInfo.title];
    titleLable.textColor=VGray_color;
    
    titleLable.font=[UIFont fontWithName:kFontDouble size:16];
    titleLable.textAlignment=NSTextAlignmentCenter;
    self.navigationItem.titleView=titleLable;
    
}
-(void)initData
{
    page=1;
    pageSize=20;
    self.dataArray=[[NSMutableArray alloc]init];
}
-(void)initUI
{
    UICollectionViewFlowLayout    *layout=[[UICollectionViewFlowLayout alloc]init];
    layout.minimumInteritemSpacing=0; //cell之间左右的
    layout.minimumLineSpacing=0;      //cell上下间隔
    //layout.itemSize=CGSizeMake(80,140);  //cell的大小
    layout.sectionInset=UIEdgeInsetsMake(10, 0, 0, 0); //整个偏移量 上左下右
    
    _myConllectionView =[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0,kDeviceWidth, kDeviceHeight-kHeightNavigation) collectionViewLayout:layout];
    _myConllectionView.backgroundColor=[UIColor whiteColor];
    [_myConllectionView registerClass:[TapStageCollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
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
            [weakSelf.myConllectionView reloadData];
            
            // 结束刷新
            [weakSelf.myConllectionView.footer endRefreshing];
        });
    }];
    // 默认先隐藏footer
    // self.myConllectionView.footer.hidden = YES;
}

-(void)requestData
{
    UserDataCenter *usercenter=[UserDataCenter shareInstance];
    NSDictionary *parameters = @{@"tag_id":self.tagInfo.tagDetailInfo.Id,@"user_id":usercenter.user_id};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *urlString =[NSString stringWithFormat:@"%@/tag-stage/list?per-page=%d&page=%d", kApiBaseUrl,pageSize,page];
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject  objectForKey:@"code"]  intValue]==0) {
            //NSLog(@"  responseObject  ===%@ ",responseObject)
            NSMutableArray  *detailArray =[responseObject objectForKey:@"models"];
            pageCount =[[responseObject objectForKey:@"pageCount"] intValue];
            if (detailArray.count>0) {
                for (NSDictionary  *modelDict in detailArray) {
                    ModelsModel  *model =[[ModelsModel alloc]init];
                    if (model) {
                        [model setValuesForKeysWithDictionary:modelDict];
                        stageInfoModel *stagemodel =[[stageInfoModel alloc]init];
                        if (stagemodel) {
                            if (![[modelDict objectForKey:@"stage"] isKindOfClass:[NSNull class]]) {
                                [stagemodel setValuesForKeysWithDictionary:[modelDict objectForKey:@"stage"]];
                                movieInfoModel *moviemodel=[[movieInfoModel alloc]init];
                                if (moviemodel) {
                                    [moviemodel setValuesForKeysWithDictionary:[[modelDict objectForKey:@"stage"] objectForKey:@"movie"]];
                                    stagemodel.movieInfo=moviemodel;
                                }
                                
                                NSMutableArray  *weiboarray =[[NSMutableArray alloc]init];
                                for (NSDictionary *weibodict in [[modelDict objectForKey:@"stage"] objectForKey:@"weibos"])
                                {
                                    weiboInfoModel *weibomodel =[[weiboInfoModel alloc]init];
                                    if (weibomodel) {
                                        [weibomodel setValuesForKeysWithDictionary:weibodict];
                                        NSMutableArray  *tagArray =[[NSMutableArray alloc]init];
                                        for (NSDictionary *tagDict in [weibodict objectForKey:@"tags"]) {
                                            TagModel *tagmodel =[[TagModel alloc]init];
                                            if (tagmodel) {
                                                [tagmodel setValuesForKeysWithDictionary:tagDict];
                                                TagDetailModel  *tagDetail =[[TagDetailModel alloc]init];
                                                if (tagDetail) {
                                                    [tagDetail setValuesForKeysWithDictionary:[tagDict objectForKey:@"tag"]];
                                                    tagmodel.tagDetailInfo=tagDetail;
                                                }
                                                [tagArray addObject:tagmodel];
                                            }
                                        }
                                        weibomodel.tagArray=tagArray;
                                        weiboUserInfoModel *usermoel =[[weiboUserInfoModel alloc]init];
                                        if (usermoel) {
                                            [usermoel setValuesForKeysWithDictionary:[weibodict objectForKey:@"user"]];
                                            weibomodel.uerInfo=usermoel;
                                        }
                                        [weiboarray addObject:weibomodel];
                                    }
                                }
                                stagemodel.weibosArray=weiboarray;
                                model.stageInfo=stagemodel;
                            }
                        }
                        
                        if(self.dataArray==nil)
                        {
                            self.dataArray=[[NSMutableArray alloc]init];
                        }
                        [self.dataArray addObject:model];
                    }
                }
                //  [self.myConllectionView reloadData];
                
            }
            ///数据为空
            else
            {
                
                
                
            }
            [self.myConllectionView reloadData];
            
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{

    return self.dataArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    TapStageCollectionViewCell   *cell=(TapStageCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.backgroundColor=[UIColor blackColor];
    if (self.dataArray.count > indexPath.row) {
        ModelsModel  *model =[self.dataArray objectAtIndex:indexPath.row];
        cell.imageView.backgroundColor=VStageView_color;
        NSURL  *photourl=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",kUrlStage,model.stageInfo.photo,KIMAGE_SMALL]];
        [cell.imageView sd_setImageWithURL:photourl placeholderImage:nil];
        if (model.stageInfo.weibosArray.count>0) {
            weiboInfoModel  *weiboinfo =[model.stageInfo.weibosArray objectAtIndex:0];
            cell.titleLab.text=[NSString stringWithFormat:@"%@",weiboinfo.content];
        }
        
    }
    return cell;
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    //    return CGSizeMake((kDeviceWidth-10)/3,(kDeviceWidth-10)/3);
    // return CGSizeMake((kDeviceWidth-5)/2,(kDeviceWidth-10)/3);
    double  w = (kDeviceWidth-5)/2;
    double  h= w*(9.0/16);
    return CGSizeMake(w,h);
    
    
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0,0,5,0);
}

//上下
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ShowStageViewController *vc = [[ShowStageViewController alloc] init];
    ModelsModel *model=[_dataArray objectAtIndex:indexPath.row];
    //vc.upweiboArray=_upWeiboArray;
    vc.stageInfo =model.stageInfo;
    [self.navigationController pushViewController:vc animated:YES];
    
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
