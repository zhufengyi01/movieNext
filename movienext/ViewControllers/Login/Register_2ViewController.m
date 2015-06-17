//
//  Register_2ViewController.m
//  movienext
//
//  Created by 风之翼 on 15/4/14.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "Register_2ViewController.h"
#import "ZCControl.h"
#import "Constant.h"
#import "AFNetworking.h"
#import "Function.h"
#import "UpYun.h"
#import "AppDelegate.h"
#import "CustmoTabBarController.h"
@interface Register_2ViewController ()<UINavigationControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate>
{
    AppDelegate  *appdelegate;
    UIWindow     *window;
    
    UIButton  *headImag;
    UITextField  *nameTextfield;
    NSMutableDictionary   *upyunDict;
    UIImage  *_upImage;
    UIImageView  *bgView;
    
}
@end

@implementation Register_2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    appdelegate = [[UIApplication sharedApplication]delegate];
    window=appdelegate.window;
    // Do any additional setup after loading the view.
    upyunDict= [[NSMutableDictionary alloc]init];
    [self createNavigition];
    [self createUI];
    //键盘将要显示
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //键盘将要隐藏
    [[NSNotificationCenter defaultCenter ]addObserver:self selector:@selector(keyboardWillHiden:) name:UIKeyboardWillHideNotification object:nil];
    
    
}

-(void)createNavigition
{
    UILabel  *titleLable=[ZCControl createLabelWithFrame:CGRectMake(0, 0, 100, 20) Font:16 Text:@"完善资料"];
    titleLable.textColor=VBlue_color;
    titleLable.font=[UIFont boldSystemFontOfSize:18];
    titleLable.textAlignment=NSTextAlignmentCenter;
    self.navigationItem.titleView=titleLable;
    
    
    //    UIButton  *button=[UIButton buttonWithType:UIButtonTypeCustom];
    //    [button setTitle:@"取消" forState:UIControlStateNormal];
    //    button.titleLabel.font =[UIFont boldSystemFontOfSize:16];
    //    [button setTitleColor:VBlue_color forState:UIControlStateNormal];
    //    //[button setBackgroundImage:[UIImage imageNamed:@"setting.png"] forState:UIControlStateNormal];
    //    button.frame=CGRectMake(10, 5, 40, 40);
    //    [button addTarget:self action:@selector(dealregiterClick:) forControlEvents:UIControlEventTouchUpInside];
    //    button.tag=99;
    //    UIBarButtonItem  *barButton=[[UIBarButtonItem alloc]initWithCustomView:button];
    //    self.navigationItem.leftBarButtonItem=barButton;
    
}


#pragma mark 键盘的通知事件
-(void)keyboardWillShow:(NSNotification * )  notification
{
    
    
    [UIView animateWithDuration:0.2 animations:^{
        bgView.frame =CGRectMake(0, -60,kDeviceWidth, kDeviceHeight);
    }];
    
}
-(void)keyboardWillHiden:(NSNotification *) notification
{
    [UIView animateWithDuration:0.2 animations:^{
        bgView.frame =CGRectMake(0, 0,kDeviceWidth,kDeviceHeight);
    }];
    
}


-(void)createUI
{
    bgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    bgView.image =[ UIImage imageNamed:@"login_background.png"];
    bgView.userInteractionEnabled=YES;
    [self.view addSubview:bgView];
    
    
    //默认使用了默认头像
    _upImage =[UIImage imageNamed:@"user_normal.png"];
    headImag=[[UIButton alloc]initWithFrame:CGRectMake((kDeviceWidth-60)/2,140, 60, 60)];
    headImag.layer.cornerRadius=30;
    headImag.layer.borderColor=VBlue_color.CGColor;
    headImag.layer.borderWidth=4;
    [headImag setBackgroundImage:_upImage forState:UIControlStateNormal];
    headImag.clipsToBounds=YES;
    headImag.tag=100;
    [headImag addTarget:self action:@selector(dealregiterClick:) forControlEvents:UIControlEventTouchUpInside];
    //    headImag.backgroundColor=[UIColor redColor];
    [bgView addSubview:headImag];
    
    
    
    UIView  *left1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 20)];
    
    nameTextfield=[ZCControl createTextFieldWithFrame:CGRectMake((kDeviceWidth-240)/2,headImag.frame.origin.y+headImag.frame.size.height+20, 240,40) placeholder:@"请输入昵称" passWord:NO leftImageView:nil rightImageView:nil Font:15];
    nameTextfield.backgroundColor=[UIColor whiteColor];
    nameTextfield.layer.cornerRadius=4;
    nameTextfield.delegate=self;
    ///nameTextfield.text=@"qq";
    nameTextfield.leftView=left1;
    nameTextfield.leftViewMode=UITextFieldViewModeAlways;
    nameTextfield.clipsToBounds=YES;
    [bgView addSubview:nameTextfield];
    
    UIButton  *loginButton =[ZCControl createButtonWithFrame:CGRectMake((kDeviceWidth-200)/2,nameTextfield.frame.origin.y+nameTextfield.frame.size.height+20, 200, 40) ImageName:@"signup_done_press.png" Target:self Action:@selector(dealregiterClick:) Title:nil];
    loginButton.tag=101;
    [bgView addSubview:loginButton];
    
    
    
}
-(void)requestRegisterData
{
    
    NSString  *logo=@"";
    if ([upyunDict  objectForKey:@"url"]) {
        logo =[upyunDict objectForKey:@"url"];
        
        // 如果用户没有使用相机，直接使用默认的头像,也是要用
    }
    //NSString *username=[[nameTextfield text] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString  *username=[nameTextfield text];
    NSString  *passstr=[NSString stringWithFormat:@"%@movienext%@",self.email,self.password];
    NSString  *pass_hash=[Function  md5:passstr];
    NSDictionary *parameters = @{@"email":self.email,@"password_hash":pass_hash,@"username":username,@"logo":logo};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/user/register-with-email", kApiBaseUrl] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject  objectForKey:@"code"]  intValue]==0) {
            //注册成功
            NSDictionary *detail    = [responseObject objectForKey:@"model"];
            if (![detail isEqual:@""]) {
                UserDataCenter  *userCenter=[UserDataCenter shareInstance];
                userCenter.user_id=[detail objectForKey:@"id"];
                userCenter.username=[detail objectForKey:@"username"];
                userCenter.logo =[detail objectForKey:@"logo"];
                
                userCenter.is_admin =[detail objectForKey:@"role_id"];
                userCenter.verified=[detail objectForKey:@"verified"];
                userCenter.sex=[detail objectForKey:@"sex"];
                userCenter.signature=[detail objectForKey:@"brief"];
                userCenter.email=[detail objectForKey:@"email"];
                userCenter.fake=[detail objectForKey:@"fake"];
                
                [Function saveUser:userCenter];
                //登陆成功后把根
                window.rootViewController=[CustmoTabBarController new];
            }
        }
        else
        {
            UIAlertView  *Al=[[UIAlertView alloc]initWithTitle:nil message:@"注册失败，请稍候重试，或检查网络设置" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [Al show];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}


-(void)dealregiterClick:(UIButton *) button
{
    if (button.tag==100)
    {
        //头像
        UIActionSheet  *sheet =[[UIActionSheet alloc]initWithTitle:@"更换头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册",@"相机", nil];
        [sheet showInView:self.view];
        
    }
    else if(button.tag==101)
    {
        // 完成
        //完成之后执行切换根试图控制器
        if ([Function isBlankString:nameTextfield.text]==YES) {
            UIAlertView  *Al=[[UIAlertView alloc]initWithTitle:nil message:@"对不起，昵称不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [Al show];
            return;
        }
        else
        {
            //开始注册
            [nameTextfield resignFirstResponder];
            [self requestRegisterData];
            
        }
    }
    
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
        _upImage = [info objectForKey:UIImagePickerControllerEditedImage];
        // NSData   *dataImage =UIImageJPEGRepresentation(image, 0.7);
        
        [self dismissViewControllerAnimated:YES completion:^{
            [headImag setBackgroundImage:_upImage forState:UIControlStateNormal];
            [self uploadImageToyun];
            
        }];
        
    }
    
    
}
-(void)uploadImageToyun
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
    float kCompressionQuality = 0.6;
    NSData *photo = UIImageJPEGRepresentation(_upImage, kCompressionQuality);
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
#pragma  mark    textfiledDelegate---------------------
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [nameTextfield resignFirstResponder];
    return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [nameTextfield resignFirstResponder];
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
