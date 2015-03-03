//
//  CommonStageCell.h
//  movienext
//
//  Created by 风之翼 on 15/3/3.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommonStageCell : UITableViewCell
{
    UIImageView   *_MovieImageView;
}
-(void)setCellValue:(NSDictionary  *) dict;
@end
