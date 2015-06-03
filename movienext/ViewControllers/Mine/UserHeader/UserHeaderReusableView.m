//
//  UserHeaderReusableView.m
//  movienext
//
//  Created by 风之翼 on 15/6/2.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "UserHeaderReusableView.h"
#import "ZCControl.h"
#import "Constant.h"
#import "UIImageView+WebCache.h"
#import "UserDataCenter.h"
@implementation UserHeaderReusableView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        userCenter =[UserDataCenter shareInstance];
        [self createUI];
    }
    return self;
}

-(void)createUI
{
    //创建基本ui
    UIView *viewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 130)];
    viewHeader.backgroundColor =[UIColor whiteColor];

    
    //头像
    int ivAvatarWidth = 50;
    ivAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, ivAvatarWidth, ivAvatarWidth)];
    ivAvatar.layer.cornerRadius = ivAvatarWidth * 0.5;
    ivAvatar.layer.masksToBounds = YES;
    ivAvatar.layer.borderColor=VBlue_color.CGColor;
    ivAvatar.layer.borderWidth=3;
    
    //ivAvatar.backgroundColor = [UIColor redColor];
    NSURL   *imageURL;
    if (self.userInfomodel) {
        imageURL =[NSURL URLWithString:[NSString stringWithFormat:@"%@%@!thumb",kUrlAvatar,self.userInfomodel.logo]];
    }
    [ivAvatar sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"user_normal.png"]];
    [viewHeader addSubview:ivAvatar];
    
//    if ([userCenter.is_admin  intValue]>0) {
//        //在头像上添加一个手势，实现变成功能
//        UIView  *view =[[UIView alloc]initWithFrame:ivAvatar.frame];
//        view.backgroundColor =[ UIColor clearColor];
//        [viewHeader addSubview:view];
//        UILongPressGestureRecognizer  *longPressHeader =[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressHead:)];
//        
//        [view addGestureRecognizer:longPressHeader];
//        
//    }
//    
//    
    lblUsername = [[UILabel alloc] initWithFrame:CGRectMake(ivAvatar.frame.origin.x+ivAvatar.frame.size.width+10, ivAvatar.frame.origin.y, 200, 20)];
    lblUsername.font = [UIFont boldSystemFontOfSize:15];
    lblUsername.textColor = VGray_color;
    if (self.userInfomodel) {
        lblUsername.text=[NSString stringWithFormat:@"%@",self.userInfomodel.username];
    }
    [viewHeader addSubview:lblUsername];

    
    
    UILabel  *lbl1=[ZCControl createLabelWithFrame:CGRectMake(lblUsername.frame.origin.x,lblUsername.frame.origin.y+lblUsername.frame.size.height+5, 35, 20) Font:14 Text:@"内容"];
    lbl1.textColor=VBlue_color;
    // lbl1.backgroundColor =[UIColor redColor];
    [viewHeader addSubview:lbl1];
    
    //内容的数量
    lblCount = [[UILabel alloc] initWithFrame:CGRectMake(lbl1.frame.origin.x+lbl1.frame.size.width, lblUsername.frame.origin.y+lblUsername.frame.size.height+5, 25, 20)];
    //  lblCount.backgroundColor=[UIColor yellowColor];
    lblCount.font = [UIFont systemFontOfSize:14];
    
    if (self.userInfomodel) {
        lblCount.text=[NSString stringWithFormat:@"%@",self.userInfomodel.weibo_count];
    }
    lblCount.textColor = VGray_color;
    //lblCount.backgroundColor = [UIColor purpleColor];
    [viewHeader addSubview:lblCount];
    
    UILabel  *lbl2=[ZCControl createLabelWithFrame:CGRectMake(lblCount.frame.origin.x+lblCount.frame.size.width,lblUsername.frame.origin.y+lblUsername.frame.size.height+5, 35, 20) Font:14 Text:@"被赞"];
    lbl2.textColor=VBlue_color;
    //lbl2.backgroundColor=[UIColor grayColor];
    [viewHeader addSubview:lbl2];
    
    //赞的数量
    lblZanCout = [[UILabel alloc] initWithFrame:CGRectMake(lbl2.frame.origin.x+lbl2.frame.size.width,lblCount.frame.origin.y , 50, 20)];
    lblZanCout.font = [UIFont systemFontOfSize:14];
    //  lblZanCout.backgroundColor=[UIColor blueColor];
    lblZanCout.textColor = VGray_color;
    if (self.userInfomodel) {
        lblZanCout.text  =[NSString stringWithFormat:@"%@",self.userInfomodel.liked_count];
    }
    [viewHeader addSubview:lblZanCout];
    
    //简介
    lblBrief = [[UILabel alloc] initWithFrame:CGRectMake(ivAvatar.frame.origin.x+ivAvatar.frame.size.width+10,lblCount.frame.origin.y+lblCount.frame.size.height+10, 60, 20)];
    lblBrief.numberOfLines=0;
    lblBrief.font = [UIFont systemFontOfSize:14];
    
   /// CGSize  Msize= [signature boundingRectWithSize:CGSizeMake(kDeviceWidth-80, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:lblBrief.font forKey:NSFontAttributeName] context:nil].size;
    lblBrief.textColor = VGray_color;
    // lblBrief.backgroundColor = [UIColor orangeColor];
    //lblBrief.text=signature;
  //  lblBrief.frame=CGRectMake(ivAvatar.frame.origin.x+ivAvatar.frame.size.width+10,lblCount.frame.origin.y+lblCount.frame.size.height+10, kDeviceWidth-ivAvatar.frame.origin.x-ivAvatar.frame.size.width-20, Msize.height);
    [viewHeader addSubview:lblBrief];
    
    
    UIButton  *addButton=[ZCControl createButtonWithFrame:CGRectMake(0,  lblBrief.frame.origin.y+lblBrief.frame.size.height+25, kDeviceWidth/2, 40) ImageName:nil Target:self Action:@selector(dealSegmentClick:) Title:@"添加"];
    [addButton setTitleColor:VGray_color forState:UIControlStateNormal];
    [addButton setTitleColor:VBlue_color forState:UIControlStateSelected];
//    if ([[buttonStateDict objectForKey:@"100"] isEqualToString:@"YES"]) {
//        [addButton setSelected:YES];
//    }
//    else{
//        [addButton setSelected:NO];
//    }
    addButton.titleLabel.font=[UIFont systemFontOfSize:16];
    //addButton.backgroundColor=VLight_GrayColor;
    addButton.tag=100;
    [viewHeader addSubview:addButton];
    
    
    
    UIView  *lineView=[[UIView alloc]initWithFrame:CGRectMake(kDeviceWidth/2,addButton.frame.origin.y+10,0.5,20)];
    lineView.backgroundColor=VLight_GrayColor;
    [viewHeader addSubview:lineView];
    
    UIButton  *zanButton=[ZCControl createButtonWithFrame:CGRectMake(kDeviceWidth/2,  lblBrief.frame.origin.y+lblBrief.frame.size.height+25, kDeviceWidth/2, 40) ImageName:nil Target:self Action:@selector(dealSegmentClick:) Title:@"赞"];
    [zanButton setTitleColor:VGray_color forState:UIControlStateNormal];
    [zanButton setTitleColor:VBlue_color forState:UIControlStateSelected];
//    if ([[buttonStateDict objectForKey:@"101"] isEqualToString:@"YES"]) {
//        [zanButton setSelected:YES];
//    }
//    else{
//        [zanButton setSelected:NO];
//    }
    zanButton.titleLabel.font=[UIFont systemFontOfSize:16];
    zanButton.tag=101;
    [viewHeader addSubview:zanButton];
     //修改了loadview的frame
    float  y=zanButton.frame.origin.y+zanButton.frame.size.height;
    viewHeader.frame=CGRectMake(0, 0, kDeviceWidth,addButton.frame.origin.y+addButton.frame.size.height);
}



//设置ui 的值
-(void)setcollectionHeaderViewValue;
{
    
    
    
}

-(void)dealSegmentClick:(UIButton *) button
{
    if (self.delegate &&[self.delegate respondsToSelector:@selector(changeCollectionHandClick:)]) {
        [self.delegate changeCollectionHandClick:button];
    }
}
@end
