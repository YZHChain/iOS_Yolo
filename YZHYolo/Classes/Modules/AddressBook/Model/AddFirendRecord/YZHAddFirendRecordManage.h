//
//  YZHAddFirendRecordManage.h
//  YZHYolo
//
//  Created by Jersey on 2018/11/13.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NIMSystemNotificationManagerProtocol.h"
#import "YZHContactMemberModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface YZHAddFriendRecordModel : NSObject

@property (nonatomic, strong) YZHContactMemberModel* member;

@property (nonatomic, strong) NIMSystemNotification* addFriendNotification;
@property (nonatomic, assign) BOOL isMyFriend;
@property (nonatomic, assign) BOOL isMySend;

@property (nonatomic, copy) NSString* targetUserId;
@property (nonatomic, copy) NSString* myUserId;

@end

@interface YZHAddFirendRecordManage : NSObject

@property (nonatomic, strong) NSMutableArray* timerArray;
@property (nonatomic, strong) NSMutableArray<NSMutableArray<YZHAddFriendRecordModel*>* >* addFirendListModel;
@property (nonatomic, strong) id<NIMSystemNotificationManager> systemNotificationManager;

- (void)removeAddFirendMessage:(NSIndexPath* )indexPath;

@end

NS_ASSUME_NONNULL_END
