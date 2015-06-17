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
#import "AddLoadingView.h"
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
    titleLable.textColor=VGray_color;
    titleLable.font=[UIFont boldSystemFontOfSize:16];
    titleLable.adjustsFontSizeToFitWidth=NO;
    titleLable.textAlignment=NSTextAlignmentCenter;
    self.navigationItem.titleView=titleLable;
    
    
    //确定发布
    UIButton * RighttBtn= [UIButton buttonWithType:UIButtonTypeSystem];
    RighttBtn.frame=CGRectMake(0, 0, 40, 40);
    [RighttBtn addTarget:self action:@selector(dealRightNavClick:) forControlEvents:UIControlEventTouchUpInside];
    RighttBtn.tag=101;
    RighttBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 10, 0, -10);
    [RighttBtn setTitleColor:VGray_color forState:UIControlStateNormal];
    [RighttBtn setTitle:@"确定" forState:UIControlStateNormal];
    RighttBtn.titleLabel.font=[UIFont systemFontOfSize:16];
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
    
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.photourl]] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        CGSize  Isize=image.size;
        //计算图片的宽高比
        float width = Isize.width;
        float heigth =Isize.height;
        float x;
        float y=0;
        float w;
        float h;
        if (heigth/width>KImageWidth_Height&&(heigth/width<1)) { //
            x=0;
            y=0;
            w=kDeviceWidth-0;
            h=(kDeviceWidth-0)*(heigth/width);
        }
        else if (heigth/width<KImageWidth_Height)
        {
            x=0;
            y=0;
            w=kDeviceWidth-0;
            h=(kDeviceWidth-0)*KImageWidth_Height;
        }
        else if (heigth/width>1) //高大于宽度的时候  成正方形
        {
            y =0;
            h= kDeviceWidth-0;
            w=(kDeviceWidth-0)*(width/heigth);
            x=((kDeviceWidth-0)-w)/2;
        }
        else
        {
            x=0;
            y=0;
            h=(kDeviceWidth-0)*(9.0/16);
            w=(kDeviceWidth-0);
        }
        imageView.frame=CGRectMake((kDeviceWidth-w)/2,(kDeviceHeight-kHeightNavigation-h)/2,w,h);
    }];
    
    [bgView addSubview:imageView];
}

-(void)dealRightNavClick:(UIButton *) button
{
    [self requestupphoto];
}
-(void)requestupphoto
{
    AddLoadingView  *loading =[[AddLoadingView alloc]initWithtitle:@"正在添加"];
    [loading show];
    UserDataCenter  *userCenter=[UserDataCenter shareInstance];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters=@{@"movie_id":self.movie_id,@"photo":self.photourl,@"user_id":userCenter.user_id};
    [manager POST:[NSString stringWithFormat:@"%@/stage/create-from-douban",kApiBaseUrl] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject  objectForKey:@"code"]  intValue]==0) {
            NSLog(@"创建成功=======%@",responseObject);
            [loading remove];
            AddMarkViewController  *vc =[[AddMarkViewController alloc]init];
            stageInfoModel  *model =[[stageInfoModel alloc]init];
            movieInfoModel  *movieInfo =[[movieInfoModel alloc]init];
            movieInfo.name =self.movie_name;
            if (self.pageType==NSDoubanSourceTypeAddCard) {
                vc.pageSoureType=NSAddMarkPageSourceAddCard;
            }
            movieInfo.Id=self.movie_id;
            model.movieInfo=movieInfo;
            [model setValuesForKeysWithDictionary:[responseObject objectForKey:@"model"]];
            vc.stageInfo=model;
            [self.navigationController pushViewController:vc animated:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [loading remove];
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
