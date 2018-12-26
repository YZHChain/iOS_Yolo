//
//  YZHAddFirendRecordManage.m
//  YZHYolo
//
//  Created by Jersey on 2018/11/13.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHAddFirendRecordManage.h"

//#import "NIMSystemNotification.h"
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
    //此条消息被处理过, 并且
    NIMUserAddAttachment* attachment = self.addFriendNotification.attachment;
    //未操作过的,并且属于通过验证的消息.则可以肯定这条消息是对方同意我发过去的消息。
    //也可以直接把操作过这个状态直接去掉,因为一般回复的时候才会有 NIMUserOperationVerify 的情况,收到消息时一般是 0 1. 2则都是收到自己发出的回复。
    if (self.addFriendNotification.handleStatus == YZHNotificationHandleTypePending && attachment.operationType == NIMUserOperationVerify) {
        return YES;
    } else {
        return NO;
    }
}

@end

static const NSInteger MaxNotificationCount = 100;
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
    NSMutableArray<YZHAddFriendRecordModel*>* addFirendModels;
    for (NIMSystemNotification* notification in addFriendNotifications) {
        YZHAddFriendRecordModel* model = [[YZHAddFriendRecordModel alloc] init];
        model.addFriendNotification = notification;
        NSDate* timeDate = [NSDate dateWithTimeIntervalSince1970:notification.timestamp];
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM"];
        NSDateComponents *components = [dateFormatter.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:timeDate];
        NSDate* currentDate = [NSDate date];
        NSDateComponents *currentComponents = [dateFormatter.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentDate];
        NSInteger currentbillYear = [currentComponents year];
        NSInteger currentbillMonth = [currentComponents month];
        
        NSInteger billYear = [components year];
        NSInteger billMonth = [components month];
        
        NSString* yearAndMonth = [NSString stringWithFormat:@"%ld/%ld", billYear, billMonth];
        if (currentbillYear == billYear && currentbillMonth == billMonth) {
            if (!self.timerArray.count) {
                self.timerArray = @[@"最近一个月"].mutableCopy;
                 addFirendModels = [[NSMutableArray alloc] init];
                //TODO: 遍历将其月份分隔开。
                self.addFirendListModel = [[NSMutableArray alloc] init];
                [self.addFirendListModel addObject:addFirendModels];
            }
        } else {
            if (![self.timerArray containsObject:yearAndMonth]) {
                if (!self.timerArray.count) {
                    self.timerArray = [[NSMutableArray alloc] init];
                    self.addFirendListModel = [[NSMutableArray alloc] init];
                }
                [self.timerArray addObject:yearAndMonth];
                addFirendModels = [[NSMutableArray alloc] init];
                [self.addFirendListModel addObject:addFirendModels];
            }
        }
        [addFirendModels addObject:model];
    }
}

- (void)removeAddFirendMessage:(NSIndexPath*)indexPath {
    
    if (self.addFirendListModel.count > indexPath.section && self.addFirendListModel[indexPath.section].count > indexPath.row) {
        [self.systemNotificationManager deleteNotification:self.addFirendListModel[indexPath.section] [indexPath.row].addFriendNotification];
        [self.addFirendListModel[indexPath.section] removeObjectAtIndex:indexPath.row];
    }
}

@end
