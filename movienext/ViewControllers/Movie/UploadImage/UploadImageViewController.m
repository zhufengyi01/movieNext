//
//  UploadImageViewController.m
//  movienext
//
//  Created by 风之翼 on 15/3/22.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "UploadImageViewController.h"
#import "ZCControl.h"
#import "Constant.h"
#import "UpYun.h"
#import "AddMarkViewController.h"
#import "UploadProgressView.h"
#import "AFNetworking.h"
#import "UserDataCenter.h"
@interface UploadImageViewController ()
{
    UIScrollView   *_myScrollView;
    UploadProgressView  *_myprogress;
    NSMutableDictionary   *upyunDict;
    NSMutableDictionary *_myDict;
}
@end

@implementation UploadImageViewController
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden=NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNavigation];
    [self initData];
    [self createUI];
    [self createProgress];
    
}
-(void)createNavigation
{
    
    
    UIView  *view =[[UIView alloc]initWithFrame:CGRectMake(0,0, kDeviceWidth, 64)];
    view.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:view];
    
    UILabel  *titleLable=[ZCControl createLabelWithFrame:CGRectMake((kDeviceWidth-120)/2, 34, 120, 20) Font:16 Text:@"上传并添加图片"];
    titleLable.textColor=VBlue_color;
    titleLable.font=[UIFont boldSystemFontOfSize:16];
    titleLable.textAlignment=NSTextAlignmentCenter;
   
    [view addSubview:titleLable];
    
    
    
    UIButton * leftBtn= [UIButton buttonWithType:UIButtonTypeSystem];
    leftBtn.frame=CGRectMake(0, 34, 60, 30);
    [leftBtn addTarget:self action:@selector(dealRightNavClick:) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.tag=100;
    [leftBtn setTitleColor:VBlue_color forState:UIControlStateNormal];
    [leftBtn setTitle:@"返回" forState:UIControlStateNormal];
    [view addSubview:leftBtn];
  //  self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:leftBtn];

    
    
    UIButton * RighttBtn= [UIButton buttonWithType:UIButtonTypeSystem];
    RighttBtn.frame=CGRectMake(kDeviceWidth-50, 34, 40, 30);
    [RighttBtn addTarget:self action:@selector(dealRightNavClick:) forControlEvents:UIControlEventTouchUpInside];
    RighttBtn.tag=101;
    RighttBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    [RighttBtn setTitleColor:VBlue_color forState:UIControlStateNormal];
    [RighttBtn setTitle:@"确定" forState:UIControlStateNormal];
    [view addSubview:RighttBtn];
    //self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:RighttBtn];
    
    
}
-(void)initData
{
    upyunDict= [[NSMutableDictionary alloc]init];
    _myDict=[[NSMutableDictionary alloc]init];
}
//确定上传
-(void)dealRightNavClick:(UIButton *) button
{
 
    if (button.tag==100) {
        [self dismissViewControllerAnimated:YES completion:nil];
      }
    else if (button.tag==101)
    {
        
        //点击上传的时候
        [self.view addSubview:_myprogress];
        //执行上传的方法
         UpYun *uy = [[UpYun alloc] init];
         uy.successBlocker = ^(id data)
         {
          
             //上传成功后，移除上传提示
                   //UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"" message:@"上传成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
         //[alert show];
             
         NSLog(@"图片上传成功%@",data);
             if (upyunDict==nil) {
                 upyunDict=[[NSMutableDictionary alloc]init];
             }
             upyunDict=data;
             //发布图片和跳转页面
                [self publicImage];
            
         };
         uy.failBlocker = ^(NSError * error)
         {
         NSString *message = [error.userInfo objectForKey:@"message"];
         UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"error" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
         [alert show];
         NSLog(@"图片上传失败%@",error);
         };
         uy.progressBlocker = ^(CGFloat percent, long long requestDidSendBytes)
         {
         //进度
         ////[_pv setProgress:percent];
             [_myprogress setProgress:percent];
             
         };
        
        /**
         *	@brief	根据 UIImage 上传
         */
        // UIImage * image = [UIImage imageNamed:@"image.jpg"];
         [uy uploadFile:self.upimage saveKey:[self getSaveKey]];
        /**
         *	@brief	根据 文件路径 上传
         */
        //    NSString* resourcePath = [[NSBundle mainBundle] resourcePath];
        //    NSString* filePath = [resourcePath stringByAppendingPathComponent:@"fileTest.file"];
        //    [uy uploadFile:filePath saveKey:[self getSaveKey]];
        
        /**
         *	@brief	根据 NSDate  上传
         */
        //    NSData * fileData = [NSData dataWithContentsOfFile:filePath];
        //    [uy uploadFile:fileData saveKey:[self getSaveKey]];
    
    }
    
}

-(NSString * )getSaveKey {
    /**
     *	@brief	方式1 由开发者生成saveKey
     */
    NSDate *d = [NSDate date];
    return [NSString stringWithFormat:@"/%d/%d/%.0f.jpg",[self getYear:d],[self getMonth:d],[[NSDate date] timeIntervalSince1970]];
    
    /**
     *	@brief	方式2 由服务器生成saveKey
     */
    //    return [NSString stringWithFormat:@"/{year}/{mon}/{filename}{.suffix}"];
    
    /**
     *	@brief	更多方式 参阅 http://wiki.upyun.com/index.php?title=Policy_%E5%86%85%E5%AE%B9%E8%AF%A6%E8%A7%A3
     */
    
}

- (int)getYear:(NSDate *) date{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSYearCalendarUnit;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
    int year=[comps year];
    return year;
}

- (int)getMonth:(NSDate *) date{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSMonthCalendarUnit;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
    int month = [comps month];
    return month;
}
-(void)publicImage
{
    UserDataCenter *usreCenter=[UserDataCenter shareInstance];
    NSString  *w=[NSString stringWithFormat:@"%f",self.upimage.size.width];
    NSString  *h=[NSString stringWithFormat:@"%f",self.upimage.size.height];

    NSDictionary *parameter = @{@"stage":[upyunDict objectForKey:@"url"],@"movie_id":self.movie_Id,@"user_id":usreCenter.user_id,@"w":w,@"h":h};
    
    NSLog(@"==parameter====%@",parameter);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/movieStage/uploadStage", kApiBaseUrl] parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"  发布图片的请求    JSON: %@", responseObject);
        
        [_myprogress setProgressTitle:@"上传成功"];
        [_myprogress removeFromSuperview];
        _myprogress=nil;

        //if ([responseObject  objectForKey:@"detail"]) {
          //  UIAlertView  *Al=[[UIAlertView alloc]initWithTitle:@"发布成功" message:@"恭喜你发布成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            //[Al show];
       // }
        if (_myDict ==nil) {
            _myDict =[[NSMutableDictionary alloc]init];
        }
        _myDict=[responseObject objectForKey:@"detail"];
        //上传成功后跳转到添加弹幕页面
        StageInfoModel   *stageInfo =[[StageInfoModel alloc]init];
        if (stageInfo) {
            [stageInfo setValuesForKeysWithDictionary:_myDict];
            stageInfo.stage=[parameter objectForKey:@"stage"];
        }
        
        AddMarkViewController  *Addmark =[[AddMarkViewController alloc]init];
        Addmark.stageInfoDict=stageInfo;
        Addmark.pageSoureType=NSAddMarkPageSourceUploadImage;
        [self.navigationController pushViewController:Addmark animated:YES];
        

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}
-(void)createUI
{
    _myScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, kDeviceWidth, kDeviceHeight)];
    [self.view addSubview:_myScrollView];
    
    UIImageView  *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 200)];
    imageView.image=self.upimage;
    [_myScrollView addSubview:imageView];
    
    CGSize  Isize=self.upimage.size;
    float  hight=((Isize.height)/(Isize.width))*kDeviceWidth;
    
    _myScrollView.contentSize=CGSizeMake(kDeviceWidth, hight);
    imageView.frame=CGRectMake(0, 0, kDeviceWidth, hight);
    
    
}
-(void)createProgress
{
    _myprogress=[[UploadProgressView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    
    //[self.view addSubview:_myprogress];
    
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
