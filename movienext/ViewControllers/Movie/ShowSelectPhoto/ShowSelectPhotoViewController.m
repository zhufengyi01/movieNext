//
//  ShowSelectPhotoViewController.m
//  movienext
//
//  Created by 风之翼 on 15/5/7.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "ShowSelectPhotoViewController.h"
#import "ZCControl.h"
#import "AFNetworking.h"
#import "Constant.h"
#import "UserDataCenter.h"
#import "MJRefresh.h"
#import "Function.h"
#import "DoubanService.h"
#import "UIImageView+WebCache.h"
#import "DoubanUpImageViewController.h"
#import "SmallImageCollectionViewCell.h"
@interface ShowSelectPhotoViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate>
{
    UISegmentedControl *segment;
    int  page;
    UICollectionViewFlowLayout    *layout;

}
@property(nonatomic,strong) NSMutableArray  *dataArray1;
@property(nonatomic,strong) NSMutableArray  *dataArray2;
@property(nonatomic,strong) UICollectionView  *myConllectionView;

@end

@implementation ShowSelectPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatNavigation];
    [self initData];
    [self initUI];
    [self requestData];
    

}
#pragma  mark  -------CreatUI;
-(void)creatNavigation
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"tabbar_backgroud_color.png"] forBarMetrics:UIBarMetricsDefault];
    NSArray *segmentedArray = [[NSArray alloc] initWithObjects:@"剧照", @"截图", nil];
    segment = [[UISegmentedControl alloc] initWithItems:segmentedArray];
    segment.frame = CGRectMake(kDeviceWidth/4, 0, kDeviceWidth/2, 28);
    segment.selectedSegmentIndex = 0;
    segment.backgroundColor = [UIColor clearColor];
    segment.tintColor = kAppTintColor;
    
    NSDictionary* selectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:14]
                                             };
    [segment setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];
    NSDictionary* unselectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:14]
                                               };
    [segment setTitleTextAttributes:unselectedTextAttributes forState:UIControlStateNormal];
    
    [segment addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventValueChanged];
    [self.navigationItem setTitleView:segment];
    
 }
-(void)segmentClick:(UISegmentedControl *)seg
{
    if(seg.selectedSegmentIndex==0)
    {
        if (self.dataArray1.count==0) {
            [self requestData];
        }
        else
        {
            [self.myConllectionView reloadData];

        }
        
    }
    else if(seg.selectedSegmentIndex==1)
    {
        if (self.dataArray2.count==0) {
            [self requestData];
        }
        else {
            
        [self.myConllectionView reloadData];
        }
    }
    
}

-(void)initData
{
    self.dataArray1 =[[NSMutableArray alloc]init];
    self.dataArray2 =[[NSMutableArray alloc]init];
    
}
-(void)initUI
{
    layout=[[UICollectionViewFlowLayout alloc]init];

    layout=[[UICollectionViewFlowLayout alloc]init];
    //layout.minimumInteritemSpacing=10; //cell之间左右的
    //layout.minimumLineSpacing=10;      //cell上下间隔
    //layout.itemSize=CGSizeMake(80,140);  //cell的大小
    
        layout.sectionInset=UIEdgeInsetsMake(0,0,64, 0); //整个偏移量 上左下右
     _myConllectionView =[[UICollectionView alloc]initWithFrame:CGRectMake(0,0,kDeviceWidth, kDeviceHeight-20) collectionViewLayout:layout];
    //[layout setHeaderReferenceSize:CGSizeMake(_myConllectionView.frame.size.width, kDeviceHeight/3+64+110)];
    
    _myConllectionView.backgroundColor=View_BackGround;
         //注册小图模式
    [_myConllectionView registerClass:[SmallImageCollectionViewCell class] forCellWithReuseIdentifier:@"smallcell"];
    // 注册头部视图sdsdsdsd
    //[_myConllectionView registerClass:[MovieHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView"];
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
    [self.myConllectionView addHeaderWithCallback:^{
        page=1;
        if (self.dataArray1.count>0) {
            //[vc.dataArray removeAllObjects];
        }
        // 进入刷新状态就会回调这个Block
        [vc requestData];
        
        // 模拟延迟加载数据，因此2秒后才调用）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //[vc.myConllectionView reloadData];
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
        // 进入刷新状态就会回调这个Block
//        if (pageCount>page) {
//            page=page+1;
//            [vc requestData];
//        }
        // 模拟延迟加载数据，因此2秒后才调用）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //  [vc.myConllectionView reloadData];
            // 结束刷新
            [vc.myConllectionView footerEndRefreshing];
        });
    }];
}


-(void)requestData
{
    
     //   UserDataCenter *userCenter =[UserDataCenter shareInstance];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString *urlstr;
    if (segment.selectedSegmentIndex==0) {
        urlstr = [NSString stringWithFormat:@"http://movie.douban.com/subject/%@/photos?type=S&start=0&sortby=vote&size=a&subtype=o", self.douban_id];
    }
    else if (segment.selectedSegmentIndex==1)
    {
      urlstr = [NSString stringWithFormat:@"http://movie.douban.com/subject/%@/photos?type=S&start=0&sortby=vote&size=a&subtype=c", self.douban_id];
    }
    
    [request setURL:[NSURL URLWithString:urlstr]];
    [request setHTTPMethod:@"GET"];
    NSOperationQueue * queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        //NSLog(@"response start");
        if (connectionError) {
            //NSLog(@"httpresponse code error %@", connectionError);
        } else {
            NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
            NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            if (responseCode == 200) {
                responseString = [Function getNoNewLine:responseString];
                
                NSString * pattern = @"http:\\/\\/img\\d\\.douban\\.com\\/view\\/photo\\/thumb\\/public\\/p\\d+\\.(jpg|jpeg|png)";
                //NSLog(@"responseString = %@", responseString);
                 NSMutableArray *doubanInfos = [[DoubanService shareInstance] getDoubanInfosByResponse:responseString withpattern:pattern type:NServiceTypePhoto];
                if (segment.selectedSegmentIndex==0 ) {
                    if(self.dataArray1==nil)
                    {
                        self.dataArray1 =[[NSMutableArray alloc]init];
                    }
                    self.dataArray1=doubanInfos;

                }
               else if (segment.selectedSegmentIndex==1)
               {
                   if (self.dataArray2==nil) {
                       self.dataArray2=[[NSMutableArray alloc]init];
                   }
                   self.dataArray2=doubanInfos;

               }
        [self.myConllectionView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
            } else {
                NSLog(@"error");
            }
        }
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
    if (segment.selectedSegmentIndex==0) {
        return self.dataArray1.count;
    }
    else if(segment.selectedSegmentIndex==1)
    {
        return self.dataArray2.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SmallImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"smallcell" forIndexPath:indexPath];
    //在这里先将内容给清除一下, 然后再加载新的, 添加完内容之后先动画, 在cell消失的时候做清理工作
    
         //stageInfoModel  *model=[_dataArray objectAtIndex:indexPath.row];
        cell.imageView.backgroundColor=VStageView_color;
        NSURL  *urlString ;
         if (segment.selectedSegmentIndex==0) {
             
             
             urlString =[NSURL URLWithString:[self.dataArray1 objectAtIndex:indexPath.row]];
 
         }
        else if(segment.selectedSegmentIndex==1)
        {
            urlString =[NSURL URLWithString:[self.dataArray2 objectAtIndex:indexPath.row]];

        }

        [cell.imageView sd_setImageWithURL:urlString placeholderImage:nil];
         cell.titleLab.hidden = YES;
    
    
        return cell;
    
  
}
//点击小图模式的时候，跳转到大图模式
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
        DoubanUpImageViewController *vc = [[DoubanUpImageViewController alloc] init];
    SmallImageCollectionViewCell  *cell =(SmallImageCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    NSString  *urlString;
    if (segment.selectedSegmentIndex==0) {
        urlString =[self.dataArray1 objectAtIndex:indexPath.row];
        
    }
    else if(segment.selectedSegmentIndex==1)
    {
        urlString =[self.dataArray2 objectAtIndex:indexPath.row];
        
    }
//    [cell.imageView sd_setImageWithURL:urlString placeholderImage:nil];
    vc.upimage=cell.imageView.image;
    vc.movie_id=self.movie_id;
    
    vc.photourl=urlString;
    
    
//        NSMutableString  *backstr=[[NSMutableString alloc]initWithString:stagemodel.movieInfo.name];
//        NSString *str;
//        if(backstr.length>5)
//        {
//            str=[backstr substringToIndex:5];
//            str =[NSString stringWithFormat:@"%@...",str];
//        }
//        
//        UIBarButtonItem  *item =[[UIBarButtonItem alloc]initWithTitle:str style:UIBarButtonItemStylePlain target:nil action:nil];
//        self.navigationItem.backBarButtonItem=item;
//        
       [self.navigationController pushViewController:vc animated:YES];
//    }
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
  
        return CGSizeMake((kDeviceWidth-20)/3,(kDeviceWidth-10)/3);
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
