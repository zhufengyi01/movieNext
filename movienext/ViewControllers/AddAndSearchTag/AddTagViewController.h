//
//  AddTagViewController.h
//  movienext
//
//  Created by 风之翼 on 15/4/28.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "RootViewController.h"

@protocol AddTagViewControllerDelegate <NSObject>

-(void)AddTagViewHandClickWithTag:(NSString *)tag;

@end
@interface AddTagViewController : RootViewController
{
    NSMutableArray  *_dataArray;
}
@property(nonatomic,strong) UITableView   *myTableView;
@property(nonatomic,strong)id <AddTagViewControllerDelegate> delegate;
@end
