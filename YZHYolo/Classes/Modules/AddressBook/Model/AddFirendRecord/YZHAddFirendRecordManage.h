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

typedef NS_ENUM(NSInteger, YZHNotificationHandleType) {
    YZHNotificationHandleTypePending = 0,
    YZHNotificationHandleTypeOk,
    YZHNotificationHandleTypeNo,
    YZHNotificationHandleTypeOutOfDate
};

@interface YZHAddFriendRecordModel : NSObject

@property (nonatomic, strong) YZHContactMemberModel* member;

@property (nonatomic, strong) NIMSystemNotification* addFriendNotification;
@property (nonatomic, assign) BOOL isMyFriend;
@property (nonatomic, assign) BOOL isMySend; // 这里的发送所指的是, 当前用户所有消息中, 那一条消息是对方请求添加我的则是 对方发给我.  isMySend = NO. 另一种情况则是我向对方发送一条好友申请的消息,然后对方处理了此条消息,这种类型消息称为我发出的。 isMySend = YES

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
