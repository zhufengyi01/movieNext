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
    logoButton =[ZCControl createButtonWithFrame:CGRectMake(15, 10, 30, 30) ImageName:@"" Target:self.superview Action:@selector(dealHeadClick:) Title:@""];
    logoButton.layer.cornerRadius=8;
    logoButton.clipsToBounds=YES;
    [self.contentView addSubview:logoButton];
    
    titleLable =[ZCControl createLabelWithFrame:CGRectMake(55, 10, kDeviceWidth-100-110, 30) Font:14 Text:@""];
    titleLable.textColor=VBlue_color;
    titleLable.numberOfLines=0;
    titleLable.textAlignment=NSTextAlignmentLeft;
    [self.contentView addSubview:titleLable];
    
    Zanlable=[ZCControl createLabelWithFrame:CGRectMake(0, 10, 0, 0) Font:14 Text:@"赞了你"];
    Zanlable.textColor=VGray_color;
    [self.contentView addSubview:Zanlable];
    
    dateLable=[ZCControl createLabelWithFrame:CGRectMake(55, 25, 120, 20) Font:12 Text:@"时间"];
    dateLable.textColor=VGray_color;
    dateLable.textAlignment=NSTextAlignmentLeft;
    [self.contentView addSubview:dateLable];
    
   stageImage =[ZCControl createImageViewWithFrame:CGRectMake(kDeviceWidth-55, 5, 50, 50) ImageName:nil];
    stageImage.layer.cornerRadius=8;
    stageImage.clipsToBounds=YES;
    [self.contentView addSubview:stageImage];

}

- (void)layoutSubviews {
    [super layoutSubviews];
    
        
}

-(void)setValueforCell:(NSDictionary  *) dict index: (NSInteger )index;

{
    if ([dict objectForKey:@"avatar"]) {
    [logoButton sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kUrlAvatar, [dict objectForKey:@"avatar"] ]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"loading_image_all.png"]];
        logoButton.tag=6000 + index;
    }
    if ([dict objectForKey:@"stageinfo"]) {
        
    [stageImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@!w340h340",kUrlStage,[[dict objectForKey:@"stageinfo"]  objectForKey:@"stage"]]] placeholderImage:[UIImage imageNamed:@"loading_image_all.png"] options:SDWebImageRetryFailed];
    }
    if ([dict objectForKey:@"username"]) {
        titleLable.text =[NSString stringWithFormat:@"%@",[dict objectForKey:@"username"]];
       
    }
    
    NSString  *nameStr=[dict objectForKey:@"username"];
    CGSize  Namesize =[nameStr boundingRectWithSize:CGSizeMake(kDeviceWidth-100-50, MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:[NSDictionary dictionaryWithObject:titleLable.font forKey:NSFontAttributeName] context:nil].size;
    titleLable.frame=CGRectMake(titleLable.frame.origin.x, titleLable.frame.origin.y, Namesize.width, Namesize.height);
    Zanlable.frame=CGRectMake(titleLable.frame.origin.x+Namesize.width+10, Zanlable.frame.origin.y, 60, 20);
    if ([dict objectForKey:@"create_time"]) {
        NSString  *dateStr=[Function friendlyTime:[dict objectForKey:@"create_time"]];
        dateLable.text=dateStr;
    }
    
    
    
}

-(void)dealHeadClick:(UIButton  *)button
{
    NSLog(@" logo  but  click");
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
