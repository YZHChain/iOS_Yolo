//
//  YZHTeamCardModel.h
//  YZHYolo
//
//  Created by Jersey on 2018/11/19.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface YZHTeamHeaderModel : NSObject

@property (nonatomic, copy) NSString* avatarImageName;
@property (nonatomic, copy) NSString* teamName;
@property (nonatomic, copy) NSString* teamSynopsis;
@property (nonatomic, strong) NSArray* labelArray;
@property (nonatomic, copy) NSString* viewClass;
@property (nonatomic, assign) BOOL canEdit;
@property (nonatomic, copy) NSString* teamId;

@end

@interface YZHTeamDetailModel : NSObject

@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSString* subtitle;
@property (nonatomic, copy) NSString* imageName;
@property (nonatomic, copy) NSString* cellClass;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) BOOL isOpenStatus;
@property (nonatomic, assign) BOOL notInteraction; // 默认是可交互.如果是Yes 则需要把图像删除.
@property (nonatomic, copy) NSString* titleTip;
@property (nonatomic, copy) NSString* router;
@property (nonatomic, copy) NSDictionary* routetInfo;

@end

@interface YZHTeamCardModel : NSObject

@property (nonatomic, strong) YZHTeamHeaderModel* headerModel;
@property (nonatomic, strong) NSMutableArray<NSMutableArray <YZHTeamDetailModel *> *>* modelList;
@property (nonatomic, copy) NSString* teamId;
@property (nonatomic, assign) BOOL muteStatus;
@property (nonatomic, assign) BOOL isManage;
@property (nonatomic, strong) NIMTeam* teamData;
@property (nonatomic, strong) YZHTeamDetailModel* publicModel; // 公开私密
@property (nonatomic, strong) YZHTeamDetailModel* memberInviteFriendModel; // 允许邀请好友加入群
@property (nonatomic, strong) YZHTeamDetailModel* sharedModel;  // 共享群
@property (nonatomic, strong) YZHTeamDetailModel* letSharedQRCodeModel; // 允许发送群名片
@property (nonatomic, strong) YZHTeamDetailModel* letMemberAddChatModel; // 允许群成员相互私聊与添加好友
@property (nonatomic, strong) YZHTeamDetailModel* informModel; // 免打扰设置
@property (nonatomic, strong) YZHTeamDetailModel* topModel;  // 群置顶
@property (nonatomic, strong) YZHTeamDetailModel* letMemberLookDetails; // 允许其他群成员查看个人信息.
@property (nonatomic, strong) YZHTeamDetailModel* transferTeamModel; // 转让群

@property (nonatomic, strong) YZHTeamDetailModel* lockModel; //
@property (nonatomic, copy) NSDictionary* teamInfos; // 修改的群信息.如果是群主则包含群名片
@property (nonatomic, copy) NSString* teamExts; // 修改个人对群自定义信息
@property (nonatomic, assign) BOOL updateSucceed;

- (instancetype)initWithTeamId:(NSString *)teamId isManage:(BOOL)ismanage;

- (void)updata;

@end

NS_ASSUME_NONNULL_END
