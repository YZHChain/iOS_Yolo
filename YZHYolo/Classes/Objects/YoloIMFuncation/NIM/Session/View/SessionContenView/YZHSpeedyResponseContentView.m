//
//  YZHSpeedyResponseContentView.m
//  YZHYolo
//
//  Created by Jersey on 2018/11/25.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHSpeedyResponseContentView.h"

#import "M80AttributedLabel+NIMKit.h"
#import "UIView+NIM.h"
#import "NIMKitUtil.h"
#import "YZHSpeedyResponseAttachment.h"
#import "UIButton+YZHTool.h"
#import "YZHSpeedyResponseButtonView.h"
#import "UIImageView+YZHImage.h"

@interface YZHSpeedyResponseContentView()<M80AttributedLabelDelegate>

@property (nonatomic, strong) YZHSpeedyResponseButtonView* speedyResponseView;
@property (nonatomic, strong) UIButton* receiveButton;
@property (nonatomic, strong) UIButton* responseButton;
@property (nonatomic, strong) UIButton* handleButton;

@end

@implementation YZHSpeedyResponseContentView

- (instancetype)initSessionMessageContentView {
    
    self = [super initSessionMessageContentView];
    if (self) {
        
        self.userInteractionEnabled = YES;
        _textLabel = [[M80AttributedLabel alloc] initWithFrame:CGRectZero];
        _textLabel.delegate = self;
        _textLabel.numberOfLines = 0;
        _textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _textLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_textLabel];
        
        YZHSpeedyResponseButtonView* speedyResponseView = [[YZHSpeedyResponseButtonView alloc] init];
        _speedyResponseView = speedyResponseView;
        _speedyResponseView.layer.cornerRadius = 4;
        _speedyResponseView.layer.borderWidth = 1;
        _speedyResponseView.layer.borderColor = [UIColor yzh_separatorLightGray].CGColor;
        _speedyResponseView.userInteractionEnabled = YES;
        
//        [self addSubview:_speedyResponseView];
        
        UIButton* receiveButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [receiveButton.titleLabel setFont:[UIFont systemFontOfSize:11]];
        [receiveButton setTitleColor:[UIColor yzh_fontShallowBlack] forState:UIControlStateNormal];
        [receiveButton setTitleColor:[UIColor yzh_sessionCellGray] forState:UIControlStateSelected];
        [receiveButton setTitle:@"收到" forState:UIControlStateNormal];
        [receiveButton yzh_setBackgroundColor:YZHColorWithRGB(245, 245, 245) forState:UIControlStateNormal];
        [receiveButton yzh_setBackgroundColor:YZHColorWithRGB(245, 245, 245) forState:UIControlStateSelected];
        _receiveButton = receiveButton;
        [_receiveButton addTarget:self action:@selector(onTouchReceiveUpInside:) forControlEvents:UIControlEventTouchUpInside];
        _receiveButton.userInteractionEnabled = YES;
        
        UIButton* responseButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [responseButton.titleLabel setFont:[UIFont systemFontOfSize:11]];
        [responseButton setTitleColor:[UIColor yzh_fontShallowBlack] forState:UIControlStateNormal];
        [responseButton setTitleColor:[UIColor yzh_sessionCellGray] forState:UIControlStateSelected];
        [responseButton yzh_setBackgroundColor:YZHColorWithRGB(245, 245, 245) forState:UIControlStateNormal];
        [responseButton yzh_setBackgroundColor:YZHColorWithRGB(245, 245, 245) forState:UIControlStateSelected];
        responseButton.layer.borderWidth = 1;
        responseButton.layer.borderColor = [UIColor yzh_separatorLightGray].CGColor;
        responseButton.layer.masksToBounds = YES;
        [responseButton setTitle:@"回复" forState:UIControlStateNormal];
        _responseButton = responseButton;
        [_responseButton addTarget:self action:@selector(onTouchResponseUpInside:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton* handleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [handleButton.titleLabel setFont:[UIFont systemFontOfSize:11]];
        [handleButton setTitleColor:[UIColor yzh_fontShallowBlack] forState:UIControlStateNormal];
        [handleButton setTitleColor:[UIColor yzh_fontShallowBlack] forState:UIControlStateSelected];
        [handleButton setTitle:@"已处理完" forState:UIControlStateNormal];
        [handleButton yzh_setBackgroundColor:YZHColorWithRGB(238, 238, 238) forState:UIControlStateNormal];
        [handleButton yzh_setBackgroundColor:[UIColor yzh_separatorLightGray] forState:UIControlStateSelected];
        _handleButton = handleButton;
        [_handleButton addTarget:self action:@selector(onTouchHandleUpInside:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_receiveButton];
        [self addSubview:_responseButton];
        [self addSubview:_handleButton];
        
    }
    return self;
}

- (void)refresh:(NIMMessageModel *)data
{
    [super refresh:data];
    
    NIMCustomObject *customObject = (NIMCustomObject*)data.message.messageObject;
    YZHSpeedyResponseAttachment* attachment = (YZHSpeedyResponseAttachment *)customObject.attachment;
    if ([attachment isKindOfClass:[YZHSpeedyResponseAttachment class]]) {
        
        NIMKitSetting *setting = [[NIMKit sharedKit].config setting:data.message];
        self.textLabel.textColor = setting.textColor;;
        self.textLabel.font      = setting.font;
        [self.textLabel nim_setText:attachment.content];
        //如果是自己发送的则需要将其删除掉.不需要显示.
        if (attachment.isSender) {
            [self.receiveButton removeFromSuperview];
            [self.responseButton removeFromSuperview];
            [self.handleButton removeFromSuperview];
        }
        self.receiveButton.selected = attachment.canGet;
//        self.responseButton.selected = attachment.isResponse;
        self.handleButton.selected = attachment.canFinish;
        self.receiveButton.enabled = !attachment.canGet;
//        self.responseButton.enabled = !attachment.isResponse;
        self.handleButton.enabled = !attachment.isResponse;
    }
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    UIEdgeInsets contentInsets = self.model.contentViewInsets;
    CGFloat tableViewWidth = self.superview.nim_width;
    CGSize contentsize = [self.model contentSize:tableViewWidth];
    CGRect labelFrame = CGRectMake(contentInsets.left, contentInsets.top, contentsize.width, contentsize.height);
    self.textLabel.frame = labelFrame;
    
    self.speedyResponseView.frame = CGRectMake(0, self.bubbleImageView.nim_bottom + 3, 165, 20);
    self.receiveButton.frame = CGRectMake(0, self.bubbleImageView.nim_bottom + 3, 50, 20);
    self.responseButton.frame = CGRectMake(50, self.bubbleImageView.nim_bottom + 3, 50, 20);
    self.handleButton.frame = CGRectMake(100, self.bubbleImageView.nim_bottom + 3, 65, 20);
}

#pragma mark - M80AttributedLabelDelegate
- (void)m80AttributedLabel:(M80AttributedLabel *)label
             clickedOnLink:(id)linkData{
    NIMKitEvent *event = [[NIMKitEvent alloc] init];
    event.eventName = NIMKitEventNameTapLabelLink;
    event.messageModel = self.model;
    event.data = linkData;
    
    [self.delegate onCatchEvent:event];
}

- (void)onTouchReceiveUpInside:(UIButton *)sender {
    
    if (sender.isSelected == YES) {
        sender.selected = YES;
        sender.enabled = NO;
        NIMKitEvent *event = [[NIMKitEvent alloc] init];
        event.eventName = NIMKitEventNameReceive;
        event.messageModel = self.model;
        [self.delegate onCatchEvent:event];
    }
}

- (void)onTouchResponseUpInside:(UIButton *)sender {
    
    if (sender.isSelected == NO) {
        sender.selected = YES;
//        sender.enabled = NO;
        NIMKitEvent *event = [[NIMKitEvent alloc] init];
        event.eventName = NIMKitEventNameResponse;
        event.messageModel = self.model;
        [self.delegate onCatchEvent:event];
    }
}

- (void)onTouchHandleUpInside:(UIButton *)sender {
    
    if (sender.isSelected == YES) {
        sender.selected = YES;
        sender.enabled = NO;
        NIMKitEvent *event = [[NIMKitEvent alloc] init];
        event.eventName = NIMKitEventNameHandle;
        event.messageModel = self.model;
        [self.delegate onCatchEvent:event];
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    for (UIView *view in self.subviews) {
        
        CGPoint viewP = [self convertPoint:point toView:view];
        
        if ([view pointInside:viewP withEvent:event]) {
            return view;
        }
    }
    return [super hitTest:point withEvent:event];
}

@end

