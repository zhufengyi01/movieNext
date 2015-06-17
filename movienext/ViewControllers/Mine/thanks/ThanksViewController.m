//
//  ThanksViewController.m
//  movienext
//
//  Created by 风之翼 on 15/3/27.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "ThanksViewController.h"

@interface ThanksViewController ()

@end

@implementation ThanksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _myWebView =[[UIWebView alloc]initWithFrame:self.view.bounds];
    NSURL  *url=[NSURL URLWithString:[NSString stringWithFormat:@"https://shimo.im/s/d7fa8c57-6995-d087-fb77-b792b4eb1403"]];
    NSURLRequest  *request=[NSURLRequest requestWithURL:url];
    [_myWebView loadRequest:request];
    [self.view addSubview:_myWebView];
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
