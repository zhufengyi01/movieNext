//
//  CustomTabBar.m
//  CustomTabBar
//
//  Created by qianfeng on 14-8-30.
//  Copyright (c) 2014年 qianfeng. All rights reserved.
//

#import "CustomTabBar.h"
#define BUTTON_COUNT 5
#import "AddViewController.h"
#define BUTTON_START_TAG 1000
#import "FinderViewController.h"
//在这里调选中的状态的字体颜色
#import "AppDelegate.h"
#import "Constant.h"
#import "MovieSearchViewController.h"
#define  TabSelectColor   [UIColor colorWithRed:0.0/255 green:146.0/255 blue:255.0/255 alpha:1]
//以后在这里调整正常字体的颜色
#define  TabNorColor      [UIColor colorWithRed:175.0/255 green:180.0/255 blue:201.0/255 alpha:1]

@interface CustomTabBar ()
{
    CGRect m_frame;
    NSArray  *titleArray;
    NSMutableDictionary  *indexSelectDict;  // 纪录当前那一个tabbar是处于选中
    
}

@property (nonatomic, strong) NSArray * m_arrNormal;
@property (nonatomic, strong) NSArray * m_arrSelected;

@end

@implementation CustomTabBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSLog(@"custom tabBar initWithFrame");
        m_frame = frame;
        NSLog(@"m_frame == %@", NSStringFromCGRect(m_frame));
        indexSelectDict =[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"1000",@"isSelect", nil];
        [self setMemory];
        [self createButtons];
        
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addnotifationPress) name:GOTO_USER_CENTER object:nil];

    }
    return self;
}
-(void)addnotifationPress
{
    UIButton * button = (UIButton *)[self viewWithTag:BUTTON_START_TAG+4];
     [self buttonPressed:button];
    //刷新个人页数据
    [[NSNotificationCenter defaultCenter] postNotificationName:Refresh_USER_LIST object:nil];
}


-(void)setMemory
{
    self.m_arrNormal = [NSArray arrayWithObjects:@"feed_tab_butten_normal.png", @"find_tab_butten_normalcopy4@2x.png",@"add_tab_butten.png", @"notice_tab_butten_normal.png", @"me_tab_butten_normal.png", nil];
    self.m_arrSelected = [NSArray arrayWithObjects:@"feed_tab_butten_press.png", @"find_tab_butten_normalcopy4@2x.png",@"add_tab_butten.png", @"notice_tab_butten_press.png", @"me_tab_butten_press.png", nil];
    titleArray=@[@"电影",@"发现",@"添加",@"消息",@"我的"];
    
}

- (void)createButtons
{
    for (NSUInteger i = 0; i < BUTTON_COUNT; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        button.frame = CGRectMake(0 + (m_frame.size.width / BUTTON_COUNT) * i, 0,m_frame.size.width/BUTTON_COUNT, m_frame.size.height);
        button.tag = BUTTON_START_TAG + i;
        
        UILabel  *lable=[[UILabel alloc]initWithFrame:CGRectMake(button.frame.origin.x, m_frame.size.height-15, button.frame.size.width, 15)];
        lable.font=[UIFont systemFontOfSize:11];
        lable.textColor=TabNorColor;
       
        lable.textAlignment=NSTextAlignmentCenter;
        lable.tag=2000+i;
        lable.text=titleArray[i];
        [self addSubview:lable];
        
        
        UIImage * normalImage = [UIImage imageNamed:[self.m_arrNormal objectAtIndex:i]];
        UIImage * selectedImage = [UIImage imageNamed:[self.m_arrSelected objectAtIndex:i]];
        [button setImage:normalImage forState:UIControlStateNormal];
        [button setImage:selectedImage forState:UIControlStateSelected];
        if (i == 0) {
             button.selected=YES;
            lable.textColor=TabSelectColor;
        } else {
             button.selected=NO;
        }
        //要想调整图片的大小和位置都可以这么调
        [button setImageEdgeInsets:UIEdgeInsetsMake(4, 20, 15, 20)];
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
}

- (void)buttonPressed:(UIButton *)button
{
    
    if (button.tag==BUTTON_START_TAG+1) {
    //发现
                FinderViewController  *finder =[FinderViewController new];
                UINavigationController  *na =[[UINavigationController alloc]initWithRootViewController:finder];
                AppDelegate  *delegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
                UIWindow  *window=[delegate window];
                [window.rootViewController presentViewController:na animated:YES completion:nil];

    }
    else if (button.tag==BUTTON_START_TAG+2)
    {
        MovieSearchViewController  *add =[MovieSearchViewController new];
        add.pageType=NSSearchSourceTypeAddCard;
        UINavigationController  *na =[[UINavigationController alloc]initWithRootViewController:add];
        AppDelegate  *delegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
        UIWindow  *window=[delegate window];
        
        [window.rootViewController presentViewController:na animated:YES completion:nil];

    }
    
    else{
         if (button.selected==NO) {
          button.selected=YES;
         [self resetButtonImagesWithButton:button];
           }
       // 针对代理协议里面有可选的代理时使用的方法可，respondsToSelector 就是判断self.m_delegate指向的对象有没有，这个方法--> buttonPresedInCustomTabBar:
         if(self.m_delegate && [self.m_delegate respondsToSelector:@selector(buttonPresedInCustomTabBar:)]) {
          [self.m_delegate buttonPresedInCustomTabBar:button.tag - BUTTON_START_TAG];
          }
     }
   
}

//重置图片
- (void)resetButtonImagesWithButton:(UIButton *)button
{
     for (NSUInteger i = 0; i < BUTTON_COUNT; i++) {
        UIButton * btn = (UIButton *)[self viewWithTag:i + BUTTON_START_TAG];
          btn.selected=NO;
        UILabel  *lable=(UILabel *)[self viewWithTag:2000+i] ;
        lable.textColor=TabNorColor;
    }
     button.selected=YES;
    UILabel  *label=(UILabel *)[self viewWithTag:button.tag+1000];
    label.textColor=TabSelectColor;
    

}

/*
 NSLog(@"button pressed");
 NSString * selected = [self.m_arrSelected objectAtIndex:button.tag - BUTTON_START_TAG];
 UIImage * selectedImage = [UIImage imageNamed:selected];
 [button setBackgroundImage:selectedImage forState:UIControlStateNormal];

 */

/*
 [button setBackgroundImage:selectedImage forState:UIControlStateSelected];
 [button setBackgroundImage:
 selectedImage
 forState:UIControlStateHighlighted];
 */

@end
