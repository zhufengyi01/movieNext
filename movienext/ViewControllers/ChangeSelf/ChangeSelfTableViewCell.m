//
//  ChangeSelfTableViewCell.m
//  movienext
//
//  Created by 风之翼 on 15/4/3.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "ChangeSelfTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "ZCControl.h"
#import "Constant.h"
@implementation ChangeSelfTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}
-(void)createUI
{
    
    headImageView =[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 40, 40)];
    headImageView.layer.cornerRadius=6;
    headImageView.clipsToBounds=YES;
    [self.contentView addSubview:headImageView];
    
    nameLable =[ZCControl createLabelWithFrame:CGRectMake(60, 10, 120, 30) Font:16 Text:@""];
    nameLable.textColor=VGray_color;
    [self.contentView addSubview:nameLable];
    
}
-(void)configCellWithdict :(NSDictionary *) dict
{
    [headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@!thumb",kUrlAvatar,[dict objectForKey:@"avatar"]]] placeholderImage:HeadImagePlaceholder];
    nameLable.text=[dict objectForKey:@"username"];

}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
