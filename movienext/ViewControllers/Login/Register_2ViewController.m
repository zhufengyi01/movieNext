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

@interface Register_2ViewController ()<UINavigationControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate>
{
    UIButton  *headImag;
    UITextField  *nameTextfield;
}
@end

@implementation Register_2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNavigition];
    [self createUI];
}

-(void)createNavigition
{
    UILabel  *titleLable=[ZCControl createLabelWithFrame:CGRectMake(0, 0, 100, 20) Font:16 Text:@"完善资料"];
    titleLable.textColor=VBlue_color;
    titleLable.font=[UIFont boldSystemFontOfSize:16];
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
-(void)createUI
{
    UIImageView  *bgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    bgView.image =[ UIImage imageNamed:@"login_background.png"];
    bgView.userInteractionEnabled=YES;
    [self.view addSubview:bgView];
    
    headImag=[[UIButton alloc]initWithFrame:CGRectMake((kDeviceWidth-60)/2,140, 60, 60)];
    headImag.layer.cornerRadius=30;
    headImag.layer.borderColor=VBlue_color.CGColor;
    headImag.layer.borderWidth=4;
    [headImag setBackgroundImage:[UIImage imageNamed:@"user_normal@2x.png"] forState:UIControlStateNormal];
    headImag.clipsToBounds=YES;
    headImag.tag=100;
    [headImag addTarget:self action:@selector(dealregiterClick:) forControlEvents:UIControlEventTouchUpInside];
    headImag.backgroundColor=[UIColor redColor];
    [bgView addSubview:headImag];
    
    
    
    UIView  *left1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 20)];

    nameTextfield=[ZCControl createTextFieldWithFrame:CGRectMake((kDeviceWidth-200)/2,headImag.frame.origin.y+headImag.frame.size.height+20, 200,40) placeholder:@"请输入昵称" passWord:NO leftImageView:nil rightImageView:nil Font:15];
    nameTextfield.backgroundColor=[UIColor whiteColor];
    nameTextfield.layer.cornerRadius=4;
    nameTextfield.delegate=self;
    nameTextfield.leftView=left1;
    nameTextfield.leftViewMode=UITextFieldViewModeAlways;
    nameTextfield.clipsToBounds=YES;
    [self.view addSubview:nameTextfield];
    
    
    
    UIButton  *loginButton =[ZCControl createButtonWithFrame:CGRectMake((kDeviceWidth-200)/2,nameTextfield.frame.origin.y+nameTextfield.frame.size.height+20, 200, 40) ImageName:@"signup_done_press.png" Target:self Action:@selector(dealregiterClick:) Title:nil];
    loginButton.tag=101;
    [self.view addSubview:loginButton];
    
    
    
}


-(void)dealregiterClick:(UIButton *) button
{
    if (button.tag==99) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else if (button.tag==100)
    {
        //头像
        
        
        UIActionSheet  *sheet =[[UIActionSheet alloc]initWithTitle:@"更换头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册",@"相机", nil];
        [sheet showInView:self.view];

    }
    else if(button.tag==101)
    {
        // 完成
        //完成之后执行切换根试图控制器
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
