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
#import "CommonStageCell.h"
@interface MovieDetailViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,MovieHeadViewDelegate>
{
    UICollectionView    *_myConllectionView;
    UICollectionViewFlowLayout    *layout;
    LoadingView         *loadView;
    NSMutableArray      *_dataArray;
    BOOL bigModel;
}

@end

@implementation MovieDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNavigation];
    [self initData];
    [self initUI];
    [self creatLoadView];
    [self requestData];

}
-(void)createNavigation
{
    UILabel  *titleLable=[ZCControl createLabelWithFrame:CGRectMake(0, 0, 100, 20) Font:16 Text:@"电影详细"];
    titleLable.textColor=VBlue_color;
    
    titleLable.font=[UIFont boldSystemFontOfSize:16];
    titleLable.textAlignment=NSTextAlignmentCenter;
    self.navigationItem.titleView=titleLable;

    
}
-(void)initData
{
    bigModel=YES;
    _dataArray =[[NSMutableArray alloc]init];
    
}
-(void)initUI
{
 
    layout=[[UICollectionViewFlowLayout alloc]init];
    //layout.minimumInteritemSpacing=10; //cell之间左右的
   // layout.minimumLineSpacing=10;      //cell上下间隔
    //layout.itemSize=CGSizeMake(80,140);  //cell的大小
    if(bigModel==YES)
    {
        layout.sectionInset=UIEdgeInsetsMake(10, 0, 10, 0);
    }
    else{
    layout.sectionInset=UIEdgeInsetsMake(10,10, 10, 10); //整个偏移量 上左下右
    }
    [layout setHeaderReferenceSize:CGSizeMake(_myConllectionView.frame.size.width, kDeviceHeight/3)];
    
    _myConllectionView =[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0,kDeviceWidth, kDeviceHeight) collectionViewLayout:layout];
    _myConllectionView.backgroundColor=View_BackGround;
    //注册大图模式
    [_myConllectionView registerClass:[BigImageCollectionViewCell class] forCellWithReuseIdentifier:@"bigcell"];
    
    //注册小图模式
    [_myConllectionView registerClass:[SmallImageCollectionViewCell class] forCellWithReuseIdentifier:@"smallcell"];
    // 注册头部视图
    [_myConllectionView registerClass:[MovieHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView"];
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
#warning  这里需要写参数
    
    NSDictionary *parameter = @{@"movie_id": @"859357", @"start_id":@"0", @"user_id": @"18"};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/movieStage/list", kApiBaseUrl] parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"  电影详情页面数据JSON: %@", responseObject);
        [loadView stopAnimation];
        [loadView removeFromSuperview];
        
        if (_dataArray==nil) {
            _dataArray=[[NSMutableArray alloc]init];
        }
        [_dataArray addObjectsFromArray:[responseObject objectForKey:@"detail"]];
        NSLog(@"=-=======dataArray 电影详细页面的数组 是=====%@",_dataArray);
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
        return _dataArray.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //在这里先将内容给清除一下, 然后再加载新的, 添加完内容之后先动画, 在cell消失的时候做清理工作
    NSDictionary *dict = [_dataArray objectAtIndex:(indexPath.row)];
    if (bigModel ==YES) {
        BigImageCollectionViewCell *cell = (BigImageCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"bigcell" forIndexPath:indexPath];
    if (_dataArray.count>indexPath.row) {
       //cell.pageType=NSPageSourceTypeMyAddedViewController;
      //  小闪动标签的数组
        //cell.WeibosArray=[[_dataArray objectAtIndex:indexPath.row]  objectForKey:@"weibos"];
        //[cell setCellValue:[[_dataArray objectAtIndex:indexPath.row]  objectForKey:@"stageinfo"] indexPath:indexPath.row];
        }
        cell.backgroundColor = [UIColor redColor];
        return cell;
    } else {
        SmallImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"smallcell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor blackColor];
        return cell;
    }
    
    return nil;
}

//设置头尾部内容
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        //定制头部视图的内容
        MovieHeadView *headerV = (MovieHeadView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView" forIndexPath:indexPath];
        headerV.delegate=self;
        headerV.backgroundColor = [UIColor yellowColor];
        //headerV.titleLab.text = @"头部视图";
        reusableView = headerV;
    }
    return reusableView;
}

// 设置每个item的尺寸
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (bigModel==YES) {
      
        float hight;
        if (_dataArray.count>indexPath.row) {
            float  h=   [[[[_dataArray  objectAtIndex:indexPath.row]  objectForKey:@"stageinfo"] objectForKey:@"h"] floatValue];
            float w=   [[[[_dataArray  objectAtIndex:indexPath.row]  objectForKey:@"stageinfo"] objectForKey:@"w"] floatValue];
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
        return CGSizeMake(kDeviceHeight,hight+10);
    }
    else
    {
        return CGSizeMake(( kDeviceWidth-20-10)/3,(kDeviceWidth-20-10)/3);

    }
    return CGSizeMake(0, 0);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (bigModel==NO) {
        return UIEdgeInsetsMake(10, 10, 10, 10);
    }
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
//左右间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    if (bigModel==YES) {
        return 0;
    }
    return 5;
}
//上下
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if (bigModel==YES) {
        return 10;
    }
    return 5;

}

// 设置头部视图的尺寸
/*-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (collectionView==_myConllectionView) {
      //  if (section==0) {
        return CGSizeMake(kDeviceWidth,kDeviceWidth/3);
        //}
    }
    return CGSizeMake(0, 0);
}*/
#pragma  mark
#pragma  mark   -----MovieHeaderViewDelegate
#pragma  mark   ---
-(void)ChangeCollectionModel:(NSInteger )index
{
    if (index==1000) {
        //点击了大图模式
        NSLog(@"/点击了大图模式");
        bigModel=YES;
        [_myConllectionView reloadData];
    }
    else if (index==1001)
    {
        //点击了小图模式
        
        NSLog(@"/点击了小图模式");
        bigModel=NO;
        [_myConllectionView reloadData];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
