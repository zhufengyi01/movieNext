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
#import "MyViewController.h"
#import "TagToStageViewController.h"
#define  TOOLBAR_HEIGHT  45

@interface StageDetailViewController ()<TagViewDelegate>
{
    UIView  *BgView;//顶部放置分享图的view
    
    UIView  *BgView2;  //中间包含名字和标签的view
    
    UIButton  *leftButtomButton;
    
    UIImageView  *MovieLogoImageView;//头像的图片
    
    UILabel  *movieNameLable;
    
    UIButton  *like_btn;
    
    UIImageView *starImageView;
    
    UILabel  *Like_lable;
    UIView  *TagContentView;
}

@property(nonatomic,strong) UIImageView         *stageImageView;  //图片

@property(nonatomic,strong) UIScrollView        *stageScrollerView;

@property(nonatomic,strong)    UILabel  *markLable;

@property(nonatomic,strong) M80AttributedLabel  *WeiboTagLable;  //中间

@end

@implementation StageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createScrollView];
    self.view.backgroundColor =View_BackGround;
}
-(void)createScrollView
{
    self.stageScrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-TOOLBAR_HEIGHT)];
    self.stageScrollerView.backgroundColor =View_BackGround;
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
    [self createCenterContentView];
}

-(void)createCenterContentView
{
    
    BgView2=[[UIView alloc]initWithFrame:CGRectMake(0,self.ShareView.frame.origin.y+self.ShareView.frame.size.height+5, kDeviceWidth, 40 +0)];
    //改变toolar 的颜色
    BgView2.backgroundColor=View_ToolBar;
    [self.view bringSubviewToFront:BgView2];
    [BgView addSubview:BgView2];
    BgView.frame=CGRectMake(0, 0, kDeviceWidth, self.ShareView.frame.size.height+45+20);
    
    
    leftButtomButton=[UIButton buttonWithType:UIButtonTypeCustom];
    leftButtomButton.frame=CGRectMake(10, 5, 140, 35);
    __weak typeof(self) weakSeaf = self;
    // [leftButtomButton addTarget:self action:@selector(StageMovieButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [leftButtomButton addActionHandler:^(NSInteger tag) {
        MyViewController  *myVC=[[MyViewController alloc]init];
         myVC.author_id =[NSString stringWithFormat:@"%@",weakSeaf.weiboInfo.uerInfo.Id];
        UIBarButtonItem  *item =[[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        weakSeaf.navigationItem.backBarButtonItem=item;
        [weakSeaf.navigationController pushViewController:myVC animated:YES];
        
    }];
    [BgView2 addSubview:leftButtomButton];
    
    
    MovieLogoImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,30, 30)];
    MovieLogoImageView.layer.cornerRadius=15;
     NSString  *uselogoString =[NSString stringWithFormat:@"%@%@!thumb",kUrlAvatar,self.weiboInfo.uerInfo.logo];
    if (self.weiboInfo) {
        uselogoString=[NSString stringWithFormat:@"%@%@!thumb",kUrlAvatar,self.weiboInfo.uerInfo.logo];
    }
    [MovieLogoImageView sd_setImageWithURL:[NSURL URLWithString:uselogoString] placeholderImage:[UIImage imageNamed:@"user_normal.png"]];
    MovieLogoImageView.layer.masksToBounds = YES;
    
    ///给管理员添加查看是否为虚拟用户
    UserDataCenter *userDataCenter = [UserDataCenter shareInstance];
    if ([userDataCenter.is_admin intValue]>0 && [self.weiboInfo.uerInfo.fake intValue] == 0) {
        UIImageView *ivFake = [[UIImageView alloc] initWithFrame:CGRectMake(MovieLogoImageView.bounds.size.width-10 , MovieLogoImageView.bounds.size.height-10, 6, 6)];
        ivFake.backgroundColor = [UIColor blueColor];
        ivFake.layer.masksToBounds = YES;
        ivFake.layer.cornerRadius = 3;
        [MovieLogoImageView addSubview:ivFake];
    }
    
    [leftButtomButton addSubview:MovieLogoImageView];
    
    movieNameLable =[[UILabel alloc]initWithFrame:CGRectMake(35,12, 120, 30)];
    movieNameLable.font=[UIFont fontWithName:kFontRegular size:16];
    movieNameLable.textColor=VGray_color;
    //movieNameLable.text=self.stageInfo.movieInfo.name;
    // movieNameLable.numberOfLines=1;
    movieNameLable.lineBreakMode=NSLineBreakByTruncatingTail;
    [leftButtomButton addSubview:movieNameLable];
    NSString  *nameStr=self.weiboInfo.uerInfo.username;
    if (!nameStr) {
        nameStr =self.weiboInfo.uerInfo.username;
    }
    CGSize  Nsize =[nameStr boundingRectWithSize:CGSizeMake(kDeviceWidth-35-70, 27) options:(NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin) attributes:[NSDictionary dictionaryWithObject:movieNameLable.font forKey:NSFontAttributeName] context:nil].size;
    movieNameLable.frame=CGRectMake(35,0, Nsize.width+4, 30);
    leftButtomButton.frame=CGRectMake(10, 9, 30+5+movieNameLable.frame.size.width, 27);
    movieNameLable.text=[NSString stringWithFormat:@"%@",nameStr];
    
    //点赞的按钮 上面放一张图片 右边放文字
    like_btn =[ZCControl createButtonWithFrame:CGRectMake(kStageWidth-70,10,70,25) ImageName:nil Target:self Action:@selector(clickLike:) Title:@""];
    like_btn.layer.cornerRadius=4;
    like_btn.clipsToBounds=YES;
    like_btn.backgroundColor=View_BackGround;
    [BgView2 addSubview:like_btn];
    
    //赞的星星
    starImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 7, 14,12)];
    starImageView.image =[UIImage imageNamed:@"like_nomoal.png"];
    [like_btn addSubview:starImageView];
    
    //赞的文字
    Like_lable =[ZCControl createLabelWithFrame:CGRectMake(20,0,40, 25) Font:14 Text:@""];
    Like_lable.textColor=VGray_color;
    Like_lable.textAlignment=NSTextAlignmentCenter;
    if (IsIphone6plus) {
        like_btn.frame=CGRectMake(kStageWidth-80, 10, 80, 32);
        starImageView.frame=CGRectMake(15, 10, 14, 12);
        Like_lable.frame=CGRectMake(20, 0, 60, 32);
    }
    
    if ([self.weiboInfo.like_count intValue]==0) {
        Like_lable.text=[NSString stringWithFormat:@"喜欢"];
    }
    else
    {
        Like_lable.text=[NSString stringWithFormat:@"%@",self.weiboInfo.like_count];
    }
    
    [like_btn addSubview:Like_lable];
    
    for (int i=0; i<self.upWeiboArray.count; i++) {
        UpweiboModel *upmodel=self.upWeiboArray[i];
        //weiboInfoModel  *weiboInfo =[self.stageInfo.weibosArray objectAtIndex:0];
        if ([upmodel.weibo_id intValue]==[self.weiboInfo.Id intValue]) {
            like_btn.selected=YES;
            starImageView.image=[UIImage imageNamed:@"like_slected.png"];
            break;
        }
        else{
            like_btn.selected=NO;
            starImageView.image=[UIImage imageNamed:@"like_nomoal.png"];
        }
    }
    [self createWeiboTagView];
    
}
-(void)createWeiboTagView
{
    if (TagContentView) {
        [TagContentView removeFromSuperview];
        TagContentView = nil;
    }
    if (self.WeiboTagLable) {
        [self.WeiboTagLable removeFromSuperview];
        self.WeiboTagLable=nil;
    }
    TagContentView  = [[UIView alloc]initWithFrame:CGRectMake(0, BgView2.frame.origin.y+BgView2.frame.size.height, kDeviceWidth, 40)];
    TagContentView.backgroundColor =[UIColor clearColor];
    [BgView addSubview:TagContentView];
    
    self.WeiboTagLable=[[M80AttributedLabel alloc]initWithFrame:CGRectZero];
    self.WeiboTagLable.backgroundColor =[UIColor clearColor];
    self.WeiboTagLable.lineSpacing=5;
    [TagContentView addSubview:self.WeiboTagLable];
    //初始化的时候获取第一个标签
    if (self.weiboInfo.tagArray.count>0) {
        for (int i=0; i<self.weiboInfo.tagArray.count; i++) {
            TagView  *tagView= [[TagView alloc]initWithWeiboInfo:self.weiboInfo AndTagInfo:self.weiboInfo.tagArray[i] delegate:self isCanClick:YES backgoundImage:nil isLongTag:NO];
            [tagView setcornerRadius:4];
            [tagView setbigTagWithSize:CGSizeMake(6,6)];
            tagView.tag=5000+i;
            //            tagView.backgroundColor =[UIColor redColor];
            [self.WeiboTagLable appendView:tagView margin:UIEdgeInsetsMake(5, 10, 0, 0)];
        }
    }
    CGSize  Tsize =[self.WeiboTagLable sizeThatFits:CGSizeMake(kDeviceWidth-20,CGFLOAT_MAX)];
    self.WeiboTagLable.frame=CGRectMake(0, 0, kDeviceWidth-20, Tsize.height+0);
    if (Tsize.height>10) {
        TagContentView.frame=CGRectMake(0, BgView2.frame.origin.y+BgView2.frame.size.height+5, kDeviceWidth,Tsize.height+5);
    }
    else
    {
        TagContentView.frame=CGRectMake(0, BgView2.frame.origin.y+BgView2.frame.size.height, kDeviceWidth, 10);
    }
    BgView.frame=CGRectMake(0,0,kDeviceWidth,TagContentView.frame.origin.y+TagContentView.frame.size.height+0);
    
    
}

#pragma mark 星星点赞方法
//点赞实现的方法
-(void)clickLike:(UIButton *) btn
{
    UserDataCenter  * userCenter =[UserDataCenter shareInstance];
    //普通用户
    NSNumber  *operation;
    if (btn.selected==YES) {
        btn.selected=NO;
        //已赞的,再点击就要移除数组
        operation =[NSNumber numberWithInt:0];
        for (int i=0; i<self.upWeiboArray.count; i++) {
            //已赞的
            UpweiboModel *upmodel =self.upWeiboArray[i];
            if ([upmodel.weibo_id intValue]==[self.weiboInfo.Id intValue]) {
                [self.upWeiboArray removeObjectAtIndex:i];
                break;
            }
        }
        starImageView.image=[UIImage imageNamed:@"like_nomoal.png"];
        //把赞的数量-1
        int  like =   [Like_lable.text intValue];
        like=like>0 ? like-1 : 0;
        self.weiboInfo.like_count=[NSNumber numberWithInt:like];
        
        if ([self.weiboInfo.like_count intValue]==0) {
            Like_lable.text=[NSString stringWithFormat:@"喜欢"];
        }
        else
        {
            Like_lable.text=[NSString stringWithFormat:@"%@",self.weiboInfo.like_count];
        }
        
    }
    else if (btn.selected==NO)
    {
        
        //        CGRect  starframe =leftButtomButton.frame;
        //
        //        UIImageView  *addone =[[UIImageView alloc]initWithFrame:CGRectMake(kDeviceWidth-70, starframe.origin.y-10, 10, 10)];
        //        addone.backgroundColor =[UIColor redColor];
        //        [BgView2 addSubview:addone];
        //
        //
        //
        //        [UIView animateWithDuration:1 animations:^{
        //            // 改变位置
        //            CGRect  addframe = addone.frame;
        //            addframe.origin.y=addframe.origin.y-50;
        //            //大小
        //            addframe.size=CGSizeMake(1, 0);
        //            addone.frame=addframe;
        //
        //            addone.alpha=0;
        //
        //
        //        } completion:^(BOOL finished) {
        //            [addone removeFromSuperview];
        //            ///addone=nil;
        //
        //        }];
        btn.selected=YES;
        //未赞
        operation =[NSNumber numberWithInt:1];
        UpweiboModel  *upmodel =[[UpweiboModel alloc]init];
        upmodel.weibo_id=self.weiboInfo.Id;
        upmodel.created_at=self.weiboInfo.created_at;
        upmodel.created_by=self.weiboInfo.created_by;
        upmodel.updated_at=self.weiboInfo.updated_at;
        [self.upWeiboArray addObject:upmodel];
        
        starImageView.image=[UIImage imageNamed:@"like_slected.png"];
        [Function BasicAnimationwithkey:@"transform.scale" Duration:0.25 repeatcont:1 autoresverses:YES fromValue:1.0 toValue:1.5 View:starImageView];
        // 把赞的数量+1
        int like=[self.weiboInfo.like_count intValue];
        like=like+1;
        self.weiboInfo.like_count=[NSNumber numberWithInt:like];
        Like_lable.text=[NSString stringWithFormat:@"%@",self.weiboInfo.like_count];
    }
    [self LikeRequstData:self.weiboInfo withOperation:operation withuserId:userCenter.user_id];
    //}
    
}

#pragma mark  =========RequestData
//operation  == 1 点赞    为  0  取消点赞
-(void)LikeRequstData:(weiboInfoModel  *) weiboInfo withOperation:(NSNumber *) operation withuserId:(NSString*)user_id
{
    //UserDataCenter  *userCenter=[UserDataCenter shareInstance];
    NSNumber  *weiboId=weiboInfo.Id;
    NSNumber  *author_id=weiboInfo.uerInfo.Id;
    if (!weiboInfo) {
        return;
    }
    NSDictionary *parameters=@{@"weibo_id":weiboId,@"user_id":user_id,@"author_id":author_id,@"operation":operation};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *urlString = [NSString stringWithFormat:@"%@/weibo/up", kApiBaseUrl];
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject  objectForKey:@"code"]  intValue]==0) {
            NSLog(@"点赞成功========%@",responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

-(void)TapViewClick:(id)tagView Withweibo:(weiboInfoModel *)weiboInfo withTagInfo:(TagModel *)tagInfo
{
    //跳转到标签列表页
    TagToStageViewController  *vc=[[TagToStageViewController alloc]init];
    vc.weiboInfo=weiboInfo;
    vc.tagInfo=tagInfo;
    UIBarButtonItem  *item =[[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem=item;
    [self.navigationController pushViewController:vc animated:YES];

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
