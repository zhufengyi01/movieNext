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
#import "ShowStageViewController.h"
@interface MovieDetailViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,MovieHeadViewDelegate,StageViewDelegate,ButtomToolViewDelegate>
{
    UICollectionView    *_myConllectionView;
    UICollectionViewFlowLayout    *layout;
    LoadingView         *loadView;
    NSMutableArray      *_dataArray;
    NSMutableDictionary       *_MovieDict;
    BOOL bigModel;
    ButtomToolView *_toolBar;
    MarkView       *_mymarkView;
    BOOL   isMarkViewsShow;

}

@end

@implementation MovieDetailViewController
-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden=YES;
    self.navigationController.navigationBar.hidden=NO;
    //下面透明度的设置，效果是设置了导航条的高度的多少倍，不是透明度多少
    self.navigationController.navigationBar.alpha=0.4;
  
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNavigation];
    [self initData];
    [self initUI];
    [self creatLoadView];
    if (self.pageSourceType==NSMovieSourcePageSearchListController) { //电影搜索页面进来的
        [self requestMovieIdWithdoubanId];
    }
    else
    {
        [self requestMovieInfoData];
        [self requestData];

    }
    [self createToolBar];


}
-(void)createNavigation
{
//  UILabel  *titleLable=[ZCControl createLabelWithFrame:CGRectMake(0, 0, 100, 20) Font:16 Text:@"电影详细"];
   // titleLable.textColor=VBlue_color;
    
   // titleLable.font=[UIFont boldSystemFontOfSize:16];
   //titleLable.textAlignment=NSTextAlignmentCenter;
   // self.navigationItem.titleView=titleLable;
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
    [layout setHeaderReferenceSize:CGSizeMake(_myConllectionView.frame.size.width, kDeviceHeight/3+64)];
    
    _myConllectionView =[[UICollectionView alloc]initWithFrame:CGRectMake(0, -64,kDeviceWidth, kDeviceHeight+20+kHeightNavigation) collectionViewLayout:layout];
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
//创建底部的视图
-(void)createToolBar
{
    _toolBar=[[ButtomToolView alloc]initWithFrame:CGRectMake(0,0,kDeviceWidth,kDeviceHeight)];
    _toolBar.delegete=self;
}


#pragma  mark  ----RequestData
#pragma  mark  ---
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
           //cell.pageType=NSPageSourceTypeMyAddedViewController;
          //  小闪动标签的数组
           // cell.WeibosArray=[[_dataArray objectAtIndex:indexPath.row]  objectForKey:@"weibos"];
            cell.WeibosArray=model.weibos;
            cell.StageInfoDict=model.stageinfo;//[[_dataArray objectAtIndex:indexPath.row]  objectForKey:@"stageinfo"];
            [cell ConfigCellWithIndexPath:indexPath.row];
            cell.StageView.delegate=self;
          //  [cell setCellValue:;
        }
          [cell.StageView performSelector:@selector(startAnimation) withObject:nil afterDelay:1];
        //cell.backgroundColor = [UIColor redColor];
        return cell;
    } else {
        SmallImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"smallcell" forIndexPath:indexPath];
        //cell.backgroundColor = [UIColor redColor];
        
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@!w340h340",kUrlStage,model.stageinfo.stage]] placeholderImage:[UIImage imageNamed:@"loading_image_all.png"]];
        if (model.stageinfo.marks) {
            cell.titleLab.text=[NSString stringWithFormat:@"%@",  model.stageinfo.marks];

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
        vc.movieModel = model;
        [self.navigationController presentViewController:vc animated:NO completion:^{ }];
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
            float  h= [model.stageinfo.h  floatValue]; // [[[[_dataArray  objectAtIndex:indexPath.row]  objectForKey:@"stageinfo"] objectForKey:@"h"] floatValue];
            float w=[model.stageinfo.w floatValue];   //[[[[_dataArray  objectAtIndex:indexPath.row]  objectForKey:@"stageinfo"] objectForKey:@"w"] floatValue];
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
        //NSLog(@"============  hight  for  row  =====%f",hight);
        return CGSizeMake(kDeviceWidth,hight);
    }
    else
    {
        return CGSizeMake(( kDeviceWidth-20)/3,(kDeviceWidth-20)/3);

    }
    return CGSizeMake(0, 0);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (bigModel==YES) {
        return UIEdgeInsetsMake(0, 5, 5, 5);
    }
    return UIEdgeInsetsMake(5, 5, 5, 5);
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

-(void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
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
    float  ImageWith=[hotmovie.stageinfo.w intValue]; //[[self.StageInfoDict objectForKey:@"w"]  floatValue];
    float  ImgeHight=[hotmovie.stageinfo.h intValue];//[[self.StageInfoDict objectForKey:@"h"]  floatValue];
    if(ImgeHight>ImageWith)
    {
        hight=  (ImgeHight/ImageWith) *kDeviceWidth;
    }
    
    BigImageCollectionViewCell *cell = (BigImageCollectionViewCell *)(button.superview.superview.superview);
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(kDeviceWidth,hight+20), YES, [UIScreen mainScreen].scale);
    [cell.StageView drawViewHierarchyInRect:cell.StageView.bounds afterScreenUpdates:YES];
    
    // old style [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //  NSLog(@"===w =%@ ",image);
    UIImageView   *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, hight)];
    imageView.image=image;
    
    UILabel  *movieLable=[ZCControl createLabelWithFrame:CGRectMake(10,hight-20, 200, 20) Font:12 Text:@""];
       movieLable.text=[_MovieDict  objectForKey:@"name"];
    
    movieLable.textColor=VGray_color;
    [imageView addSubview:movieLable];
    
    UILabel  *logoLable=[ZCControl createLabelWithFrame:CGRectMake(kDeviceWidth-70,hight-20, 60, 20) Font:12 Text:@"影弹App"];
    //logoLable.text=hotmovie.stageinfo.movie_name;
    logoLable.textAlignment=NSTextAlignmentRight;
    logoLable.textColor=VGray_color;
    [imageView addSubview:logoLable];
    
    // [self.view addSubview:imageView];
    UIImage  *getImage=[Function getImage:imageView];
    
    NSString  *shareText=[_MovieDict  objectForKey:@"name"];
    
    
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:kUmengKey
                                      shareText:shareText
                                     shareImage: getImage
                                shareToSnsNames:[NSArray arrayWithObjects: UMShareToWechatSession, UMShareToWechatTimeline, UMShareToQzone, UMShareToSina, nil]
                                       delegate:nil];

    
}
//点击增加弹幕
-(void)addMarkButtonClick:(UIButton  *) button
{
    NSLog(@" ==addMarkButtonClick  ====%d",button.tag);
    AddMarkViewController  *AddMarkVC=[[AddMarkViewController alloc]init];
    HotMovieModel  *model =[_dataArray objectAtIndex:button.tag-3000];
    AddMarkVC.stageInfoDict = model.stageinfo;//[dict valueForKey:@"stageinfo"];
    
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
        //self.tabBarController.tabBar.hidden=YES;
        [self.view addSubview:_toolBar];
        //弹出工具栏
        [_toolBar ShowButtomView];
        
    }
    else if (isselect==NO)
    {
        //隐藏toolbar
        NSLog(@" 执行了隐藏工具栏的方法");
       // self.tabBarController.tabBar.hidden=NO;
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
    
        NSString  *shareText=weiboDict.topic;//[weiboDict objectForKey:@"topic"];
        NSLog(@" 点击了分享按钮");
        
        float hight= kDeviceWidth;
        float  ImageWith=[stageInfoDict.w intValue]; //[[self.StageInfoDict objectForKey:@"w"]  floatValue];
        float  ImgeHight=[stageInfoDict.h intValue];//[[self.StageInfoDict objectForKey:@"h"]  floatValue];
        if(ImgeHight>ImageWith)
        {
            hight=  (ImgeHight/ImageWith) *kDeviceWidth;
        }
        
        
        BigImageCollectionViewCell *cell = (BigImageCollectionViewCell *)(markView.superview.superview.superview);
        
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(kDeviceWidth, hight+20), YES, [UIScreen mainScreen].scale);
        [cell.StageView drawViewHierarchyInRect:cell.StageView.bounds afterScreenUpdates:YES];
        
        // old style [self.layer renderInContext:UIGraphicsGetCurrentContext()];
        
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        
        
        
        UIImageView   *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, hight)];
        imageView.image=image;
        
        UILabel  *movieLable=[ZCControl createLabelWithFrame:CGRectMake(10,hight-20, 200, 20) Font:12 Text:@""];
        movieLable.text=[_MovieDict  objectForKey:@"name"];
        movieLable.textColor=VGray_color;
        [imageView addSubview:movieLable];
        
        UILabel  *logoLable=[ZCControl createLabelWithFrame:CGRectMake(kDeviceWidth-70,hight-20, 60, 20) Font:12 Text:@"影弹App"];
        //logoLable.text=hotmovie.stageinfo.movie_name;
        logoLable.textAlignment=NSTextAlignmentRight;
        logoLable.textColor=VGray_color;
        [imageView addSubview:logoLable];
        UIImage  *getImage=[Function getImage:imageView];
        
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
        [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:kUmengKey
                                          shareText:shareText
                                         shareImage:getImage
                                    shareToSnsNames:[NSArray arrayWithObjects: UMShareToWechatSession, UMShareToWechatTimeline, UMShareToQzone, UMShareToSina, nil]
                                           delegate:nil];

        
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
}
//重新布局markview
-(void)layoutMarkViewWithMarkView:(MarkView  *) markView WeiboInfo:(WeiboModel *) weibodict
{
    
    
    NSLog(@" 点赞 后 微博dict  ＝====uped====%@    ups===%@",weibodict.uped,weibodict.ups);
    
    float  x=[weibodict.x floatValue];
    float  y=[weibodict.y floatValue];
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
    float markViewX = (x*kDeviceWidth)/100-markViewWidth;
    markViewX = MIN(MAX(markViewX, 1.0f), kDeviceWidth-markViewWidth-1);
    
    float markViewY = (y*kDeviceWidth)/100+(Msize.height/2);
#warning    kDeviceWidth 目前计算的是正方形的，当图片高度>屏幕的宽度的实际，需要使用图片的高度
    markViewY = MIN(MAX(markViewY, 1.0f), kDeviceWidth-markViewHeight-1);
#pragma mark 设置气泡的大小和位置
    markView.frame=CGRectMake(markViewX, markViewY, markViewWidth, markViewHeight);
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
    self.tabBarController.tabBar.hidden=NO;
    if (_toolBar) {
        [_toolBar HidenButtomView];
        //  [_toolBar performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.5];
        [_toolBar removeFromSuperview];
        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
