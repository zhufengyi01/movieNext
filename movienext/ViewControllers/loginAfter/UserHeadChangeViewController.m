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
@interface UserHeadChangeViewController ()<UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,changeUserNameDelegate>
{
      AppDelegate *appdelegate;
      UIWindow     *window;
    UIButton *headImag;
    UIButton  *nickButton;
}
@end

@implementation UserHeadChangeViewController
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden=NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    appdelegate = [[UIApplication sharedApplication]delegate ];
    window=appdelegate.window;
   // self.view.backgroundColor = View_BackGround;
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
    [headImag sd_setBackgroundImageWithURL:imageURL forState:UIControlStateNormal placeholderImage:HeadImagePlaceholder];
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
    
    
    UILabel  *label= [ZCControl createLabelWithFrame:CGRectMake((kDeviceWidth-200)/2, 30, 200, 30) Font:16 Text:@"个人资料"];
    label.font=[UIFont boldSystemFontOfSize:16];
    label.textAlignment=NSTextAlignmentCenter;
    label.textColor=VBlue_color;
    self.navigationItem.titleView=label;
    
}
//更改图片
-(void)changeHeadImage
{
    UIActionSheet  *sheet =[[UIActionSheet alloc]initWithTitle:@"更换头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册",@"相机", nil];
    [sheet showInView:self.view];
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
        

        [headImag setBackgroundImage:image forState:UIControlStateNormal];
        NSData   *dataImage =UIImageJPEGRepresentation(image, 0.7);
        
#warning   发送服务器请求
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    
    
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
