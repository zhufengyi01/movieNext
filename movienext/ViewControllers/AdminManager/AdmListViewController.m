//
//  AdmListViewController.m
//  movienext
//
//  Created by 风之翼 on 15/5/21.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "AdmListViewController.h"

#import "AdmCustomListViewController.h"
#import "ZCControl.h"
#import "Constant.h"
#import "TagToStageViewController.h"
#import "TagDetailModel.h"
#import "MovieDetailViewController.h"
#import "NewAddViewController.h"
@interface AdmListViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) UITableView  *myTableView;
@property(nonatomic,strong)NSMutableArray  *dataArray;

@end

@implementation AdmListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNaviagtion];
    [self createUI];
    
}
-(void)createNaviagtion
{
    UILabel  *titleLable=[ZCControl createLabelWithFrame:CGRectMake(0, 0, 100, 20) Font:16 Text:@"管理员"];
    titleLable.textColor=VGray_color;
    titleLable.font=[UIFont boldSystemFontOfSize:18];
    titleLable.textAlignment=NSTextAlignmentCenter;
    self.navigationItem.titleView=titleLable;

}
-(void)createUI
{
    _dataArray =[[NSMutableArray alloc]initWithObjects:@"用户列表",@"标签，表情包",@"已屏蔽剧照列表",@"微博屏蔽",@"微博最新",@"微博发现",@"微博热门",nil];
    _myTableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth,55*7) style:UITableViewStylePlain];
    _myTableView.delegate=self;
    _myTableView.dataSource=self;
    _myTableView.bounces=NO;
    _myTableView.scrollEnabled=NO;
    _myTableView.separatorColor = VLight_GrayColor;
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:_myTableView];
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
           cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.font =[UIFont systemFontOfSize:14];
    //  cell.textColor =VGray_color;
    cell.textLabel.textColor=VGray_color;
    cell.textLabel.text=[_dataArray  objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case ADM_TYPE_USER:
        {
            UIBarButtonItem  *item =[[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
            self.navigationItem.backBarButtonItem=item;
            [self.navigationController pushViewController:[AdmCustomListViewController new] animated:YES];
        }
            break;
         case ADM_TYPE_EMOJ:
        {
            TagModel  *tagmodel =[[TagModel alloc]init];
            TagDetailModel  *tagdetail =[[TagDetailModel alloc]init];
            tagdetail.Id=@"532";
            tagdetail.title=@"表情包";
            tagdetail.created_by=@"56";
            tagmodel.tagDetailInfo=tagdetail;
            
            TagToStageViewController  *tostage =[TagToStageViewController new];
            tostage.tagInfo=tagmodel;
            UIBarButtonItem  *item =[[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
            self.navigationItem.backBarButtonItem=item;
            [self.navigationController pushViewController:tostage animated:YES];
            break;
        }
            
         case ADM_TYPE_CLOSE_STAGE:
        {
            MovieDetailViewController *movied =[[MovieDetailViewController alloc]init];
            movied.pageSourceType=NSMovieSourcePageAdminCloseStageViewController;
            UIBarButtonItem  *item =[[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
            self.navigationItem.backBarButtonItem=item;
            [self.navigationController pushViewController:movied animated:YES];

            break;
        }
        case ADM_TYPE_CLOSE_WEIBO:
        {
            NewAddViewController *new  =[NewAddViewController new];
            new.pageType=NSNewAddPageSoureTypeCloseWeiboList;
            UIBarButtonItem  *item =[[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
            self.navigationItem.backBarButtonItem=item;
            [self.navigationController pushViewController:new animated:YES];
            break;
        }
        case ADM_TYPE_NEW_ADD:
        {
            NewAddViewController *new  =[NewAddViewController new];
            new.pageType=NSNewAddPageSoureTypeNewList;
            UIBarButtonItem  *item =[[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
            self.navigationItem.backBarButtonItem=item;
            [self.navigationController pushViewController:new animated:YES];

            break;
        }
        case ADM_TYPE_ADM_DESCORVER:
        {
            NewAddViewController *new  =[NewAddViewController new];
            new.pageType=NSNewAddPageSoureTypeDecorver;
            UIBarButtonItem  *item =[[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
            self.navigationItem.backBarButtonItem=item;
            [self.navigationController pushViewController:new animated:YES];
            break;
        }
        case ADM_TYPE_RECOMMEND:
        {
            NewAddViewController *new  =[NewAddViewController new];
            new.pageType=NSNewAddPageSoureTypeRecommed;
            UIBarButtonItem  *item =[[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
            self.navigationItem.backBarButtonItem=item;
            [self.navigationController pushViewController:new animated:YES];

        }
        default:
        break;
            
    }
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
