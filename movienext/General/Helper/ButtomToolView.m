//
//  ButtomToolView.m
//  movienext
//
//  Created by 风之翼 on 15/3/11.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "ButtomToolView.h"
#import "Constant.h"
#import "ZCControl.h"
#import "UIButton+WebCache.h"
#import "Function.h"
#import "UserDataCenter.h"
#import "UpweiboModel.h"
#import "UIButton+WebCache.h"

@implementation ButtomToolView 

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self =[super initWithFrame:frame]) {
        m_frame=frame;
        self.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.2];
        [self createButtomView];
    }
    return self;
}
-(void)createButtomView
{
    //self.backgroundColor = VBlue_color;
    //self.userInteractionEnabled=YES;
    
    
    //添加手势去回收alertview
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TouchbuttonClick:)];
    [self addGestureRecognizer:tap];
    
    
    
    //弹出框
    alertView =[[UIView alloc]initWithFrame:CGRectMake(15,180, kDeviceWidth-30, 180)];
    alertView.backgroundColor=[UIColor whiteColor];
    alertView.alpha=0;
    alertView.layer.cornerRadius=4;
    alertView.clipsToBounds=YES;
    alertView.userInteractionEnabled=YES;
    [self addSubview:alertView];
    
    //在alertview上添加手势用来截获点击屏幕事件
    UITapGestureRecognizer  *tapalert =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(alertViewTap:)];
    [alertView addGestureRecognizer:tapalert];

    
    
    //头像
    headButton=[UIButton buttonWithType:UIButtonTypeCustom];
    headButton.frame=CGRectMake(10,10, 35, 35);
    headButton.layer.cornerRadius=4;
    headButton.clipsToBounds=YES;
    [headButton addTarget:self action:@selector(dealButtomClick:) forControlEvents:UIControlEventTouchUpInside];
    headButton.tag=10000;
    [alertView addSubview:headButton];
    
     userNamelabel =[ZCControl createLabelWithFrame:CGRectMake(headButton.frame.origin.x+headButton.frame.size.width+10,headButton.frame.origin.y, 200, 20) Font:14 Text:@"名字"];
    userNamelabel.textColor=VBlue_color;
    userNamelabel.adjustsFontSizeToFitWidth=NO;
    userNamelabel.lineBreakMode=NSLineBreakByTruncatingTail;
    [alertView addSubview:userNamelabel];
    
    
    
    
    timelabel =[ZCControl createLabelWithFrame:CGRectMake(userNamelabel.frame.origin.x,userNamelabel.frame.origin.y+userNamelabel.frame.size.height,200, 20) Font:12 Text:@"刚刚"];
    timelabel.textColor=VGray_color;
    [alertView addSubview:timelabel];
    
    
    
    contentLable =[ZCControl createLabelWithFrame:CGRectMake(headButton.frame.origin.x,headButton.frame.origin.y+headButton.frame.size.height+0,alertView.frame.size.width-20, 50) Font:16 Text:@"内容"];
    contentLable.numberOfLines=0;
   //contentLable.adjustsFontSizeToFitWidth=NO;
   // contentLable.lineBreakMode=NSLineBreakByTruncatingTail;
    contentLable.textColor=VGray_color;
    [alertView addSubview:contentLable];
    
    
    //放置分享点赞按钮
    buttomShareView= [[UIView alloc]initWithFrame:CGRectMake(0, alertView.frame.size.height-40, alertView.frame.size.width, 45)];
    buttomShareView.userInteractionEnabled=YES;
    [alertView addSubview:buttomShareView];
    
    
    
    shareButton =[ZCControl createButtonWithFrame:CGRectMake(0,0,alertView.frame.size.width/2,45) ImageName:nil Target:self Action:@selector(dealButtomClick:) Title:@""];
    [shareButton setTitleColor:VBlue_color forState:UIControlStateNormal];
    shareButton.titleLabel.font=[UIFont systemFontOfSize:14];
    [shareButton setTitleEdgeInsets:UIEdgeInsetsMake(10, 25, 10, 10)];

    [shareButton setImage:[UIImage imageNamed:@"opened_share_icon.png"] forState:UIControlStateNormal];
    [shareButton setBackgroundImage:[UIImage imageNamed:@"login_alpa_backgroundcolor.png"] forState:UIControlStateNormal];
    shareButton.tag=10001;
    [buttomShareView addSubview:shareButton];
    
    

    zanbutton =[ZCControl createButtonWithFrame:CGRectMake(alertView.frame.size.width/2, 0,alertView.frame.size.width/2, 45) ImageName:nil Target:self Action:@selector(dealButtomClick:) Title:@""];
    [zanbutton setTitleColor:VBlue_color forState:UIControlStateNormal];
    zanbutton.tag=10002;
    //[zanbutton setImage:[UIImage imageNamed:@"ic_menu_like_default.png"] forState:UIControlStateNormal];
    [zanbutton setBackgroundImage:[UIImage imageNamed:@"login_alpa_backgroundcolor.png"] forState:UIControlStateNormal];
    //[zanbutton setTitle:@"已赞" forState:UIControlStateSelected];
    [zanbutton setTitleEdgeInsets:UIEdgeInsetsMake(10, 25, 10, 10)];
    zanbutton.titleLabel.font=[UIFont systemFontOfSize:14];
    
    // 在赞上面添加一个大拇指
    likeimageview=[[UIImageView alloc]initWithFrame:CGRectMake((zanbutton.frame.size.width)/2-15,zanbutton.frame.size.height/2-15, 25, 25)];
    likeimageview.image=[UIImage imageNamed:@"opened_like_icon.png"];
    [zanbutton addSubview:likeimageview];
    
    
    //高亮显示
    [buttomShareView addSubview:zanbutton];
    
//    UIView  *lineView1=[[UIView alloc]initWithFrame:CGRectMake(alertView.frame.size.width/2, 0,1,buttomShareView.frame.size.height)];
//    lineView1.backgroundColor=VLight_GrayColor;
//    [buttomShareView addSubview:lineView1];
//    
    
    morebuton=[ZCControl createButtonWithFrame:CGRectMake(0,0,30,45) ImageName:nil Target:self Action:@selector(dealButtomClick:) Title:@""];
    [morebuton setImage:[UIImage imageNamed:@"single_switch(gray).png"] forState:UIControlStateNormal];
    morebuton.tag=10003;
    [buttomShareView addSubview:morebuton];


}
// 设置toolbar 的值
-(void)configToolBar
{
    //获取了当前微博对象，如果当前的微博对象在数组中有的话，那就需要显示为已赞

    //头像
    NSURL  *headURL =[NSURL URLWithString:[NSString stringWithFormat:@"%@%@!thumb",kUrlAvatar,self.weiboInfo.uerInfo.logo]];
    [headButton sd_setBackgroundImageWithURL:headURL forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"user_normal.png"]];
    //名字
    userNamelabel.text =self.weiboInfo.uerInfo.username;
    
    //时间
    
    NSString *timeStr =[Function getTimeIntervalfromInerterval:self.weiboInfo.created_at];
    timelabel.text=timeStr;
    //内容
    contentLable.text =self.weiboInfo.content;
   

   ////标签
    [self removeTagViewFromSuperView];
    leadWidth=0;
    
    
    if (self.weiboInfo.tagArray&&self.weiboInfo.tagArray.count) {
          tagLable =[[M80AttributedLabel alloc]initWithFrame:CGRectMake(contentLable.frame.origin.x, contentLable.frame.origin.y+contentLable.frame.size.height, alertView.frame.size.width-20, TagHeight+10)];
        
        for (int i=0; i<self.weiboInfo.tagArray.count; i++) {
            TagView *tagview = [self createTagViewWithtagInfo:self.weiboInfo.tagArray[i] andIndex:i];
            [tagLable appendView:tagview margin:UIEdgeInsetsMake(0, 0, 0, 10)];
        }
        [alertView addSubview:tagLable];
     }
    
    
    
    
    for (int i=0; i<self.upweiboArray.count; i++) {
        UpweiboModel *upmodel=self.upweiboArray[i];
        if ([upmodel.weibo_id intValue]==[self.weiboInfo.Id intValue]) {
            zanbutton.selected=YES;
            likeimageview.image=[UIImage imageNamed:@"opened_liked_icon.png"];
            break;
        }
        else{
            zanbutton.selected=NO;
            likeimageview.image=[UIImage imageNamed:@"opened_like_icon.png"];
        }
    }
    
}
//创建标签的方法
-(TagView *)createTagViewWithtagInfo:(TagModel *) tagmodel andIndex:(NSInteger ) index
{
    
    TagView *tagview =[[TagView alloc]initWithFrame:CGRectZero];
    tagview.tag=1000+index;
    tagview.clipsToBounds=YES;
    tagview.delegete=self;
    tagview.tagInfo=tagmodel;
    tagview.weiboInfo=self.weiboInfo;
    NSLog(@"tag model ===%@ ----%ld",tagmodel.Id,index);
    NSString *titleStr = tagmodel.tagDetailInfo.title;
    tagview.titleLable.text=titleStr;
    CGSize  Tsize =[titleStr boundingRectWithSize:CGSizeMake(MAXFLOAT, TagHeight) options:(NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin) attributes:[NSDictionary dictionaryWithObject:tagview.titleLable.font forKey:NSFontAttributeName] context:nil].size;
    //纪录前面一个标签的宽度
     tagview.frame=CGRectMake(0,0, Tsize.width+10, TagHeight+10);
    
    return tagview;
}


-(void)alertViewTap:(UITapGestureRecognizer *) tap
{
    
    
    //
}

#pragma mark
#pragma mark  －－－－底部视图的点击事件
//底部视图的点击事件
-(void)dealButtomClick:(UIButton  *) button
{
    if (button.tag==10002) {
      if (zanbutton.selected==YES) {
        zanbutton.selected=NO;
        likeimageview.image=[UIImage imageNamed:@"opened_like_icon.png"];
      }
      else if (zanbutton.selected==NO)
      {
        zanbutton.selected=YES;
        //如果按钮点击的是赞的话
        if (button==zanbutton) {
        //执行放大动画又缩小回去
           likeimageview.image=[UIImage imageNamed:@"opened_liked_icon.png"];
            [Function BasicAnimationwithkey:@"transform.scale" Duration:0.25 repeatcont:1 autoresverses:YES fromValue:1.0 toValue:1.5 View:likeimageview];
        }
        
    }
    }
    if (self.delegete &&[self.delegete respondsToSelector:@selector(ToolViewHandClick::weiboDict:StageInfo:)]) {
        [self.delegete ToolViewHandClick:button :_markView weiboDict:self.weiboInfo StageInfo:self.stageInfo];
    }
}


//显示底部试图
-(void)ShowButtomView;
{
    [UIView animateWithDuration:0.5 animations:^{
//        CGRect  Bframe=alertView.frame;
//        Bframe.origin.y=m_frame.size.height-kHeightNavigation-50;
//        alertView.frame=Bframe;
        alertView.alpha=1;
        
    } completion:^(BOOL finished) {
    }];
}
//隐藏底部试图
-(void)HidenButtomView;
{
    [UIView animateWithDuration:0.5 animations:^{
//        CGRect  Bframe=alertView.frame;
//        Bframe.origin.y=m_frame.size.height-kHeightNavigation;
//        alertView.frame=Bframe;
        alertView.alpha=0;
    } completion:^(BOOL finished) {
        
    }];
}


//创建标签之前移除标签
-(void)removeTagViewFromSuperView
{
    //移除标签
    for (id view in alertView.subviews) {
        if ([view isKindOfClass:[M80AttributedLabel class]]) {
            [view removeFromSuperview];
            
        }
    }
    
}
#pragma mark -------TapViewClickDelegete---------------------------------------------
-(void)TapViewClick:(id)tagView Withweibo:(weiboInfoModel *)weiboInfo withTagInfo:(TagModel *)tagInfo
{
    if (self.delegete &&[self.delegete respondsToSelector:@selector(ToolViewTagHandClickTagView:withweiboinfo:WithTagInfo:)]) {
        [self.delegete ToolViewTagHandClickTagView:tagView withweiboinfo:weiboInfo WithTagInfo:tagInfo];
    }
    
}

//点击屏幕
-(void)TouchbuttonClick:(UITapGestureRecognizer *) tap
{
    
    
    if (self.delegete &&[self.delegete respondsToSelector:@selector(topViewTouchBengan)]) {
        [self.delegete topViewTouchBengan];
    }
}


//布局子视图
-(void)layoutSubviews
{
    [super layoutSubviews];
    NSString *weiboString = self.weiboInfo.content;
    CGSize  Wsize=[weiboString boundingRectWithSize:CGSizeMake(kStageWidth-40, MAXFLOAT) options:(NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin) attributes:[NSDictionary dictionaryWithObject:contentLable.font forKey:NSFontAttributeName] context:nil].size;
    
    
    
}


@end
