//
//  MainNavigationViewController.m
//  movienext
//
//  Created by 朱封毅 on 17/06/15.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "MainNavigationViewController.h"
#import "UIButton+Block.h"
#import "UIImage+Color.h"
@interface MainNavigationViewController ()

@end

@implementation MainNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    UIButton  *back = [UIButton buttonWithType:UIButtonTypeCustom];
//    back.frame=CGRectMake(0, 0, 8, 14);
//    [back setImage:[UIImage imageNamed:@"back_gray_Icon.png"] forState:UIControlStateNormal];
//     [back addActionHandler:^(NSInteger tag) {
//         [self popViewControllerAnimated:YES];
//     }];
//    UIBarButtonItem  *baritem  =[[UIBarButtonItem alloc]initWithCustomView:back];
//    self.navigationItem.leftBarButtonItem=baritem;
}
+(void)initialize
{
    
    
}
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count>0) {
        viewController.hidesBottomBarWhenPushed=YES;
    }
    [super pushViewController:viewController animated:animated];

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
