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
@property (nonatomic, strong) YZHTeamDetailModel* publicModel;
@property (nonatomic, strong) YZHTeamDetailModel* memberInviteFriendModel;
@property (nonatomic, strong) YZHTeamDetailModel* sharedModel;
@property (nonatomic, strong) YZHTeamDetailModel* letSharedQRCodeModel;
@property (nonatomic, strong) YZHTeamDetailModel* informModel;
@property (nonatomic, strong) YZHTeamDetailModel* topModel;
@property (nonatomic, strong) YZHTeamDetailModel* addFriendModel;
@property (nonatomic, strong) YZHTeamDetailModel* allowChatModel;
@property (nonatomic, strong) YZHTeamDetailModel* lockModel;
@property (nonatomic, strong) NSDictionary* teamInfos;

- (instancetype)initWithTeamId:(NSString *)teamId isManage:(BOOL)ismanage;

- (void)updata;

@end

NS_ASSUME_NONNULL_END
