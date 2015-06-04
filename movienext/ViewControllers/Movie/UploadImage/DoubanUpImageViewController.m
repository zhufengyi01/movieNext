//
//  DoubanUpImageViewController.m
//  movienext
//
//  Created by 风之翼 on 15/5/7.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "DoubanUpImageViewController.h"
#import "ZCControl.h"
#import "Constant.h"
#import "AFNetworking.h"
#import "UserDataCenter.h"
#import "AddMarkViewController.h"
#import "stageInfoModel.h"
#import  "UIImageView+WebCache.h"

@interface DoubanUpImageViewController ()

@end

@implementation DoubanUpImageViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNavigation];
    [self createUI];
}

-(void)createNavigation
{
    
    UILabel  *titleLable=[ZCControl createLabelWithFrame:CGRectMake(0, 0, 120, 30) Font:16 Text:@"预览"];
    titleLable.textColor=VBlue_color;
    titleLable.font=[UIFont systemFontOfSize:18];
    titleLable.adjustsFontSizeToFitWidth=NO;
    titleLable.textAlignment=NSTextAlignmentCenter;
    self.navigationItem.titleView=titleLable;
    
    
    //确定发布
    UIButton * RighttBtn= [UIButton buttonWithType:UIButtonTypeSystem];
    RighttBtn.frame=CGRectMake(0, 0, 40, 40);
    [RighttBtn addTarget:self action:@selector(dealRightNavClick:) forControlEvents:UIControlEventTouchUpInside];
    RighttBtn.tag=101;
     RighttBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 10, 0, -10);
    [RighttBtn setTitleColor:VBlue_color forState:UIControlStateNormal];
    [RighttBtn setTitle:@"确定" forState:UIControlStateNormal];
    RighttBtn.titleLabel.font=[UIFont systemFontOfSize:18];
    RighttBtn.titleLabel.adjustsFontSizeToFitWidth=NO;
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:RighttBtn];
    
    
}
-(void)createUI
{
    UIView  *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kHeightNavigation)];
    bgView.backgroundColor=VStageView_color;
    [self.view addSubview:bgView];
    
    UIImageView  *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 200)];
    //imageView.image=self.upimage;
    imageView.contentMode=UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds=YES;
  
  //  [imageView  sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.photourl]] placeholderImage:nil];
    [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.photourl]] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        CGSize  Isize=imageView.image.size;
//        float x=0;
//        float y=0;
//        float width=0;
//        float hight=0;
//        if (Isize.width>Isize.height) {
//            x=0;
//            width=kDeviceWidth;
//            hight=(Isize.height/Isize.width)*kDeviceWidth;
//            y=(kDeviceWidth-hight)/2;
//        }
//        else
//        {
//            y=0;
//            hight=kDeviceWidth;
//            width=(Isize.width/Isize.height)*kDeviceWidth;
//            x=(kDeviceWidth-width)/2;
//        }
        
        float  height = kDeviceWidth*(9.0/16);
        imageView.frame=CGRectMake(0,(kDeviceHeight-height-kHeightNavigation)/2,kDeviceWidth,kDeviceWidth*(9.0/16));
 
    }];
    
    [bgView addSubview:imageView];
}

-(void)dealRightNavClick:(UIButton *) button
{
    [self requestupphoto];
}
-(void)requestupphoto
{
    UserDataCenter  *userCenter=[UserDataCenter shareInstance];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters=@{@"movie_id":self.movie_id,@"photo":self.photourl,@"user_id":userCenter.user_id};
    [manager POST:[NSString stringWithFormat:@"%@/stage/create-from-douban",kApiBaseUrl] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject  objectForKey:@"code"]  intValue]==0) {
            NSLog(@"创建成功=======%@",responseObject);
            
//            UIAlertView *al =[[UIAlertView alloc]initWithTitle:@"删除成功" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [al show];
            
            AddMarkViewController  *vc =[[AddMarkViewController alloc]init];
            stageInfoModel  *model =[[stageInfoModel alloc]init];
            movieInfoModel  *movieInfo =[[movieInfoModel alloc]init];
            
            movieInfo.name =self.movie_name;
            vc.pageSoureType=NSAddMarkPageSourceDoubanUploadImage;
            movieInfo.Id=self.movie_id;
            model.movieInfo=movieInfo;
             [model setValuesForKeysWithDictionary:[responseObject objectForKey:@"model"]];
            vc.stageInfo=model;
          //  UINavigationController  *na =[[UINavigationController alloc]initWithRootViewController:vc];
            //[self.navigationController presentViewController:vc animated:YES completion:nil];
            [self.navigationController pushViewController:vc animated:NO];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
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
