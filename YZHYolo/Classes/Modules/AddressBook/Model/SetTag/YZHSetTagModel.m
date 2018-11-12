//
//  YZHSetTagModel.m
//  YZHYolo
//
//  Created by Jersey on 2018/11/11.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHSetTagModel.h"

static id instance = nil;
@implementation YZHSetTagModel

+ (instancetype)sharedSetTagModel {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[YZHSetTagModel alloc] init];
    });
    return instance;
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        [self configurationUserTagModel];
    }
    return self;
}

- (void)configurationUserTagModel {
    
    self.userTagModel = [[NSMutableArray alloc] init];
    
    YZHUserInfoExtManage* userInfoExt = [YZHUserInfoExtManage currentUserInfoExt];
    
    NSArray* defaultTagArray = userInfoExt.groupTags;
    NSMutableArray* customTagArray = userInfoExt.customTags.mutableCopy;
    
    self.userTagModel = [[NSMutableArray alloc] initWithObjects:defaultTagArray, customTagArray, nil];
}

#pragma mark --

- (NSIndexPath *)findtargetUserTagName:(NSString *)tagName {
    
    __block NSIndexPath* indexPath = nil;
    if (YZHIsString(tagName)) {
        
        YZHUserInfoExtManage* userInfoExt = [YZHUserInfoExtManage currentUserInfoExt];
        if (YZHIsArray(userInfoExt.groupTags)) {
            [userInfoExt.groupTags enumerateObjectsUsingBlock:^(YZHUserGroupTagModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.tagName isEqualToString:tagName]) {
                    indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
                    *stop = YES;
                }
            }];
        }
        if (YZHIsArray(userInfoExt.customTags)) {
            [userInfoExt.customTags enumerateObjectsUsingBlock:^(YZHUserCustomTagModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.tagName isEqualToString:tagName]) {
                    indexPath = [NSIndexPath indexPathForRow:idx inSection:1];
                    *stop = YES;
                }
            }];
        }
    }
    if (indexPath) {
        return indexPath;
    } else {
        return nil;
    }
}

-(NSInteger)tagNumberOfRowsInSection:(NSInteger)section {
    
    if (self.userTagModel.count > section) {
        return self.userTagModel[section].count;
    } else {
        return 0;
    }
    
}

#pragma mark -- Add & remove

- (void)addUserCustomTag:(NSString *)tagName WithsuccessCompletion:(YZHVoidBlock)successCompletion failureCompletion:(YZHErrorBlock)failureCompletion {
    
    YZHUserInfoExtManage* userInfoExt = [YZHUserInfoExtManage currentUserInfoExt];
    //创建自定义标签
    YZHUserCustomTagModel* tagsModel = [[YZHUserCustomTagModel alloc] init];
    tagsModel.tagName = tagName;
    tagsModel.isDefault = NO;
    NSMutableArray* tempCustomTags;
    if (YZHIsArray(userInfoExt.customTags)) {
        tempCustomTags = [[NSMutableArray alloc] initWithArray:userInfoExt.customTags.copy];
    } else {
        tempCustomTags = [[NSMutableArray alloc] init];
    }

    [tempCustomTags addObject:tagsModel];
    
    userInfoExt.customTags = tempCustomTags.copy;
    NSString* userInfoExtString = [userInfoExt userInfoExtString];
    if (YZHIsString(userInfoExtString)) {
        //可继续封装一层.
        [[[NIMSDK sharedSDK] userManager] updateMyUserInfo:@{
                                                             
                                                             @(NIMUserInfoUpdateTagExt) : userInfoExtString                            } completion:^(NSError * _Nullable error) {
                                                                 
                                                                 if (!error) {
                                                                     
                                                                     successCompletion();                          } else {
                                                                         failureCompletion(error);
                                                                     }
                                                             }];
    } else {
        //TODO:由于 UserExt 为空导致,后台问题。
        successCompletion();
    }

}

- (void)removeUserCustomTagIndex:(NSInteger)index WithsuccessCompletion:(YZHVoidBlock)successCompletion failureCompletion:(YZHErrorBlock)failureCompletion {
    
    YZHUserInfoExtManage* userInfoExt = [YZHUserInfoExtManage currentUserInfoExt];
    
    NSMutableArray* tempCustomTags = [[NSMutableArray alloc] initWithArray:userInfoExt.customTags.copy];
    if (tempCustomTags.count > index) {
        [tempCustomTags removeObjectAtIndex:index];
    } else {
//        failureCompletion()
        return;
    }
    
    userInfoExt.customTags = tempCustomTags.copy;
    NSString* userInfoExtString = [userInfoExt userInfoExtString];
    //可继续封装一层
    [[[NIMSDK sharedSDK] userManager] updateMyUserInfo:@{
                                                         
                                                         @(NIMUserInfoUpdateTagExt) : userInfoExtString                            } completion:^(NSError * _Nullable error) {
                                                             
                                                             if (!error) {
                                                                 
                                                                 successCompletion();                          } else {
                                                                     failureCompletion(error);
                                                                 }
                                                         }];

    
}

- (BOOL)checkoutContainCustomTagName:(NSString *)tagName {
    
    __block BOOL isContain = NO;
    YZHUserInfoExtManage* userInfoExt = [YZHUserInfoExtManage currentUserInfoExt];
    
    if (YZHIsArray(userInfoExt.groupTags)) {
        [userInfoExt.groupTags enumerateObjectsUsingBlock:^(YZHUserGroupTagModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.tagName isEqualToString:tagName]) {
                isContain = YES;
                *stop = YES;
            }
        }];
    }
    if (YZHIsArray(userInfoExt.customTags)) {
        [userInfoExt.customTags enumerateObjectsUsingBlock:^(YZHUserCustomTagModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.tagName isEqualToString:tagName]) {
                isContain = YES;
                *stop = YES;
            }
        }];
    }
    
    return isContain;
}

- (void)updateTargetUserTag {
    
    //重新配置.
    [self configurationUserTagModel];
}


@end
