//
//  NotificationTableViewCell.m
//  movienext
//
//  Created by 风之翼 on 15/3/2.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "NotificationTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "ZCControl.h"
#import "Constant.h"
#import "Function.h"
#import "NSDate+Extension.h"
@implementation NotificationTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self= [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self createUI];
    }
    return self;
}
-(void)createUI
{
    logoButton =[ZCControl createButtonWithFrame:CGRectMake(15, 10, 30, 30) ImageName:@"" Target:self Action:@selector(dealCellClick:) Title:@""];
    logoButton.layer.cornerRadius=15;
    logoButton.clipsToBounds=YES;
    logoButton.tag=100;
    [self.contentView addSubview:logoButton];
    
    titleLable =[ZCControl createLabelWithFrame:CGRectMake(55, 10, kDeviceWidth-100-110, 30) Font:14 Text:@""];
    titleLable.textColor=VBlue_color;
    titleLable.numberOfLines=0;
    titleLable.textAlignment=NSTextAlignmentLeft;
    [self.contentView addSubview:titleLable];
    
    titleButon =[ZCControl createButtonWithFrame:CGRectMake(0, 0, kDeviceWidth-100-110, 30) ImageName:nil Target:self Action:@selector(dealCellClick:) Title:nil];
   // titleButon.backgroundColor =[[UIColor blackColor]colorWithAlphaComponent:0.5];
    titleButon.tag=101;
    [self.contentView addSubview:titleButon];
    
    
    Zanlable=[ZCControl createLabelWithFrame:CGRectMake(0, 10, 0, 0) Font:14 Text:@"赞了你"];
    Zanlable.textColor=VGray_color;
    [self.contentView addSubview:Zanlable];
    
    dateLable=[ZCControl createLabelWithFrame:CGRectMake(55, 25, 120, 20) Font:12 Text:@"时间"];
    dateLable.textColor=VLight_GrayColor;
    dateLable.textAlignment=NSTextAlignmentLeft;
    [self.contentView addSubview:dateLable];
    
   stageImage =[ZCControl createImageViewWithFrame:CGRectMake(kDeviceWidth-50, 10, 40, 40) ImageName:nil];
    stageImage.layer.cornerRadius=4;
    stageImage.clipsToBounds=YES;
    [self.contentView addSubview:stageImage];

}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}
-(void)setValueforCell:(userAddmodel *) model  index: (NSInteger )index;
{
    
    
    _index=index;
    //if () {
        NSString *logoString=[NSString stringWithFormat:@"%@%@", kUrlAvatar,model.weiboInfo.uerInfo.logo];
    
    [logoButton sd_setBackgroundImageWithURL:[NSURL URLWithString:logoString ] forState:UIControlStateNormal placeholderImage:HeadImagePlaceholder];
     //}
    
    //if (![[dict objectForKey:@"weibo"]  isKindOfClass:[NSNull class]]) {
        NSString *urlString =[NSString stringWithFormat:@"%@%@!w340h340",kUrlStage,model.weiboInfo.stageInfo.photo];
        
    [stageImage sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"loading_image_all.png"] options:SDWebImageRetryFailed];
    //}
    NSString  *nameStr=model.weiboInfo.uerInfo.username;
    
    titleLable.text =nameStr;
    CGSize  Namesize =[nameStr boundingRectWithSize:CGSizeMake(kDeviceWidth-100-50, MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:[NSDictionary dictionaryWithObject:titleLable.font forKey:NSFontAttributeName] context:nil].size;
    
    titleLable.frame=CGRectMake(titleLable.frame.origin.x, titleLable.frame.origin.y, Namesize.width, Namesize.height);
    titleButon.frame=titleLable.frame;
    Zanlable.frame=CGRectMake(titleLable.frame.origin.x+Namesize.width+0, titleLable.frame.origin.y, 60,titleLable.frame.size.height);
    
   // if ([dict objectForKey:@"updated_at"]) {
         //NSString *dateStr=[Function getTimeIntervalfromInerterval:[dict objectForKey:@"updated_at"]];
        //dateLable.text=dateStr;
        NSDate  *comfromTimesp =[NSDate dateWithTimeIntervalSince1970:[model.updated_at intValue]];
        NSString  *da = [NSDate timeInfoWithDate:comfromTimesp];
        dateLable.text=da;

    //}
    
}
-(void)dealCellClick:(UIButton *) button
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(NotificationClick:indexPath:)])
    {
        [self.delegate NotificationClick:button indexPath:_index];
    }
    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
