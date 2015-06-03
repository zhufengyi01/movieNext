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
@implementation UMShareView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initwithStageInfo:(stageInfoModel *) stageInfo ScreenImage:(UIImage *) screenImage delgate:(id<UMShareViewDelegate>) delegate
{
    if ([super init]) {
        _delegate=delegate;
        _screenImage=screenImage;
        _stageInfo=stageInfo;
        self.frame=CGRectMake(0, 0,kDeviceWidth,kDeviceHeight);
        self.backgroundColor =[[UIColor blackColor] colorWithAlphaComponent:0];
        
        float height=(kDeviceWidth/4)+(kDeviceWidth-20)*(9.0/16)+40+30+50;
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
    UILabel  *titleLable=[ZCControl createLabelWithFrame:CGRectMake((kDeviceWidth-100)/2, 0, 100, 40) Font:14 Text:@"分享"];
    titleLable.textColor=VGray_color;
    titleLable.textAlignment=NSTextAlignmentCenter;
    [backView addSubview:titleLable];
}
//截获点击屏幕的事件
-(void)click
{
    
}
-(void)CancleShareClick
{
    [UIView animateWithDuration:KShow_ShareView_Time animations:^{
        float height=(kDeviceWidth/4)+(kDeviceWidth-20)*(9.0/16)+40+30+50;
        backView.frame=CGRectMake(0, kDeviceHeight, kDeviceWidth,height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(void)createShareView
{
    shareView =[[UIView alloc]initWithFrame:CGRectMake(10,40, kDeviceWidth-20, (kDeviceWidth-20)*(9.0/16)+20)];
    shareView.userInteractionEnabled=YES;
    shareView.backgroundColor=View_BackGround;
    [backView addSubview:shareView];
    
    _ShareimageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0,kDeviceWidth-20,(kDeviceWidth-20)*(9.0/16))];
    _ShareimageView.backgroundColor=[UIColor redColor];
    _ShareimageView.image=_screenImage;
    [shareView addSubview:_ShareimageView];
    
    //放置电影名和标签的view
    logosupView=[[UIView alloc]initWithFrame:CGRectMake(0,_ShareimageView.frame.origin.y+_ShareimageView.frame.size.height,kDeviceWidth-20, 20)];
    logosupView.backgroundColor=[UIColor blackColor];
   // logosupView.hidden=YES;
    [shareView addSubview:logosupView];
    
    _moviewName= [ZCControl createLabelWithFrame:CGRectMake(0,0,kDeviceWidth-20, 20) Font:12 Text:@""];
    _moviewName.textColor=VLight_GrayColor;
    _moviewName.numberOfLines=0;
  
    _moviewName.text=[NSString stringWithFormat:@"%@",_stageInfo.movieInfo.name];
    _moviewName.adjustsFontSizeToFitWidth=NO;
    _moviewName.lineBreakMode=NSLineBreakByTruncatingTail;
    [logosupView addSubview:_moviewName];
    
    if (!_stageInfo.movieInfo) {
        return;
     }
    NSMutableString  *namstr =[[NSMutableString alloc]initWithString:_stageInfo.movieInfo.name];
    NSString  *str=namstr;
    if (namstr.length>8) {
       str= [namstr substringToIndex:8];
       str =[str stringByAppendingString:@"..."];
    }
    _moviewName.text=[NSString stringWithFormat:@"《%@》 电影卡片",str];
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
    button.titleLabel.font =[UIFont systemFontOfSize:14];
    button.backgroundColor = VLight_GrayColor_apla;
    button.layer.cornerRadius = 3;
    [button addTarget:self action:@selector(CancleShareClick) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:button];
}

//点击分享
-(void)handShareButtonClick:(UIButton *) button
{
    logosupView.hidden=NO;
    shareImage=[Function getImage:shareView WithSize:CGSizeMake(kDeviceWidth-20, (kDeviceWidth-20)*(9.0/16)+20)];
    
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
    if (error != NULL)
    {
        NSLog(@"保存失败");
        
    } else {
        NSLog(@"已保存到相册");
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
        float height=(kDeviceWidth/4)+(kDeviceWidth-20)*(9.0/16)+40+30+50;
        backView.frame=CGRectMake(0, kDeviceHeight-height, kDeviceWidth, height);
        self.backgroundColor =[[UIColor blackColor] colorWithAlphaComponent:0.5];

    } completion:^(BOOL finished) {
        self.backgroundColor =[[UIColor blackColor] colorWithAlphaComponent:0.5];
    }];
    
    
}

@end
