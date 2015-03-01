//
//  BaseTableViewController.m
//  movienext
//
//  Created by 杜承玖 on 14/11/20.
//  Copyright (c) 2014年 redianying. All rights reserved.
//

#import "BaseTableViewController.h"
#import "UIImageView+WebCache.h"
#import "Constant.h"

@implementation BaseTableViewController

- (void)viewDidLoad {
    _aivLoading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _aivLoading.color = kAppTintColor;
    _aivLoading.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight);
    _aivLoading.hidesWhenStopped = YES;
    [self.view addSubview:_aivLoading];
    
//    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                                                     [UIColor colorWithRed:0 green:0.7 blue:0.8 alpha:1], UITextAttributeTextColor,
//                                                                     [UIColor colorWithRed:0 green:0.7 blue:0.8 alpha:1], UITextAttributeTextShadowColor,
//                                                                     [NSValue valueWithUIOffset:UIOffsetMake(0, 0)], UITextAttributeTextShadowOffset,
//                                                                     [UIFont fontWithName:@"Arial-Bold" size:0.0], UITextAttributeFont,
//                                                                     nil]];
    //self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.0f/255.0f green:127.0f/255.0f blue:127.0f/255.0f alpha:1];
}

- (void)didReceiveMemoryWarning{
    [[SDImageCache sharedImageCache] clearMemory];
    [super didReceiveMemoryWarning];
}

@end
