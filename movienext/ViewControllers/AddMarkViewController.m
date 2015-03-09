//
//  AddMarkViewController.m
//  movienext
//
//  Created by 风之翼 on 15/3/9.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "AddMarkViewController.h"
#import "ZCControl.h"
#import "Constant.h"
@interface AddMarkViewController ()<UITextFieldDelegate>
{
    UIToolbar  *_toolBar;
    UITextField  *_inputText;
    NSDictionary  *_myDict;
}
@end

@implementation AddMarkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _myDict =[NSDictionary dictionaryWithDictionary:_stageDict];
    [self createNavigation];
    //键盘将要显示
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
     //键盘将要隐藏
    [[NSNotificationCenter defaultCenter ]addObserver:self selector:@selector(keyboardWillHiden:) name:UIKeyboardWillHideNotification object:nil];
    [self createStageView];
    [self createButtomView];
}
-(void)createNavigation
{
    UILabel  *titleLable=[ZCControl createLabelWithFrame:CGRectMake(0, 0, 100, 20) Font:16 Text:@"发布弹幕"];
    titleLable.textColor=VBlue_color;
    titleLable.font=[UIFont boldSystemFontOfSize:16];
    titleLable.textAlignment=NSTextAlignmentCenter;
    self.navigationItem.titleView=titleLable;
    
    
    UIButton  *leftBtn= [UIButton buttonWithType:UIButtonTypeSystem];
    leftBtn.frame=CGRectMake(0, 0, 40, 30);
    [leftBtn setTitleColor:VGray_color forState:UIControlStateNormal];
    [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(dealNavClick:) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.tag=100;
    UIBarButtonItem  *leftBarButton=[[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem=leftBarButton;
    
    UIButton  *RighttBtn= [UIButton buttonWithType:UIButtonTypeSystem];
    RighttBtn.frame=CGRectMake(0, 0, 40, 30);
    [RighttBtn addTarget:self action:@selector(dealNavClick:) forControlEvents:UIControlEventTouchUpInside];
    RighttBtn.tag=101;
    [RighttBtn setTitleColor:VGray_color forState:UIControlStateNormal];
    [RighttBtn setTitle:@"确定" forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:RighttBtn];
    

}
-(void)createStageView
{
    stageView = [[StageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceWidth)];
    NSLog(@" 在 添加弹幕页面的   stagedict = %@",_myDict);
    [stageView setStageValue:_stageDict];
    [self.view addSubview:stageView];
    
}

-(void)createButtomView
{
    
    
     _toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0,kDeviceHeight-40-kHeightNavigation, kDeviceHeight, 40)];
     //_toolBar.barTintColor=[UIColor redColor];   //背景颜色
   // [self.navigat setBackgroundImage:[UIImage imageNamed:@"tabbar_backgroud_color.png"] forBarMetrics:UIBarMetricsDefault];
    [_toolBar setBackgroundImage:[UIImage imageNamed:@"tabbar_backgroud_color.png"] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
     _toolBar.tintColor=VGray_color;  //内容颜色
     
     _inputText= [[UITextField alloc]initWithFrame:CGRectMake(10,5, kDeviceWidth-80,30)];
     _inputText.layer.cornerRadius=4;
     _inputText.layer.borderWidth=1;
    _inputText.delegate=self;
     _inputText.layer.borderColor=VLight_GrayColor.CGColor;
     [_toolBar addSubview:_inputText];
     
     UIButton  *publishBtn=[ZCControl createButtonWithFrame:CGRectMake(kDeviceWidth-60, 5, 50, 28) ImageName:@"loginoutbackgroundcolor.png" Target:self Action:@selector(dealNavClick:) Title:@"发布"];
    
    publishBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    publishBtn.layer.cornerRadius=4;
    publishBtn.tag=99;
    publishBtn.clipsToBounds=YES;
     [_toolBar addSubview:publishBtn];
     [_inputText becomeFirstResponder];
    [self.view addSubview:_toolBar];
    
    
}


-(void)dealNavClick:(UIButton *) button
{
    
    if (button.tag==100) {
        NSLog(@" =========取消发布的方法");
        //取消发布
        [self.navigationController popViewControllerAnimated:NO];
        //[_inputText becomeFirstResponder];
    }
    else if (button.tag==101)
    {
        NSLog(@" =========执行确定发布的方法");
        
        
        //执行发布的方法
    }
    else if (button.tag==99)
    {
        //点击确定按钮
        NSLog(@" =========点击发布到屏幕");
        
    }
}


#pragma mark 键盘的通知事件
-(void)keyboardWillShow:(NSNotification * )  notification
{
    [UIView  animateWithDuration:1.0 animations:^{
        CGRect  tframe=_toolBar.frame;
        tframe.origin.y=kDeviceHeight-216-35-kHeightNavigation-40;
        _toolBar.frame=tframe;
    } completion:^(BOOL finished) {
        
    }];
}
-(void)keyboardWillHiden:(NSNotification *) notification
{
    
    [UIView  animateWithDuration:1.0 animations:^{
        CGRect  tframe=_toolBar.frame;
        tframe.origin.y=kDeviceHeight-40-kHeightNavigation;
        _toolBar.frame=tframe;
    } completion:^(BOOL finished) {
        
    }];

}

#pragma  mark  ---textfieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_inputText resignFirstResponder];
    return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_inputText resignFirstResponder];
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
