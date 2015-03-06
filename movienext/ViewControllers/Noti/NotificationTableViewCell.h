//
//  NotificationTableViewCell.h
//  movienext
//
//  Created by 风之翼 on 15/3/2.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationTableViewCell : UITableViewCell
{
    UIButton    *logoButton;  ///头像
    UILabel     *titleLable;  //标题
    UILabel     *dateLable;   //时间
    UIImageView   *stageImage;   // 剧情图片
    UILabel     *Zanlable;
}
-(void)setValueforCell:(NSDictionary  *) dict index: (NSInteger )index;
@end
