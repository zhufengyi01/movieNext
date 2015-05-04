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
    titleLable.textColor=VBlue_color;
    
    titleLable.font=[UIFont boldSystemFontOfSize:16];
    titleLable.textAlignment=NSTextAlignmentCenter;
    self.navigationItem.titleView=titleLable;
    
}
-(void)initData
{
    page=1;
    pageSize=15;
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
    [self setupHeadView];
    [self setupFootView];


}
- (void)setupHeadView
{
    
    __unsafe_unretained typeof(self) vc = self;
    // 添加下拉刷新头部控件
    [_myConllectionView addHeaderWithCallback:^{
        page=1;
        if (self.dataArray.count>0) {
            [vc.dataArray removeAllObjects];
        }
        // 进入刷新状态就会回调这个Block
        [vc requestData];
        
        // 模拟延迟加载数据，因此2秒后才调用）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [vc.myConllectionView reloadData];
            // 结束刷新
            [vc.myConllectionView headerEndRefreshing];
        });
    }];
    
#warning 自动刷新(一进入程序就下拉刷新)
   // [vc.myConllectionView headerBeginRefreshing];
}

- (void)setupFootView
{
    
    
    __unsafe_unretained typeof(self) vc = self;
    // 添加上拉刷新尾部控件
    [vc.myConllectionView addFooterWithCallback:^{
        if (pageCount>page) {
            page ++;
            [vc requestData];
            
        }
        
        // 进入刷新状态就会回调这个Block
        //page++;
        
        // 增加5条假数据
        ///  for (int i = 0; i<5; i++) {
        //   [vc.fakeColors addObject:MJRandomColor];
        //}
        
        // 模拟延迟加载数据，因此2秒后才调用）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [vc.myConllectionView reloadData];
            // 结束刷新
            [vc.myConllectionView footerEndRefreshing];
        });
        
    }];
    
}

-(void)requestData
{
    UserDataCenter *usercenter=[UserDataCenter shareInstance];
    NSDictionary *parameters = @{@"tag_id":self.tagInfo.tagDetailInfo.Id,@"user_id":usercenter.user_id};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *urlString =[NSString stringWithFormat:@"%@/tag-stage/list?per-page=%d&page=%d", kApiBaseUrl,pageSize,page];
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject  objectForKey:@"code"]  intValue]==0) {
            
            //NSLog(@"  responseObject  ===%@ ",responseObject);
            
            NSMutableArray  *detailArray =[responseObject objectForKey:@"models"];

            if (detailArray.count>0) {
                
                for (NSDictionary  *modelDict in detailArray) {
                  ModelsModel  *model =[[ModelsModel alloc]init];
                    if (model) {
                        [model setValuesForKeysWithDictionary:modelDict];
                        stageInfoModel *stagemodel =[[stageInfoModel alloc]init];
                        if (stagemodel) {
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
    //return 12;
    
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    TapStageCollectionViewCell   *cell=(TapStageCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.backgroundColor=[UIColor blackColor];
      if (self.dataArray.count > indexPath.row) {
        ModelsModel  *model =[self.dataArray objectAtIndex:indexPath.row];
          cell.imageView.backgroundColor=VStageView_color;
          NSURL  *photourl=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@!w340h340",kUrlStage,model.stageInfo.photo]];
         [cell.imageView sd_setImageWithURL:photourl placeholderImage:nil];
          
          if(model.stageInfo.movieInfo.name.length==0)
          {
              cell.titleLab.hidden=YES;
          }
          cell.titleLab.text=[NSString stringWithFormat:@"%@",model.stageInfo.movieInfo.name];
          
    }
    return cell;
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
         return CGSizeMake((kDeviceWidth-10)/3,(kDeviceWidth-10)/3);
    
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
