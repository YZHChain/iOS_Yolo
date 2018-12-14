//
//  YZHSearchModel.h
//  YZHYolo
//
//  Created by Jersey on 2018/12/6.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YZHContactMemberModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface YZHSearchModel : NSObject

@property (nonatomic, strong) NSString* teamIcon;
@property (nonatomic, strong) NSString* teamName;
@property (nonatomic, copy) NSString* teamId;

@end

@interface YZHSearchRecruitModel : NSObject

@property (nonatomic, strong) NSString* teamIcon;
@property (nonatomic, strong) NSString* teamName;
@property (nonatomic, copy) NSString* teamId;
@property (nonatomic, strong) NSString* teamOwner;
@property (nonatomic, strong) NSString* recuitContent;

@end

@interface YZHSearchListModel : NSObject

@property (nonatomic, strong) NSMutableArray<YZHSearchRecruitModel *>* searchRecruitArray;
@property (nonatomic, strong) NSMutableArray<YZHSearchRecruitModel *>* recommendRecruitArray; // 推荐列表
@property (nonatomic, strong) NSMutableArray<YZHSearchModel *>* searchArray; // 后台接口搜索结果
@property (nonatomic, strong) NSMutableArray<YZHSearchModel *>* recommendArray; // 推荐列表
@property (nonatomic, strong) NSMutableArray<NIMRecentSession* >* searchRecentSession; //搜索本地回话列表
@property (nonatomic, strong) NSMutableArray<YZHContactMemberModel *>* searchFirends; //搜索到的好友.
@property (nonatomic, strong) NSMutableArray<NIMTeam* >* searchTeams; //搜索到的群组

@property (nonatomic, assign) int pageTotal; //总页数

- (void)searchPrivateKeyText:(NSString *)keyText; // 搜索私聊回话列表
- (void)searchFirendKeyText:(NSString *)keyText; // 搜索我的好友
- (void)searchTeamRecentSessionKeyText:(NSString *)keyText; // 搜索群聊最近回话列表
- (void)searchTeamKeyText:(NSString *)keyText;
- (void)searchTeamTag:(NSString *)tagName;  // 对最近会话搜索标签
- (void)searchFirendTag:(NSString *)tagName; // 搜索好友标签


@end

NS_ASSUME_NONNULL_END
