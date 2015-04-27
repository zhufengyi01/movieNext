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
@interface TagToStageViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate>
{
    LoadingView   *loadView;
    int page;
    int pageSize;
    int pageCount;

}
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
    
}
-(void)initData
{
    page=1;
    pageSize=12;
    _dataArray=[[NSMutableArray alloc]init];
    
    
}
-(void)initUI
{
    
    UICollectionViewFlowLayout    *layout=[[UICollectionViewFlowLayout alloc]init];
    layout.minimumInteritemSpacing=20; //cell之间左右的
    layout.minimumLineSpacing=20;      //cell上下间隔
    //layout.itemSize=CGSizeMake(80,140);  //cell的大小
    layout.sectionInset=UIEdgeInsetsMake(10, 20, 10, 20); //整个偏移量 上左下右
    
    _myConllectionView =[[UICollectionView alloc]initWithFrame:CGRectMake(0, 40,kDeviceWidth, kDeviceHeight-40-kHeightNavigation-kHeigthTabBar) collectionViewLayout:layout];
    _myConllectionView.backgroundColor=[UIColor whiteColor];
    [_myConllectionView registerClass:[TagToStageViewController class] forCellWithReuseIdentifier:@"tagCell"];
    _myConllectionView.delegate=self;
    _myConllectionView.dataSource=self;
    [self.view addSubview:_myConllectionView];

}

-(void)requestData
{
    UserDataCenter *usercenter=[UserDataCenter shareInstance];
    
    NSDictionary *parameters = @{@"tag_id":self.tagInfo.tagDetailInfo.Id,@"user_id":usercenter.user_id};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *urlString =[NSString stringWithFormat:@"%@/tag-stage/list?per-page=%d&page=%d", kApiBaseUrl,pageSize,page];
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject  objectForKey:@"code"]  intValue]==0) {
            if ([[responseObject objectForKey:@"models"] count]>0) {
                NSMutableArray  *detailArray =[responseObject objectForKey:@"models"];
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
                                    
                                    [weiboarray addObject:weiboarray];
                                }
                                
                            }
                            
                            model.stageInfo=stagemodel;
                            
                        }
                        
                        [self.dataArray addObject:model];
                    }
                
                }
            }
            else
            {
                
            }
            
        
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

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
    
    TapStageCollectionViewCell   *cell=(TapStageCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"tagCell" forIndexPath:indexPath];
    if (self.dataArray.count > indexPath.row) {
        
         cell.imageView.backgroundColor=VStageView_color;
//        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@!w340h340",kUrlStage,model.photo]] placeholderImage:[UIImage imageNamed:nil]];
//        if ( model.weibosArray.count>0) {
//            cell.titleLab.hidden = NO;
//            cell.titleLab.text=[NSString stringWithFormat:@"%ld", model.weibosArray.count];
    }
    return cell;
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
         return CGSizeMake((kDeviceWidth-10)/3,(kDeviceWidth-10)/3);
    
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
     return UIEdgeInsetsMake(0,0, 5,0);
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
