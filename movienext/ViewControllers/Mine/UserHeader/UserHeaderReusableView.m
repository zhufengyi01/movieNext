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
#import "AvatarBrowser.h"
@implementation UserHeaderReusableView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        userCenter =[UserDataCenter shareInstance];
        buttonStateDict=[[NSMutableDictionary alloc]init];
        [buttonStateDict setObject:@"100" forKey:@"YES"];
        
        self.backgroundColor =[UIColor clearColor];
        
        
        [self createUI];
    }
    return self;
}

-(void)createUI
{
    //创建基本ui
    UIView *viewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 130)];
    viewHeader.backgroundColor =[UIColor whiteColor];
    [self addSubview:viewHeader];
    //头像
    int ivAvatarWidth = 50;
    ivAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, ivAvatarWidth, ivAvatarWidth)];
    ivAvatar.layer.cornerRadius = ivAvatarWidth * 0.5;
    ivAvatar.layer.masksToBounds = YES;
    ivAvatar.layer.borderColor=VBlue_color.CGColor;
    ivAvatar.layer.borderWidth=3;
    ivAvatar.userInteractionEnabled = YES;
    
    // 用户点击头像显示大图
    UITapGestureRecognizer *avatarTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showBigAvatar:)];
    [ivAvatar addGestureRecognizer:avatarTap];
    
    [viewHeader addSubview:ivAvatar];
    
    if ([userCenter.is_admin  intValue]>0) {
        //在头像上添加一个手势，实现变成功能
        UILongPressGestureRecognizer  *longPressHeader =[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressHead:)];
        [ivAvatar addGestureRecognizer:longPressHeader];
    }
    
    lblUsername = [[UILabel alloc] initWithFrame:CGRectMake(ivAvatar.frame.origin.x+ivAvatar.frame.size.width+10, ivAvatar.frame.origin.y, 200, 20)];
    lblUsername.font = [UIFont fontWithName:kFontDouble size:15];
    lblUsername.textColor = VGray_color;
    [viewHeader addSubview:lblUsername];
    
    
    UILabel  *lbl1=[ZCControl createLabelWithFrame:CGRectMake(lblUsername.frame.origin.x,lblUsername.frame.origin.y+lblUsername.frame.size.height+5, 35, 20) Font:14 Text:@"内容"];
    lbl1.textColor=VBlue_color;
    // lbl1.backgroundColor =[UIColor redColor];
    [viewHeader addSubview:lbl1];
    
    //内容的数量
    lblCount = [[UILabel alloc] initWithFrame:CGRectMake(lbl1.frame.origin.x+lbl1.frame.size.width, lblUsername.frame.origin.y+lblUsername.frame.size.height+5, 25, 20)];
    //  lblCount.backgroundColor=[UIColor yellowColor];
    lblCount.font = [UIFont fontWithName:kFontRegular size:14];
    lblCount.textColor = VGray_color;
    //lblCount.backgroundColor = [UIColor purpleColor];
    [viewHeader addSubview:lblCount];
    
    UILabel  *lbl2=[ZCControl createLabelWithFrame:CGRectMake(lblCount.frame.origin.x+lblCount.frame.size.width,lblUsername.frame.origin.y+lblUsername.frame.size.height+5, 35, 20) Font:14 Text:@"被赞"];
    lbl2.textColor=VBlue_color;
    //lbl2.backgroundColor=[UIColor grayColor];
    [viewHeader addSubview:lbl2];
    
    //赞的数量
    lblZanCout = [[UILabel alloc] initWithFrame:CGRectMake(lbl2.frame.origin.x+lbl2.frame.size.width,lblCount.frame.origin.y , 50, 20)];
    lblZanCout.font = [UIFont fontWithName:kFontRegular size:14];
    //  lblZanCout.backgroundColor=[UIColor blueColor];
    lblZanCout.textColor = VGray_color;
    [viewHeader addSubview:lblZanCout];
    
    //简介
    lblBrief = [[UILabel alloc] initWithFrame:CGRectMake(ivAvatar.frame.origin.x+ivAvatar.frame.size.width+10,lblCount.frame.origin.y+lblCount.frame.size.height+10, kDeviceWidth - (ivAvatar.frame.origin.x+ivAvatar.frame.size.width+10), 20)];
    lblBrief.numberOfLines=0;
    lblBrief.font = [UIFont fontWithName:kFontRegular size:14];
    
    /// CGSize  Msize= [signature boundingRectWithSize:CGSizeMake(kDeviceWidth-80, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:lblBrief.font forKey:NSFontAttributeName] context:nil].size;
    lblBrief.textColor = VGray_color;
    // lblBrief.backgroundColor = [UIColor orangeColor];
    //lblBrief.text=signature;
    //  lblBrief.frame=CGRectMake(ivAvatar.frame.origin.x+ivAvatar.frame.size.width+10,lblCount.frame.origin.y+lblCount.frame.size.height+10, kDeviceWidth-ivAvatar.frame.origin.x-ivAvatar.frame.size.width-20, Msize.height);
    [viewHeader addSubview:lblBrief];
    
    
    addButton=[ZCControl createButtonWithFrame:CGRectMake(0,  lblBrief.frame.origin.y+lblBrief.frame.size.height+25, kDeviceWidth/2, 40) ImageName:nil Target:self Action:@selector(dealSegmentClick:) Title:@"添加"];
    [addButton setTitleColor:VGray_color forState:UIControlStateNormal];
    [addButton setTitleColor:VBlue_color forState:UIControlStateSelected];
    if ([[buttonStateDict objectForKey:@"YES"] isEqualToString:@"100"]) {
        [addButton setSelected:YES];
    }
    else{
        [addButton setSelected:NO];
    }
    addButton.titleLabel.font=[UIFont fontWithName:kFontRegular size:16];
    addButton.tag=100;
    [viewHeader addSubview:addButton];
    
    
    
    UIView  *lineView=[[UIView alloc]initWithFrame:CGRectMake(kDeviceWidth/2,addButton.frame.origin.y+10,0.5,20)];
    lineView.backgroundColor=VLight_GrayColor;
    [viewHeader addSubview:lineView];
    
    zanButton=[ZCControl createButtonWithFrame:CGRectMake(kDeviceWidth/2,  lblBrief.frame.origin.y+lblBrief.frame.size.height+25, kDeviceWidth/2, 40) ImageName:nil Target:self Action:@selector(dealSegmentClick:) Title:@"喜欢"];
    [zanButton setTitleColor:VGray_color forState:UIControlStateNormal];
    [zanButton setTitleColor:VBlue_color forState:UIControlStateSelected];
    if ([[buttonStateDict objectForKey:@"YES"] isEqualToString:@"101"]) {
        [zanButton setSelected:YES];
    }
    else{
        [zanButton setSelected:NO];
    }
    zanButton.titleLabel.font=[UIFont fontWithName:kFontRegular size:16];
    zanButton.tag=101;
    [viewHeader addSubview:zanButton];
    //修改了loadview的frame
    float  y=zanButton.frame.origin.y+zanButton.frame.size.height;
    viewHeader.frame=CGRectMake(0, 0, kDeviceWidth,addButton.frame.origin.y+addButton.frame.size.height);
}



//设置ui 的值
-(void)setcollectionHeaderViewValueWithUserInfo:(weiboUserInfoModel *) userInfo;
{
    NSURL   *imageURL;
    //头像
    imageURL =[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kUrlAvatar,userInfo.logo]];
    [ivAvatar sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"user_normal.png"]];
    //用户名
    lblUsername.text=[NSString stringWithFormat:@"%@",userInfo.username];
    //添加的数量
    lblCount.text=[NSString stringWithFormat:@"%@",userInfo.weibo_count];
    lblZanCout.text =[NSString stringWithFormat:@"%@",userInfo.liked_count];
    lblBrief.text=userInfo.brief;
    
    
}

-(void)dealSegmentClick:(UIButton *) button
{
    [buttonStateDict setObject:[NSString stringWithFormat:@"%d",button.tag] forKey:@"YES"];
    if ([[buttonStateDict objectForKey:@"YES"] isEqualToString:@"100"]) {
        
        [addButton  setSelected:YES];
        [zanButton setSelected:NO];
    }
    else if([[buttonStateDict objectForKey:@"YES"] isEqualToString:@"101"]){
        [addButton setSelected:NO];
        [zanButton setSelected:YES];
    }
    
    
    if (self.delegate &&[self.delegate respondsToSelector:@selector(changeCollectionHandClick:)]) {
        [self.delegate changeCollectionHandClick:button];
    }
}
-(void)longPressHead:(UITapGestureRecognizer *) tap
{
    if (tap.state==UIGestureRecognizerStateBegan) {
        //长按变身
        if (self.delegate && [self.delegate respondsToSelector:@selector(changeUserHandClick)]) {
            [self.delegate changeUserHandClick];
        }
    }
}

- (void)showBigAvatar:(UITapGestureRecognizer *)sender //显示大头像
{
    [AvatarBrowser showImage:(UIImageView*)sender.view];
}

@end
