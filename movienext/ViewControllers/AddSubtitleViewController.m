//
//  AddSubtitleViewController.m
//  movienext
//
//  Created by 风之翼 on 15/3/6.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "AddSubtitleViewController.h"
#import "Constant.h"
#import "DAKeyboardControl.h"
#import "UIImageView+WebCache.h"
#import "ZCControl.h"
@interface AddSubtitleViewController ()<UITextFieldDelegate>
{
    UIToolbar  *_toolBar;
    UITextField  *_textField;
}
@end

@implementation AddSubtitleViewController
-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden=YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}
-(void)keyboardWillShow:(NSNotification *) noti
{
    
}
-(void)loadView
{
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //[self createUI];
    [self createNavigation];
    
    stageView = [[StageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceWidth)];
    NSLog(@"stagedict = %@", _stageDict);
    [stageView setStageValue:_stageDict];
    [self.view addSubview:stageView];

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
    // self.navigationItem.leftBarButtonItem=leftBarButton;
    self.navigationItem.leftBarButtonItem=leftBarButton;
    
    UIButton  *RighttBtn= [UIButton buttonWithType:UIButtonTypeSystem];
    RighttBtn.frame=CGRectMake(0, 0, 40, 30);
    [RighttBtn addTarget:self action:@selector(dealNavClick:) forControlEvents:UIControlEventTouchUpInside];
    RighttBtn.tag=101;
    [RighttBtn setTitleColor:VGray_color forState:UIControlStateNormal];
    [RighttBtn setTitle:@"发布" forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:RighttBtn];
    
}
-(void)createUI
{
    
    
   /* _toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0,70, kDeviceHeight, 40)];
     _toolBar.barTintColor=[UIColor redColor];   //背景颜色
     _toolBar.tintColor=[UIColor blackColor];  //内容颜色

    _inputText= [[UITextField alloc]initWithFrame:CGRectMake(10,10, kDeviceWidth-60,30)];
    _inputText.layer.cornerRadius=4;
    _inputText.layer.borderWidth=1;
    _inputText.layer.borderColor=VBlue_color.CGColor;
    [_toolBar addSubview:_inputText];
    
    UIButton  *publishBtn=[ZCControl createButtonWithFrame:CGRectMake(kDeviceHeight-50, 10, 40, 28) ImageName:@"loginoutbackgroundcolor.png" Target:self Action:@selector(dealNavClick:) Title:@"发布"];
    [_toolBar addSubview:publishBtn];
    
    [_inputText becomeFirstResponder];
    [_inputText becomeFirstResponder];
    //[self.view addSubview:_toolBar];
    
   //  _inputText.inputAccessoryView=_toolBar;
    
    [self.view addKeyboardPanningWithFrameBasedActionHandler:^(CGRect keyboardFrameInView, BOOL opening, BOOL closing) {
    
         Try not to call "self" inside this block (retain cycle).
         But if you do, make sure to remove DAKeyboardControl
         when you are done with the view controller by calling:
         [self.view removeKeyboardControl];
    
        
        CGRect toolBarFrame = _toolBar.frame;
        toolBarFrame.origin.y = keyboardFrameInView.origin.y - toolBarFrame.size.height;
        _toolBar.frame = toolBarFrame;
    } constraintBasedActionHandler:nil];*/


    
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
        NSLog(@" =========执行发布的方法");

        //执行发布的方法
    }
    else if (button.tag==99)
    {
        //点击确定按钮
        NSLog(@" =========点击确定按钮");
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
