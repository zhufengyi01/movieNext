//
//  BaseViewController.m
//  movienext
//
//  Created by 杜承玖 on 14/11/20.
//  Copyright (c) 2014年 redianying. All rights reserved.
//

#import "BaseViewController.h"
#import "UIImageView+WebCache.h"
#import "Constant.h"

@implementation BaseViewController

- (void)viewDidLoad {
    _aivLoading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _aivLoading.color = kAppTintColor;
    _aivLoading.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight);
    _aivLoading.hidesWhenStopped = YES;
    [self.view addSubview:_aivLoading];
}

- (void)didReceiveMemoryWarning{
    [[SDImageCache sharedImageCache] clearMemory];
    [super didReceiveMemoryWarning];
}

@end
