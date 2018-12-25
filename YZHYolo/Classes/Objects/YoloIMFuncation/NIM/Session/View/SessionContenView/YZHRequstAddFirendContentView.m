//
//  YZHRequstAddFirendContentView.m
//  YZHYolo
//
//  Created by Jersey on 2018/10/27.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHRequstAddFirendContentView.h"

#import "YZHRequstAddFirendAttachment.h"
@interface YZHRequstAddFirendContentView()

@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UIView* titleBackgroundView;

@end

@implementation YZHRequstAddFirendContentView

- (instancetype)initSessionMessageContentView {
    
    self = [super initSessionMessageContentView];
    if (self) {
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textColor = [UIColor yzh_sessionCellGray];
        
        _titleBackgroundView = [[UIView alloc] init];
        _titleBackgroundView.backgroundColor = [UIColor yzh_colorWithHexString:@"#FFDDDEE1"];
        
//        [_titleBackgroundView addSubview:_titleLabel];
//        [self addSubview:_titleBackgroundView];
        [self addSubview:_titleLabel];
        [self.bubbleImageView removeFromSuperview];
        self.bubbleImageView = nil;
    }
    
    return self;
}

- (void)refresh:(NIMMessageModel *)data {
    
    [super refresh:data];
    
    NIMCustomObject* customObject = (NIMCustomObject* )data.message.messageObject;
    YZHRequstAddFirendAttachment* addachment = (YZHRequstAddFirendAttachment* )customObject.attachment;
    
    if ([addachment isKindOfClass:[YZHRequstAddFirendAttachment class]]) {
        
        _titleLabel.text = addachment.addFirendTitle;
        [_titleLabel sizeToFit];
    }
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    _titleBackgroundView.center = CGPointMake(self.width / 2, self.height / 2);
    _titleBackgroundView.size = CGSizeMake(100, 50);
    _titleLabel.center = CGPointMake(self.width / 2, self.height / 2);
    
}
    
@end
