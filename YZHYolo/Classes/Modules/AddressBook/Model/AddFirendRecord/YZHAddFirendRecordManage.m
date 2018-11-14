//
//  YZHAddFirendRecordManage.m
//  YZHYolo
//
//  Created by Jersey on 2018/11/13.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHAddFirendRecordManage.h"

#import "NIMSystemNotification.h"
#import "NIMKitInfoFetchOption.h"

@implementation YZHAddFriendRecordModel

- (YZHContactMemberModel *)member {
    
    if (!_member) {
        NIMKitInfoFetchOption* infoFetchOption = [[NIMKitInfoFetchOption alloc] initWithIsAddressBook:YES];
        NIMKitInfo* kitInfo = [[NIMKit sharedKit] infoByUser:self.targetUserId option:infoFetchOption];
        _member = [[YZHContactMemberModel alloc] initWithInfo:kitInfo];
    }
    return _member;
}

- (NSString *)targetUserId {
    
    if (!_targetUserId) {
        //先判断这条消息是我收到对方的请求回执的,还是自己发出去的.
        //直接通过是否是自己,来判断即可.
        if ([self.addFriendNotification.targetID isEqualToString:self.myUserId]) {
            _targetUserId = self.addFriendNotification.sourceID;
        } else {
            _targetUserId = self.addFriendNotification.targetID;
        }
        
    }
    return _targetUserId;
}

- (BOOL)isMyFriend {
    
    return [[[NIMSDK sharedSDK] userManager] isMyFriend:self.targetUserId];
}

- (NSString *)myUserId {
    
    if (!_myUserId) {
        _myUserId = [[[NIMSDK sharedSDK] loginManager] currentAccount];
    }
    return _myUserId;
}

- (BOOL )isMySend {
    
    if ([self.myUserId isEqualToString:self.addFriendNotification.sourceID]) {
        return YES;
    } else {
        return NO;
    }
}

@end

static const NSInteger MaxNotificationCount = 50;
@implementation YZHAddFirendRecordManage

- (instancetype)init {
    
    self = [super init];
    if (self) {
        [self configurationRecordMessage];
    }
    return self;
}

- (void)configurationRecordMessage {
    
    id<NIMSystemNotificationManager> systemNotificationManager = [[NIMSDK sharedSDK] systemNotificationManager];
    NIMSystemNotificationFilter* fileter = [[NIMSystemNotificationFilter alloc] init];
    fileter.notificationTypes = @[[NSNumber numberWithInteger:NIMSystemNotificationTypeFriendAdd]];
    NSArray<id>* addFriendNotifications = [systemNotificationManager fetchSystemNotifications:nil limit:MaxNotificationCount filter:fileter];
    NSMutableArray<YZHAddFriendRecordModel*>* addFirendModels = [[NSMutableArray alloc] init];
    for (NIMSystemNotification* notification in addFriendNotifications) {
        YZHAddFriendRecordModel* model = [[YZHAddFriendRecordModel alloc] init];
        model.addFriendNotification = notification;
        [addFirendModels addObject:model];
    }
    
    // 遍历将其月份分隔开。
    self.addFirendListModel = [[NSMutableArray alloc] init];
    [self.addFirendListModel addObject:addFirendModels.mutableCopy];
    
    self.timerArray = @[@"最近一个月"].mutableCopy;
}

- (void)removeAddFirendMessage:(NSIndexPath*)indexPath {
    
    if (self.addFirendListModel.count > indexPath.section && self.addFirendListModel[indexPath.section].count > indexPath.row) {
        [self.systemNotificationManager deleteNotification:self.addFirendListModel[indexPath.section] [indexPath.row].addFriendNotification];
        [self.addFirendListModel[indexPath.section] removeObjectAtIndex:indexPath.row];
    }
}

@end
