//
//  YZHTeamCardModel.m
//  YZHYolo
//
//  Created by Jersey on 2018/11/19.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHTeamCardModel.h"

#import "YZHTeamInfoExtManage.h"
#import "YZHTeamExtManage.h"
@implementation YZHTeamHeaderModel



@end

@implementation YZHTeamDetailModel



@end

@implementation YZHTeamCardModel

- (instancetype)initWithTeamId:(NSString *)teamId isManage:(BOOL)isManage {
    
    self = [super init];
    if (self) {
        _teamId = [teamId copy];
        _isManage = isManage;
        
        [self configuration];
    }
    return self;
}

- (void)configuration {
   
    NIMTeam* team = [[[NIMSDK sharedSDK] teamManager] teamById:_teamId];
    NSString* userId = [[[NIMSDK sharedSDK] loginManager] currentAccount];
    NIMTeamMember* member = [[[NIMSDK sharedSDK] teamManager] teamMember:userId inTeam:_teamId];
    YZHTeamInfoExtManage* teamExtManage = [YZHTeamInfoExtManage YZH_objectWithKeyValues:team.clientCustomInfo];
    
    YZHTeamHeaderModel* headerModel = [[YZHTeamHeaderModel alloc] init];
    headerModel.teamName = team.teamName;
    headerModel.teamSynopsis = team.intro;
    headerModel.avatarImageName = team.avatarUrl;
//    headerModel.labelArray = teamExtManage.labelArray;
    headerModel.labelArray = @[@"户外",@"娱乐",@"电影"];
    headerModel.canEdit = _isManage;
    headerModel.viewClass = @"YZHTeamCardHeaderView";
    headerModel.teamId = _teamId;
    
    YZHTeamDetailModel* sharedQRCodeModel = [[YZHTeamDetailModel alloc] init];
    sharedQRCodeModel.title = @"群分享";
    sharedQRCodeModel.imageName = @"my_informationCell_QRCode";
    sharedQRCodeModel.cellClass = @"YZHTeamCardImageCell";
    sharedQRCodeModel.router = kYZHRouterCommunityCardQRCodeShared;
    sharedQRCodeModel.routetInfo = @{
                                     @"teamId": self.teamId ? self.teamId : NULL
                                     };
    
    YZHTeamDetailModel* memberModel = [[YZHTeamDetailModel alloc] init];
    memberModel.title = @"群成员";
    memberModel.subtitle = [NSString stringWithFormat:@"%ld",team.memberNumber];
    memberModel.cellClass = @"YZHTeamCardTextCell";
    
    YZHTeamDetailModel* chatContentModel = [[YZHTeamDetailModel alloc] init];
    chatContentModel.title = @"群聊内容";
    chatContentModel.subtitle = @"图片、名片链接等聊天记录";
    chatContentModel.cellClass = @"YZHTeamCardTextCell";
    chatContentModel.router = kYZHRouterSessionChatContent;
    //TODO: 空白展示页.
    chatContentModel.routetInfo = @{
                                    @"targetId": self.teamId,
                                    };
    // 群主设置
    YZHTeamDetailModel* publicModel = [[YZHTeamDetailModel alloc] init];
    self.publicModel = publicModel;
    publicModel.title = @"是否公开本群";
    publicModel.isOpenStatus = team.joinMode; //0 为公开, 1 2 都是私密
    publicModel.subtitle = team.joinMode ? @"私密" : @"公开";
    publicModel.cellClass = @"YZHTeamCardSwitchCell";
    
    YZHTeamDetailModel* memberInviteFriendModel = [[YZHTeamDetailModel alloc] init];
    self.memberInviteFriendModel = memberInviteFriendModel;
    memberInviteFriendModel.title = @"允许群成员添加好友进群";
    memberInviteFriendModel.isOpenStatus = team.inviteMode; //0 为群主管理员可邀请, 1 所有好友都可以邀请
    memberInviteFriendModel.subtitle = team.inviteMode ? @"允许" : @"不允许";
    memberInviteFriendModel.cellClass = @"YZHTeamCardSwitchCell";
    
    YZHTeamDetailModel* sharedModel = [[YZHTeamDetailModel alloc] init];
    self.sharedModel = sharedModel;
    sharedModel.title = @"是否可互享";
    sharedModel.isOpenStatus = teamExtManage.isShareTeam;
    sharedModel.subtitle = teamExtManage.isShareTeam ? @"互享": @"不可互享";
    sharedModel.cellClass = @"YZHTeamCardSwitchCell";
    
    YZHTeamDetailModel* findSharedModel = [[YZHTeamDetailModel alloc] init];
    findSharedModel.title = @"寻找互享群";
    findSharedModel.cellClass = @"YZHTeamCardTextCell";
    
    YZHTeamDetailModel* letSharedQRCodeModel = [[YZHTeamDetailModel alloc] init];
    self.letSharedQRCodeModel = letSharedQRCodeModel;
    letSharedQRCodeModel.title = @"允许向群里分享其他群名片";
    letSharedQRCodeModel.isOpenStatus = teamExtManage.isShareTeam;
    letSharedQRCodeModel.subtitle = teamExtManage.isShareTeam ? @"允许": @"不允许";
    letSharedQRCodeModel.cellClass = @"YZHTeamCardSwitchCell";
    
    YZHTeamDetailModel* noticeModel = [[YZHTeamDetailModel alloc] init];
    noticeModel.title = @"群公告";
    noticeModel.cellClass = @"YZHTeamCardTextCell";
    noticeModel.router = kYZHRouterCommunityCardTeamNotice;
    noticeModel.routetInfo = @{
                               @"isManage": @(self.isManage),
                               @"teamId": self.teamId
                               };
//    noticeModel.isOpenStatus = teamExtManage.isShareTeam;
    //群功能
    YZHTeamDetailModel* nickNameModel = [[YZHTeamDetailModel alloc] init];
    nickNameModel.title = @"群内昵称设置";
    nickNameModel.subtitle = member.nickname;
    nickNameModel.cellClass = @"YZHTeamCardTextCell";
    nickNameModel.router = kYZHRouterMyInformationSetName;
    nickNameModel.routetInfo = @{
                                     @"teamId": self.teamId ? self.teamId : NULL,
                                     kYZHRouteSegue: kYZHRouteSegueModal,
                                     kYZHRouteSegueNewNavigation: @(YES)
                                     };
    
    YZHTeamDetailModel* informModel = [[YZHTeamDetailModel alloc] init];
    self.informModel = informModel;
    informModel.title = @"群消息免打扰";
    informModel.isOpenStatus = YES;
    informModel.cellClass = @"YZHTeamCardSwitchCell";

    YZHTeamDetailModel* topModel = [[YZHTeamDetailModel alloc] init];
    self.topModel = topModel;
    topModel.title = @"群置顶";
    topModel.isOpenStatus = YES;
    topModel.cellClass = @"YZHTeamCardSwitchCell";
    
    YZHTeamDetailModel* addFriendModel = [[YZHTeamDetailModel alloc] init];
    self.addFriendModel = addFriendModel;
    addFriendModel.title = @"允许群成员加好友";
    addFriendModel.isOpenStatus = YES;
    addFriendModel.cellClass = @"YZHTeamCardSwitchCell";
    
    YZHTeamDetailModel* allowChatModel = [[YZHTeamDetailModel alloc] init];
    self.allowChatModel = allowChatModel;
    allowChatModel.title = @"允许群成员和我私聊";
    allowChatModel.isOpenStatus = YES;
    allowChatModel.cellClass = @"YZHTeamCardSwitchCell";
    
    YZHTeamDetailModel* lockModel = [[YZHTeamDetailModel alloc] init];
    self.lockModel = lockModel;
    lockModel.title = @"群上锁";
    lockModel.titleTip = @"（需要阅读密码才能查看）";
    lockModel.isOpenStatus = YES;
    lockModel.subtitle = lockModel.isOpenStatus ? @"上锁" : @"不上锁";
    lockModel.cellClass = @"YZHTeamCardSwitchCell";
    
    // 其他
    YZHTeamDetailModel* chatDataModel = [[YZHTeamDetailModel alloc] init];
    chatDataModel.title = @"清空聊天记录";
    chatDataModel.cellClass = @"YZHTeamCardTextCell";
    
    NSMutableArray* listArray = [[NSMutableArray alloc] init];
    NSMutableArray* teamShowArray = [[NSMutableArray alloc] init];
    NSMutableArray* managePublickArray = [[NSMutableArray alloc] init];
    NSMutableArray* manageSharedArray = [[NSMutableArray alloc] init];
    NSMutableArray* manageSharedQRCodeArray = [[NSMutableArray alloc] init];
    NSMutableArray* teamFunctionArray = [[NSMutableArray alloc] init];
    NSMutableArray* teamMoreArray = [[NSMutableArray alloc] init];
    if (_isManage) {
        // 拼装分区0 数据
        [teamShowArray addObject:sharedQRCodeModel];
        [teamShowArray addObject:memberModel];
        [teamShowArray addObject:chatContentModel];
        // 拼接群主设置数据
        [managePublickArray addObject:publicModel];
        // 非公开时,需要展示邀请模式
        if (!publicModel.isOpenStatus) {
            [managePublickArray addObject:memberInviteFriendModel];
        }
        [manageSharedArray addObject: sharedModel];
        if (sharedModel.isOpenStatus) {
            [manageSharedArray addObject:findSharedModel];
        }
        [manageSharedQRCodeArray addObject:letSharedQRCodeModel];
        [manageSharedQRCodeArray addObject:noticeModel];
        // 拼装群功能
        [teamFunctionArray addObject:nickNameModel];
        [teamFunctionArray addObject:informModel];
        [teamFunctionArray addObject:topModel];
        [teamFunctionArray addObject:addFriendModel];
        [teamFunctionArray addObject:allowChatModel];
        [teamFunctionArray addObject:lockModel];
        // 拼装其他功能
        [teamMoreArray addObject:chatDataModel];
    } else {
        
    }
    
    [listArray addObject:teamShowArray];
    [listArray addObject:managePublickArray];
    [listArray addObject:manageSharedArray];
    [listArray addObject:manageSharedQRCodeArray];
    [listArray addObject:teamFunctionArray];
    [listArray addObject:teamMoreArray];
    
    self.modelList = listArray;
    self.headerModel = headerModel;
}

- (void)updata {
    
}

- (NSDictionary *)teamInfos {
    
    //TODO:
    NSString* teamClientExt = @"";
    NSDictionary *teamInfos = @{
                                @(NIMTeamUpdateTagJoinMode) : @(self.publicModel.isOpenStatus),
                                @(NIMTeamUpdateTagClientCustom) : @"",
                                @(NIMTeamUpdateTagUpdateClientCustomMode): @""
                                };
    return teamInfos;
}

@end
