//
//  UserHeadChangeViewController.m
//  movienext
//
//  Created by 风之翼 on 15/4/3.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "UserHeadChangeViewController.h"
#import "UserDataCenter.h"
#import "ZCControl.h"
#import "Constant.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "AppDelegate.h"
#import "AFNetworking.h"
#import "ChangeUsernameViewController.h"
#import "CustmoTabBarController.h"
#import "UpYun.h"
@interface UserHeadChangeViewController ()<UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,changeUserNameDelegate>
{
      AppDelegate *appdelegate;
      UIWindow     *window;
      UIButton *headImag;
      UIButton  *nickButton;
       NSMutableDictionary   *upyunDict;
}
@end

@implementation UserHeadChangeViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden=NO;
    self.tabBarController.tabBar.hidden=YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    upyunDict= [[NSMutableDictionary alloc]init];
    appdelegate = [[UIApplication sharedApplication]delegate ];
    window=appdelegate.window;
    self.view.backgroundColor =[UIColor whiteColor];
    [self createNavigation];
    UserDataCenter *userCenter=[UserDataCenter shareInstance];
    headImag=[[UIButton alloc]initWithFrame:CGRectMake((kDeviceWidth-60)/2,140, 60, 60)];
    headImag.layer.cornerRadius=30;
    headImag.layer.borderColor=VBlue_color.CGColor;
    headImag.layer.borderWidth=4;
    headImag.clipsToBounds=YES;
    headImag.backgroundColor=[UIColor redColor];
    NSURL   *imageURL;
    if (userCenter.logo) {
        imageURL =[NSURL URLWithString:[NSString stringWithFormat:@"%@%@!thumb",kUrlAvatar,userCenter.logo]];
    }
    [headImag addTarget:self action:@selector(changeHeadImage) forControlEvents:UIControlEventTouchUpInside];
    [headImag sd_setBackgroundImageWithURL:imageURL forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"user_normal.png"]];
    [self.view addSubview:headImag];
    
    nickButton=[ZCControl createButtonWithFrame:CGRectMake((kDeviceWidth-200)/2, headImag.frame.origin.y+headImag.frame.size.height+40, 200, 30) ImageName:nil Target:self Action:@selector(changeNickClick) Title:userCenter.username];
     [nickButton setTitleColor:VGray_color forState:UIControlStateNormal];
    //nickButton.backgroundColor=[UIColor redColor];
    [self.view addSubview:nickButton];
    
}
-(void)createNavigation
{
    UIButton  *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"确定" forState:UIControlStateNormal];
    //[button setBackgroundImage:[UIImage imageNamed:@"setting.png"] forState:UIControlStateNormal];
    button.frame=CGRectMake(kDeviceWidth-50, 10, 40,40);
    [button setTitleColor:VBlue_color forState:UIControlStateNormal];
    [button addTarget:self action:@selector(GotoCustomClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem  *barButton=[[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem=barButton;
    if (self.pageType==NSHeadChangePageTypeSetting) {
        self.navigationItem.rightBarButtonItem=nil;
    }
    
    
    UILabel  *label= [ZCControl createLabelWithFrame:CGRectMake((kDeviceWidth-200)/2, 30, 200, 30) Font:16 Text:@"个人资料"];
    label.font=[UIFont boldSystemFontOfSize:16];
    label.textAlignment=NSTextAlignmentCenter;
    label.textColor=VGray_color;
    self.navigationItem.titleView=label;
    
}
//更改图片
-(void)changeHeadImage
{
    UIActionSheet  *sheet =[[UIActionSheet alloc]initWithTitle:@"更换头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册",@"相机", nil];
    [sheet showInView:self.view];
}




-(void)requestChangeHeader
{
    
    NSString  *logo=@"";
    if ([upyunDict  objectForKey:@"url"]) {
        logo =[upyunDict objectForKey:@"url"];
     }
    UserDataCenter  *userCenter =[UserDataCenter shareInstance];
    NSString * user_id = userCenter.user_id;
   
    NSDictionary *parameters = @{@"user_id":user_id,@"logo":logo};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/user/change-user-logo", kApiBaseUrl] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@" succuss");
        userCenter.logo=[upyunDict objectForKey:@"url"];
        
     
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}


//更改用户名
-(void)changeNickClick
{
    ChangeUsernameViewController *vc=[ChangeUsernameViewController new];
    vc.delegate=self;
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma  mark  ----------ChangeUsernameViewControllerDelegate ----
-(void)changeUserName:(NSString *)userName
{
    [nickButton setTitle:userName forState:UIControlStateNormal];
    
}
//切换根视图控制器
-(void)GotoCustomClick
{
    //发送服务器请求,请求完成后，更换根视图控制器
    window.rootViewController=[CustmoTabBarController new];
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex<2) {
    UIImagePickerController  *pick = [[UIImagePickerController alloc]init];
    pick.sourceType=buttonIndex;
    pick.allowsEditing=YES;
    pick.delegate=self;
    [self presentViewController:pick animated:YES completion:nil];
    }
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:UIImagePickerControllerEditedImage];
        
       // NSData   *dataImage =UIImageJPEGRepresentation(image, 0.4);
        
#warning   发送服务器请求
        [self dismissViewControllerAnimated:YES completion:^{
            
            [headImag setBackgroundImage:image forState:UIControlStateNormal];
            

            [self uploadImageToyunWithImage:image];

        }];
        
    }
    
    
}
-(void)uploadImageToyunWithImage:(UIImage *) image;
{
    
    //执行上传的方法
    UpYun *uy = [[UpYun alloc] init];
    uy.bucket=@"next-avatar";
    uy.passcode=@"doQ8Atczh0OWH2uMXz6SarL5eac=";
    uy.successBlocker = ^(id data)
    {
        
        NSLog(@"图片上传成功%@",data);
        if (upyunDict==nil) {
            upyunDict=[[NSMutableDictionary alloc]init];
        }
        upyunDict=data;
        //发布图片和跳转页面
        [self requestChangeHeader];
        
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
        
    };
    
    /**
     *	@brief	根据 UIImage 上传
     */
    // UIImage * image = [UIImage imageNamed:@"image.jpg"];
    //[uy uploadFile:self.upimage saveKey:[self getSaveKey]];
    /**
     *	@brief	根据 文件路径 上传
     */
    //    NSString* resourcePath = [[NSBundle mainBundle] resourcePath];
    //    NSString* filePath = [resourcePath stringByAppendingPathComponent:@"fileTest.file"];
    //    [uy uploadFile:filePath saveKey:[self getSaveKey]];
    
    /**
     *	@brief	根据 NSDate  上传
     */
    float kCompressionQuality = 0.4;
    NSData *photo = UIImageJPEGRepresentation(image, kCompressionQuality);
    //  NSData * fileData = [NSData dataWithContentsOfFile:filePath];
    [uy uploadFile:photo saveKey:[self getSaveKey]];
    
    
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

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"您取消了选择图片");
    // [picker dismissModalViewControllerAnimated:YES];
    [picker dismissViewControllerAnimated:YES completion:nil];
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
