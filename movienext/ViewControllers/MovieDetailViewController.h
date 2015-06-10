//
//  电影页, 剧情列表
//  MovieDetailViewController.h
//  movienext
//
//  Created by 风之翼 on 15/3/6.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "RootViewController.h"
#import "ButtomToolView.h"
//个人页面来源，区分于那个
typedef NS_ENUM(NSInteger,NSMovieSourcePage)
{
    NSMovieSourcePageMovieListController =100,
    NSMovieSourcePageSearchListController  =101,
    NSMovieSourcePageAdminCloseStageViewController
    
};
@interface MovieDetailViewController : RootViewController <ButtomToolViewDelegate>
{
        
}
@property(nonatomic,strong)UICollectionView  *myConllectionView;

// 属性，提供向外的接口，外部只要获得当前类，就可以获得他的属性和方法
@property (nonatomic,strong) NSString  *movieId;

@property (nonatomic,strong) NSString  *moviename;

@property(nonatomic,strong) NSString  *movielogo;


@property(nonatomic,strong) NSString  *douban_Id;

@property(nonatomic,assign) NSMovieSourcePage   pageSourceType;

//viod  返回类型

@end
