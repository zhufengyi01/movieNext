//
//  UMShareViewController2.m
//  movienext
//
//  Created by 风之翼 on 15/4/30.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "UMShareViewController2.h"
#import "ZCControl.h"
#import "Constant.h"
#import "Function.h"
#import "TagView.h"
#import "UIImageView+WebCache.h"
@interface UMShareViewController2 ()
{
    
    UIScrollView  *myScrollerView;
    UIView  *shareView;
}
//标签
@property(nonatomic,strong) M80AttributedLabel  *tagLable;
//内容
@property(nonatomic,strong) UILabel   *contentLable;

@property(nonatomic,strong) UIImageView   *headImage;

@property(nonatomic,strong) UILabel   *userName;

@property(nonatomic,strong) UILabel   *logoName;


@end

@implementation UMShareViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    [self createNavigation];
    [self creatScrollerView];
    
    [self createStageView];
    [self createButtomView];

}

-(void)createNavigation
{
    //[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"tabbar_backgroud_color.png"] forBarMetrics:UIBarMetricsDefault];
    
    UIView  *view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kHeightNavigation)];
    view.userInteractionEnabled=YES;
    view.layer.shadowColor=[UIColor blackColor].CGColor;
    view.layer.shadowRadius=8;
    //view.backgroundColor =[UIColor redColor];
    view.layer.shadowOpacity=1;
    view.layer.shadowOffset=CGSizeMake(20, 100);
    
    [self.view addSubview:view];
    
    UILabel  *titleLable=[ZCControl createLabelWithFrame:CGRectMake((kDeviceWidth-100)/2, 30, 100, 20) Font:16 Text:@"分享"];
    titleLable.textColor=VBlue_color;
    titleLable.font=[UIFont boldSystemFontOfSize:18];
    titleLable.textAlignment=NSTextAlignmentCenter;
//    self.navigationItem.titleView=titleLable;
    [view addSubview:titleLable];
    
    UIButton  *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"取消" forState:UIControlStateNormal];
    [button setTitleColor:VBlue_color forState:UIControlStateNormal];
    button.frame=CGRectMake(10, 30, 40, 30);
    [button addTarget:self action:@selector(CancleShareClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
//    UIBarButtonItem  *barButton=[[UIBarButtonItem alloc]initWithCustomView:button];
//    self.navigationItem.leftBarButtonItem=barButton;
    
}
-(void)CancleShareClick:(UIButton *) button
{
 
//    //[self dismissViewControllerAnimated:YES completion:nil];
    [self dismissViewControllerAnimated:YES completion:^{
        
     }];
}

-(void)createButtomView
{
    buttomView=[[UIView alloc]initWithFrame:CGRectMake(0, kDeviceHeight-kDeviceWidth/4-kHeightNavigation+64, kDeviceWidth, kDeviceWidth/4+64)];
    buttomView.backgroundColor=[UIColor whiteColor];
    buttomView.userInteractionEnabled=YES;
    [self.view addSubview:buttomView];
#pragma create four button
    NSArray  *imageArray=[NSArray arrayWithObjects:@"wechat_share_icon.png",@"moments_share_icon.png",@"qzone_share_icon.png",@"weibo_share_icon.png", nil];
    for (int i=0; i<4; i++) {
        double   x=(kDeviceWidth/4)*i;
        double   y=0;
        UIButton  *    btn = [ZCControl createButtonWithFrame:CGRectMake(x,y, kDeviceWidth/4, kDeviceWidth/4) ImageName:imageArray[i] Target:self Action:@selector(handShareButtonClick:) Title:nil];
        btn.tag=10000+i;
        btn.backgroundColor=[UIColor whiteColor];
        [buttomView addSubview:btn];
    }
}

-(void)creatScrollerView
{
    myScrollerView =[[UIScrollView alloc]initWithFrame:CGRectMake(0,64, kDeviceWidth,kDeviceHeight-kDeviceWidth/4-kHeightNavigation)];
    myScrollerView.contentSize=CGSizeMake(kDeviceWidth, kDeviceHeight);
    //myScrollerView.backgroundColor =[UIColor  yellowColor];
    [self.view addSubview:myScrollerView];
}


-(void)createStageView
{
    //   self.view.backgroundColor=VStageView_color;
    
    shareView =[[UIView alloc]initWithFrame:CGRectMake(0,0,kDeviceWidth, kDeviceWidth+20)];
    shareView.userInteractionEnabled=YES;
    shareView.backgroundColor=[UIColor whiteColor];
    [myScrollerView addSubview:shareView];
    
    
    float  ImageWith=[self.StageInfo.width intValue];
    float  ImgeHight=[self.StageInfo.height intValue];
    if (ImageWith==0) {
        ImageWith=kDeviceWidth;
    }
    if (ImgeHight==0) {
        ImgeHight=kDeviceWidth;
    }
    float  height =(ImgeHight/ImageWith)*kDeviceWidth;
    _ShareimageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth,height)];
    _ShareimageView.backgroundColor=[UIColor whiteColor];
   // _ShareimageView.image=self.screenImage;
     NSString *photostring=[NSString stringWithFormat:@"%@%@!w640",kUrlStage,self.StageInfo.photo];
    [_ShareimageView sd_setImageWithURL:[NSURL URLWithString:photostring] placeholderImage:nil];
    [shareView addSubview:_ShareimageView];
 
    // 电影名
    _moviewName= [ZCControl createLabelWithFrame:CGRectMake(15,_ShareimageView.frame.origin.y+_ShareimageView.frame.size.height+10, kDeviceWidth-40, 20) Font:14 Text:@""];
    _moviewName.textColor=VLight_GrayColor;
    _moviewName.numberOfLines=0;
    _moviewName.adjustsFontSizeToFitWidth=NO;
    _moviewName.text=[NSString stringWithFormat:@"《%@》", self.StageInfo.movieInfo.name];
    _moviewName.lineBreakMode=NSLineBreakByTruncatingTail;
    [shareView addSubview:_moviewName];
    
    //标签
    if (self.weiboInfo.tagArray&&self.weiboInfo.tagArray.count) {
        self.tagLable =[[M80AttributedLabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
        self.tagLable.frame=CGRectMake(_moviewName.frame.origin.x,_moviewName.frame.origin.y+_moviewName.frame.size.height+10,kDeviceWidth-30, TagHeight+0);
        self.tagLable.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0];
        for (int i=0; i<self.weiboInfo.tagArray.count; i++) {
            TagView *tagview = [self createTagViewWithtagInfo:self.weiboInfo.tagArray[i] andIndex:i];
            [self.tagLable appendView:tagview margin:UIEdgeInsetsMake(0, 0, 0, 5)];
        }
        [shareView addSubview:self.tagLable];
    }
    
    //内容
    self.contentLable=[ZCControl createLabelWithFrame:CGRectMake(_moviewName.frame.origin.x,_moviewName.frame.origin.y+_moviewName.frame.size.height+10, kDeviceWidth-30, 40) Font:MarkTextFont14 Text:self.weiboInfo.content];
    self.contentLable.adjustsFontSizeToFitWidth=NO;
    if (IsIphone6plus) {
        self.contentLable.font=[UIFont systemFontOfSize:MarkTextFont16];
    }
    self.contentLable.numberOfLines=0;
    if (self.weiboInfo.tagArray.count>0) {
        self.contentLable.frame=CGRectMake(self.tagLable.frame.origin.x,self.tagLable.frame.origin.y+self.tagLable.frame.size.height+5, kDeviceWidth-30, 40);
        
    }
    CGSize  Wsize =[self.contentLable.text boundingRectWithSize:CGSizeMake(kDeviceWidth-30, MAXFLOAT) options:(NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin) attributes:[NSDictionary dictionaryWithObject:self.contentLable.font forKey:NSFontAttributeName] context:nil].size;
    self.contentLable.frame=CGRectMake(self.contentLable.frame.origin.x, self.contentLable.frame.origin.y, self.contentLable.frame.size.width, Wsize.height+0);
    self.contentLable.textAlignment=NSTextAlignmentLeft;
    self.contentLable.textColor=VGray_color;
    [shareView addSubview:self.contentLable];

 
    //用户头像
    self.headImage=[[UIImageView alloc]initWithFrame:CGRectMake(_moviewName.frame.origin.x,self.contentLable.frame.origin.y+self.contentLable.frame.size.height+80,30, 30)];
   NSString  *headString =  [NSString stringWithFormat:@"%@%@!thumb",kUrlAvatar,self.weiboInfo.uerInfo.logo];
    [self.headImage  sd_setImageWithURL:[NSURL URLWithString:headString] placeholderImage:HeadImagePlaceholder];
    self.headImage.layer.cornerRadius=4;
    self.headImage.layer.masksToBounds = YES;
    [shareView addSubview:self.headImage];

    
    //用户名
    self.userName=[ZCControl createLabelWithFrame:CGRectMake(_moviewName.frame.origin.x+self.headImage.frame.size.width+10,self.headImage.frame.origin.y, kDeviceWidth-20,30) Font:14 Text:self.weiboInfo.uerInfo.username];
    self.userName.adjustsFontSizeToFitWidth=NO;
    self.userName.numberOfLines=0;
    self.userName.textAlignment=NSTextAlignmentLeft;
    self.userName.textColor=VGray_color;
    [shareView addSubview:self.userName];
    
    shareView.frame=CGRectMake(0,0, kDeviceWidth, self.userName.frame.origin.y+self.userName.frame.size.height+60);
    myScrollerView.contentSize=CGSizeMake(kDeviceWidth, shareView.frame.size.height+0);
    
    
    logoView =[[UIView alloc]initWithFrame:CGRectMake(0, self.headImage.frame.origin.y+self.headImage.frame.size.height+30, kDeviceWidth, 30) ];
    logoView.hidden=YES;
    logoView.backgroundColor =View_ToolBar;
    [shareView addSubview:logoView];
    
    self.logoName=[ZCControl createLabelWithFrame:CGRectMake(_moviewName.frame.origin.x,0, kDeviceWidth-20,logoView.frame.size.height) Font:12 Text:@"Powered By 影弹"];
    self.logoName.adjustsFontSizeToFitWidth=NO;
    self.logoName.numberOfLines=1;
    self.logoName.textAlignment=NSTextAlignmentLeft;
    self.logoName.textColor=ShareLogo_color;
    [logoView addSubview:self.logoName];

}

//创建标签的方法
-(TagView *)createTagViewWithtagInfo:(TagModel *) tagmodel andIndex:(NSInteger ) index
{
    TagView *tagview =[[TagView alloc]initWithFrame:CGRectZero];
    tagview.clipsToBounds=YES;
    tagview.tag=1000+index;
    tagview.tagBgImageview.backgroundColor =[UIColor colorWithRed:155.0/255 green:155.0/255 blue:155.0/255 alpha:1];
    tagview.weiboInfo=self.weiboInfo;
    NSString *titleStr = tagmodel.tagDetailInfo.title;
    tagview.titleLable.text=titleStr;
    CGSize  Tsize =[titleStr boundingRectWithSize:CGSizeMake(MAXFLOAT, TagHeight) options:(NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin) attributes:[NSDictionary dictionaryWithObject:tagview.titleLable.font forKey:NSFontAttributeName] context:nil].size;
    //纪录前面一个标签的宽度
    tagview.frame=CGRectMake(0,0, Tsize.width+10, TagHeight);
    return tagview;
}

//点击分享
-(void)handShareButtonClick:(UIButton *) button
{
  
    logoView.hidden=NO;
    [self dismissViewControllerAnimated:YES completion:^{
        shareImage=[Function getImage:shareView WithSize:CGSizeMake(kDeviceWidth,shareView.frame.size.height)];
        
        if (self.delegate &&[self.delegate respondsToSelector:@selector(UMShareViewController2HandClick:ShareImage:StageInfoModel:)]) {
            [self.delegate UMShareViewController2HandClick:button ShareImage:shareImage StageInfoModel:self.StageInfo];
        }
        
    }];
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
