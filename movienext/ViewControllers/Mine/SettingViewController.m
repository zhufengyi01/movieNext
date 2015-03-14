//
//  SettingViewController.m
//  movienext
//
//  Created by 风之翼 on 15/3/1.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "SettingViewController.h"
#import "Constant.h"
#import "UserDataCenter.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
@interface SettingViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    AppDelegate *appdelegate;
    UIWindow  *window;
    UITableView   *_myTableView;
    NSMutableArray   *_dataArray;
}

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationItem.title=@"设置";
    self.view.backgroundColor=View_BackGround;
    appdelegate = [[UIApplication sharedApplication]delegate ];
    window=appdelegate.window;
    [self createUI];
    [self createOutLogin];
    
}
-(void)createUI
{
    _dataArray =[[NSMutableArray alloc]initWithObjects:@"分享给好小伙伴",@"清空缓存",@"意见反馈",nil];
    _myTableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 165) style:UITableViewStylePlain];
    _myTableView.delegate=self;
    _myTableView.dataSource=self;
    _myTableView.bounces=NO;
    _myTableView.scrollEnabled=NO;
    _myTableView.separatorColor = VLight_GrayColor;
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:_myTableView];
    
}
-(void)createOutLogin
{
 
    UIButton  *button=[UIButton buttonWithType:UIButtonTypeCustom];
  //  [button setTitle:@"退出此账号" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont systemFontOfSize:14];
    [button setBackgroundImage:[UIImage imageNamed:@"login out.png"] forState:UIControlStateNormal];
    button.frame=CGRectMake((kDeviceWidth-233)/2, 360, 233, 43);
    [button addTarget:self action:@selector(OutLoginClick:) forControlEvents:UIControlEventTouchUpInside];
    button.layer.cornerRadius=3;
    button.clipsToBounds=YES;
    [self.view addSubview:button];

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55.0f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString  *cellID=@"cell";
    UITableViewCell   *cell=(UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.font =[UIFont systemFontOfSize:14];
  //  cell.textColor =VGray_color;
    cell.textLabel.textColor=VGray_color;
    cell.textLabel.text=[_dataArray  objectAtIndex:indexPath.row];
    return cell;
}

//退出登录
-(void)OutLoginClick:(UIButton *)button
{
    UserDataCenter  *userCenter=[UserDataCenter shareInstance];
    userCenter.user_id=nil;
    userCenter.username=nil;
    userCenter.avatar =nil;
    userCenter.signature=nil;
    userCenter.update_time=nil;
    userCenter.user_bind_type=nil;
    NSUserDefaults  *userDefualt=[NSUserDefaults standardUserDefaults];
    [userDefualt removeObjectForKey:kUserKey];
    [userDefualt synchronize];
    window.rootViewController=[LoginViewController new];
    
    
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
