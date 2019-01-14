//
//  YZHUnreadMessageView.m
//  YZHYolo
//
//  Created by Jersey on 2018/11/29.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHUnreadMessageView.h"

@implementation YZHUnreadMessageView

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 4;
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor yzh_colorWithHexString:@"#E5E5E5"].CGColor;
        self.layer.masksToBounds = YES;
    
        UILabel* title = [[UILabel alloc] init];
        title.font = [UIFont yzh_commonStyleWithFontSize:12];
        title.textColor = [UIColor yzh_fontShallowBlack];
        _titleLabel = title;
        [self addSubview:_titleLabel];
        
        UIButton* readButton = [UIButton buttonWithType:UIButtonTypeCustom];
        readButton.backgroundColor = [UIColor clearColor];
        _readButton = readButton;
        [self addSubview:_readButton];
    }
    return self;
}

- (instancetype)initWithUnreadNumber:(NSInteger)number {
    
    self = [self init];
    if (self) {
        if (number > 99) {
           self.titleLabel.text = [NSString stringWithFormat:@"有99条+新消息"];
        } else {
           self.titleLabel.text = [NSString stringWithFormat:@"有%ld条新消息" ,number];
        }
        [self.titleLabel sizeToFit];
    }
    return self;
}

@end
