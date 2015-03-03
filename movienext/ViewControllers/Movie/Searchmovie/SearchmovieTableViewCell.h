//
//  SearchmovieTableViewCell.h
//  movienext
//
//  Created by 风之翼 on 15/3/2.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchmovieTableViewCell : UITableViewCell

{
    UIImageView  *leftImage;
    UILabel      *titleLable;
}
-(void)setCellValue:(NSDictionary *) dict;

@end
