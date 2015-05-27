//
//  FindBeforeViewController.m
//  movienext
//
//  Created by 风之翼 on 15/5/26.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "FindBeforeViewController.h"

#import "ZCControl.h"

#import "Constant.h"
#import "FinderViewController.h"

@interface FindBeforeViewController ()

@end

@implementation FindBeforeViewController
-(void)viewWillAppear:(BOOL)animated
{
    }
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNavigation];
    
  
    
}
-(void)createNavigation
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"tabbar_backgroud_color.png"] forBarMetrics:UIBarMetricsDefault];
    
    UILabel  *titleLable=[ZCControl createLabelWithFrame:CGRectMake(0, 0, 100, 20) Font:16 Text:@"发现之旅"];
    titleLable.textColor=VBlue_color;
    
    titleLable.font=[UIFont boldSystemFontOfSize:18];
    titleLable.textAlignment=NSTextAlignmentCenter;
    self.navigationItem.titleView=titleLable;
    
    UILabel  *lable =[ZCControl createLabelWithFrame:CGRectMake(0,(kDeviceHeight-kHeightNavigation-100)/2, kDeviceWidth, 100) Font:20 Text:@"点击屏幕开启发现之旅"];
    lable.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:lable];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    FinderViewController *find =[FinderViewController new];
    find.CustomtabbarController=(CustmoTabBarController *)self.tabBarController;
    UINavigationController *na =[[UINavigationController alloc]initWithRootViewController:find];
    
    [self.navigationController presentViewController:na animated:YES completion:nil];
    

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
