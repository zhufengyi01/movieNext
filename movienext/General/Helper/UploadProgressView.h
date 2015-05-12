//
//  UploadProgressView.h
//  movienext
//
//  Created by 风之翼 on 15/3/23.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UploadProgressView : UIView
{
    //UploadProgressView  *_myProgressView;
    CGRect  m_frame;
    UILabel  *tipLable;
}
@property(nonatomic,strong)  UIProgressView*  myProgressView;
-(void)setProgressTitle:(NSString *) title;
-(void)setProgress:(float) progress;
@end
