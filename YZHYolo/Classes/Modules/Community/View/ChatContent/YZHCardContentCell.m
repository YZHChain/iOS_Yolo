//
//  YZHCardContentCell.m
//  YZHYolo
//
//  Created by Jersey on 2018/12/2.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHCardContentCell.h"

#import "UIView+YZHTool.h"
@implementation YZHCardContentCell
{
    NSString* _viewClass;
    CGRect _cardFrame;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        //        [self makeComponents];
        //        [self makeGesture];
    }
    return self;
}

- (void)refreshData:(NIMMessage *)data {
    
    self.message = data;
    
    [self refresh];
}

- (void)refresh {
    
    self.backgroundColor = [NIMKit sharedKit].config.cellBackgroundColor;
    
    
    [self addContentViewIfNotExist];
    //Jersey IM:将数据加载到内容视图中<
    NIMMessageModel* model = [[NIMMessageModel alloc] initWithMessage:_message];
    [_cardView refresh:model];
    
    [_cardView setNeedsLayout];
    
    [self setNeedsLayout];
}

- (void)addContentViewIfNotExist
{
    if (_cardView == nil)
    {
        NIMCustomObject *customObject = (NIMCustomObject*)_message.messageObject;
        CGRect frame;
        if ([customObject.attachment isKindOfClass:NSClassFromString(@"YZHUserCardAttachment")]) {
            _viewClass = @"YZHUserCardContentView";
            frame = CGRectMake(12, 10, 250, 97);
        } else {
            _viewClass = @"YZHTeamCardContentView";
            frame = CGRectMake(12, 10, 250, 123);
        }
        Class clazz = NSClassFromString(_viewClass);
        //TODO: 异常捕获,
        NIMSessionMessageContentView *contentView =  [[clazz alloc] initSessionMessageContentView];
        _cardView = contentView;
        _cardView.frame = frame;
        _cardFrame = frame;
        [self.contentView addSubview:_cardView];
    }
}

- (void)layoutIfNeeded {
    
    [super layoutIfNeeded];
    
    [self setCardLayout];
}

- (void)setCardLayout {
    
    self.cardView.frame = _cardFrame;
}

@end
