//
//  YZHUserCardContentView.m
//  YZHYolo
//
//  Created by Jersey on 2018/10/26.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHUserCardContentView.h"

#import "YZHUserCardAttachment.h"
#import "UIImageView+YZHImage.h"
#import "YZHCustomAttachmentDecoder.h"
@interface  YZHUserCardContentView()

@property (nonatomic, strong) UIView* titleView;
@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UIView* separatorLineView;
@property (nonatomic, strong) UIView* contentView;
@property (nonatomic, strong) UIImageView* avatarImageView;
@property (nonatomic, strong) UILabel* nickNameLabel;
@property (nonatomic, strong) UILabel* yoloIDLaebl;
@property (nonatomic, strong) UIButton* showButton;

@end

@implementation YZHUserCardContentView

- (instancetype)initSessionMessageContentView{
    self = [super initSessionMessageContentView];
    if (self) {
        self.opaque = YES;
        _titleView = [[UIView alloc] initWithFrame:CGRectZero];
        _titleView.backgroundColor = [UIColor yzh_sessionCellBackgroundGray];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont systemFontOfSize:10];
        _titleLabel.textColor = [UIColor yzh_sessionCellGray];
        
        _separatorLineView = [[UIView alloc] initWithFrame:CGRectZero];
        _separatorLineView.backgroundColor = [UIColor yzh_sessionCellGray];
        
        _contentView = [[UIView alloc] initWithFrame:CGRectZero];
        _contentView.backgroundColor = [UIColor whiteColor];
        
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.image = [UIImage imageNamed:@"addBook_cover_cell_photo_default"];
        _avatarImageView.layer.cornerRadius = 2.5;
        _avatarImageView.layer.masksToBounds = YES;
        
        _nickNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nickNameLabel.font = [UIFont systemFontOfSize:14];
        _nickNameLabel.textColor = [UIColor yzh_fontShallowBlack];
        
        _yoloIDLaebl = [[UILabel alloc] initWithFrame:CGRectZero];
        _yoloIDLaebl.font = [UIFont systemFontOfSize:11];
        _yoloIDLaebl.textColor = [UIColor yzh_sessionCellGray];
        //TODO 离屏渲染
        self.layer.cornerRadius = 4;
        self.layer.borderColor = [UIColor yzh_sessionCellGray].CGColor;
        self.layer.borderWidth = 0.5f;
        self.layer.masksToBounds = YES;
        
        [self addSubview:_titleView];
        [_titleView addSubview:_titleLabel];
        [self addSubview:_separatorLineView];
        [self addSubview:_contentView];
        [_contentView addSubview:_avatarImageView];
        [_contentView addSubview:_nickNameLabel];
        [_contentView addSubview:_yoloIDLaebl];
        
        _showButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _showButton.backgroundColor = [UIColor clearColor];
        [_showButton addTarget:self action:@selector(onTouchCardUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_showButton];
        
        [self.bubbleImageView removeFromSuperview];
        self.bubbleImageView = nil;
        
    }
    return self;
}

- (void)refresh:(NIMMessageModel *)data{
    
    [super refresh:data];
    NIMCustomObject *customObject = (NIMCustomObject*)data.message.messageObject;
    YZHUserCardAttachment* attachment = (YZHUserCardAttachment *)customObject.attachment;
    //TODO:异常处理
    if ([attachment isKindOfClass:[YZHUserCardAttachment class]]) {
        
        _titleLabel.text = attachment.titleName;
        [_avatarImageView yzh_setImageWithString:attachment.avatarUrl placeholder:@"addBook_cover_cell_photo_default"];
//        [_avatarImageView yzh_cornerRadiusAdvance:2.5f rectCornerType:UIRectCornerAllCorners];
        _nickNameLabel.text = attachment.userName;
        _yoloIDLaebl.text = attachment.yoloID;
        [_avatarImageView setSize:CGSizeMake(45, 45)];
        [_titleLabel sizeToFit];
        [_nickNameLabel sizeToFit];
        [_yoloIDLaebl sizeToFit];
    } else {
        
    }
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat tableViewWidth = self.superview.width;
    CGSize contentSize = [self.model contentSize:tableViewWidth];
    //排版
    CGRect titleViewFrame = CGRectMake(0, 0, contentSize.width, 26);
    _titleView.frame = titleViewFrame;
    
    _titleLabel.x = 14;
    _titleLabel.centerY = _titleView.height / 2;
    
    _separatorLineView.frame = CGRectMake(0, _titleView.height, contentSize.width, 0.5f);
    
    _contentView.frame = CGRectMake(0, _titleView.height + 0.5, contentSize.width, contentSize.height - _titleView.height - _separatorLineView.height);
    
    _avatarImageView.x = 16;
    _avatarImageView.y = 13;
    
    _nickNameLabel.x = _avatarImageView.right + 8;
    _nickNameLabel.y = 13;
    
    _yoloIDLaebl.x = _nickNameLabel.x;
    _yoloIDLaebl.y = 42;
    
    _showButton.frame = self.frame;
    
//    self.size = contentSize;
}

- (void)onTouchCardUpInside:(id)sender
{
    
    if (self.model) {
        NIMCustomObject *customObject = (NIMCustomObject*)self.model.message.messageObject;
        YZHUserCardAttachment* attachment = (YZHUserCardAttachment *)customObject.attachment;
        NSString* account;
        if ([attachment isKindOfClass:[YZHUserCardAttachment class]]) {
            account = attachment.account;
        }
        //TODO: 鉴定账号
        if (YZHIsString(account)) {
            [YZHRouter openURL:kYZHRouterAddressBookDetails info:@{
                                                                   @"userId": account
                                                                   }];
        }
    }
}

#pragma mark -- YZHCustom



@end
