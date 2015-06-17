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
#import "UploadImageViewController.h"
#import "LoadingView.h"
#import "UIButton+Block.h"
static const CGFloat MJDuration = 0.6;


@interface ShowSelectPhotoViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,LoadingViewDelegate>
{
    LoadingView         *loadView;
    UISegmentedControl *segment;
    int  page1;
    int  page2;
    UICollectionViewFlowLayout    *layout;
    UIButton * upLoadimageBtn;
    
    UserDataCenter  *userCenter;
    
    
}
@property(nonatomic,strong) NSMutableArray  *dataArray1;
@property(nonatomic,strong) NSMutableArray  *dataArray2;
@property(nonatomic,strong) UICollectionView  *myConllectionView;
//@property(nonatomic,strong) NSString  *IS_CHECK;  //是否是审核版 1  代表是审核版   0代表是正式版

@end

@implementation ShowSelectPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatNavigation];
    [self initData];
    [self initUI];
    [self creatLoadView];
    //判断是否是审核版
    
    
}
#pragma  mark  -------CreatUI;
-(void)creatNavigation
{
    
    UIButton  *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"取消" forState:UIControlStateNormal];
    [button setTitleColor:VBlue_color forState:UIControlStateNormal];
    button.frame=CGRectMake(10, 10, 40, 30);
    [button addActionHandler:^(NSInteger tag) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    button.titleEdgeInsets=UIEdgeInsetsMake(0, -10,0, 10);
    [button setTitleColor:VGray_color forState:UIControlStateNormal];
    //button.titleLabel.font =[UIFont boldSystemFontOfSize:18];
    button.titleLabel.font =[UIFont systemFontOfSize:16];
    // [button addTarget:self action:@selector(navigationbtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem  *barButton=[[UIBarButtonItem alloc]initWithCustomView:button];
    button.tag=99;
    
    self.navigationItem.leftBarButtonItem=barButton;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"tabbar_backgroud_color.png"] forBarMetrics:UIBarMetricsDefault];
    NSArray *segmentedArray = [[NSArray alloc] initWithObjects:@"剧照",@"截图", nil];
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
    
    
    
    upLoadimageBtn=[ZCControl createButtonWithFrame:CGRectMake(0,0,40,30) ImageName:nil Target:self Action:nil Title:nil];
    __weak typeof(self) WeakSelf = self;
    [upLoadimageBtn addActionHandler:^(NSInteger tag) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.delegate =WeakSelf;
        //设置选择后的图片可被编辑
        picker.allowsEditing = YES;
        [WeakSelf presentViewController:picker animated:YES completion:nil];
        
    }];
    upLoadimageBtn.tag=100;
    upLoadimageBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 10, 0, -10);
    [upLoadimageBtn setTitle:@"上传" forState:UIControlStateNormal];
    [upLoadimageBtn setTitleColor:VGray_color forState:UIControlStateNormal];
    upLoadimageBtn.titleLabel.font =[UIFont systemFontOfSize:16];
    // [upLoadimageBtn setImage:[UIImage imageNamed:@"up_picture_blue.png"] forState:UIControlStateNormal];
    UIBarButtonItem  *rigthbar =[[UIBarButtonItem alloc]initWithCustomView:upLoadimageBtn];
    self.navigationItem.rightBarButtonItem=rigthbar;
    
}
//-(void)navigationbtnClick:(UIButton *) btn
//{
//    if (btn.tag==99) {
//        [self dismissViewControllerAnimated:YES completion:nil];
//
//
//    }
//    else if (btn.tag==100)
//    {
//        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//        picker.delegate = self;
//        //设置选择后的图片可被编辑
//        picker.allowsEditing = YES;
//        [self presentViewController:picker animated:YES completion:nil];
//    }
//}

#pragma mark  ---
#pragma mark  -----imagePickerControlldelegate
#pragma mark  ----
//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:UIImagePickerControllerOriginalImage];
        [self dismissViewControllerAnimated:NO completion:^{
            UploadImageViewController  *upload=[[UploadImageViewController alloc]init];
            upload.upimage=image;
            if (self.pageType==NSShowSelectViewSoureTypeAddCard) {
                upload.pageTpye=NSUploadImageSourceTypeAddCard;
            }
            upload.movie_name=self.movie_name;
            upload.movie_Id=self.movie_id;
            //upload.movie_Id=moviedetailmodel.douban_id;
            [self.navigationController pushViewController:upload animated:YES];
        }];
    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
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
    page1=0;
    page2=0;
    userCenter =[UserDataCenter shareInstance];
    
}
-(void)initUI
{
    layout=[[UICollectionViewFlowLayout alloc]init];
    layout.itemSize=CGSizeMake((kDeviceWidth-15)/4, (kDeviceWidth-15)/4);
    layout.minimumInteritemSpacing=0; //cell之间左右的
    layout.minimumLineSpacing=0;      //cell上下间隔
    
    //   layout.sectionInset=UIEdgeInsetsMake(0,0,64, 0); //整个偏移量 上左下右
    _myConllectionView =[[UICollectionView alloc]initWithFrame:CGRectMake(0,0,kDeviceWidth+0, kDeviceHeight-kHeightNavigation) collectionViewLayout:layout];
    _myConllectionView.backgroundColor=View_BackGround;
    //注册小图模式
    [_myConllectionView registerClass:[SmallImageCollectionViewCell class] forCellWithReuseIdentifier:@"smallcell"];
    
    _myConllectionView.delegate=self;
    _myConllectionView.dataSource=self;
    [self.view addSubview:_myConllectionView];
    [self setUprefresh];
    //    [self setupHeadView];
    //    [self setupFootView];
}
-(void)creatLoadView
{
    loadView =[[LoadingView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    loadView.delegate=self;
    [self.view addSubview:loadView];
    
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
        // 进入刷新状态就会回调这个Block
        [weakSelf requestData];
        // 设置文字
        [weakSelf.myConllectionView.header setTitle:@"下拉刷新..." forState:MJRefreshHeaderStateIdle];
        [weakSelf.myConllectionView.header setTitle:@"释放刷新..." forState:MJRefreshHeaderStatePulling];
        [weakSelf.myConllectionView.header setTitle:@"正在刷新..." forState:MJRefreshHeaderStateRefreshing];
        //隐藏时间
        weakSelf.myConllectionView.header.updatedTimeHidden=YES;
        
        if(segment.selectedSegmentIndex==0)
        {
            page1=1;
            if (weakSelf.dataArray1.count>0) {
                [weakSelf.dataArray1 removeAllObjects];
            }
        }
        else if(segment.selectedSegmentIndex==1)
        {
            page2=1;
            if (weakSelf.dataArray2.count>0) {
                [weakSelf.dataArray2 removeAllObjects];
            }
        }
        // 进入刷新状态就会回调这个Block
        [weakSelf requestData];
        
        // 设置字体
        //weakSelf.myConllectionView.header.font = [UIFont systemFontOfSize:12];
        
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
        if (segment.selectedSegmentIndex==0) {
            page1=page1+1;
        }
        else if (segment.selectedSegmentIndex==1)
        {
            page2=page2+1;
        }
        [weakSelf requestData];
        
        // 设置文字
        [weakSelf.myConllectionView.footer setTitle:@"点击加载更多..." forState:MJRefreshFooterStateIdle];
        [weakSelf.myConllectionView.footer setTitle:@"加载更多..." forState:MJRefreshFooterStateRefreshing];
        [weakSelf.myConllectionView.footer setTitle:@"THE END" forState:MJRefreshFooterStateNoMoreData];
        
        // 设置字体
        // weakSelf.myConllectionView.footer.font = [UIFont systemFontOfSize:12];
        
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
#warning 上线的时候需要去去掉return的注视
    
    if ([userCenter.Is_Check intValue]==1) {
        loadView.failTitle.text =@"还没有内容，快来添加一条吧！";
        [loadView.failBtn setTitle:@"添加" forState:UIControlStateNormal];
        [loadView showFailLoadData];
        return;
    }
    [loadView removeFromSuperview];
    //   UserDataCenter *userCenter =[UserDataCenter shareInstance];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString *urlstr;
    if (segment.selectedSegmentIndex==0) {
        urlstr = [NSString stringWithFormat:@"http://movie.douban.com/subject/%@/photos?type=S&start=%ld&sortby=vote&size=a&subtype=o", self.douban_id,self.dataArray1.count];
    }
    else if (segment.selectedSegmentIndex==1)
    {
        urlstr = [NSString stringWithFormat:@"http://movie.douban.com/subject/%@/photos?type=S&start=%ld&sortby=vote&size=a&subtype=c", self.douban_id,self.dataArray2.count];
    }
    
    [request setURL:[NSURL URLWithString:urlstr]];
    [request setHTTPMethod:@"GET"];
    NSOperationQueue * queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            //NSLog(@"httpresponse code error %@", connectionError);
            [loadView showFailLoadData];
            
        } else {
            [loadView stopAnimation];
            [loadView removeFromSuperview];
            
            
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
                    if (doubanInfos.count>0) {
                        [self.dataArray1 addObjectsFromArray:doubanInfos];
                        //   NSLog(@"====doubanInfo ===%@",doubanInfos);
                        if (doubanInfos.count<40) {
                            //[self.myConllectionView.footer noticeNoMoreData];
                        }
                    }
                }
                else if (segment.selectedSegmentIndex==1)
                {
                    if (self.dataArray2==nil) {
                        self.dataArray2=[[NSMutableArray alloc]init];
                    }
                    if (doubanInfos.count>0) {
                        [self.dataArray2 addObjectsFromArray:doubanInfos];
                        if (doubanInfos.count<40) {
                            [self.myConllectionView.footer noticeNoMoreData];
                        }
                    }
                }
                [self.myConllectionView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
            } else {
                NSLog(@"error");
                
                [loadView showFailLoadData];
                
            }
        }
    }];
    
}
-(void)reloadDataClick
{
    if ([loadView.failBtn.titleLabel.text isEqualToString:@"添加"]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.delegate = self;
        //设置选择后的图片可被编辑
        picker.allowsEditing = YES;
        // UINavigationController  *na =[[UINavigationController alloc]initWithRootViewController:picker];
        [self.navigationController presentViewController:picker animated:YES completion:nil];
        
    }
    else {
        [self requestData];
        [loadView hidenFailLoadAndShowAnimation];
        
    }
}
#pragma  mark
#pragma mark - UICollectionViewDataSource ----

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
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
    
    cell.imageView.backgroundColor=VStageView_color;
    NSURL  *urlString ;
    if (segment.selectedSegmentIndex==0) {
        
        if (self.dataArray1.count>indexPath.row) {
            urlString =[NSURL URLWithString:[self.dataArray1 objectAtIndex:indexPath.row]];
            //          [cell.imageView sd_setImageWithURL:urlString placeholderImage:nil];
            [cell.imageView sd_setImageWithURL:urlString placeholderImage:nil options:(SDWebImageRetryFailed|SDWebImageLowPriority)];
            
        }
    }
    else if(segment.selectedSegmentIndex==1)
    {
        if (self.dataArray2.count>indexPath.row) {
            urlString =[NSURL URLWithString:[self.dataArray2 objectAtIndex:indexPath.row]];
            // [cell.imageView sd_setImageWithURL:urlString placeholderImage:nil];
            [cell.imageView sd_setImageWithURL:urlString placeholderImage:nil options:(SDWebImageRetryFailed|SDWebImageLowPriority)];
        }
        
    }
    //   cell.titleLab.hidden = YES;
    return cell;
    
    
}
//点击小图模式的时候，跳转到大图模式
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DoubanUpImageViewController *vc = [[DoubanUpImageViewController alloc] init];
    SmallImageCollectionViewCell  *cell =(SmallImageCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    NSString  *urlString;
    if (segment.selectedSegmentIndex==0) {
        if (self.dataArray1.count>indexPath.row) {
            urlString =[self.dataArray1 objectAtIndex:indexPath.row];
            urlString=   [urlString stringByReplacingOccurrencesOfString:@"albumicon" withString:@"photo"];
        }
    }
    else if(segment.selectedSegmentIndex==1)
    {
        if (self.dataArray2.count>indexPath.row) {
            urlString =[self.dataArray2 objectAtIndex:indexPath.row];
            urlString=   [urlString stringByReplacingOccurrencesOfString:@"albumicon" withString:@"photo"];
            
        }
    }
    
    if (self.pageType==NSShowSelectViewSoureTypeAddCard) {
        vc.pageType=NSDoubanSourceTypeAddCard;
    }
    vc.upimage=cell.imageView.image;
    vc.movie_name=self.movie_name;
    vc.movie_id=self.movie_id;
    if (urlString) {
        vc.photourl=urlString;
    }
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma  mark ----
#pragma  mark -----UICollectionViewLayoutDelegate
#pragma  mark ----

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((kDeviceWidth-15)/4,(kDeviceWidth-15)/4);
    
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
