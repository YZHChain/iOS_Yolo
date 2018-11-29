//
//  YZHTeamNoticeShowView.m
//  YZHYolo
//
//  Created by Jersey on 2018/11/29.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHTeamNoticeShowView.h"

@interface YZHTeamNoticeShowView()



@end

@implementation YZHTeamNoticeShowView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        self.shadowView = [[UIView alloc] init];
        self.shadowView.backgroundColor = YZHColorWithRGB(0, 0, 0);
        self.shadowView.alpha = 0.3;
        [self addSubview:self.shadowView];
        
        self.shadowButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.shadowView addSubview:self.shadowButton];
        
        self.titleView = [[UIView alloc] init];
        self.titleView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.titleView];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.textColor = [UIColor yzh_fontShallowBlack];
        self.titleLabel.font = [UIFont yzh_commonStyleWithFontSize:12];
        self.titleLabel.numberOfLines = 1;
        [self.titleView addSubview:self.titleLabel];
        
        self.showButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.titleView addSubview:self.showButton];
        
        self.contentView = [[UIView alloc] init];
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.contentView];
        
        self.lineView = [[UIView alloc] init];
        self.lineView.backgroundColor = [UIColor yzh_separatorLightGray];
        [self.contentView addSubview:self.lineView];
        
        self.contentLabel = [[UILabel alloc] init];
        self.contentLabel.textColor = [UIColor yzh_fontShallowBlack];
        self.contentLabel.font = [UIFont systemFontOfSize:12];
        self.contentLabel.numberOfLines = 4;
        self.contentLabel.contentMode = UIViewContentModeTopLeft;
        [self.contentView addSubview:self.contentLabel];
    }
    return self;
}

-(void)setLabelSpace:(UILabel*)label withValue:(NSString*)str withFont:(UIFont*)font {
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 5; //设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    //设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f};
    
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:str attributes:dic];
    label.attributedText = attributeStr;
};


@end
