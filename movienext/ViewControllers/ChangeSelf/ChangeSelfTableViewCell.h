//
//  ChangeSelfTableViewCell.h
//  movienext
//
//  Created by 风之翼 on 15/4/3.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangeSelfTableViewCell : UITableViewCell
{
    UIImageView  *headImageView;
    UILabel      *nameLable;
}
-(void)configCellWithdict :(NSDictionary *) dict ;
@end
