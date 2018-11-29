//
//  YZHTeamNoticeModel.h
//  YZHYolo
//
//  Created by Jersey on 2018/11/21.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YZHTeamNoticeModel : NSObject

@property (nonatomic, copy) NSString* sendTime;
@property (nonatomic, copy) NSString* announcement;
@property (nonatomic, copy) NSString* endTime;
@property (nonatomic, copy) NSString* groupId;
@property (nonatomic, copy) NSString* createNoticeId;
@property (nonatomic, copy) NSString* noticeId;

@end

@interface YZHTeamNoticeList : NSObject

@property (nonatomic, strong) NSMutableArray<YZHTeamNoticeModel *>* noticeArray;
@property (nonatomic, assign) NSInteger total;
@property (nonatomic, assign) NSInteger totalPages;

@end

NS_ASSUME_NONNULL_END
