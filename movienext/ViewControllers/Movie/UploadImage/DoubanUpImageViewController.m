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
    
    UILabel  *titleLable=[ZCControl createLabelWithFrame:CGRectMake(0, 0, 120, 20) Font:16 Text:@"上传图片"];
    titleLable.textColor=VBlue_color;
    titleLable.font=[UIFont boldSystemFontOfSize:16];
    titleLable.textAlignment=NSTextAlignmentCenter;
    self.navigationItem.titleView=titleLable;
    
    //确定发布
    UIButton * RighttBtn= [UIButton buttonWithType:UIButtonTypeSystem];
    RighttBtn.frame=CGRectMake(0, 0, 40, 30);
    [RighttBtn addTarget:self action:@selector(dealRightNavClick:) forControlEvents:UIControlEventTouchUpInside];
    RighttBtn.tag=101;
    RighttBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    [RighttBtn setTitleColor:VBlue_color forState:UIControlStateNormal];
    [RighttBtn setTitle:@"确定" forState:UIControlStateNormal];
    RighttBtn.titleLabel.font=[UIFont boldSystemFontOfSize:16];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:RighttBtn];
    
    
}
-(void)createUI
{
    UIView  *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceWidth)];
    bgView.backgroundColor=VStageView_color;
    [self.view addSubview:bgView];
    
    UIImageView  *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 200)];
    imageView.image=self.upimage;
    
    [bgView addSubview:imageView];
    
    CGSize  Isize=self.upimage.size;
    float x=0;
    float y=0;
    float width=0;
    float hight=0;
    if (Isize.width>Isize.height) {
        x=0;
        width=kDeviceWidth;
        hight=(Isize.height/Isize.width)*kDeviceWidth;
        y=(kDeviceWidth-hight)/2;
    }
    else
    {
        y=0;
        hight=kDeviceWidth;
        width=(Isize.width/Isize.height)*kDeviceWidth;
        x=(kDeviceWidth-width)/2;
    }
    imageView.frame=CGRectMake(x,y,width,hight);
    
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
            NSLog(@"删除成功=======%@",responseObject);
            
//            UIAlertView *al =[[UIAlertView alloc]initWithTitle:@"删除成功" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [al show];
            AddMarkViewController  *vc =[[AddMarkViewController alloc]init];
            stageInfoModel  *model =[[stageInfoModel alloc]init];
             [model setValuesForKeysWithDictionary:[responseObject objectForKey:@"model"]];
            vc.stageInfo=model;
            [self.navigationController pushViewController:vc animated:YES];
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
