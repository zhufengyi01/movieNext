//
//  NewViewController.m
//  movienext
//
//  Created by 风之翼 on 15/2/27.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "NewViewController.h"
#import "AppDelegate.h"
#import "Constant.h"
#import  "UserDataCenter.h"
@interface NewViewController ()
{
    AppDelegate  *appdelegate;
    
}
@end

@implementation NewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor =[UIColor redColor];
    appdelegate =(AppDelegate *)[[UIApplication sharedApplication]delegate ];
    UserDataCenter  *userInfo=  [UserDataCenter shareInstance];
   NSLog(@"-------登陆成功  user=======%@ ",  userInfo.username);
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
