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
#import "UserDataCenter.h"
#import "UIImageView+WebCache.h"
#import "AFNetworking.h"
@interface AddMarkViewController ()<UITextFieldDelegate,UIAlertViewDelegate>
{
    UIToolbar  *_toolBar;
    UITextField  *_inputText;
    MarkView  *_myMarkView;
    NSString    *X;
    NSString    *Y;
    CGSize   keyboardSize;
}
@end

@implementation AddMarkViewController

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.alpha=1;
    self.tabBarController.tabBar.hidden=YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   // _myDict =[NSDictionary dictionaryWithDictionary:_stageDict];
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
    [RighttBtn setTitle:@"发布" forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:RighttBtn];
    

}
-(void)createStageView
{
    stageView = [[StageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceWidth)];
 //   NSLog(@" 在 添加弹幕页面的   stagedict = %@",_myDict);
    stageView.StageInfoDict=self.stageInfoDict;
    [stageView configStageViewforStageInfoDict];
       NSLog(@" 在 添加弹幕页面的   stagedict = %@",self.stageInfoDict);
     [self.view addSubview:stageView];
}

-(void)createButtomView
{
     _toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0,kDeviceHeight-50-kHeightNavigation, kDeviceHeight, 50)];
     //_toolBar.barTintColor=[UIColor redColor];   //背景颜色
     // [self.navigat setBackgroundImage:[UIImage imageNamed:@"tabbar_backgroud_color.png"] forBarMetrics:UIBarMetricsDefault];
     [_toolBar setBackgroundImage:[UIImage imageNamed:@"tabbar_backgroud_color.png"] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
     _toolBar.tintColor=VGray_color;  //内容颜色
     
     _inputText= [[UITextField alloc]initWithFrame:CGRectMake(10,10, kDeviceWidth-80,30)];
     _inputText.font = [UIFont systemFontOfSize:14];
    _inputText.delegate=self;
     _inputText.layer.cornerRadius=4;
     _inputText.layer.borderWidth=0.5;
     _inputText.layer.borderColor=VLight_GrayColor.CGColor;

     [_toolBar addSubview:_inputText];
     
     UIButton  *publishBtn=[ZCControl createButtonWithFrame:CGRectMake(kDeviceWidth-60, 10, 50, 28) ImageName:@"loginoutbackgroundcolor.png" Target:self Action:@selector(dealNavClick:) Title:@"确定"];
    
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
    }
    else if (button.tag==101)
    {        [self  PublicRuqest];
        //执行发布的方法
    }
    else if (button.tag==99)
    {
        //点击确定按钮
        NSLog(@" =========点击发布到屏幕");
        [self  PushlicInScreen];
        
    }
}
//把markview 添加到屏幕
-(void)PushlicInScreen
{
    //清楚原来添加的弹幕
    for (UIView *view in stageView.subviews) {
        if ([view isKindOfClass:[MarkView class]]) {
            [view removeFromSuperview];
        }
    }
    _myMarkView =[[MarkView alloc]initWithFrame:CGRectMake(100,140 , 100, 20)];
    ///显示标签的头像
    UserDataCenter  * userCenter=[UserDataCenter shareInstance];
    [ _myMarkView.LeftImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@!thumb",kUrlAvatar,    userCenter.avatar]]];
    _myMarkView.TitleLable.text=[_inputText text];
    [stageView addSubview:_myMarkView];
    
    
    NSString   *inputString=_inputText.text;
     CGSize  Msize= [inputString  boundingRectWithSize:CGSizeMake(kDeviceWidth/2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:_myMarkView.TitleLable.font forKey:NSFontAttributeName] context:nil].size;
    
    //宽度=字的宽度+左头像图片的宽度＋赞图片的宽度＋赞数量的宽度+中间两个空格2+2
    //位置=
    float markViewWidth = Msize.width+23+5+5+11+5;
    float markViewHeight = Msize.height+6;
    _myMarkView.frame=CGRectMake((kDeviceWidth-markViewWidth)/2, stageView.frame.size.height/2, markViewWidth, markViewHeight);
    X =[NSString stringWithFormat:@"%f",((_myMarkView.frame.origin.x+_myMarkView.frame.size.width)/kDeviceWidth)*100];
    Y=[NSString stringWithFormat:@"%f",((_myMarkView.frame.origin.y+(markViewHeight/2))/kDeviceHeight)*100];

    //在标签上添加一个手势
     UIPanGestureRecognizer   *pan=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handelPan:)];
    [_myMarkView addGestureRecognizer:pan];

}

-(void)handelPan:(UIPanGestureRecognizer*)gestureRecognizer{
   //获取平移手势对象在stageView的位置点，并将这个点作为self.aView的center,这样就实现了拖动的效果
    CGPoint curPoint = [gestureRecognizer locationInView:stageView];    
    CGFloat xoffset = _myMarkView.frame.size.width/2.0;
    CGFloat yoffset = _myMarkView.frame.size.height/2.0;
    //CGRect  stageViewfrem=stageView.frame;
    float  stageX=kDeviceWidth;
    float hight= kDeviceWidth;
    float  ImageWith=[self.stageInfoDict.w intValue]; //[[self.StageInfoDict objectForKey:@"w"]  floatValue];
    float  ImgeHight=[self.stageInfoDict.h intValue];//[[self.StageInfoDict objectForKey:@"h"]  floatValue];
    if(ImgeHight>ImageWith)
    {
        hight=  (ImgeHight/ImageWith) *kDeviceWidth;
    }
    float  stageY=hight;
    
    CGFloat x = MIN(stageX-xoffset,  MAX(xoffset, curPoint.x) );
    CGFloat y = MIN(stageY-yoffset,  MAX(yoffset, curPoint.y) );
    _myMarkView.center = CGPointMake(x, y);
}
# pragma  mark  发布数据请求
//确定发布
-(void)PublicRuqest
{
    if ([_inputText text].length==0) {
        UIAlertView  *Al =[[UIAlertView alloc]initWithTitle:nil message:@"对不起，您还没有添加内容" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [Al show];
        return ;
    }
    UserDataCenter  *userCenter=[UserDataCenter shareInstance];
    NSDictionary *parameter = @{@"user_id": userCenter.user_id,@"topic_name":[_inputText text],@"stage_id":self.stageInfoDict.Id,@"x":X,@"y":Y};

    NSLog(@"==parameter====%@",parameter);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/weibo/create", kApiBaseUrl] parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"  添加弹幕发布请求    JSON: %@", responseObject);
        if ([responseObject  objectForKey:@"detail"]) {
            UIAlertView  *Al=[[UIAlertView alloc]initWithTitle:@"发布成功" message:@"恭喜你发布成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [Al show];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}
//发布弹幕请求
#pragma mark 键盘的通知事件
-(void)keyboardWillShow:(NSNotification * )  notification
{
        NSDictionary *info = [notification userInfo];
        NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
         keyboardSize = [value CGRectValue].size;
       float  timeInterval=1.0;
        NSLog(@"keyBoard:%f", keyboardSize.height);
        ///keyboardWasShown = YES;
    if (keyboardSize.height>216) {
        keyboardSize.height=keyboardSize.height+30;
        timeInterval=0.3;
    }
    
    [UIView  animateWithDuration:timeInterval animations:^{
        CGRect  tframe=_toolBar.frame;
        tframe.origin.y=kDeviceHeight-keyboardSize.height-35-kHeightNavigation-50;
        _toolBar.frame=tframe;
    } completion:^(BOOL finished) {
        
    }];
}
-(void)keyboardWillHiden:(NSNotification *) notification
{
    
    [UIView  animateWithDuration:1.0 animations:^{
        CGRect  tframe=_toolBar.frame;
        tframe.origin.y=kDeviceHeight-50-kHeightNavigation;
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

#pragma  mark  ----UIAlertViewdelegate  ---
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
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
