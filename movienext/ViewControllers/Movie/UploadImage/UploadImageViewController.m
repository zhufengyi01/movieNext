//
//  UploadImageViewController.m
//  movienext
//
//  Created by 风之翼 on 15/3/22.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "UploadImageViewController.h"
#import "ZCControl.h"
#import "Constant.h"
#import "UpYun.h"
@interface UploadImageViewController ()
{
    UIScrollView   *_myScrollView;
}
@end

@implementation UploadImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNavigation];
    [self createUI];
    
}
-(void)createNavigation
{
    
    
    UILabel  *titleLable=[ZCControl createLabelWithFrame:CGRectMake(0, 0, 100, 20) Font:16 Text:@"上传并添加图片"];
    titleLable.textColor=VBlue_color;
    titleLable.font=[UIFont boldSystemFontOfSize:16];
    titleLable.textAlignment=NSTextAlignmentCenter;
    self.navigationItem.titleView=titleLable;

    UIButton * RighttBtn= [UIButton buttonWithType:UIButtonTypeSystem];
    RighttBtn.frame=CGRectMake(0, 0, 60, 30);
    [RighttBtn addTarget:self action:@selector(dealRightNavClick) forControlEvents:UIControlEventTouchUpInside];
    RighttBtn.tag=101;
    [RighttBtn setTitleColor:VBlue_color forState:UIControlStateNormal];
    [RighttBtn setTitle:@"确定" forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:RighttBtn];
    
    
}
//确定上传
-(void)dealRightNavClick
{
    
    
}
-(void)createUI
{
    _myScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    [self.view addSubview:_myScrollView];
    
    UIImageView  *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 200)];
    imageView.image=self.upimage;
    [_myScrollView addSubview:imageView];
    
    CGSize  Isize=self.upimage.size;
    float  hight=((Isize.height)/(Isize.width))*kDeviceWidth;
    _myScrollView.contentSize=CGSizeMake(kDeviceWidth, hight);
    imageView.frame=CGRectMake(0, 0, kDeviceWidth, hight);
    
    
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
