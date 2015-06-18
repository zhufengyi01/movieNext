//
//  TagView.m
//  movienext
//
//  Created by 风之翼 on 15/4/26.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "TagView.h"
#import "ZCControl.h"
#import "Constant.h"
@implementation TagView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
//重写tagview的方法
-(instancetype)initWithWeiboInfo:(weiboInfoModel *) weiboInfo AndTagInfo :(TagModel *) tagInfo delegate:(id<TagViewDelegate>) delegate isCanClick:(BOOL) click  backgoundImage:(UIImage *) image isLongTag:(BOOL) longtag;
{
    if (self =[super init]) {
        //Custom init
        _weiboInfo =weiboInfo;
        _tagInfo=tagInfo;
        _delegate = delegate;
        _isCanclick=click;
        _backgroundImage = image;
        _isLongtag =longtag;
        self.layer.cornerRadius=0;
        self.backgroundColor =VBlue_color;
        self.clipsToBounds=YES;
        [self createUI];
        if (click==YES) {
            UITapGestureRecognizer  *tapself =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dealTapSelf:)];
            [self addGestureRecognizer:tapself];
        }
    }
    return self;
}
-(void)createUI
{
    //添加背景图片
    self.tagBgImageview =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0,self.frame.size.width , self.frame.size.height)];
    self.tagBgImageview.backgroundColor = VBlue_color;
    self.tagBgImageview.image =[_backgroundImage stretchableImageWithLeftCapWidth:10 topCapHeight:20];
    [self addSubview:self.tagBgImageview];
    //添加文字
    self.titleLable=[ZCControl createLabelWithFrame:CGRectMake(0,0, 60, 30) Font:TagTextFont16 Text:@"标签"];
    self.titleLable.textColor=[UIColor whiteColor];
    
    self.titleLable.font =[UIFont fontWithName:kFontRegular size:TagTextFont16];
    if (IsIphone6plus) {
        self.titleLable.font=[UIFont fontWithName:kFontRegular size:TagTextFont18];
    }
    self.titleLable.lineBreakMode=NSLineBreakByTruncatingTail;
    self.titleLable.adjustsFontSizeToFitWidth=NO;
    self.titleLable.textAlignment=NSTextAlignmentCenter;
    if (_tagInfo) {
        self.titleLable.text=_tagInfo.tagDetailInfo.title;
    }
    else
    {
        self.titleLable.text=_weiboInfo.content;
    }
    //设置字体间距的属性
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:self.titleLable.text];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:15];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [self.titleLable.text length])];
    [self.titleLable setAttributedText:attributedString1];
    
    [self.tagBgImageview addSubview:self.titleLable];
    //计算自身的大小
    //NSString  *titleString =_tagInfo.tagDetailInfo.title;
    CGSize  Tsize =[self.titleLable.text boundingRectWithSize:CGSizeMake(MAXFLOAT, TagHeight) options:(NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin) attributes:[NSDictionary dictionaryWithObject:self.titleLable.font forKey:NSFontAttributeName] context:nil].size;
    //不是长微博
    if (_isLongtag==NO) {
        if (Tsize.width>(kDeviceWidth-40)){
            Tsize.width=(kDeviceWidth-40);
        }
    }
    self.frame=CGRectMake(0, 0, Tsize.width+10, TagHeight);
    self.titleLable.frame=CGRectMake(3,0, self.frame.size.width-6,self.frame.size.height);
}
-(void)setbigTagWithSize:(CGSize) Size;
{
    self.frame=CGRectMake(0, 0,self.frame.size.width+Size.width, self.frame.size.height+Size.height);
    self.titleLable.frame=CGRectMake(0,0,self.frame.size.width, self.frame.size.height);
}

//设置是否圆角
-(void)setcornerRadius:(NSInteger) corner;
{
    //设置是否圆角
    self.layer.cornerRadius=corner;
    
}


//点击本身执行跳转到具有这个标签的剧情
-(void)dealTapSelf:(UITapGestureRecognizer *) tap
{
    if (_delegate &&[_delegate respondsToSelector:@selector(TapViewClick:Withweibo:withTagInfo:)]) {
        [_delegate TapViewClick:self Withweibo:_weiboInfo withTagInfo:_tagInfo];
    }
    
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.tagBgImageview.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.titleLable.frame=CGRectMake(6,0, self.frame.size.width,self.frame.size.height);
    
}

@end
