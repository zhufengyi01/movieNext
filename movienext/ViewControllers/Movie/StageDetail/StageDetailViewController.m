//
//  StageDetailViewController.m
//  movienext
//
//  Created by 朱封毅 on 18/06/15.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "StageDetailViewController.h"
#import "ZCControl.h"
#import "Constant.h"
#import "AFNetworking.h"
#import "FindDatailViewController.h"
#import "ModelsModel.h"
#import "MovieViewController.h"
#import "UserDataCenter.h"
#import "weiboInfoModel.h"
#import "MJExtension.h"
#import "LoadingView.h"
#import "UIButton+Block.h"
#import "StageView.h"
#import "Like_HUB.h"
#import "UIImageView+WebCache.h"
#import "UMSocial.h"
#import "Function.h"
#import "UMShareView.h"
#import "StageDetailViewController.h"
#define  TOOLBAR_HEIGHT  160

@interface StageDetailViewController ()
{
    UIView  *BgView;//顶部放置分享图的view

}
@property(nonatomic,strong) UIView             *ShareView;   // 最终分享出去的图

@property(nonatomic,strong) UIImageView         *stageImageView;  //图片

@property(nonatomic,strong) UIScrollView        *stageScrollerView;

@property(nonatomic,strong)    UILabel  *markLable;
@end

@implementation StageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createScrollView];
    self.view.backgroundColor =[UIColor redColor];
//    
//    UILabel  *lbl =[[UILabel alloc]initWithFrame:CGRectMake(100, 100, 200, 30)];
//    lbl.text=@"12323";
//    [self.view addSubview:lbl];
}
-(void)createScrollView
{
    self.stageScrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-TOOLBAR_HEIGHT)];
    self.stageScrollerView.backgroundColor =View_BackGround;
    self.stageScrollerView.backgroundColor =[UIColor redColor];
    self.stageScrollerView.contentSize = CGSizeMake(kDeviceWidth, kDeviceHeight);
    [self.view addSubview:self.stageScrollerView];
    [self createStageView];
}
-(void)createStageView
{
    //分享出来的不是这个view
    BgView =[[UIImageView alloc]initWithFrame:CGRectMake(0,0,kDeviceWidth, (kDeviceWidth-0)*(9.0/16))];
    BgView.clipsToBounds=YES;
    [BgView.layer setShadowOffset:CGSizeMake(kDeviceWidth, 20)];
    BgView.backgroundColor=View_ToolBar;
    BgView.userInteractionEnabled=YES;
    [self.stageScrollerView addSubview:BgView];
    
    //最后要分享出去的图
    self.ShareView =[[UIView alloc]initWithFrame:CGRectMake(10,10, kDeviceWidth-20, (kDeviceWidth-20)*(9.0/16))];
    self.ShareView.userInteractionEnabled=YES;
    self.ShareView.backgroundColor=[UIColor blackColor];
    [BgView addSubview:self.ShareView];
    CGRect frame =[Function getImageFrameWithwidth:[self.weiboInfo.stageInfo.width intValue] height:[self.weiboInfo.stageInfo.height intValue] inset:20];
    
    //分享的view 上面放一张图片
    self.stageImageView =[[UIImageView alloc]initWithFrame:frame];
    self.stageImageView.contentMode=UIViewContentModeScaleAspectFill;
    self.stageImageView.clipsToBounds=YES;
    NSString *photostring=[NSString stringWithFormat:@"%@%@%@",kUrlStage,self.weiboInfo.stageInfo.photo,KIMAGE_BIG];
    [self.stageImageView   sd_setImageWithURL:[NSURL URLWithString:photostring] placeholderImage:nil options:(SDWebImageLowPriority|SDWebImageRetryFailed)];
    [self.ShareView addSubview:self.stageImageView];
    
    
    self.ShareView.frame=CGRectMake(10, 10, kDeviceWidth-20, self.stageImageView.frame.size.height+0);
    BgView.frame=CGRectMake(0, 0, kDeviceWidth, self.ShareView.frame.size.height+20);
    
    
    //创建剧照上的渐变背景文字
    UIView  *_layerView =[[UIView alloc]initWithFrame:CGRectMake(0, self.stageImageView.frame.size.height-60, kDeviceWidth-20, 60)];
    [self.stageImageView addSubview:_layerView];
    CAGradientLayer * _gradientLayer = [CAGradientLayer layer];  // 设置渐变效果
    _gradientLayer.bounds = _layerView.bounds;
    _gradientLayer.borderWidth = 0;
    
    _gradientLayer.frame = _layerView.bounds;
    _gradientLayer.colors = [NSArray arrayWithObjects:
                             (id)[[UIColor clearColor] CGColor],
                             (id)[[UIColor blackColor] CGColor], nil, nil];
    _gradientLayer.startPoint = CGPointMake(0.5, 0.5);
    _gradientLayer.endPoint = CGPointMake(0.5, 1.0);
    [_layerView.layer insertSublayer:_gradientLayer atIndex:0];
    
    
    self.markLable=[ZCControl createLabelWithFrame:CGRectMake(10,40,_layerView.frame.size.width-20, 60) Font:20 Text:@"弹幕文字"];
    self.markLable.font =[UIFont fontWithName:kFontDouble size:23];
    //markLable.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.4];
    if (IsIphone6) {
        self.markLable.frame=CGRectMake(20, 30, _layerView.frame.size.width-40, 65);
        self.markLable.font =[UIFont fontWithName:kFontDouble size:25];
    }
    if (IsIphone6plus) {
        self.markLable.frame=CGRectMake(20, 20,_layerView.frame.size.width-40, 70);
        self.markLable.font=[UIFont fontWithName:kFontDouble size:28];
    }
    
    
    self.markLable.textColor=[UIColor whiteColor];
    //    weiboInfoModel *weibomodel;
    //    if (self.stageInfo.weibosArray.count>0) {
    //        weibomodel =[self.stageInfo.weibosArray objectAtIndex:0];
    //    }
    //    if (self.weiboInfo) {
    //        weibomodel=self.WeiboInfo;
    //    }
    //    markLable.text=weibomodel.content;
    //
    //    if (self.weiboInfo) {
    //        markLable.text=self.weiboInfo.content;
    //    }
    
    self.markLable.lineBreakMode=NSLineBreakByCharWrapping;
    self.markLable.contentMode=UIViewContentModeBottom;
    self.markLable.textAlignment=NSTextAlignmentCenter;
    self.markLable.text = self.weiboInfo.content;
    [self.ShareView addSubview:self.markLable];
    
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;
    NSDictionary *attributes = @{
                                 NSFontAttributeName:self.markLable.font,
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    self.markLable.attributedText = [[NSAttributedString alloc] initWithString:self.markLable.text attributes:attributes];
    
    self.markLable.textAlignment=NSTextAlignmentCenter;
    
    //计算文字的高度从而确定整个shareview的高度
    
    CGSize  Msize = [self.markLable.text boundingRectWithSize:CGSizeMake(kDeviceWidth-40, MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:[NSDictionary dictionaryWithObject:self.markLable.font forKey:NSFontAttributeName] context:nil].size;
    
    self.ShareView.frame=CGRectMake(self.ShareView.frame.origin.x, self.ShareView.frame.origin.y, self.ShareView.frame.size.width, self.ShareView.frame.size.height+Msize.height-27);
    BgView.frame=CGRectMake(0, 0, kDeviceWidth, self.ShareView.frame.size.height+20);
    self.markLable.frame=CGRectMake(10, self.ShareView.frame.size.height-Msize.height-5 ,self.ShareView.frame.size.width-20,Msize.height);
    //创建中间的工具栏
    //  [self createCenterContentView];
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
