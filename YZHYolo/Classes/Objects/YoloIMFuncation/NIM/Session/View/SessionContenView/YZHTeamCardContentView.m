//
//  YZHTeamCardContentView.m
//  YZHYolo
//
//  Created by Jersey on 2018/10/26.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHTeamCardContentView.h"

#import "YZHTeamCardAttachment.h"
#import "UIImageView+YZHImage.h"
#import "YZHTeamInfoExtManage.h"
#import "YZHProgressHUD.h"

@interface YZHTeamCardContentView()

@property (nonatomic, strong) UIView* titleView;
@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UIView* titleSeparatorLineView;
@property (nonatomic, strong) UIButton* addTeamButton;
@property (nonatomic, strong) UIView* separatorLineView;
@property (nonatomic, strong) UIView* contentView;
@property (nonatomic, strong) UIImageView* avatarImageView;
@property (nonatomic, strong) UILabel* teamNameLabel;
@property (nonatomic, strong) UILabel* teamUrlLabel;
@property (nonatomic, strong) UILabel* teamSynopsisLabel;
@property (nonatomic, strong) UIButton* showButton;

@end

@implementation YZHTeamCardContentView

- (instancetype)initSessionMessageContentView{
    self = [super initSessionMessageContentView];
    if (self) {
        self.opaque = YES;
        _titleView = [[UIView alloc] initWithFrame:CGRectZero];
        _titleView.backgroundColor = [UIColor yzh_sessionCellBackgroundGray];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont systemFontOfSize:10];
        _titleLabel.textColor = [UIColor yzh_sessionCellGray];
        
        _titleSeparatorLineView = [[UIView alloc] initWithFrame:CGRectMake(182, 0, 0.5, 26)];
        _titleSeparatorLineView.backgroundColor = [UIColor yzh_sessionCellGray];
        
        _separatorLineView = [[UIView alloc] initWithFrame:CGRectZero];
        _separatorLineView.backgroundColor = [UIColor yzh_sessionCellGray];
        
        _contentView = [[UIView alloc] initWithFrame:CGRectZero];
        _contentView.backgroundColor = [UIColor whiteColor];
        
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.image = [UIImage imageNamed:@"team_cell_photoImage_default"];
        _avatarImageView.layer.cornerRadius = 2.5;
        _avatarImageView.layer.masksToBounds = YES;
        
        _teamNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _teamNameLabel.font = [UIFont systemFontOfSize:14];
        _teamNameLabel.textColor = [UIColor yzh_fontShallowBlack];
        _teamNameLabel.numberOfLines = 2;
        _teamNameLabel.width = 145;
//        _teamNameLabel.preferredMaxLayoutWidth = 250 - 65;
    
        _teamUrlLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _teamUrlLabel.textColor = [UIColor yzh_sessionCellGray];
        _teamUrlLabel.font = [UIFont systemFontOfSize:11];
        
        _teamSynopsisLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _teamSynopsisLabel.textColor = [UIColor yzh_sessionCellGray];
        _teamSynopsisLabel.font = [UIFont systemFontOfSize:10];
        _teamSynopsisLabel.numberOfLines = 2;
        //TODO 离屏渲染
        self.layer.cornerRadius = 4;
        self.layer.borderColor = [UIColor yzh_sessionCellGray].CGColor;
        self.layer.borderWidth = 0.5f;
        self.layer.masksToBounds = YES;
        
        [self addSubview:_titleView];
        [_titleView addSubview:_titleLabel];
        [_titleView addSubview:_titleSeparatorLineView];
        [self addSubview:_separatorLineView];
        [self addSubview:_contentView];
        [_contentView addSubview:_avatarImageView];
        [_contentView addSubview:_teamNameLabel];
        [_contentView addSubview:_teamUrlLabel];
        [_contentView addSubview:_teamSynopsisLabel];
        
        _showButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _showButton.backgroundColor = [UIColor clearColor];
        [_showButton addTarget:self action:@selector(onTouchTeamUpInside:) forControlEvents:UIControlEventTouchUpInside];
        
        _addTeamButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addTeamButton setTitle:@"立即加入" forState:UIControlStateNormal];
        [_addTeamButton.titleLabel setFont:[UIFont systemFontOfSize:11]];
        [_addTeamButton setTitleColor:[UIColor yzh_fontShallowBlack] forState:UIControlStateNormal];
        [_addTeamButton addTarget:self action:@selector(onTouchAddTeamUpInside:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:_showButton];
        [self.titleView addSubview:_addTeamButton];
        
        [self.bubbleImageView removeFromSuperview];
        self.bubbleImageView = nil;
    }
    return self;
}

- (void)refresh:(NIMMessageModel *)data {
    
    [super refresh:data];
    NIMCustomObject *customObject = (NIMCustomObject*)data.message.messageObject;
    YZHTeamCardAttachment* attachment = (YZHTeamCardAttachment *)customObject.attachment;
    self.attachment = attachment;
    if ([attachment isKindOfClass:[YZHTeamCardAttachment class]]) {
        _titleLabel.text = attachment.titleName;
        [_avatarImageView yzh_setImageWithString:attachment.avatarUrl placeholder:@"team_cell_photoImage_default"];
//        [_avatarImageView yzh_cornerRadiusAdvance:2.5f rectCornerType:UIRectCornerAllCorners];
        _teamNameLabel.text = attachment.groupName;
        _teamUrlLabel.text = attachment.groupUrl;
        _teamSynopsisLabel.text = attachment.groupSynopsis;
        [_avatarImageView setSize:CGSizeMake(45, 45)];
        [_titleLabel sizeToFit];
        [_teamNameLabel sizeToFit];
        [_teamUrlLabel sizeToFit];
        [_teamSynopsisLabel sizeToFit];
    }
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGFloat tableViewWidth = self.superview.width;
    CGSize contentSize = [self.model contentSize:tableViewWidth];
    //排版
    CGRect titleViewFrame = CGRectMake(0, 0, contentSize.width, 26);
    _titleView.frame = titleViewFrame;
    
    _titleLabel.x = 14;
    _titleLabel.centerY = _titleView.height / 2;
    
    _titleSeparatorLineView.frame = CGRectMake(182, 0, 0.5, 26);
    
    _addTeamButton.x = 182.5;
    _addTeamButton.width = 67.5;
    _addTeamButton.height = 26;
    
    _separatorLineView.frame = CGRectMake(0, _titleView.height, contentSize.width, 0.5f);
    
    _contentView.frame = CGRectMake(0, _titleView.height + 0.5, contentSize.width, contentSize.height - _titleView.height - _separatorLineView.height);
    
    _avatarImageView.x = 16;
    _avatarImageView.y = 13;
    
    _teamNameLabel.x = _avatarImageView.right + 8;
    _teamNameLabel.y = 13;
    _teamNameLabel.width = 165;
    
    _teamUrlLabel.x = _teamNameLabel.x;
    _teamUrlLabel.y = 35;
    _teamUrlLabel.width = contentSize.width - 75;
    _teamUrlLabel.numberOfLines = 2;
    [_teamUrlLabel sizeToFit];
    
    _teamSynopsisLabel.x = 12;
    _teamSynopsisLabel.y = 65;
    _teamSynopsisLabel.width = contentSize.width - 25;
    [_teamSynopsisLabel sizeToFit];
    
    _showButton.frame = _contentView.frame;
    
//    self.size = contentSize;
}

#pragma mark -- YZHCustom


- (void)onTouchTeamUpInside:(id)sender
{
    //判断当前账号与此群关系
    BOOL isMyTeam = [[[NIMSDK sharedSDK] teamManager] isMyTeam:self.attachment.groupID];
    BOOL isOwner = NO;
    
    if (isMyTeam) {
        NSString* userId = [[[NIMSDK sharedSDK] loginManager] currentAccount];
        NSString* teamOwner = [[[NIMSDK sharedSDK] teamManager] teamById:self.attachment.groupID].owner;
        if ([userId isEqualToString:teamOwner]) {
            isOwner = YES;
        } else {
            isOwner = NO;
        }
        [YZHRouter openURL:kYZHRouterCommunityCard info:@{
                                                          @"isTeamOwner":@(isOwner),
                                                          @"teamId":self.attachment.groupID ? self.attachment.groupID : @""
                                                          }];
    } else {
        
        [YZHRouter openURL:kYZHRouterCommunityCardIntro info:@{
                                                               @"teamId": self.attachment.groupID ? self.attachment.groupID : @"",
                                                               kYZHRouteSegue: kYZHRouteSegueModal,
                                                               kYZHRouteSegueNewNavigation: @(YES)
                                                               }];
    }
}

- (void)onTouchAddTeamUpInside:(id)sender {
    
    //判断当前账号与此群关系
    BOOL isMyTeam = [[[NIMSDK sharedSDK] teamManager] isMyTeam:self.attachment.groupID];
    NSString* userId = [[[NIMSDK sharedSDK] loginManager] currentAccount];
    if (!isMyTeam) {
        //是否还需要再判断此群是公开或者私密等.
        [[[NIMSDK sharedSDK] teamManager] addUsers:@[userId] toTeam:self.attachment.groupID postscript:@"通过群名片分享加入" completion:^(NSError * _Nullable error, NSArray<NIMTeamMember *> * _Nullable members) {
            if (!error) {
                [YZHProgressHUD showText:@"您已成功加入社群" onView:YZHAppWindow];
            }
        }];
    } else {
        //已在本群
        [YZHProgressHUD showText:@"您已是本社群成员" onView:YZHAppWindow];
    }
    
}

@end
