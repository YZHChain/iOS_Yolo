//
//  YZHAddFirendContentView.m
//  YZHYolo
//
//  Created by Jersey on 2018/10/27.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHAddFirendContentView.h"

#import "YZHAddFirendAttachment.h"

@interface YZHAddFirendContentView()

@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UIButton* addFirendButton;
@property (nonatomic, strong) UIView* addFirendButtonLineView;
@property (nonatomic, strong) YZHAddFirendAttachment* attachment;

@end

@implementation YZHAddFirendContentView

- (instancetype)initSessionMessageContentView {
    
    self = [super initSessionMessageContentView];
    
    if (self) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textColor = [UIColor yzh_sessionCellGray];
        
        _addFirendButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_addFirendButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [_addFirendButton setTitleColor:[UIColor colorWithRed:53/255.0 green:115/255.0 blue:252/255.0 alpha:1] forState:UIControlStateNormal];
        
        _addFirendButtonLineView = [[UIView alloc] init];
        _addFirendButtonLineView.backgroundColor = _addFirendButton.currentTitleColor;
        
        [_addFirendButton addTarget:self action:@selector(onTouchaddFirend:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_titleLabel];
        [self addSubview:_addFirendButton];
        [_addFirendButton addSubview:_addFirendButtonLineView];
        
        [self.bubbleImageView removeFromSuperview];
        self.bubbleImageView = nil;
    }
    
    return self;
}

- (void)refresh:(NIMMessageModel *)data {
    
    [super refresh:data];
    
    NIMCustomObject* customObject = (NIMCustomObject* )data.message.messageObject;
    YZHAddFirendAttachment* addachment = (YZHAddFirendAttachment* )customObject.attachment;
    
    if ([addachment isKindOfClass:[YZHAddFirendAttachment class]]) {
        
        _attachment = addachment;
        _titleLabel.text = addachment.addFirendTitle;
        [_addFirendButton setTitle:addachment.addFirendButtonTitle forState:UIControlStateNormal];
        
        [_titleLabel sizeToFit];
        [_addFirendButton sizeToFit];
    }
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGFloat tableViewWidth = self.superview.width;
    CGSize contentSize = [self.model contentSize:tableViewWidth];
    
    _titleLabel.y = 15;
    _titleLabel.centerX = contentSize.width / 2;
    
    _addFirendButton.bottom = self.height;
    _addFirendButton.width = 100;
    _addFirendButton.centerX = contentSize.width / 2;
    
    _addFirendButtonLineView.x = _addFirendButton.titleLabel.x;
    _addFirendButtonLineView.y = _addFirendButton.height - 1;
    _addFirendButtonLineView.width = [_addFirendButton.titleLabel width];
    _addFirendButtonLineView.height = 1;
}

- (void)onTouchaddFirend:(UIButton* )sender {
    
    NSString* formAccount = _attachment.fromAccount;
    //判断对方是否为好友,如果不是好友则添加.并发送一条添加好友消息.
    if (YZHIsString(formAccount)) {
        NIMKitEvent *event = [[NIMKitEvent alloc] init];
        event.eventName = NIMKitEventNameTapContent;
        event.messageModel = self.model;
        [self.delegate onCatchEvent:event];
    }
}
@end
