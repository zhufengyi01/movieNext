//
//  ShareView.m
//  movienext
//
//  Created by 风之翼 on 15/5/19.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "UMShareView.h"
#import "ZCControl.h"
#import "MyButton.h"
#import "Constant.h"
#import "Function.h"
#import "MobClick.h"
#import "AFNetworking.h"
@implementation UMShareView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
-(instancetype)initwithStageInfo:(stageInfoModel *) StageInfo ScreenImage:(UIImage *) screenImage delgate:(id<UMShareViewDelegate>) delegate andShareHeight:(float) Height;
{
    if ([super init]) {
        
        _delegate=delegate;
        _screenImage=screenImage;
        _stageInfo=StageInfo;
        shareheight=Height;
        self.frame=CGRectMake(0, 0,kDeviceWidth,kDeviceHeight);
        self.backgroundColor =[[UIColor blackColor] colorWithAlphaComponent:0];
        
        float height=(kDeviceWidth/4)+Height+40+30+50;
        backView =[[UIView alloc]initWithFrame:CGRectMake(0,kDeviceHeight, kDeviceWidth, height)];
        backView.userInteractionEnabled=YES;
        backView.backgroundColor =[UIColor whiteColor];
        //用于截取点击self的事件
        UITapGestureRecognizer  *t =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click)];
        [backView addGestureRecognizer:t];
        
        [self addSubview:backView];
        [self createNavigation];
        [self createShareView];
        [self createButtomView];
        //添加手势
        UITapGestureRecognizer  *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(CancleShareClick)];
        [self addGestureRecognizer:tap];
    }
    return self;
}
-(void)createNavigation
{
    self.tipLable=[[M80AttributedLabel alloc]initWithFrame:CGRectZero];
    //NSMutableAttributedString  *attrstr =[[NSMutableAttributedString alloc]initWithString:@"分享"];
    self.tipLable.textColor=VGray_color;
    self.tipLable.font=[UIFont fontWithName:kFontRegular size:14];
    //[self.tipLable appendText:@"分享"];
    self.tipLable.backgroundColor =[UIColor clearColor];
    self.tipLable.textAlignment=kCTTextAlignmentCenter;
    // CGSize Tsize =[self.tipLable sizeThatFits:CGSizeMake(kDeviceWidth,CGFLOAT_MAX)];
    self.tipLable.frame=CGRectMake(0, 10, kDeviceWidth, 30);
    [backView addSubview:self.tipLable];
}
-(void)setShareLable;
{
    
    if (self.pageType==UMShareTypeSuccess) {
        UIImageView *sucImage =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 15, 15)];
        sucImage.image =[UIImage imageNamed:@"sucseed_add"];
        [self.tipLable appendView:sucImage margin:UIEdgeInsetsMake(0, 0,0,5)];
        self.tipLable.font=[UIFont fontWithName:kFontRegular size:12];
        [self.tipLable appendText:@"发布成功,卡片将出现在发现页,快去分享吧!"];
    }
    else {
        [self.tipLable appendText:@"分享"];
    }
}


//截获点击屏幕的事件
-(void)click
{
    
}
-(void)CancleShareClick
{
    [UIView animateWithDuration:KShow_ShareView_Time animations:^{
        float height=(kDeviceWidth/4)+shareheight+40+30+50;
        backView.frame=CGRectMake(0, kDeviceHeight, kDeviceWidth,height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
//点击取消需要返回
-(void)cancleshareClick
{
    if (_delegate&&[_delegate respondsToSelector:@selector(UMCancleShareClick)]) {
        [_delegate UMCancleShareClick];
    }
    [UIView animateWithDuration:KShow_ShareView_Time animations:^{
        float height=(kDeviceWidth/4)+shareheight+40+30+50;
        backView.frame=CGRectMake(0, kDeviceHeight, kDeviceWidth,height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(void)createShareView
{
    shareView =[[UIView alloc]initWithFrame:CGRectMake(10,40, kDeviceWidth-20,shareheight+20)];
    shareView.userInteractionEnabled=YES;
    shareView.backgroundColor=View_BackGround;
    [backView addSubview:shareView];
    
    _ShareimageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0,shareView.frame.size.width,shareheight)];
    //    _ShareimageView.backgroundColor=[UIColor redColor];
    _ShareimageView.image=_screenImage;
    _ShareimageView.contentMode=UIViewContentModeScaleAspectFit;
    
    [shareView addSubview:_ShareimageView];
    
    //放置电影名和标签的view
    logosupView=[[UIView alloc]initWithFrame:CGRectMake(0,_ShareimageView.frame.origin.y+_ShareimageView.frame.size.height-2,kDeviceWidth-20, 22)];
    logosupView.backgroundColor=[UIColor blackColor];
    // logosupView.hidden=YES;
    [shareView addSubview:logosupView];
    
    _moviewName= [ZCControl createLabelWithFrame:CGRectMake(0,0,kDeviceWidth-20, 20) Font:12 Text:@""];
    _moviewName.textColor=ShareLogo_color;
    _moviewName.numberOfLines=0;
    
    if (!_stageInfo.movieInfo|!_stageInfo.movieInfo.name) {
        _stageInfo.movieInfo.name=@"";
    }
    _moviewName.text=[NSString stringWithFormat:@"%@",_stageInfo.movieInfo.name];
    _moviewName.adjustsFontSizeToFitWidth=NO;
    _moviewName.lineBreakMode=NSLineBreakByTruncatingTail;
    [logosupView addSubview:_moviewName];
    
    NSMutableString  *namstr =[[NSMutableString alloc]initWithString:_stageInfo.movieInfo.name];
    NSString  *str=namstr;
    if (namstr.length>20) {
        str= [namstr substringToIndex:20];
        str =[str stringByAppendingString:@"..."];
    }
    _moviewName.text=[NSString stringWithFormat:@"《%@》 电影卡片App",str];
    _moviewName.textAlignment=NSTextAlignmentCenter;
    
    //    CGSize Msize =[_stageInfo.movieInfo.name boundingRectWithSize:CGSizeMake(100, 20) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:[NSDictionary dictionaryWithObject:_moviewName.font forKey:NSFontAttributeName] context:nil].size;
    //    _moviewName.frame=CGRectMake(0, 0, Msize.width, 20);
    //
    
    logoLable=[ZCControl createLabelWithFrame:CGRectMake(_moviewName.frame.origin.x+_moviewName.frame.size.width,0,50, 20) Font:12 Text:@"电影卡片"];
    logoLable.textAlignment=NSTextAlignmentRight;
    logoLable.textColor=VGray_color;
    //logoLable.backgroundColor =[UIColor whiteColor];
    // [logosupView addSubview:logoLable];
    
}
-(void)createButtomView
{
    
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, backView.frame.size.height-(kDeviceWidth/4)-40-5, kDeviceWidth, 0.5)];
    lineV.backgroundColor = VLight_GrayColor;
    [backView addSubview:lineV];
    
    buttomView=[[UIView alloc]initWithFrame:CGRectMake(0,backView.frame.size.height-(kDeviceWidth/4)-40, kDeviceWidth, (kDeviceWidth)/4)];
    buttomView.backgroundColor=[UIColor whiteColor];
    buttomView.userInteractionEnabled=YES;
    [backView addSubview:buttomView];
#pragma create four button
    NSArray  *imageArray=[NSArray arrayWithObjects:@"moment_share.png",@"wechat_share.png",@"weibo_share.png", @"download.png", nil];
    NSArray *titleArray = [NSArray arrayWithObjects:@"朋友圈", @"微信", @"微博", @"保存", nil];
    for (int i=0; i<4; i++) {
        double   x=(buttomView.bounds.size.width/4)*i;
        double   y=10;
        MyButton *btn = [MyButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(x,y, kDeviceWidth/4, kDeviceWidth/4) ImageName:imageArray[i] Target:self Action:@selector(handShareButtonClick:) Title:titleArray[i] Font:12];
        btn.tag=10000+i;
        [btn setTitleColor:VBlue_color forState:UIControlStateNormal];
        btn.backgroundColor=[UIColor whiteColor];
        [buttomView addSubview:btn];
    }
    UIButton  *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"取消" forState:UIControlStateNormal];
    [button setTitleColor:VGray_color forState:UIControlStateNormal];
    button.frame=CGRectMake(20, backView.frame.size.height-50, kDeviceWidth-40, 40);
    button.titleLabel.font =[UIFont fontWithName:kFontRegular size:14];
    button.backgroundColor = VLight_GrayColor_apla;
    button.layer.cornerRadius = 3;
    [button addTarget:self action:@selector(cancleshareClick) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:button];
}

//点击分享
-(void)handShareButtonClick:(UIButton *) button
{
    [self requestShareWithMethod: [NSString stringWithFormat:@"%ld",button.tag-10000]];
    logosupView.hidden=NO;
    shareImage=[Function getImage:shareView WithSize:CGSizeMake(kDeviceWidth-20, shareheight+20)];
    
    NSArray *eventArray = [NSArray arrayWithObjects:@"share_moment", @"share_wechat", @"share_weibo", @"share_download", nil];
    
    [MobClick event:eventArray[button.tag-10000]];
    
    if (button.tag == 10003) {
        UIImageWriteToSavedPhotosAlbum(shareImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        //[self removeFromSuperview];
        return;
    }
    if (_delegate &&[_delegate respondsToSelector:@selector(UMShareViewHandClick:ShareImage:StageInfoModel:)]) {
        [_delegate UMShareViewHandClick:button ShareImage:shareImage StageInfoModel:_stageInfo];
    }
    
    [self CancleShareClick];
    
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error
  contextInfo:(void *)contextInfo
{
    [self CancleShareClick];
    if (error != NULL)
    {
        UIAlertView  *Al =[[UIAlertView alloc]initWithTitle:nil message:@"保存失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [Al show];
        NSLog(@"保存失败");
    } else {
        UIAlertView  *al =[[UIAlertView alloc]initWithTitle:nil message:@"图片保存成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [al show];
    }
}
//以动画形式显示出分享视图
-(void)show
{
    //添加分享视图到window
    [AppView addSubview:self];
    [UIView animateWithDuration:KShow_ShareView_Time animations:^{
        float height=(kDeviceWidth/4)+shareheight+40+30+50;
        backView.frame=CGRectMake(0, kDeviceHeight-height, kDeviceWidth, height);
        self.backgroundColor =[[UIColor blackColor] colorWithAlphaComponent:0.5];
        
    } completion:^(BOOL finished) {
        self.backgroundColor =[[UIColor blackColor] colorWithAlphaComponent:0.5];
    }];
}

//微博分享上传到服务器
-(void)requestShareWithMethod:(NSString *) method;
{
    UserDataCenter  *userCenter=[UserDataCenter shareInstance];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters=@{@"user_id":userCenter.user_id,@"weibo_id":self.weiboInfo.Id,@"platform":@"1",@"method":method};
    [manager POST:[NSString stringWithFormat:@"%@/share/create", kApiBaseUrl] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject  objectForKey:@"code"]  intValue]==0) {
            NSLog(@"分享发送成功=======%@",responseObject);
         }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}


@end
