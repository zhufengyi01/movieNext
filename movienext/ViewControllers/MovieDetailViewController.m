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
#import "UMSocial.h"
#import "AddMarkViewController.h"

@interface MovieDetailViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,MovieHeadViewDelegate>
{
    UICollectionView    *_myConllectionView;
    UICollectionViewFlowLayout    *layout;
    LoadingView         *loadView;
    NSMutableArray      *_dataArray;
    NSMutableDictionary       *_MovieDict;
    BOOL bigModel;
}

@end

@implementation MovieDetailViewController
-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden=YES;
    self.navigationController.navigationBar.hidden=YES;
  
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNavigation];
    [self initData];
    [self initUI];
    [self creatLoadView];
    [self requestMovieInfoData];
    [self requestData];

}
-(void)createNavigation
{
   // UILabel  *titleLable=[ZCControl createLabelWithFrame:CGRectMake(0, 0, 100, 20) Font:16 Text:@"电影详细"];
    //titleLable.textColor=VBlue_color;
    
   // titleLable.font=[UIFont boldSystemFontOfSize:16];
    //titleLable.textAlignment=NSTextAlignmentCenter;
    //self.navigationItem.titleView=titleLable;
//    UIButton  *leftBtn= [UIButton buttonWithType:UIButtonTypeSystem];
//    leftBtn.frame=CGRectMake(0, 30, 60, 36);
//    [leftBtn setTitleColor:VGray_color forState:UIControlStateNormal];
//    [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
//    [leftBtn addTarget:self action:@selector(dealBackClick:) forControlEvents:UIControlEventTouchUpInside];
//    [leftBtn setImage:[UIImage imageNamed:@"Back Icon"] forState:UIControlStateNormal];
//    [self.view addSubview:leftBtn];

    

    
}
-(void)initData
{
    bigModel=YES;
    _MovieDict=[[NSMutableDictionary alloc]init];
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
    
    _myConllectionView =[[UICollectionView alloc]initWithFrame:CGRectMake(0, -20,kDeviceWidth, kDeviceHeight+20) collectionViewLayout:layout];
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

//根据电影id 请求电影的详细信息
-(void)requestMovieInfoData
{
    if (!_movieId || _movieId<=0) {
        return;
    }
    NSDictionary *parameter = @{@"id": _movieId};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/movie/info", kApiBaseUrl] parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"  电影详情页面的电影信息数据JSON: %@", responseObject);
        if (_MovieDict ==nil) {
            _MovieDict=[[NSMutableDictionary alloc]init];
        }
        _MovieDict =[NSMutableDictionary dictionaryWithDictionary:[responseObject  objectForKey:@"detail"]];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    

}

-(void)requestData
{
#warning  这里需要写参数
    
    //NSDictionary *parameter = @{@"movie_id": @"859357", @"start_id":@"0", @"user_id": @"18"};
    if (!_movieId || _movieId<=0) {
        return;
    }
    NSDictionary *parameter = @{@"movie_id": _movieId, @"start_id":@"0", @"user_id": @"18"};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/movieStage/list", kApiBaseUrl] parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
     ///   NSLog(@"  电影详情页面数据JSON: %@", responseObject);
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
    //在这里先将内容给清除一下, 然后再加载新的, 添加完内容之后先动画, 在cell消失的时候做清理工作
    NSDictionary *dict = [_dataArray objectAtIndex:(indexPath.row)];
    if (bigModel ==YES) {
        BigImageCollectionViewCell *cell = (BigImageCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"bigcell" forIndexPath:indexPath];
        if (_dataArray.count>indexPath.row) {
           //cell.pageType=NSPageSourceTypeMyAddedViewController;
          //  小闪动标签的数组
            cell.WeibosArray=[[_dataArray objectAtIndex:indexPath.row]  objectForKey:@"weibos"];
            [cell setCellValue:[[_dataArray objectAtIndex:indexPath.row]  objectForKey:@"stageinfo"] indexPath:indexPath.row];
        }
        [cell.StageView performSelector:@selector(startAnimation) withObject:nil afterDelay:1];
        cell.backgroundColor = [UIColor redColor];
        return cell;
    } else {
        SmallImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"smallcell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor redColor];
        
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@!w340h340",kUrlStage,[[dict  objectForKey:@"stageinfo"]  objectForKey:@"stage"]]] placeholderImage:[UIImage imageNamed:@"loading_image_all.png"]];
        if ([[dict objectForKey:@"stageinfo"] objectForKey:@"marks"]) {
            cell.titleLab.text=[NSString stringWithFormat:@"%@",  [[dict objectForKey:@"stageinfo"] objectForKey:@"marks"]];

        }
        
        return cell;
    }
    
    return nil;
}
//点击小图模式的时候，跳转到大图模式
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (bigModel==NO&&collectionView==_myConllectionView) {
     
    }
}


//设置头尾部内容
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        //定制头部视图的内容
        MovieHeadView *headerV = (MovieHeadView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView" forIndexPath:indexPath];
        headerV.delegate=self;
        ///headerV.backgroundColor =View_BackGround;// [UIColor yellowColor];
        if (_MovieDict) {
        [headerV setCollectionHeaderValue:_MovieDict];
        }
        
        //headerV.titleLab.text = @"头部视图";
        reusableView = headerV;
    }
    return reusableView;
}
#pragma  mark ----
#pragma  mark -----UICollectionViewLayoutDelegate
#pragma  mark ----

// 设置每个item的尺寸
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (bigModel==YES) {
      
        float hight;
        if (_dataArray.count>indexPath.row) {
            float  h=   [[[[_dataArray  objectAtIndex:indexPath.row]  objectForKey:@"stageinfo"] objectForKey:@"h"] floatValue];
            float w=   [[[[_dataArray  objectAtIndex:indexPath.row]  objectForKey:@"stageinfo"] objectForKey:@"w"] floatValue];
            if (w==0||h==0) {
                hight= kDeviceWidth+45;
            }
            if (w>h) {
                hight= kDeviceWidth+45;
            }
            else if(h>w)
            {
                hight=  (h/w) *kDeviceWidth+45;
            }
        }
        NSLog(@"============  hight  for  row  =====%f",hight);
        return CGSizeMake(kDeviceWidth,hight);
    }
    else
    {
        return CGSizeMake(( kDeviceWidth-20)/3,(kDeviceWidth-20-10)/3);

    }
    return CGSizeMake(0, 0);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (bigModel==NO) {
        return UIEdgeInsetsMake(5, 5, 5, 5);
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
//collectionview 即将显示collectionview
-(void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    //结束显示cell
    if (bigModel==YES) {
        UICollectionViewCell * stageCell = cell;
        if ( [stageCell isKindOfClass:[BigImageCollectionViewCell class]] ) {
            BigImageCollectionViewCell *bigcell = (BigImageCollectionViewCell *)stageCell;
            if ( [bigcell.StageView respondsToSelector:@selector(stopAnimation)] ) {
                [bigcell.StageView stopAnimation];
            }
        }
    }
    
    
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (bigModel ==YES) {
        
    }
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
-(void)ChangeCollectionModel:(UIButton *  )button
{
    if (button.tag==1000)
    {        //点击了大图模模式
        NSLog(@"/点击了大图模式");
        bigModel=YES;

          if (button.selected==NO)
        {
            button.selected=YES;
            [_myConllectionView reloadData];
        }
     
        UIButton *btn2=(UIButton *)[button.superview viewWithTag:1001];
        btn2.selected=NO;

    }
    else if (button.tag==1001)///&&button.selected==YES)
    {
        //点击了小图模式
         bigModel=NO;
        NSLog(@"/点击了小图模式");
          if (button.selected==NO)
        {
            button.selected=YES;
            [_myConllectionView reloadData];
        }
     
        UIButton *btn1=(UIButton *)[button.superview viewWithTag:1000];
        btn1.selected=NO;
        
    }
}

-(void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

//分享
-(void)ScreenButtonClick:(UIButton  *) button
{
    NSLog(@" ==ScreenButtonClick  ====%d",button.tag);
    CommonStageCell *cell = (CommonStageCell *)(button.superview.superview);
    
    UIGraphicsBeginImageContextWithOptions(_myConllectionView.bounds.size, YES, [UIScreen mainScreen].scale);
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
    NSLog(@" ==addMarkButtonClick  ====%d",button.tag);
    AddMarkViewController  *AddMarkVC=[[AddMarkViewController alloc]init];
    //CommonStageCell *cell = (CommonStageCell *)button.superview.superview.superview;
    NSDictionary *dict = [_dataArray objectAtIndex:button.tag-3000];
    AddMarkVC.stageDict = [dict valueForKey:@"stageinfo"];
    //NSLog(@"dict = %@", dict);
    NSLog(@"dict.stageinfo = %@", [dict valueForKey:@"stageinfo"]);
    [self.navigationController pushViewController:AddMarkVC animated:NO];
    //[self presentViewController:AddMarkVC animated:NO completion:nil]
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
