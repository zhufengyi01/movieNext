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
#import "HotMovieModel.h"
#import "StageInfoModel.h"
#import "WeiboModel.h"
#import "MyViewController.h"
#import "ButtomToolView.h"
#import "HotMovieModel.h"
#import "UMShareView.h"
#import "MJRefresh.h"
#import "UserDataCenter.h"
#import "UMShareView.h"
#import "ShowStageViewController.h"
#import "UploadImageViewController.h"
#import "UpYun.h"

@interface MovieDetailViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,MovieHeadViewDelegate,StageViewDelegate,ButtomToolViewDelegate,UMSocialUIDelegate,UMSocialDataDelegate,UMShareViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate>

{
    ///UICollectionView    *_myConllectionView;
    UICollectionViewFlowLayout    *layout;
    LoadingView         *loadView;
    NSMutableArray      *_dataArray;
    NSMutableDictionary       *_MovieDict;
    BOOL bigModel;
    ButtomToolView *_toolBar;
    MarkView       *_mymarkView;
    BOOL   isMarkViewsShow;
    UMShareView   *shareView;
    int page;
    //导航条
    UIView *Navview;
    //上传图片的按钮
    UIButton  *upLoadimageBtn;
    // 返回按钮
    UIButton  *backBtn;
    StageInfoModel  *_TStageInfo;
    WeiboModel      *_TweiboInfo;


}

@end

@implementation MovieDetailViewController
-(void)viewWillAppear:(BOOL)animated
{
    //下面透明度的设置，效果是设置了导航条的高度的多少倍，不是透明度多少
  ///  self.navigationController.navigationBar.alpha=0.4;
    self.navigationController.navigationBar.hidden=YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestMovieData) name:@"RefreshMovieDeatail" object:nil];


}
-(void)viewDidAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden=YES;
    self.navigationController.navigationBar.hidden=YES;


}
-(void)requestMovieData
{
    page=0;
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
    [self creatLoadView];
    if (self.pageSourceType==NSMovieSourcePageSearchListController) { //电影搜索页面进来的
        page=0;
        [self requestMovieIdWithdoubanId];
    }
    else
    {
        // 从电影列表页进来的
        page=0;
        [self requestMovieInfoData];
        [self requestData];
    }
    [self createNavigation];
    [self createToolBar];
    [self createShareView];
  
}

//创建可以显示隐藏的导航条
-(void)createNavigation
{
    
    Navview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 64)];
    Navview.userInteractionEnabled=YES;
    Navview.backgroundColor=[[UIColor whiteColor] colorWithAlphaComponent:0];
    [_myConllectionView bringSubviewToFront:Navview];
    [self.view addSubview:Navview];
    
    backBtn=[ZCControl createButtonWithFrame:CGRectMake(10,26,60,32) ImageName:nil Target:self Action:@selector(NavigationClick:) Title:nil];
    backBtn.tag=200;
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -40, 0, 0)];
    //  backBtn.backgroundColor=[UIColor redColor];
    [backBtn setImage:[UIImage imageNamed:@"back_Icon@2x.png"] forState:UIControlStateNormal];
    [self.view addSubview:backBtn];
    
    upLoadimageBtn=[ZCControl createButtonWithFrame:CGRectMake(kDeviceWidth-70,30,60,25) ImageName:@"update_picture_whaite@2x.png" Target:self Action:@selector(NavigationClick:) Title:nil];
    upLoadimageBtn.tag=201;
    [self.view addSubview:upLoadimageBtn];
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
      UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
       // UIImage  *image=[UIImage imageNamed:@"choice_icon@2x.png"];
         NSLog(@" image   =%@=== Imagesize  higth  =%f width ====%f   ",image,image.size.height,image.size.width);
        [self dismissViewControllerAnimated:NO completion:^{
            
            UploadImageViewController  *upload=[[UploadImageViewController alloc]init];
            upload.upimage=image;
            upload.movie_Id =[_MovieDict objectForKey:@"id"];
            [self.navigationController pushViewController:upload animated:YES];
        }];
    
    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"您取消了选择图片");
   // [picker dismissModalViewControllerAnimated:YES];
    [picker dismissViewControllerAnimated:YES completion:nil];
}


-(void)initData
{
    //page=0;
    bigModel=YES;
    isMarkViewsShow=YES;
    _MovieDict=[[NSMutableDictionary alloc]init];
    _dataArray =[[NSMutableArray alloc]init];
    
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
    //kDeviceHeight/3-45+44
    
    _myConllectionView =[[UICollectionView alloc]initWithFrame:CGRectMake(0, -200,kDeviceWidth, kDeviceHeight+kHeightNavigation+180) collectionViewLayout:layout];
    [layout setHeaderReferenceSize:CGSizeMake(_myConllectionView.frame.size.width, kDeviceHeight/3+64+180)];

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
    
   // [self setupHeadView];
    [self setupFootView];
    

}

/*
 - (void)setupHeadView
{
    page=0;
    __unsafe_unretained typeof(self) vc = self;
    if (_dataArray.count>0) {
        [_dataArray removeAllObjects];
    }
    // 添加下拉刷新头部控件
    [_myConllectionView addHeaderWithCallback:^{
        // 进入刷新状态就会回调这个Block
        
        // 增加5条假数据
        //for (int i = 0; i<5; i++) {
        //  [vc.fakeColors insertObject:MJRandomColor atIndex:0];
        //}
        [vc requestData];
        
        // 模拟延迟加载数据，因此2秒后才调用）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [vc.myConllectionView reloadData];
            // 结束刷新
            [vc.myConllectionView headerEndRefreshing];
        });
    }];
    
#warning 自动刷新(一进入程序就下拉刷新)
    [vc.myConllectionView headerBeginRefreshing];
}*/

- (void)setupFootView
{
    
    __unsafe_unretained typeof(self) vc = self;
    // 添加上拉刷新尾部控件
    [vc.myConllectionView addFooterWithCallback:^{
        // 进入刷新状态就会回调这个Block
        
        // 增加5条假数据
        ///  for (int i = 0; i<5; i++) {
        //   [vc.fakeColors addObject:MJRandomColor];
        //}
        page=page+1;
        [vc requestData];
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
    [self.view addSubview:loadView];
}
//创建底部的视图
-(void)createToolBar
{
    _toolBar=[[ButtomToolView alloc]initWithFrame:CGRectMake(0,0,kDeviceWidth,kDeviceHeight+64)];
    _toolBar.delegete=self;
}
-(void)createShareView
{
    shareView=[[UMShareView alloc]initWithFrame:CGRectMake(0,0, kDeviceWidth, kDeviceHeight+64)];
    shareView.delegate=self;
}



#pragma  mark  ----RequestData
#pragma  mark  ---
//举报某人
-(void)requestReport
{
    NSString *type=@"1";
    UserDataCenter *userCenter =[UserDataCenter shareInstance];
    NSDictionary *parameters = @{@"reported_user_id":_TweiboInfo.user_id,@"reported_id":_TweiboInfo.Id,@"reason":@"",@"type":type,@"created_by":userCenter.user_id};
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/report/create", kApiBaseUrl] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject  objectForKey:@"return_code"]  intValue]==10000) {
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
        if ([[responseObject  objectForKey:@"return_code"]  intValue]==10000) {
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
        if ([[responseObject  objectForKey:@"return_code"]  intValue]==10000) {
            NSLog(@"推荐成功=======%@",responseObject);
            UIAlertView  *Al=[[UIAlertView alloc]initWithTitle:nil message:@"变身成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [Al show];
            _TweiboInfo.user_id=[dict objectForKey:@"id"];
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
    NSDictionary *parameters = @{@"id":_TweiboInfo.Id,@"stage_id":_TStageInfo.Id};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/weibo/remove", kApiBaseUrl] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject  objectForKey:@"return_code"]  intValue]==10000) {
            NSLog(@"删除数据成功=======%@",responseObject);
            UIAlertView  *Al=[[UIAlertView alloc]initWithTitle:nil message:@"删除成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [Al show];
            [self requestData];
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
        NSLog(@"responseobject = %@", responseObject);
        NSDictionary *detail = [responseObject objectForKey:@"detail"];
        NSString * movie_id = [detail objectForKey:@"id"];
        if (movie_id && [movie_id intValue]>0) {
            self.movieId = movie_id;
        }
        [self requestMovieInfoData];
        [self requestData];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

}

//根据电影id 请求电影的详细信息
-(void)requestMovieInfoData
{
    if (!_movieId || _movieId<=0) {
        return;
    }
    NSDictionary *parameter = @{@"id": self.movieId};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/movie/info", kApiBaseUrl] parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"  电影详情页面的电影信息数据JSON: %@", responseObject);
        if (_MovieDict ==nil) {
            _MovieDict=[[NSMutableDictionary alloc]init];
        }
        _MovieDict =[NSMutableDictionary dictionaryWithDictionary:[responseObject  objectForKey:@"detail"]];
        //[self requestData];
        
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
    UserDataCenter  *userCenter =[UserDataCenter shareInstance];

    NSDictionary *parameter = @{@"movie_id": _movieId, @"page":[NSString stringWithFormat:@"%d",page], @"user_id": userCenter.user_id};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/movieStage/list", kApiBaseUrl] parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"  电影详情页面数据JSON: %@", responseObject);
        NSMutableArray  *detailArray=[responseObject objectForKey:@"detail"];
        [loadView stopAnimation];
        [loadView removeFromSuperview];
        
        if (_dataArray==nil) {
            _dataArray=[[NSMutableArray alloc]init];
        }
        for (NSDictionary  *movieDict in detailArray) {
            HotMovieModel *model=[[HotMovieModel alloc]init];
            if (model) {
                [model setValuesForKeysWithDictionary:movieDict];
                StageInfoModel  *stageModel=[[StageInfoModel alloc]init];
                [stageModel setValuesForKeysWithDictionary:[movieDict objectForKey:@"stageinfo"]];
                model.stageinfo=stageModel;
              
                NSMutableArray  *weibosArray=[[NSMutableArray alloc]init];
                for (NSDictionary  *weiboDict in [movieDict objectForKey:@"weibos"]) {
                    WeiboModel  *weibomodel=[[WeiboModel alloc]init];
                    if (weibomodel) {
                        [weibomodel setValuesForKeysWithDictionary:weiboDict];
                        [weibosArray addObject:weibomodel];
                    }
                }
                model.weibos=weibosArray;
                
            }
            [_dataArray addObject:model];
           
            
        }
        
        [_myConllectionView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}
#pragma  mark -----
#pragma  mark ------  DataRequest
#pragma  mark ----
//微博点赞请求
-(void)LikeRequstData:(WeiboModel  *) weiboDict StageInfo :(StageInfoModel *) stageInfoDict
{
    
    UserDataCenter  *userCenter=[UserDataCenter shareInstance];
    NSString  *movieId=[_MovieDict objectForKey:@"id"];
    NSString  *movieName=[_MovieDict objectForKey:@"name"];
    NSDictionary *parameters = @{@"weibo_id":weiboDict.Id, @"stage_id":stageInfoDict.Id,@"movie_id":movieId,@"movie_name":movieName,@"user_id":userCenter.user_id,@"author_id":weiboDict.user_id,@"operation":weiboDict.uped};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/weiboUp/up", kApiBaseUrl] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject  objectForKey:@"return_code"]  intValue]==10000) {
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
    //在这里先将内容给清除一下, 然后再加载新的, 添加完内容之后先动画, 在cell消失的时候做清理工作
    //NSDictionary *dict = [_dataArray objectAtIndex:(indexPath.row)];
    HotMovieModel  *model=[_dataArray objectAtIndex:indexPath.row];
    if (bigModel ==YES) {
        BigImageCollectionViewCell *cell = (BigImageCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"bigcell" forIndexPath:indexPath];
        if (_dataArray.count>indexPath.row) {
            cell.WeibosArray=model.weibos;
            cell.backgroundColor=View_BackGround;
            cell.StageInfoDict=model.stageinfo;
            [cell ConfigCellWithIndexPath:indexPath.row];
            cell.StageView.delegate=self;
          
        }
        [cell.StageView startAnimation];
          // [cell.StageView performSelector:@selector(startAnimation) withObject:nil afterDelay:1];
        return cell;
    } else {
        SmallImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"smallcell" forIndexPath:indexPath];
        cell.imageView.backgroundColor=VStageView_color;
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@!w340h340",kUrlStage,model.stageinfo.stage]] placeholderImage:[UIImage imageNamed:nil]];
        if (model.stageinfo.marks && [model.stageinfo.marks intValue]>0) {
            cell.titleLab.hidden = NO;
            cell.titleLab.text=[NSString stringWithFormat:@"%@",  model.stageinfo.marks];
        } else {
            cell.titleLab.hidden = YES;
        }
        
        return cell;
    }
    
    return nil;
}
//点击小图模式的时候，跳转到大图模式
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (bigModel==YES&&collectionView==_myConllectionView) {
        //点击cell 隐藏弹幕，再点击隐藏
        NSLog(@"didDeselectRowAtIndexPath  =====%ld",indexPath.row);
        BigImageCollectionViewCell   *cell=(BigImageCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        if (isMarkViewsShow==YES) {
            isMarkViewsShow=NO;
            [cell.StageView  hidenAndShowMarkView:YES];
            
        } else{
            isMarkViewsShow=YES;
            [cell.StageView  hidenAndShowMarkView:NO];
        }
    } else {
        ShowStageViewController *vc = [[ShowStageViewController alloc] init];
        HotMovieModel  *model=[_dataArray objectAtIndex:indexPath.row];
        if ([_MovieDict objectForKey:@"name"]) {
            model.stageinfo.movie_name=[_MovieDict objectForKey:@"name"];
        }
        if ([_MovieDict objectForKey:@"id"]) {
            model.stageinfo.movie_id=[_MovieDict objectForKey:@"id"];
        }
        vc.movieModel = model;
        [self.navigationController pushViewController:vc animated:YES];
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
    HotMovieModel  *model =[_dataArray objectAtIndex:indexPath.row];
    if (bigModel==YES) {
        float hight;
        if (_dataArray.count>indexPath.row) {
            float  h= [model.stageinfo.h  floatValue];
            float w=[model.stageinfo.w floatValue];
             hight= kDeviceWidth+45;
             if(h>w)
            {
                hight=  (h/w) *kDeviceWidth+45;
            }
        }
        return CGSizeMake(kDeviceWidth,hight+10);
    }
    else
    {
        return CGSizeMake(( kDeviceWidth-10)/3,(kDeviceWidth-10)/3);

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
    else if (button.tag==201)
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.delegate = self;
        //设置选择后的图片可被编辑
        picker.allowsEditing = YES;
        [self presentViewController:picker animated:YES completion:nil];
    }
}

//分享
-(void)ScreenButtonClick:(UIButton  *) button
{
    
    NSLog(@" ==ScreenButtonClick  ====%ld",button.tag);
    //获取cell
#pragma mark 暂时把sharetext设置成null
    HotMovieModel  *hotmovie;
    hotmovie =[_dataArray objectAtIndex:button.tag-2000];
    float hight= kDeviceWidth;
    float  ImageWith=[hotmovie.stageinfo.w intValue];
    float  ImgeHight=[hotmovie.stageinfo.h intValue];
    if(ImgeHight>ImageWith)
    {
        hight=  (ImgeHight/ImageWith) *kDeviceWidth;
    }
    BigImageCollectionViewCell *cell = (BigImageCollectionViewCell *)(button.superview.superview.superview);
    UIImage  *image=[Function getImage:cell.StageView WithSize:CGSizeMake(kDeviceWidth, hight)];
    
    //创建UMshareView 后必须配备这三个方法
    hotmovie.stageinfo.movie_name=[_MovieDict objectForKey:@"name"];
    shareView.StageInfo=hotmovie.stageinfo;
    shareView.screenImage=image;
    [shareView configShareView];
    [self.view addSubview:shareView];
    self.tabBarController.tabBar.hidden=YES;
    if ([shareView respondsToSelector:@selector(showShareButtomView)]) {
        [shareView showShareButtomView];
        
    }
    
}
#pragma  mark  -----UMButtomViewshareViewDlegate-------
-(void)UMshareViewHandClick:(UIButton *)button ShareImage:(UIImage *)shareImage MoviewModel:(StageInfoModel *)StageInfo
{
    NSArray  *sharearray =[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQzone, UMShareToSina, nil];
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
    
    [[UMSocialControllerService defaultControllerService] setShareText:StageInfo.movie_name shareImage:shareImage socialUIDelegate:self];        //设置分享内容和回调对象
    [UMSocialSnsPlatformManager getSocialPlatformWithName:[sharearray  objectAtIndex:button.tag-10000]].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
    NSLog(@"分享到微信");
    self.tabBarController.tabBar.hidden=YES;
    if (shareView) {
        [shareView HidenShareButtomView];
        [shareView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.5];
        
    }
}
///点击分享的屏幕，收回分享的背景
-(void)SharetopViewTouchBengan
{
    NSLog(@"controller touchbegan  中 执行了隐藏工具栏的方法");
    //取消当前的选中的那个气泡
    [_mymarkView CancelMarksetSelect];
    if (shareView) {
        [shareView HidenShareButtomView];
        [shareView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.5];
        self.tabBarController.tabBar.hidden=YES;
        
    }
    
}
#pragma mark  --umShareDelegate

-(void)didCloseUIViewController:(UMSViewControllerType)fromViewControllerType
{
    //返回到app执行的方法，移除的时候应该写在这里
    NSLog(@"didCloseUIViewController第一步执行这个");
    if (shareView) {
        [shareView removeFromSuperview];
        
    }
    
}
//根据有的view 上次一张图片
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    NSLog(@"didFinishGetUMSocialDataInViewController第二部执行这个");
    if (shareView) {
        [shareView removeFromSuperview];
    }
    
}
-(void)didFinishGetUMSocialDataResponse:(UMSocialResponseEntity *)response;
{
    NSLog(@"didFinishGetUMSocialDataResponse第二部执行这个");
    if (shareView) {
        [shareView removeFromSuperview];
    }
    
    
}


//点击增加弹幕
-(void)addMarkButtonClick:(UIButton  *) button
{
    NSLog(@" ==addMarkButtonClick  ====%d",button.tag);
    AddMarkViewController  *AddMarkVC=[[AddMarkViewController alloc]init];
    HotMovieModel  *model =[_dataArray objectAtIndex:button.tag-3000];
    AddMarkVC.stageInfoDict = model.stageinfo;//[dict valueForKey:@"stageinfo"];
   // AddMarkVC.pageSoureType=NSAddMarkPageSourceDefault;
    [self.navigationController pushViewController:AddMarkVC animated:NO];
    
}



#pragma mark  -----
#pragma mark  ---StaegViewDelegate
#pragma mark  ----
-(void)StageViewHandClickMark:(WeiboModel *)weiboDict withmarkView:(id)markView StageInfoDict:(StageInfoModel *)stageInfoDict
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
-(void)SetToolBarValueWithDict:(WeiboModel  *)weiboDict markView:(id) markView isSelect:(BOOL ) isselect StageInfo:(StageInfoModel *) stageInfo
{
    //先对它赋值，然后让他弹出到界面
    if (isselect==YES) {
        NSLog(@" new viewController SetToolBarValueWithDict  执行了出现工具栏的方法");
        
        //设置工具栏的值
        //[_toolBar setToolBarValue:weiboDict :markView WithStageInfo:stageInfo];
        _toolBar.weiboDict=weiboDict;
        _toolBar.StageInfoDict=stageInfo;
        _toolBar.markView=markView;
        [_toolBar configToolBar];
        
        //把工具栏添加到当前视图
        self.tabBarController.tabBar.hidden=YES;
        [self.view addSubview:_toolBar];
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
-(void)ToolViewHandClick:(UIButton *)button :(MarkView *)markView weiboDict:(WeiboModel *)weiboDict StageInfo:(StageInfoModel *)stageInfoDict
{
    NSLog(@"点击头像  微博dict  ＝====%@ ======出现的stageinfo  ＝＝＝＝＝＝%@",weiboDict,stageInfoDict);
    
    _TStageInfo=stageInfoDict;
    _TweiboInfo=weiboDict;
    

    if (button.tag==10000) {
        ///点击了头像//进入个人页面
        NSLog(@"点击头像  微博dict  ＝====%@ ======出现的stageinfo  ＝＝＝＝＝＝%@",weiboDict,stageInfoDict);
        MyViewController   *myVc=[[MyViewController alloc]init];
        myVc.author_id=weiboDict.user_id;
        [self.navigationController pushViewController:myVc animated:YES];

        
        
    }
#pragma mark     -----------分享
    else if (button.tag==10001)
    {
        //点击了分享
    
    //    NSString  *shareText=weiboDict.topic;//[weiboDict objectForKey:@"topic"];
        NSLog(@" 点击了分享按钮");
        
        float hight= kDeviceWidth;
        float  ImageWith=[stageInfoDict.w intValue]; //[[self.StageInfoDict objectForKey:@"w"]  floatValue];
        float  ImgeHight=[stageInfoDict.h intValue];//[[self.StageInfoDict objectForKey:@"h"]  floatValue];
        if(ImgeHight>ImageWith)
        {
            hight=  (ImgeHight/ImageWith) *kDeviceWidth;
        }
        
        BigImageCollectionViewCell *cell = (BigImageCollectionViewCell *)(markView.superview.superview.superview);
        UIImage  *image=[Function getImage:cell.StageView WithSize:CGSizeMake(kDeviceWidth, hight)];
        

        //创建UMshareView 后必须配备这三个方法
        stageInfoDict.movie_name=[_MovieDict objectForKey:@"name"];
        shareView.StageInfo=stageInfoDict;
        shareView.screenImage=image;
        [shareView configShareView];
        [self.view addSubview:shareView];
        self.tabBarController.tabBar.hidden=YES;
        if ([shareView respondsToSelector:@selector(showShareButtomView)]) {
            [shareView showShareButtomView];
            
        }

        
    }
#pragma mark  ----------点赞--------------
    else  if(button.tag==10002)
    {
        //改变赞的状态
        //点击了赞
        
        NSLog(@" 点赞 前 微博dict  ＝====uped====%@    ups===%@",weiboDict.uped,weiboDict.ups);
        if ([weiboDict.uped intValue]==0)
        {
            weiboDict.uped=[NSNumber numberWithInt:1];
            int ups=[weiboDict.ups intValue];
            ups =ups+[weiboDict.uped intValue];
            weiboDict.ups=[NSNumber numberWithInt:ups];
            //重新给markview 赋值，改变markview的frame
            [self layoutMarkViewWithMarkView:markView WeiboInfo:weiboDict];
            
            
            
        }
        else  {
            
            weiboDict.uped=[NSNumber numberWithInt:0];
            int ups=[weiboDict.ups intValue];
            ups =ups-1;
            weiboDict.ups=[NSNumber numberWithInt:ups];
            [self layoutMarkViewWithMarkView:markView WeiboInfo:weiboDict];
        }
        
#warning    暂时屏蔽了上传网络服务器请求
        ////发送到服务器
        [self LikeRequstData:weiboDict StageInfo:stageInfoDict];
        
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

#pragma mark  ----actionSheetDelegate--
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (actionSheet.tag==500) {
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
#warning  确定举报  未实现

    else if(actionSheet.tag==504)
    {
        if (buttonIndex==0) {
            //弹出确认举报
            [self requestReport];
            
        }
    }
}



//重新布局markview
-(void)layoutMarkViewWithMarkView:(MarkView  *) markView WeiboInfo:(WeiboModel *) weibodict
{
    
    
    NSLog(@" 点赞 后 微博dict  ＝====uped====%@    ups===%@",weibodict.uped,weibodict.ups);
    //float  x=[weibodict.x floatValue];
    //float  y=[weibodict.y floatValue];
        [Function BasicAnimationwithkey:@"transform.scale" Duration:0.25 repeatcont:1 autoresverses:YES fromValue:1.0 toValue:1.05 View:markView];
    NSString  *weiboTitleString=weibodict.topic;
    NSString  *UpString=[NSString stringWithFormat:@"%@",weibodict.ups];//weibodict.ups;
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
    if(IsIphone6)
    {
        markViewWidth=markViewWidth+10;
        markViewHeight=markViewHeight+4;
    }
#pragma mark 设置气泡的大小和位置
    markView.frame=CGRectMake(markView.frame.origin.x, markView.frame.origin.y, markViewWidth, markViewHeight);
#pragma mark 设置标签的内容
    // markView.TitleLable.text=weiboTitleString;
    markView.ZanNumLable.text =[NSString stringWithFormat:@"%@",weibodict.ups];
    if ([weibodict.ups intValue]==0) {
        markView.ZanNumLable.hidden=YES;
    }
    else
    {
        markView.ZanNumLable.hidden=NO;
    }
    
}
#pragma mark  -----
#pragma mark  -------隐藏工具栏的方法
#pragma mark  -------
//点击屏幕，隐藏工具栏

-(void)topViewTouchBengan
{
    NSLog(@"controller touchbegan  中 执行了隐藏工具栏的方法");
    //取消当前的选中的那个气泡
    [_mymarkView CancelMarksetSelect];
    self.tabBarController.tabBar.hidden=YES;
    if (_toolBar) {
        [_toolBar HidenButtomView];
        //  [_toolBar performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.5];
        [_toolBar removeFromSuperview];
    }
}
#pragma mark ---UIScrollerViewDelegate
//滑倒最顶部的时候执行这个
-(void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    Navview.backgroundColor=[[UIColor whiteColor]  colorWithAlphaComponent:0];
    [backBtn setImage:[UIImage imageNamed:@"back_Icon@2x.png"] forState:UIControlStateNormal];
    [upLoadimageBtn setImage:[UIImage imageNamed:@"update_picture_whaite@2x.png"] forState:UIControlStateNormal];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y<80) {
        Navview.backgroundColor=[[UIColor whiteColor] colorWithAlphaComponent:0];
        [backBtn setImage:[UIImage imageNamed:@"back_Icon@2x.png"] forState:UIControlStateNormal];
        [upLoadimageBtn setImage:[UIImage imageNamed:@"update_picture_whaite@2x.png"] forState:UIControlStateNormal];

    }
     else   if (scrollView.contentOffset.y>80&&scrollView.contentOffset.y<scrollView.contentOffset.y<300) {
        //在80的时候为0 在300的时候为1
        float compoent =((scrollView.contentOffset.y)-80)/220;
        Navview.backgroundColor=[[UIColor whiteColor] colorWithAlphaComponent:compoent];
        
         if (scrollView.contentOffset.y>160) {
             
             [backBtn setImage:[UIImage imageNamed:@"back_icon_blue@2x.png"] forState:UIControlStateNormal];
             [upLoadimageBtn setImage:[UIImage imageNamed:@"up_picture_blue@2x.png"] forState:UIControlStateNormal];
         }
    }
    else
    {
        Navview.backgroundColor=[[UIColor whiteColor] colorWithAlphaComponent:1];
        [backBtn setImage:[UIImage imageNamed:@"back_icon_blue@2x.png"] forState:UIControlStateNormal];
        [upLoadimageBtn setImage:[UIImage imageNamed:@"up_picture_blue@2x.png"] forState:UIControlStateNormal];
    }
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RefreshMovieDeatail" object:nil];

}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
