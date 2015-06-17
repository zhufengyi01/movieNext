//
//  ScanMovieInfoViewController.m
//  movienext
//
//  Created by 风之翼 on 15/4/17.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "ScanMovieInfoViewController.h"
#import "Constant.h"
#import "Function.h"
#import "ZCControl.h"
@interface ScanMovieInfoViewController ()

@end

@implementation ScanMovieInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    [self createNavgaition];
    [self createUI];
}
-(void)createNavgaition
{
    
    UIButton  *dismissButton =[ZCControl createButtonWithFrame:CGRectMake(10,20, 40, 40) ImageName:nil Target:self Action:@selector(dismissClick:) Title:nil];
    dismissButton.tag=98;
    [dismissButton setImage:[UIImage imageNamed:@"close_icon.png"] forState:UIControlStateNormal];
    [self.view addSubview:dismissButton];
}
-(void)createUI
{
    UILabel *create_namelabel =[ZCControl createLabelWithFrame:CGRectMake(0, (kDeviceHeight-160)/2, kDeviceWidth, 20) Font:16 Text:@""];
    NSString  *path =[[NSBundle mainBundle] pathForResource:@"Fakeuserlist" ofType:@"plist"];
    NSArray   *array =[NSArray arrayWithContentsOfFile:path];
    NSString *createBy;
    //if ([self.stageInfo.created_by intValue] ==0) {
    createBy = [array objectAtIndex:([self.stageInfo.Id integerValue]%50)];
    createBy =[NSString stringWithFormat:@"图片上传者 : %@",createBy];
    create_namelabel.text=createBy;
    //}
    
    create_namelabel.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:create_namelabel];
    
    
    UILabel *create_timelabel =[ZCControl createLabelWithFrame:CGRectMake(0,create_namelabel.frame.origin.y+create_namelabel.frame.size.height+10 , kDeviceWidth, 20) Font:14 Text:@"创建时间"];
    
    NSString  *createTime;
    createTime=self.stageInfo.created_at;
    createTime=  [Function getTimewithInterval:createTime];
    createTime =[NSString stringWithFormat:@"上传时间 : %@",createTime];
    create_timelabel.text=createTime;
    create_timelabel.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:create_timelabel];
    
    
}
-(void)dismissClick:(UIButton *) button
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
