//
//  YZHCardContentCell.m
//  YZHYolo
//
//  Created by Jersey on 2018/12/2.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHCardContentCell.h"

@implementation YZHCardContentCell
{
    NSString* _viewClass;
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
//    NIMMessageModel* model = [NIMMessageModel ]
//    [_cardView refresh:<#(NIMMessageModel *)#>.
//    [_bubbleView setNeedsLayout];
    
    [self setNeedsLayout];
}

- (void)addContentViewIfNotExist
{
    if (_cardView == nil)
    {
        NIMCustomObject *customObject = (NIMCustomObject*)_message.messageObject;
        if ([customObject.attachment isKindOfClass:NSClassFromString(@"YZHUserCardAttachment")]) {
            _viewClass = @"YZHUserCardContentView";
        } else {
            _viewClass = @"YZHTeamCardContentView";
        }
        Class clazz = NSClassFromString(_viewClass);
        //TODO: 异常捕获,
        NIMSessionMessageContentView *contentView =  [[clazz alloc] initSessionMessageContentView];
        _cardView = contentView;
//        _bubbleView.delegate = self;
        [self.contentView addSubview:_cardView];
    }
}

@end
