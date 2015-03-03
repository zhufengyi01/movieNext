//
//  SearchmovieTableViewCell.m
//  movienext
//
//  Created by 风之翼 on 15/3/2.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "SearchmovieTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "ZCControl.h"
#import "Constant.h"
@implementation SearchmovieTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
        
    }
    return self;
}
-(void)createUI
{
    leftImage =[[UIImageView alloc]initWithFrame:CGRectMake(10, 10,45,80)];
    [self.contentView addSubview:leftImage];
    
    titleLable=[ZCControl createLabelWithFrame:CGRectMake(leftImage.frame.origin.x+leftImage.frame.size.width+10,10, (kDeviceWidth-30)/3, 120) Font:14 Text:@"电影描述"];
    [self.contentView addSubview:titleLable];

}
-(void)setCellValue:(NSDictionary *) dict;
{
    if ([dict objectForKey:@"smallimage"]) {
        NSURL *urlString=[NSURL URLWithString:  [NSString stringWithFormat:@"%@",[dict objectForKey:@"smallimage"]]];
        [leftImage sd_setImageWithURL:urlString placeholderImage:[UIImage imageNamed:@"loading_image_all.png"]];
    }
    if ([dict  objectForKey:@"title"]) {
        titleLable.text=[NSString stringWithFormat:@"%@",[dict objectForKey:@"title"]];
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
