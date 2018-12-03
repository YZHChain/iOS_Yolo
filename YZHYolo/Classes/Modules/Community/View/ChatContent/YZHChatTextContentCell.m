//
//  YZHChatTextContentCell.m
//  YZHYolo
//
//  Created by Jersey on 2018/12/2.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHChatTextContentCell.h"

#import "UIView+NIM.h"
@interface YZHChatTextContentCell()<NIMMessageContentViewDelegate>

@end

@implementation YZHChatTextContentCell
{
    UILongPressGestureRecognizer *_longPressGesture;
    UIMenuController             *_menuController;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        [self makeComponents];
        [self makeGesture];
    }
    return self;
}

- (void)makeGesture{
    _longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGesturePress:)];
    [self addGestureRecognizer:_longPressGesture];
}

- (void)refreshData:(NIMMessageModel *)data
{
    self.model = data;
    if ([self checkData])
    {
        [self refresh];
    }
}

- (BOOL)checkData{
    
    return [self.model isKindOfClass:[NIMMessageModel class]];
}

- (void)refresh {
    
    self.backgroundColor = [NIMKit sharedKit].config.cellBackgroundColor;
    
    [self addContentViewIfNotExist];
    //Jersey IM:将数据加载到内容视图中<
    [_bubbleView refresh:self.model];
    [_bubbleView setNeedsLayout];
    
    [self setNeedsLayout];
}

- (void)addContentViewIfNotExist
{
    if (_bubbleView == nil)
    {
        id<NIMCellLayoutConfig> layoutConfig = [[NIMKit sharedKit] layoutConfig];
        NSString *contentStr = [layoutConfig cellContent:self.model];
        NSAssert([contentStr length] > 0, @"should offer cell content class name");
        Class clazz = NSClassFromString(contentStr);
        //TODO: 异常捕获,
        NIMSessionMessageContentView *contentView =  [[clazz alloc] initSessionMessageContentView];
        NSAssert(contentView, @"can not init content view");
        _bubbleView = contentView;
        _bubbleView.delegate = self;
//        NIMMessageType messageType = self.model.message.messageType;
//        if (messageType == NIMMessageTypeAudio) {
//            ((NIMSessionAudioContentView *)_bubbleView).audioUIDelegate = self;
//        }
        [self.contentView addSubview:_bubbleView];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    [self layoutBubbleView];
}

- (void)layoutBubbleView
{
    //计算正在的内容大小.
    CGSize size  = [self.model contentSize:self.nim_width];
    UIEdgeInsets insets = self.model.contentViewInsets;
    size.width  = size.width + insets.left + insets.right;
    size.height = size.height + insets.top + insets.bottom;
    _bubbleView.nim_size = size;
    
//    UIEdgeInsets contentInsets = self.model.bubbleViewInsets;
//    if (!self.model.shouldShowLeft)
//    {
//        CGFloat protraitRightToBubble = 5.f;
//        CGFloat right = self.model.shouldShowAvatar? CGRectGetMinX(self.headImageView.frame)  - protraitRightToBubble : self.nim_width;
//        contentInsets.left = right - CGRectGetWidth(self.bubbleView.bounds);
//    }
    _bubbleView.nim_left = 10;
    _bubbleView.nim_top  = 5;
}

#pragma mark - NIMMessageContentViewDelegate
- (void)onCatchEvent:(NIMKitEvent *)event{
    if ([self.delegate respondsToSelector:@selector(onTapCell:)]) {
        [self.delegate onTapCell:event];
    }
}

- (void)longGesturePress:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]] &&
        gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(onLongPressCell:inView:)]) {
            [self.delegate onLongPressCell:self.model.message
                                    inView:_bubbleView];
        }
    }
}

@end
