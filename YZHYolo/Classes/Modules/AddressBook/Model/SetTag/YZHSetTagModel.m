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
        [self configurationTeamTagModel];
    }
    return self;
}

- (void)configurationUserTagModel {
    
    self.userTagModel = [[NSMutableArray alloc] init];
    
    YZHUserInfoExtManage* userInfoExt = [YZHUserInfoExtManage currentUserInfoExt];
    
    NSMutableArray* defaultTagArray = [[NSMutableArray alloc] init];
    NSMutableArray* customTagArray = [[NSMutableArray alloc] init];
    [userInfoExt.customTags enumerateObjectsUsingBlock:^(YZHUserCustomTagModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.isDefault) {
            [defaultTagArray addObject:obj];
        } else {
            [customTagArray addObject:obj];
        }
    }];
    [self.userTagModel addObjectsFromArray:defaultTagArray];
    if (customTagArray) {
        self.userTagModel = [[NSMutableArray alloc] initWithObjects: defaultTagArray, customTagArray, nil];
    } else {
        self.userTagModel = [[NSMutableArray alloc] initWithObjects: defaultTagArray, nil];
    }
}

- (void)configurationTeamTagModel {
    
    self.userTeamTagModel = [[NSMutableArray alloc] init];
    
    YZHUserInfoExtManage* userInfoExt = [YZHUserInfoExtManage currentUserInfoExt];
    
    NSMutableArray* defaultTagArray = [[NSMutableArray alloc] init];
    NSMutableArray* customTagArray = [[NSMutableArray alloc] init];
    [userInfoExt.groupTags enumerateObjectsUsingBlock:^(YZHUserGroupTagModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.isDefault) {
            [defaultTagArray addObject:obj];
        } else {
            [customTagArray addObject:obj];
        }
    }];
    [self.userTeamTagModel addObjectsFromArray:defaultTagArray];
    if (customTagArray) {
        self.userTeamTagModel = [[NSMutableArray alloc] initWithObjects: defaultTagArray, customTagArray, nil];
    } else {
        self.userTeamTagModel = [[NSMutableArray alloc] initWithObjects: defaultTagArray, nil];
    }
    
}

#pragma mark --

- (NSIndexPath *)findtargetUserTagName:(NSString *)tagName type:(YZHSetTagModelType)type{
    
    __block NSIndexPath* indexPath = nil;
    YZHUserInfoExtManage* userInfoExt = [YZHUserInfoExtManage currentUserInfoExt];
    NSArray *customTags;
    NSInteger defaultTags;
    if (type == YZHSetTagModelTypeUser) {
        customTags = userInfoExt.customTags;
        defaultTags = self.userTagModel.firstObject.count;
    } else {
        customTags = userInfoExt.groupTags;
        defaultTags = self.userTeamTagModel.firstObject.count;
    }
    if (YZHIsString(tagName)) {
        if (YZHIsArray(customTags)) {
            [customTags enumerateObjectsUsingBlock:^(YZHUserCustomTagModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.isDefault) {
                    if ([obj.tagName isEqualToString:tagName]) {
                        indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
                        *stop = YES;
                    }
                } else {
                    if ([obj.tagName isEqualToString:tagName]) {
                        indexPath = [NSIndexPath indexPathForRow:idx - defaultTags inSection:1];
                        *stop = YES;
                    }
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

-(NSInteger)tagNumberOfRowsInSection:(NSInteger)section type:(YZHSetTagModelType)type {
    
    if (type == YZHSetTagModelTypeUser) {
        if (self.userTagModel.count > section) {
            return self.userTagModel[section].count;
        } else {
            return 0;
        }
    } else {
        if (self.userTeamTagModel.count > section) {
            return self.userTeamTagModel[section].count;
        } else {
            return 0;
        }
    }

}

#pragma mark -- Add & remove

- (void)addUserCustomTag:(NSString *)tagName type:(YZHSetTagModelType)type WithsuccessCompletion:(YZHVoidBlock)successCompletion failureCompletion:(YZHErrorBlock)failureCompletion {
    
    YZHUserInfoExtManage* userInfoExt = [YZHUserInfoExtManage currentUserInfoExt];
    //创建自定义标签
    YZHUserCustomTagModel* tagsModel = [[YZHUserCustomTagModel alloc] init];
    tagsModel.tagName = tagName;
    tagsModel.isDefault = NO;
    if (type == YZHSetTagModelTypeUser) {
        NSMutableArray* tempCustomTags = userInfoExt.customTags.mutableCopy;
        [tempCustomTags addObject:tagsModel];
        userInfoExt.customTags = tempCustomTags.copy;
    } else {
        NSMutableArray* tempCustomTags = userInfoExt.groupTags.mutableCopy;
        [tempCustomTags addObject:tagsModel];
        userInfoExt.groupTags = tempCustomTags.copy;
    }
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

- (void)removeUserCustomTagIndex:(NSInteger)index type:(YZHSetTagModelType)type WithsuccessCompletion:(nonnull YZHVoidBlock)successCompletion failureCompletion:(nonnull YZHErrorBlock)failureCompletion {
    
    YZHUserInfoExtManage* userInfoExt = [YZHUserInfoExtManage currentUserInfoExt];
    
    NSMutableArray* tempCustomTags;
    if (type == YZHSetTagModelTypeUser) {
        tempCustomTags = [[NSMutableArray alloc] initWithArray:userInfoExt.customTags.copy];
        if (self.userTagModel.lastObject.count > index) {
            [self.userTagModel.lastObject removeObjectAtIndex:index];
            if (tempCustomTags.count > index + self.userTagModel.firstObject.count) {
                [tempCustomTags removeObjectAtIndex:index + self.userTagModel.firstObject.count];
            }
        } else {
            return;
        }
        userInfoExt.customTags = tempCustomTags.copy;
    } else {
        tempCustomTags = [[NSMutableArray alloc] initWithArray:userInfoExt.groupTags.copy];
        if (self.userTeamTagModel.lastObject.count > index) {
            [self.userTeamTagModel.lastObject removeObjectAtIndex:index];
            if (tempCustomTags.count > index + self.userTeamTagModel.firstObject.count) {
                [tempCustomTags removeObjectAtIndex:index + self.userTeamTagModel.firstObject.count];
            }
        } else {
            return;
        }
        userInfoExt.groupTags = tempCustomTags.copy;
    }

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

- (BOOL)checkoutContainCustomTagName:(NSString *)tagName type:(YZHSetTagModelType)type{
    
    __block BOOL isContain = NO;
    YZHUserInfoExtManage* userInfoExt = [YZHUserInfoExtManage currentUserInfoExt];
    
    if (type == YZHSetTagModelTypeUser) {
        if (YZHIsArray(userInfoExt.customTags)) {
            [userInfoExt.customTags enumerateObjectsUsingBlock:^(YZHUserCustomTagModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.tagName isEqualToString:tagName]) {
                    isContain = YES;
                    *stop = YES;
                }
            }];
        }
    } else {
        if (YZHIsArray(userInfoExt.groupTags)) {
            [userInfoExt.groupTags enumerateObjectsUsingBlock:^(YZHUserGroupTagModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.tagName isEqualToString:tagName]) {
                    isContain = YES;
                    *stop = YES;
                }
            }];
        }
    }
    return isContain;
}

- (void)updateTargetUserTag {
    
    //重新配置.
    [self configurationUserTagModel];
}

- (void)updateTargetTeamTag {
    
    //重新配置.
    [self configurationTeamTagModel];
}


@end
