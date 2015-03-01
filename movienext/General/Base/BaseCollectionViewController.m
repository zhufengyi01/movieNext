//
//  BaseCollectionViewController.m
//  movienext
//
//  Created by 杜承玖 on 14/11/21.
//  Copyright (c) 2014年 redianying. All rights reserved.
//

#import "BaseCollectionViewController.h"
#import "UIImageView+WebCache.h"
#import "Constant.h"

@implementation BaseCollectionViewController

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
