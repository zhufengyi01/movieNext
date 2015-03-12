//
//  RootViewController.m
//  movienext
//
//  Created by 风之翼 on 15/3/1.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "RootViewController.h"
#import "Constant.h"

@interface RootViewController ()

@end

@implementation RootViewController
-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden=YES;
    //下面透明度的设置，效果是设置了导航条的高度的多少倍，不是透明度多少
//    self.navigationController.navigationBar.alpha=1;
    //设置半透明。
//    self.navigationController.navigationBar.translucent=NO;

    self.navigationController.navigationBar.hidden=NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
      self.view.backgroundColor=View_BackGround;
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
