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
#import "M80AttributedLabel.h"
#import "Constant.h"
//导入App delegate
#import "AppDelegate.h"
//导入功能类
#import "Function.h"
#import "MJExtension.h"
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
#import "MyViewController.h"
//#import "ButtomToolView.h"
#import "MJRefresh.h"
#import "UserDataCenter.h"
#import "ShowStageViewController.h"
#import "UploadImageViewController.h"
#import "UMShareViewController.h"
#import "UMShareViewController2.h"
#import "UpYun.h"
#import "TagModel.h"
#import "stageInfoModel.h"
#import "movieInfoModel.h"
#import "ScanMovieInfoViewController.h"
#import "TagToStageViewController.h"
#import "ShowSelectPhotoViewController.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
@interface MovieDetailViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,MovieHeadViewDelegate,StageViewDelegate,ButtomToolViewDelegate,UMSocialUIDelegate,UMSocialDataDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate,BigImageCollectionViewCellDelegate,AddMarkViewControllerDelegate,UMShareViewControllerDelegate,UMShareViewController2Delegate,MFMailComposeViewControllerDelegate,LoadingViewDelegate,TagViewDelegate>

{
     UICollectionViewFlowLayout    *layout;
    LoadingView         *loadView;
     BOOL bigModel;
    ButtomToolView *_toolBar;
    MarkView       *_mymarkView;
     //UMShareView   *shareView;
    int pageSize;
    int page;
    //导航条
    UIView *Navview;
    //上传图片的按钮
    UIButton  *upLoadimageBtn;
    // 返回按钮
    UIButton  *backBtn;
    stageInfoModel  *_TStageInfo;
    weiboInfoModel      *_TweiboInfo;
    //电影详细信息
    movieInfoModel   * moviedetailmodel;
    int pageCount;
    NSMutableArray  *_upWeiboArray;
    NSInteger      Rowindex;
    //头部放置标签列表的视图
   //  UIView  *headView;
    NSString *tagId;
    
    
}
@property(nonatomic,strong) M80AttributedLabel  *tagLable;//头部标签

@property(nonatomic,strong) UIScrollView      *HeadScrollerView;

@property(nonatomic,strong) NSMutableArray    *tagListArray;

@property(nonatomic,strong) NSMutableArray  *dataArray;

@end

@implementation MovieDetailViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //下面透明度的设置，效果是设置了导航条的高度的多少倍，不是透明度多少
  ///  self.navigationController.navigationBar.alpha=0.4;
    self.navigationController.navigationBar.hidden=NO;
    self.tabBarController.tabBar.hidden=YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestMovieData) name:@"RefreshMovieDeatail" object:nil];


}

-(void)viewDidAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden=NO;


}
-(void)requestMovieData
{
    page=1;
    if (_dataArray.count >0) {
        [_dataArray removeAllObjects];
    }
    [self requestData];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self initUI];
    [self createNavigation];

    if (self.pageSourceType==NSMovieSourcePageSearchListController) { //电影搜索页面进来的
        page=1;
        [self requestMovieIdWithdoubanId];
    }
    else if(self.pageSourceType==NSMovieSourcePageMovieListController)
    {
        // 从电影列表页进来的
        page=1;
        [self requestData];
    }
    else if (self.pageSourceType ==NSMovieSourcePageAdminCloseStageViewController)
    {
        //管理员页面进来
        page=1;
        [self requestData];
        
    }
    [self createToolBar];
    [self creatLoadView];
   
}

//创建可以显示隐藏的导航条
-(void)createNavigation
{
    UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth-120, 40)];
    //电影图片
    UIImageView *    MovieLogoImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0,5,30, 30)];
    MovieLogoImageView.layer.cornerRadius=4;
    MovieLogoImageView.contentMode=UIViewContentModeScaleAspectFill;
    MovieLogoImageView.clipsToBounds=YES;
    MovieLogoImageView.image =[UIImage imageNamed:@"Moments.png"];
    MovieLogoImageView.layer.masksToBounds = YES;
    [titleView addSubview:MovieLogoImageView];
    //电影名
    UILabel  *movieNameLable =[[UILabel alloc]initWithFrame:CGRectMake(35,0, 120, 30)];
    movieNameLable.font=[UIFont systemFontOfSize:16];
    movieNameLable.textColor=VGray_color;
    // movieNameLable.numberOfLines=1;
    movieNameLable.lineBreakMode=NSLineBreakByTruncatingTail;
    [titleView addSubview:movieNameLable];
    
    NSString  *logoString;
    if (self.pageSourceType==NSMovieSourcePageMovieListController) {
        logoString =[NSString stringWithFormat:@"%@%@!poster",kUrlFeed,self.movielogo];
    }
    else if(self.pageSourceType==NSMovieSourcePageSearchListController)
    {
        logoString =self.movielogo;
    }
    else
    {
     logoString =[NSString stringWithFormat:@"%@%@!w100h100",kUrlMoviePoster,self.movielogo];
    }
    
    [MovieLogoImageView sd_setImageWithURL:[NSURL URLWithString:logoString] placeholderImage:[UIImage imageNamed:@"Moments.png"]];
    NSString  *nameStr=self.moviename;
    if (self.pageSourceType==NSMovieSourcePageAdminCloseStageViewController) {
         nameStr=@"已屏蔽剧照";
        MovieLogoImageView.frame=CGRectZero;
    }
    nameStr =[Function htmlString:nameStr];
    float nameW=kDeviceWidth*0.6;
    CGSize   Nsize =[nameStr boundingRectWithSize:CGSizeMake(nameW, 25) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:16] forKey:NSFontAttributeName] context:nil].size;
    movieNameLable.text=[NSString stringWithFormat:@"%@",nameStr];
    movieNameLable.frame=CGRectMake(35,8,Nsize.width+5, 25);
    titleView.frame=CGRectMake(0, 0, 30+5+movieNameLable.frame.size.width, 40);
    self.navigationItem.titleView=titleView;
    [self.navigationItem.titleView setContentMode:UIViewContentModeCenter];
    
    upLoadimageBtn=[ZCControl createButtonWithFrame:CGRectMake(0,0,40,25) ImageName:nil Target:self Action:@selector(uploadImageFromAbumdAndDouban) Title:@"添加"];
    upLoadimageBtn.tag=201;
    [upLoadimageBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    //upLoadimageBtn.backgroundColor = [UIColor redColor];
    [upLoadimageBtn setTitleColor:VBlue_color forState:UIControlStateNormal];
    upLoadimageBtn.imageEdgeInsets= UIEdgeInsetsMake(5, 20, 0, -10);
//    [upLoadimageBtn setImage:[UIImage imageNamed:@"up_picture_blue.png"] forState:UIControlStateNormal];
    UIBarButtonItem  *rigthbar =[[UIBarButtonItem alloc]initWithCustomView:upLoadimageBtn];
    self.navigationItem.rightBarButtonItem=rigthbar;
    
}

-(void)uploadImageFromAbumdAndDouban
{
    
//    UIActionSheet  *ac =[[UIActionSheet alloc]initWithTitle:@"选择照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"网上图片",@"本地上传", nil];
//    ac.tag=499;
//    [ac showInView:self.view];
    //选取网络图片
    [self requestMovieInfoData];

    
}

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

            upload.movie_Id=self.movieId;
            //upload.movie_Id=moviedetailmodel.douban_id;
            [self.navigationController pushViewController:upload animated:YES];
        }];
    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
   
    [picker dismissViewControllerAnimated:YES completion:nil];
}


-(void)initData
{
    page=1;
    pageSize=15;
    pageCount=0;
    bigModel=NO;
    tagId=@"0";
    _dataArray =[[NSMutableArray alloc]init];
    self.tagListArray=[[NSMutableArray alloc]init];
    moviedetailmodel=[[movieInfoModel alloc]init];
    _upWeiboArray=[[NSMutableArray alloc]init];
    
}
#pragma mark 创建头部的标签列表
-(void)createHeadViewWithArray:(NSArray *) array
{
//    headView=[[UIView alloc]initWithFrame:CGRectMake(0,0, kDeviceWidth, 200)];
//    headView.backgroundColor =[UIColor whiteColor];
//    [self.view addSubview:headView];
    
    self.HeadScrollerView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 120)];
    self.HeadScrollerView.contentSize=CGSizeMake(kDeviceWidth+100, 120);
    [self.view addSubview:self.HeadScrollerView];
    
    self.tagLable =[[M80AttributedLabel alloc]initWithFrame:CGRectMake(10,10,kDeviceWidth-20, 100)];
    self.tagLable.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0];
    self.tagLable.lineSpacing=10;
    for (int i=0; i<array.count; i++) {
        TagView *tagview = [self createTagViewWithtagInfo:array[i] andIndex:i];
        [self.tagLable appendView:tagview margin:UIEdgeInsetsMake(0, 0, 0, 10)];
     }
    [self.HeadScrollerView addSubview:self.tagLable];
    //计算tagview的高度
    CGSize Tagsize =[self.tagLable sizeThatFits:CGSizeMake(kDeviceWidth+100, 100)];
    self.tagLable.frame=CGRectMake(10,10,Tagsize.width, Tagsize.height+0);
    //headView.frame=CGRectMake(0, 0, kDeviceWidth,20+Tagsize.height+40);

}
//创建标签的方法
-(TagView *)createTagViewWithtagInfo:(TagModel *) tagmodel andIndex:(NSInteger ) index
{
    TagView *tagview =[[TagView alloc]initWithWeiboInfo:nil AndTagInfo:tagmodel delegate:self isCanClick:YES backgoundImage:nil isLongTag:YES];
    tagview.tagBgImageview.backgroundColor=VLight_GrayColor;
    [tagview setbigTag:YES];
    tagview.tag=2000+index;
    tagview.titleLable.textColor=VGray_color;
    if (index==0) {
        tagview.tagBgImageview.backgroundColor =VBlue_color;
        tagview.titleLable.textColor=[UIColor whiteColor];
    }
    return tagview;
}



-(void)initUI
{
    layout=[[UICollectionViewFlowLayout alloc]init];
    //layout.minimumInteritemSpacing=10; //cell之间左右的
    //layout.minimumLineSpacing=10;      //cell上下间隔
    //layout.itemSize=CGSizeMake(80,140);  //cell的大小
    if(bigModel==YES)
    {
        layout.sectionInset=UIEdgeInsetsMake(0, 0, 64, 0);
    }
    else{

        layout.sectionInset=UIEdgeInsetsMake(0,0,64, 0); //整个偏移量 上左下右
    }
    _myConllectionView =[[UICollectionView alloc]initWithFrame:CGRectMake(0,0,kDeviceWidth, kDeviceHeight-20-0) collectionViewLayout:layout];
    //[layout setHeaderReferenceSize:CGSizeMake(_myConllectionView.frame.size.width, kDeviceHeight/3+64+110)];

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
        if (pageCount>page) {
            page=page+1;
            [vc requestData];
        }
        // 模拟延迟加载数据，因此2秒后才调用）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
          //  [vc.myConllectionView reloadData];
            // 结束刷新
            [vc.myConllectionView footerEndRefreshing];
        });
    }];
}

-(void)creatLoadView
{
    loadView =[[LoadingView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    loadView.delegate=self;
    [self.view addSubview:loadView];
}
//创建底部的视图
-(void)createToolBar
{
    _toolBar=[[ButtomToolView alloc]initWithFrame:CGRectMake(0,0,kDeviceWidth,kDeviceHeight)];
    _toolBar.delegete=self;
}



#pragma  mark  ----RequestData
#pragma  mark  ---

//举报某人
-(void)requestTagList
{
    //UserDataCenter *userCenter =[UserDataCenter shareInstance];
    NSDictionary *parameters = @{@"movie_id":self.movieId};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/tag-stage/tag-list", kApiBaseUrl] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject  objectForKey:@"code"]  intValue]==0) {
            NSLog(@"标签列表=======%@",responseObject);
            NSMutableArray  *array =[[NSMutableArray alloc]initWithArray:[TagModel objectArrayWithKeyValuesArray:[responseObject objectForKey:@"models"]]];
            //自己创建一个文字问全部的标签
            TagDetailModel  *detailmodel =[[TagDetailModel alloc]init];
            detailmodel.title=@"全部";
            TagModel *tagmodel =[[TagModel alloc]init];
            tagmodel.tagDetailInfo=detailmodel;
            [array insertObject:tagmodel atIndex:0];
            self.tagListArray=array;
            [self createHeadViewWithArray:array];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

#pragma mark
-(void)TapViewClick:(TagView *)tagView Withweibo:(weiboInfoModel *)weiboInfo withTagInfo:(TagModel *)tagInfo
{

    page=1;
    if (self.dataArray.count>0) {
    [self.dataArray removeAllObjects];
 
    }
    
    for (int i=0; i<self.tagListArray.count; i++) {
    //直接
        TagView  *tagView=(TagView *)[self.tagLable viewWithTag:2000+i];
        tagView.tagBgImageview.backgroundColor =VLight_GrayColor;
        tagView.titleLable.textColor=VGray_color;
    }
    
    tagView.tagBgImageview.backgroundColor =VBlue_color;
    tagView.titleLable.textColor=[UIColor whiteColor];
    tagId =tagInfo.tagDetailInfo.Id;
    [self requestData];
    
    
    
}


//审核版到正式版的切换
-(void)requestmoveReviewToNormal:(NSString *) stageId
{
    UserDataCenter *usercenter=[UserDataCenter shareInstance];
    NSString  *review;
    if ([Version  isEqualToString:@"1.0.1"]) {
        //从审核版到正常
        review=@"0";
    }
    else
    {
        review=@"1";
        
    }
    NSDictionary *parameters = @{@"stage_id":stageId,@"user_id":usercenter.user_id,@"review":review};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *urlString =[NSString stringWithFormat:@"%@/stage/move-to-review", kApiBaseUrl];
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject  objectForKey:@"code"]  intValue]==0) {
            NSLog(@"移除剧照成功=======%@",responseObject);
            UIAlertView  *Al =[[UIAlertView alloc]initWithTitle:nil message:@"审核（正常）切换成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [Al show];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}




-(void)requestReportSatge
{
     NSNumber  *stageId;
    NSString  *author_id=@"";
    
    stageInfoModel  *stageInfo =[_dataArray objectAtIndex:Rowindex];
    stageId=stageInfo.Id;
    author_id=stageInfo.created_by;
    UserDataCenter *userCenter =[UserDataCenter shareInstance];
    NSDictionary *parameters = @{@"reported_user_id":author_id,@"stage_id":stageId,@"reason":@"",@"user_id":userCenter.user_id};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/report-stage/create", kApiBaseUrl] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject  objectForKey:@"code"]  intValue]==0) {
            NSLog(@"随机数种子请求成功=======%@",responseObject);
            UIAlertView  *Al =[[UIAlertView alloc]initWithTitle:nil message:@"你的举报已成功,我们会在24小时内处理" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [Al show];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}


//举报某人
-(void)requestReportweibo
{
    UserDataCenter *userCenter =[UserDataCenter shareInstance];
    NSDictionary *parameters = @{@"reported_user_id":_TweiboInfo.uerInfo.Id,@"stage_id":_TStageInfo.Id,@"reason":@"",@"user_id":userCenter.user_id};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/report-stage/create", kApiBaseUrl] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject  objectForKey:@"code"]  intValue]==0) {
            NSLog(@"随机数种子请求成功=======%@",responseObject);
            UIAlertView  *Al =[[UIAlertView alloc]initWithTitle:nil message:@"你的举报已成功,我们会在24小时内处理" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [Al show];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}


//变身请求的随机数种子
-(void)requestChangeUserRand4
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/user/fakeUser", kApiBaseUrl] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject  objectForKey:@"code"]  intValue]==0) {
            NSLog(@"随机数种子请求成功=======%@",responseObject);
            
            [self  requestChangeUser:[responseObject objectForKey:@"detail"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}
//跟换用户的数据请求
-(void)requestChangeUser:(NSDictionary  *) dict
{
    NSDictionary *parameters = @{@"weibo_id":_TweiboInfo.Id,@"user_id":[dict objectForKey:@"id"]};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/weibo/switch", kApiBaseUrl] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject  objectForKey:@"code"]  intValue]==0) {
            NSLog(@"推荐成功=======%@",responseObject);
            UIAlertView  *Al=[[UIAlertView alloc]initWithTitle:nil message:@"变身成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [Al show];
            _TweiboInfo.uerInfo.Id=[dict objectForKey:@"id"];
            [ _mymarkView.LeftImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kUrlAvatar, [dict objectForKey:@"avatar"] ]]];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}
//推荐微博的接口
-(void)requestrecommendData
{
    //  NSLog(@"hotmodel  ==weibiid ==%@   hotmodel stageinfo id ==%@ ",hotmodel.weibo.Id,hotmodel.stageinfo.Id);
    NSDictionary *parameters = @{@"id":_TweiboInfo.Id,@"stage_id":_TStageInfo.Id};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/hot/create", kApiBaseUrl] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject  objectForKey:@"return_code"]  intValue]==10000) {
            NSLog(@"推荐成功=======%@",responseObject);
            UIAlertView  *Al=[[UIAlertView alloc]initWithTitle:nil message:@"推荐成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [Al show];
            //[self requestData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}


//删除微博的接口
-(void)requestDelectData
{
    //  NSLog(@"hotmodel  ==weibiid ==%@   hotmodel stageinfo id ==%@ ",hotmodel.weibo.Id,hotmodel.stageinfo.Id);
    NSDictionary *parameters = @{@"weibo_id":_TweiboInfo.Id,@"stage_id":_TStageInfo.Id};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/weibo/remove", kApiBaseUrl] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject  objectForKey:@"return_code"]  intValue]==10000) {
            NSLog(@"删除数据成功=======%@",responseObject);
            UIAlertView  *Al=[[UIAlertView alloc]initWithTitle:nil message:@"删除成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [Al show];
           // [self requestData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

//根据豆瓣id  请求movieid
-(void)requestMovieIdWithdoubanId
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"douban_id": self.douban_Id};
    
    [manager POST:[NSString stringWithFormat:@"%@/movie/create", kApiBaseUrl] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject  objectForKey:@"code"] intValue]==0) {
        
        NSLog(@"responseobject = %@", responseObject);
        NSDictionary *detail = [responseObject objectForKey:@"model"];
        NSString * movie_id = [detail objectForKey:@"id"];
        if (movie_id && [movie_id intValue]>0) {
            self.movieId = movie_id;
        }
         //[self requestTagList];
            [self requestData];
         }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [loadView showNullView:@"没有数据..."];
        
    }];

}


//根据电影id 请求电影的详细信息
-(void)requestMovieInfoData
{
    if (!_movieId || _movieId<=0) {
        return;
    }
    NSDictionary *parameter = @{@"movie_id": self.movieId};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/movie/info", kApiBaseUrl] parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
      //  NSLog(@"  电影详情页面的电影信息数据JSON: %@", responseObject);
        if ([[responseObject  objectForKey:@"code"]  intValue]==0) {
            NSDictionary  *dict =[responseObject objectForKey:@"model"];
            
            ShowSelectPhotoViewController  *vc =[[ShowSelectPhotoViewController alloc]init];
            vc.douban_id=[dict objectForKey:@"douban_id"];
            vc.movie_id=self.movieId;
            vc.movie_name=self.moviename;
            
            UIBarButtonItem  *item =[[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
            self.navigationItem.backBarButtonItem=item;
            UINavigationController  *na =[[UINavigationController alloc]initWithRootViewController:vc];
             [self presentViewController:na animated:YES completion:nil];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
    }];
}

-(void)requestData
{
    /*if (!_movieId || _movieId<=0) {
        return;
    }*/
    
    UserDataCenter  *userCenter =[UserDataCenter shareInstance];
    NSDictionary *parameter;
    NSString  *urlString;
//    if ([tagId intValue]==0) { //是全部的标签
//        urlString =[NSString stringWithFormat:@"%@/stage/list?per-page=%d&page=%d",kApiBaseUrl,pageSize,page];
//        parameter = @{@"movie_id": _movieId, @"user_id": userCenter.user_id,@"Version":Version};
//    }
//    else{
    //在电影列表或者是搜索页进来的
    if (self.pageSourceType==NSMovieSourcePageMovieListController|self.pageSourceType==  NSMovieSourcePageSearchListController)
    {
        urlString =[NSString stringWithFormat:@"%@/stage/list?per-page=%d&page=%d",kApiBaseUrl,pageSize,page];
        parameter = @{@"movie_id": _movieId, @"user_id": userCenter.user_id,@"Version":Version};
    }
     //}
    else   if (self.pageSourceType==NSMovieSourcePageAdminCloseStageViewController) {
        urlString =[NSString stringWithFormat:@"%@/stage/block-list?per-page=%d&page=%d",kApiBaseUrl,pageSize,page];
        parameter = @{ @"user_id": userCenter.user_id,@"Version":Version};
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:urlString parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"  电影详情页面数据JSON: %@", responseObject);
        if ([[responseObject  objectForKey:@"code"]  intValue]==0) {
        pageCount=[[responseObject objectForKey:@"pageCount"] intValue];
        NSMutableArray  *detailArray=[responseObject objectForKey:@"models"];
        if (detailArray.count>0) {
        [loadView stopAnimation];
        [loadView removeFromSuperview];
        for (NSDictionary  *stageDict in detailArray) {
            stageInfoModel  *stagemodel =[[stageInfoModel alloc]init];
            if (stagemodel) {
                [stagemodel setValuesForKeysWithDictionary:stageDict];
                
                NSMutableArray  *weibos=[[NSMutableArray alloc]init];
                for (NSDictionary *weiboDict in [stageDict objectForKey:@"weibos"]) {
                    weiboInfoModel  *weibomodel=[[weiboInfoModel alloc]init];
                   if (weibomodel) {
                     [weibomodel setValuesForKeysWithDictionary:weiboDict];
                       weiboUserInfoModel  *usermodel=[[weiboUserInfoModel alloc]init];
                       if (usermodel) {
                           [usermodel setValuesForKeysWithDictionary:[weiboDict objectForKey:@"user"]];
                           weibomodel.uerInfo=usermodel;
                       }
                       //tag
                       NSMutableArray  *tagArray = [[NSMutableArray alloc]init];
                       for (NSDictionary  *tagDict  in [weiboDict objectForKey:@"tags"]) {
                           TagModel *tagmodel =[[TagModel alloc]init];
                           if (tagmodel) {
                               [tagmodel setValuesForKeysWithDictionary:tagDict];
                               TagDetailModel *tagedetail = [[TagDetailModel alloc]init];
                               if (tagedetail) {
                                   [tagedetail setValuesForKeysWithDictionary:[tagDict  objectForKey:@"tag"]];
                                   tagmodel.tagDetailInfo=tagedetail;
                               }
                               
                               [tagArray addObject:tagmodel];
                           }
                       }
                       weibomodel.tagArray=tagArray;
                       [weibos addObject:weibomodel];
                    }
                }
                stagemodel.weibosArray=weibos;
                
                movieInfoModel  *moviemodel =[[movieInfoModel alloc]init];
                if (moviemodel) {
                    [moviemodel setValuesForKeysWithDictionary:[stageDict objectForKey:@"movie"]];
                    stagemodel.movieInfo=moviemodel;
                
                }
                if (_dataArray==nil) {
                    _dataArray=[[NSMutableArray alloc]init];
                }
                [_dataArray addObject:stagemodel];
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
                }}
            
          [_myConllectionView reloadData];
        }
        else if(detailArray.count==0)
        {
            
            //[loadView  showNullView:@"没有数据..."];
           //没有数据 时候添加图片，添加图片,
            loadView.failTitle.text =@"还没有内容，快来添加一条吧！";
            [loadView.failBtn setTitle:@"添加" forState:UIControlStateNormal];
            [loadView showFailLoadData];

        }
    }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error     地方: %@", error);
        //重新加载
        [loadView showFailLoadData];
        
    }];
    
}
//数据加载失败
-(void)reloadDataClick
{
    //[self requestData];
    //[loadView hidenFailLoadAndShowAnimation];
    [self uploadImageFromAbumdAndDouban];
    
}
#pragma  mark -----
#pragma  mark ------  DataRequest
#pragma  mark ----
//微博点赞请求
-(void)LikeRequstData:(weiboInfoModel  *) weiboInfo withOperation:(NSNumber *) operation
{
    
    UserDataCenter  *userCenter=[UserDataCenter shareInstance];
    NSNumber  *weiboId=weiboInfo.Id;
    NSString  *userId=userCenter.user_id;
    NSNumber  *author_id=weiboInfo.uerInfo.Id;

    
    NSDictionary *parameters=@{@"weibo_id":weiboId,@"user_id":userId,@"author_id":author_id,@"operation":operation};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
     NSString *urlString = [NSString stringWithFormat:@"%@/weibo/up", kApiBaseUrl];
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject  objectForKey:@"code"]  intValue]==0) {
            NSLog(@"点赞成功========%@",responseObject);
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
    stageInfoModel  *model=[_dataArray objectAtIndex:indexPath.row];
        cell.imageView.backgroundColor=VStageView_color;
        NSURL  *url =[NSURL URLWithString:[NSString stringWithFormat:@"%@%@!w340h340",kUrlStage,model.photo]];
        //[cell.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@!w340h340",kUrlStage,model.photo]] placeholderImage:[UIImage imageNamed:nil]];
        
        [cell.imageView sd_setImageWithURL:url placeholderImage:nil options:(SDWebImageRetryFailed|SDWebImageLowPriority)];
        
        if ( model.weibosArray.count>0) {
            //cell.titleLab.hidden = NO;
            // 显示第一条微博
            weiboInfoModel *weibo = [model.weibosArray objectAtIndex:0];
            cell.titleLab.text=[NSString stringWithFormat:@"%@",weibo.content];
        } else {
            cell.titleLab.hidden = YES;
        }
        return cell;
    //}
    }
    return cell;
}
//点击小图模式的时候，跳转到大图模式
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (bigModel==YES&&collectionView==_myConllectionView) {
        //点击cell 隐藏弹幕，再点击隐藏
 
     } else {
         

        ShowStageViewController *vc = [[ShowStageViewController alloc] init];
         stageInfoModel *stagemodel=[_dataArray objectAtIndex:indexPath.row];
         vc.upweiboArray=_upWeiboArray;
         vc.stageInfo = stagemodel;
         
          UIBarButtonItem  *item =[[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
         self.navigationItem.backBarButtonItem=item;
        [self.navigationController pushViewController:vc animated:YES];
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
   // HotMovieModel  *model =[_dataArray objectAtIndex:indexPath.row];
    if (bigModel==YES) {
         return CGSizeMake(kDeviceWidth,kDeviceWidth+45+10);
    }
    else
    {
        return CGSizeMake((kDeviceWidth-5)/2,(kDeviceWidth-10)/3);

    }
    return CGSizeMake(0, 0);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (bigModel==YES) {
        return UIEdgeInsetsMake(0,0,0,0);
    }
    return UIEdgeInsetsMake(0,0, 5,0);
}
//左右间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    if (bigModel==YES) {
        return 0;
    }
    return 0;
}
//上下
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if (bigModel==YES) {
        return 0;
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
       // UICollectionViewCell * stageCell = cell;
        if (collectionView==_myConllectionView) {
            BigImageCollectionViewCell *bigcell = (BigImageCollectionViewCell *)cell;
            if ( [bigcell.StageView respondsToSelector:@selector(startAnimating)] ) {
              //  [bigcell.StageView performSelector:@selector(startAnimation) withObject:nil afterDelay:1];
            }
        }


        
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
#pragma mark  ----navigationClick--and Delegate
-(void)NavigationClick:(UIButton *)button
//返回
{
   // [self.navigationController popViewControllerAnimated:YES];
    if (button.tag==200) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma  mark  -------BigImageCollectionViewCellToolButtonClick  ---- -- ---------------------
-(void)BigImageCollectionViewCellToolButtonClick:(UIButton *)button Rowindex:(NSInteger)index
{
   
    Rowindex =index;
    stageInfoModel   *stagemodel;
    stagemodel =[_dataArray objectAtIndex:index];
    if (button.tag==2000) {
        //分享
        //获取cell
#pragma mark 暂时把sharetext设置成null
      
         BigImageCollectionViewCell *cell = (BigImageCollectionViewCell *)(button.superview.superview.superview.superview);
        UIImage  *image=[Function getImage:cell.StageView WithSize:CGSizeMake(kDeviceWidth, kDeviceWidth)];
        UMShareViewController  *shareVC=[[UMShareViewController alloc]init];
        movieInfoModel  *moviemodel =[[movieInfoModel alloc]init];
        moviemodel.name=moviedetailmodel.name;
        stagemodel.movieInfo=moviemodel;
    
        shareVC.StageInfo=stagemodel;
        shareVC.screenImage=image;
        shareVC.delegate=self;
        UINavigationController  *na =[[UINavigationController alloc]initWithRootViewController:shareVC];
        [self presentViewController:na animated:YES completion:nil];

        
    }
    else if(button.tag==3000)
    {
            AddMarkViewController  *AddMarkVC=[[AddMarkViewController alloc]init];
            AddMarkVC.stageInfo = stagemodel;
            //AddMarkVC.model=model;
            AddMarkVC.delegate=self;
           // AddMarkVC.pageSoureType=NSAddMarkPageSourceDefault;
            [self.navigationController pushViewController:AddMarkVC animated:NO];
    }
    else if (button.tag==4000)
    {

        UserDataCenter  *userCenter =[UserDataCenter shareInstance];
        //点击了更多
        
        if ([userCenter.is_admin intValue]>0) {
            
            UIActionSheet  *Act=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"内容投诉",@"版权投诉",@"图片信息",@"切换剧照到（审核/正式）", nil];
            Act.tag=507;
            [Act showInView:Act];
        }
        else
        {
            UIActionSheet  *Act=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"内容投诉",@"版权投诉",@"图片信息", nil];
            Act.tag=507;
            [Act showInView:Act];
        }

    }
    
}
#pragma  mark  -------- AddMarkViewControllerReturn  -----------------------------------------------
-(void)AddMarkViewControllerReturn
{
    [self.myConllectionView reloadData];
    
}
-(void)UMShareViewControllerHandClick:(UIButton *)button ShareImage:(UIImage *)shareImage StageInfoModel:(stageInfoModel *)StageInfo
{
    NSArray  *sharearray =[NSArray arrayWithObjects:UMShareToWechatTimeline,UMShareToWechatSession, UMShareToSina, nil];
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
    
    [[UMSocialControllerService defaultControllerService] setShareText:StageInfo.movieInfo.name shareImage:shareImage socialUIDelegate:self];        //设置分享内容和回调对象
    [UMSocialSnsPlatformManager getSocialPlatformWithName:[sharearray  objectAtIndex:button.tag-10000]].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
    NSLog(@"分享到微信");
    self.tabBarController.tabBar.hidden=YES;

}
-(void)UMShareViewController2HandClick:(UIButton *)button ShareImage:(UIImage *)shareImage StageInfoModel:(stageInfoModel *)StageInfo
{
    
    NSArray  *sharearray =[NSArray arrayWithObjects:UMShareToWechatTimeline,UMShareToWechatSession, UMShareToSina, nil];
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
    [[UMSocialControllerService defaultControllerService] setShareText:StageInfo.movieInfo.name shareImage:shareImage socialUIDelegate:self];
    //设置分享内容和回调对象
    
    [UMSocialSnsPlatformManager getSocialPlatformWithName:[sharearray  objectAtIndex:button.tag-10000]].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
    
}

///点击分享的屏幕，收回分享的背景
-(void)SharetopViewTouchBengan
{
    NSLog(@"controller touchbegan  中 执行了隐藏工具栏的方法");
    //取消当前的选中的那个气泡
    [_mymarkView CancelMarksetSelect];
}
#pragma mark  --umShareDelegate

-(void)didCloseUIViewController:(UMSViewControllerType)fromViewControllerType
{
    //返回到app执行的方法，移除的时候应该写在这里
    NSLog(@"didCloseUIViewController第一步执行这个");
}
//根据有的view 上次一张图片
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    NSLog(@"didFinishGetUMSocialDataInViewController第二部执行这个");
    
}
-(void)didFinishGetUMSocialDataResponse:(UMSocialResponseEntity *)response;
{
    NSLog(@"didFinishGetUMSocialDataResponse第二部执行这个");
  
}


#pragma mark  -----
#pragma mark  ---StaegViewDelegate
#pragma mark  ----
-(void)StageViewHandClickMark:(weiboInfoModel *)weiboDict withmarkView:(id)markView StageInfoDict:(stageInfoModel *)stageInfoDict
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
-(void)SetToolBarValueWithDict:(weiboInfoModel  *)weiboDict markView:(id) markView isSelect:(BOOL ) isselect StageInfo:(stageInfoModel *) stageInfo
{
    
    //先对它赋值，然后让他弹出到界面
    if (isselect==YES) {
        _toolBar.alertView.frame=CGRectMake(15,0,kStageWidth-20, 100);
        _toolBar.weiboInfo=weiboDict;
        _toolBar.stageInfo=stageInfo;
        _toolBar.markView=markView;
        _toolBar.upweiboArray=_upWeiboArray;
        [_toolBar configToolBar];
        
        //把工具栏添加到当前视图
        self.tabBarController.tabBar.hidden=YES;
        [AppView addSubview:_toolBar];
        //[self.view addSubview:_toolBar];
        //弹出工具栏
        [_toolBar ShowButtomView];
        
    }
    else if (isselect==NO)
    {
        //隐藏toolbar
        NSLog(@" 执行了隐藏工具栏的方法");
        self.tabBarController.tabBar.hidden=YES;
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
-(void)ToolViewHandClick:(UIButton *)button :(MarkView *)markView weiboDict:(weiboInfoModel *)weiboDict StageInfo:(stageInfoModel *)stageInfoDict
{
    NSLog(@"点击头像  微博dict  ＝====%@ ======出现的stageinfo  ＝＝＝＝＝＝%@",weiboDict,stageInfoDict);
    
    _TStageInfo=stageInfoDict;
    _TweiboInfo=weiboDict;
    

    if (button.tag==10000) {
        ///点击了头像//进入个人页面
        [_mymarkView CancelMarksetSelect];
        if (_toolBar) {
            [_toolBar HidenButtomView];
            [_toolBar removeFromSuperview];
            
        }

        NSLog(@"点击头像  微博dict  ＝====%@ ======出现的stageinfo  ＝＝＝＝＝＝%@",weiboDict,stageInfoDict);
        MyViewController   *myVc=[[MyViewController alloc]init];
        myVc.author_id=weiboDict.created_by;
        UIBarButtonItem  *item =[[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        self.navigationItem.backBarButtonItem=item;
        [self.navigationController pushViewController:myVc animated:YES];

    }
#pragma mark     -----------分享
    else if (button.tag==10001)
    {
        UMShareViewController2  *shareVC=[[UMShareViewController2 alloc]init];
        movieInfoModel  *moviemodel =[[movieInfoModel alloc]init];
        moviemodel.name=moviedetailmodel.name;
        stageInfoDict.movieInfo=moviemodel;
        shareVC.StageInfo=stageInfoDict;
        shareVC.weiboInfo=weiboDict;
        shareVC.delegate=self;
      //  UINavigationController  *na =[[UINavigationController alloc]initWithRootViewController:shareVC];
        [self.navigationController presentViewController:shareVC animated:YES completion:nil];
        
        

    }
#pragma mark  ----------点赞--------------
    else  if(button.tag==10002)
    {
        NSNumber  *operation;
        int tag=0;// 标志是否含有weiboid
        for (int i=0; i<_upWeiboArray.count; i++) {
            //已赞的
            UpweiboModel *upmodel =_upWeiboArray[i];
            if ([upmodel.weibo_id intValue]==[weiboDict.Id intValue]) {
                tag=1;
                operation =[NSNumber numberWithInt:0];
                int like=[weiboDict.like_count intValue];
                like=like-1;
                weiboDict.like_count=[NSNumber numberWithInt:like];
                [_upWeiboArray removeObjectAtIndex:i];
                break;
            }
        }
        //查询到最后如果没有查到说明是没有赞过的微博,那么把这条赞信息添加到了赞数组中去
        if (tag==0) {
            //没有赞的
            operation =[NSNumber numberWithInt:1];
            UpweiboModel  *upmodel =[[UpweiboModel alloc]init];
            upmodel.weibo_id=weiboDict.Id;
            upmodel.created_at=weiboDict.created_at;
            upmodel.created_by=weiboDict.created_by;
            upmodel.updated_at=weiboDict.updated_at;
            
            int like=[weiboDict.like_count intValue];
            like=like+1;
            weiboDict.like_count=[NSNumber numberWithInt:like];
            [_upWeiboArray addObject:upmodel];
        }
        [self layoutMarkViewWithMarkView:markView WeiboInfo:weiboDict];
        ////发送到服务器
        [self LikeRequstData:weiboDict withOperation:operation];

    }
    else if(button.tag==10003)
    {
        
        UserDataCenter  *userCenter =[UserDataCenter shareInstance];
        if ([userCenter.is_admin  intValue]>0) {
            UIActionSheet   *ash=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"删除",@"变身",@"推荐", nil];
            ash.tag=500;
            [ash showInView:self.view];
        }
        else
        {
            UIActionSheet   *ash=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"举报" otherButtonTitles:nil, nil];
            ash.tag=504;
            [ash showInView:self.view];
        }
    }
}
-(void)ToolViewTagHandClick:(weiboInfoModel *)weiboInfo WithTagInfo:(TagModel *)tagInfo
{
    
    if (_toolBar) {
        [_toolBar removeFromSuperview];
        
    }
    TagToStageViewController  *vc=[[TagToStageViewController alloc]init];
    vc.weiboInfo=weiboInfo;
    vc.tagInfo=tagInfo;
    UIBarButtonItem  *item =[[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem=item;
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark  ----actionSheetDelegate--
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag==499) {
        
        if (buttonIndex==0) {
            [self requestMovieInfoData];
        }
        else if (buttonIndex==1)
        {
            
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            picker.delegate = self;
            //设置选择后的图片可被编辑
            picker.allowsEditing = YES;
            // UINavigationController  *na =[[UINavigationController alloc]initWithRootViewController:picker];
            [self.navigationController presentViewController:picker animated:YES completion:nil];

        }
    }
    
    else  if (actionSheet.tag==500) {
        if (buttonIndex==0) {
            //删除
            UIActionSheet   *ash=[[UIActionSheet alloc]initWithTitle:@"确定删除" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:nil,nil];
            ash.tag=501;
            [ash showInView:self.view];
            
        }
        else if(buttonIndex==1)
        {
            ///变身
            // [self.navigationController pushViewController:[ChangeSelfViewController new] animated:YES];
            //请求随机数种子
            [self requestChangeUserRand4];
        }
        else if(buttonIndex==2)
        {
            //推荐
            UIActionSheet   *ash=[[UIActionSheet alloc]initWithTitle:@"确定推荐" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil,nil];
            ash.tag=502;
            [ash showInView:self.view];
        }
    }
    // 确定删除
    else if(actionSheet.tag==501)
    {
        if (buttonIndex==0) {
            //删除了
            [self requestDelectData];
        }
        
    }
    else if(actionSheet.tag==502)
    {
        if (buttonIndex==0) {
            //推荐了
            [self requestrecommendData];
        }
        
    }
     else if(actionSheet.tag==504)
    {
        if (buttonIndex==0) {
            //弹出确认举报
            [self requestReportweibo];
            
        }
    }
    else if (actionSheet.tag==507)
    {
        if (buttonIndex==0) {
            //举报剧情
            [self requestReportSatge];
            
        }
        else if(buttonIndex==1)
        {
            
            stageInfoModel  *stagemodel =[_dataArray objectAtIndex:Rowindex];
            //版权问题
            [self sendFeedBackWithStageInfo:stagemodel];
            
        }
        else if(buttonIndex==2)
        {
            //           查看图片信息
            ScanMovieInfoViewController * scanvc =[ScanMovieInfoViewController new];
                stageInfoModel  *stagemodel =[_dataArray objectAtIndex:Rowindex];
                scanvc.stageInfo=stagemodel;
              [self presentViewController:scanvc animated:YES completion:nil];
            
         }
        else if (buttonIndex==3)
        {
            NSString  *stageId;
                stageInfoModel *model=[_dataArray objectAtIndex:Rowindex];
               stageId=[NSString stringWithFormat:@"%@",model.Id];
            //移动到审核版或者正常
            [self requestmoveReviewToNormal:stageId];
            
        }


    }
}
- (void)sendFeedBackWithStageInfo:(stageInfoModel *)stageInfo
{
    //    [self showNativeFeedbackWithAppkey:UMENT_APP_KEY];
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (mailClass != nil)
    {
        // We must always check whether the current device is configured for sending emails
        if ([mailClass canSendMail])
        {
            [self displayComposerSheet:stageInfo];
        }
        else
        {
            [self launchMailAppOnDevice];
        }
    }
    else
    {
        [self launchMailAppOnDevice];
    }
    
}
-(void)displayComposerSheet:(stageInfoModel *) stageInfo
{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];/*MFMailComposeViewController邮件发送选择器*/
    picker.mailComposeDelegate = self;
    
    // Custom NavgationBar background And set the backgroup picture
    picker.navigationBar.tintColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.5];
    //    picker.navigationBar.tintColor = [UIColor colorWithRed:178.0/255 green:173.0/255 blue:170.0/255 alpha:1.0]; //    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0) {
    //        [picker.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg.png"] forBarMetrics:UIBarMetricsDefault];
    //    }
    //    NSArray *ccRecipients = [NSArray arrayWithObjects:@"dcj3sjt@gmail.com", nil];
    //    NSArray *bccRecipients = [NSArray arrayWithObjects:@"dcj3sjt@163.com", nil];
    //    [picker setCcRecipients:ccRecipients];
    //    [picker setBccRecipients:bccRecipients];
    
    // Set up recipients
    NSArray *toRecipients = [NSArray arrayWithObject:@"feedback@redianying.com"];
    [picker setToRecipients:toRecipients];
    // Fill out the email body text
    //struct utsname device_info;
    //uname(&device_info);
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appCurName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *appCurVersionNum = [infoDictionary objectForKey:@"CFBundleVersion"];
    
    UIDevice * myDevice = [UIDevice currentDevice];
    NSString * sysVersion = [myDevice systemVersion];
//*emailpicker标题主题行*/
    UserDataCenter  *usercenter=[UserDataCenter shareInstance];
    
    NSString *emailBody = [NSString stringWithFormat:@"\n您的名字：\n联系电话:\n投诉内容:\n\n\n\n\n-------\n请勿删除以下信息，并提交你拥有此版权的证明--------\n\n 电影:%@\n剧情id:%@\n投诉人id:%@\n投诉昵称:%@\n",stageInfo.movieInfo.name,stageInfo.Id,usercenter.user_id,usercenter.username];

    [picker setTitle:@"@版权问题"];
    [picker setSubject:@"版权投诉"];
    [picker setMessageBody:emailBody isHTML:NO];
    [self presentViewController:picker animated:YES completion:nil];
    //        [self.navigationController presentViewController:picker animated:YES completion:nil];
    //        [self.navigationController pushViewController:picker animated:YES];
}
-(void)launchMailAppOnDevice
{
    NSString *recipients = @"mailto:dcj3sjt@gmail.com&subject=Pocket Truth or Dare Support";
    NSString *body = @"&body=email body!";
    NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
    email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}
// 2. Displays an email composition interface inside the application. Populates all the Mail fields.

#pragma mark - 协议的委托方法

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    NSString *msg;
    switch (result)
    {
        case MFMailComposeResultCancelled:
            msg = @"邮件发送取消";//@"邮件发送取消";
            break;
        case MFMailComposeResultSaved:
            msg = @"邮件保存成功";//@"邮件保存成功";
            break;
        case MFMailComposeResultSent:
            msg = @"邮件发送成功";//@"邮件发送成功";
            break;
        case MFMailComposeResultFailed:
            msg = @"邮件发送失败";//@"邮件发送失败";
            break;
        default:
            msg = @"邮件未发送";
            break;
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
}




//重新布局markview
-(void)layoutMarkViewWithMarkView:(MarkView  *) markView WeiboInfo:(weiboInfoModel *) weibodict
{
#pragma mark   缩放整体的弹幕大小
    [Function BasicAnimationwithkey:@"transform.scale" Duration:0.25 repeatcont:1 autoresverses:YES fromValue:1.0 toValue:1.05 View:markView];
    
    
    //NSLog(@" 点赞 后 微博dict  ＝====uped====%@    ups===%@",weibodict.uped,weibodict.ups);
    
    NSString  *weiboTitleString=weibodict.content;
    NSString  *UpString=[NSString stringWithFormat:@"%@",weibodict.like_count];//weibodict.ups;
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
    if(IsIphone6plus)
    {
        markViewWidth=markViewWidth+10;
        markViewHeight=markViewHeight+4;
    }
#pragma mark 设置气泡的大小和位置
    markView.frame=CGRectMake(markView.frame.origin.x, markView.frame.origin.y, markViewWidth, markViewHeight);
    if (weibodict.tagArray.count>0) {
        markView.frame=CGRectMake(markView.frame.origin.x, markView.frame.origin.y, markViewWidth, markViewHeight+TagHeight+6);
    }

#pragma mark 设置标签的内容
    // markView.TitleLable.text=weiboTitleString;
    markView.ZanNumLable.text =[NSString stringWithFormat:@"%@",weibodict.like_count];
    if ([weibodict.like_count intValue]==0) {
        markView.ZanNumLable.hidden=YES;
    }
    else
    {
        markView.ZanNumLable.hidden=NO;
    }
    
}
#pragma mark ---UIScrollerViewDelegate
//滑倒最顶部的时候执行这个
/*-(void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    Navview.backgroundColor=[[UIColor whiteColor]  colorWithAlphaComponent:0];
    [backBtn setImage:[UIImage imageNamed:@"back_Icon.png"] forState:UIControlStateNormal];
    [upLoadimageBtn setImage:[UIImage imageNamed:@"update_picture_whaite.png"] forState:UIControlStateNormal];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y<80) {
        Navview.backgroundColor=[[UIColor whiteColor] colorWithAlphaComponent:0];
        [backBtn setImage:[UIImage imageNamed:@"back_Icon.png"] forState:UIControlStateNormal];
        [upLoadimageBtn setImage:[UIImage imageNamed:@"update_picture_whaite.png"] forState:UIControlStateNormal];

    }
     else if (scrollView.contentOffset.y>80&&scrollView.contentOffset.y<scrollView.contentOffset.y<300) {
        //在80的时候为0 在300的时候为1
        float compoent =((scrollView.contentOffset.y)-80)/220;
        Navview.backgroundColor=[[UIColor whiteColor] colorWithAlphaComponent:compoent];
        
         if (scrollView.contentOffset.y>160) {
             
             [backBtn setImage:[UIImage imageNamed:@"back_icon_blue.png"] forState:UIControlStateNormal];
             [upLoadimageBtn setImage:[UIImage imageNamed:@"up_picture_blue@2x.png"] forState:UIControlStateNormal];
         }
    }
    else
    {
        Navview.backgroundColor=[[UIColor whiteColor] colorWithAlphaComponent:1];
        [backBtn setImage:[UIImage imageNamed:@"back_icon_blue.png"] forState:UIControlStateNormal];
        [upLoadimageBtn setImage:[UIImage imageNamed:@"up_picture_blue@2x.png"] forState:UIControlStateNormal];
    }
}*/
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RefreshMovieDeatail" object:nil];

}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
