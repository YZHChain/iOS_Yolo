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
@property (nonatomic, strong) UIView* topLineView;
@property (nonatomic, strong) UIView* bottomLineView;

@end

@implementation YZHRequstAddFirendContentView

- (instancetype)initSessionMessageContentView {
    
    self = [super initSessionMessageContentView];
    if (self) {
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textColor = [UIColor yzh_sessionCellGray];
        
        _topLineView = [[UIView alloc] init];
        _topLineView.backgroundColor = YZHColorWithRGB(224, 224, 224);
        
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = _topLineView.backgroundColor;
        
        [self addSubview:_titleLabel];
        [self addSubview:_topLineView];
        [self addSubview:_bottomLineView];
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
    
    _titleLabel.center = CGPointMake(self.width / 2, self.height / 2);
    
    _topLineView.frame = CGRectMake(38, 0, self.width - 38 * 2, 1);
    _bottomLineView.frame = CGRectMake(38, self.height - 1, self.width - 38 * 2, 1);
    
    
}
    

@end
