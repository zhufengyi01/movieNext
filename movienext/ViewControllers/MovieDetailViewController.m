//
//  MovieDetailViewController.m
//  movienext
//
//  Created by 风之翼 on 15/3/6.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "MovieDetailViewController.h"
//导入网络处理引擎框架
#import "AFNetworking.h"
//导入图片处理引擎框架
#import "UIImageView+WebCache.h"
//导入常量
#import "Constant.h"
//导入App delegate
#import "AppDelegate.h"
//导入功能类
#import "Function.h"
#import "LoadingView.h"
#import "UserDataCenter.h"
#import "ZCControl.h"
#import "MJRefresh.h"
#import "BigImageCollectionViewCell.h"
#import "SmallImageCollectionViewCell.h"
#import "MovieHeadView.h"
@interface MovieDetailViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate>
{
    UICollectionView    *_myConllectionView;
    UICollectionViewFlowLayout    *layout;
    LoadingView         *loadView;
    NSMutableArray      *_dataArray;

    
}

@end

@implementation MovieDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNavigation];
    [self initData];
    [self initUI];
   // [self creatLoadView];
    [self requestData];

}
-(void)createNavigation
{
    self.navigationController.navigationItem.title=@"电影";
}
-(void)initData
{
    _dataArray =[[NSMutableArray alloc]init];
    
}
-(void)initUI
{
 
    layout=[[UICollectionViewFlowLayout alloc]init];
    layout.minimumInteritemSpacing=10; //cell之间左右的
    layout.minimumLineSpacing=10;      //cell上下间隔
    //layout.itemSize=CGSizeMake(80,140);  //cell的大小
    layout.sectionInset=UIEdgeInsetsMake(20, 10, 10, 10); //整个偏移量 上左下右
    
    _myConllectionView =[[UICollectionView alloc]initWithFrame:CGRectMake(0, 30,kDeviceWidth, kDeviceHeight-30-kHeightNavigation-kHeigthTabBar) collectionViewLayout:layout];
    _myConllectionView.backgroundColor=View_BackGround;
    //注册大图模式
    [_myConllectionView registerClass:[BigImageCollectionViewCell class] forCellWithReuseIdentifier:@"bigcell"];
    //注册小图模式
    [_myConllectionView registerClass:[SmallImageCollectionViewCell class] forCellWithReuseIdentifier:@"smallcell"];
    // 注册头部视图
    //[_myConllectionView registerClass:[MovieHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView"];
    _myConllectionView.delegate=self;
    _myConllectionView.dataSource=self;
    
    [self.view addSubview:_myConllectionView];
    
    
}
-(void)creatLoadView
{
    loadView =[[LoadingView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    [self.view addSubview:loadView];
    
}

#pragma  mark  ----RequestData
#pragma  mark  ---
-(void)requestData
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/feed/list", kApiBaseUrl] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"  电影首页数据JSON: %@", responseObject);
        [loadView stopAnimation];
        [loadView removeFromSuperview];
        
        if (_dataArray==nil) {
            _dataArray=[[NSMutableArray alloc]init];
        }
        [_dataArray addObjectsFromArray:[responseObject objectForKey:@"detail"]];
        NSLog(@"=-=======dataArray =====%@",_dataArray);
        [_myConllectionView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

#pragma mark - UICollectionViewDataSource

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
        //return _dataArray.count;
    
    }
    return 0;
}

/*- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

   
    
}*/

/*-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
      MovieHeadView    *headerView;
    if (collectionView ==_myConllectionView) {
       
    if (kind == UICollectionElementKindSectionHeader){
        
        if ([kind isEqual:UICollectionElementKindSectionHeader]) {
            if (indexPath.section==0) {
            
            headerView  =(MovieHeadView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView" forIndexPath:indexPath];
            }

        }
    }
    }
    return headerView;

}*/
// 设置每个item的尺寸
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    int width = ((kDeviceWidth-4*12)/3);
    int movieNameMarginTop = 10;
    int movieNameHeight = 20;
    return CGSizeMake( width, width*1.5 + movieNameMarginTop + movieNameHeight);
     
   
    
}
// 设置头部视图的尺寸
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (collectionView==_myConllectionView) {
        if (section==0) {
        return CGSizeMake(kDeviceWidth,kDeviceWidth/3);
        }
    }
    return CGSizeMake(0, 0);
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
