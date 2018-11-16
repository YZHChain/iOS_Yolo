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
//

}

#pragma mark --

- (NSIndexPath *)findtargetUserTagName:(NSString *)tagName {
    
    __block NSIndexPath* indexPath = nil;
    if (YZHIsString(tagName)) {
        
        YZHUserInfoExtManage* userInfoExt = [YZHUserInfoExtManage currentUserInfoExt];
//        if (YZHIsArray(userInfoExt.groupTags)) {
//            [userInfoExt.groupTags enumerateObjectsUsingBlock:^(YZHUserGroupTagModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                if ([obj.tagName isEqualToString:tagName]) {
//                    indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
//                    *stop = YES;
//                }
//            }];
//        }
        if (YZHIsArray(userInfoExt.customTags)) {
            [userInfoExt.customTags enumerateObjectsUsingBlock:^(YZHUserCustomTagModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.isDefault) {
                    if ([obj.tagName isEqualToString:tagName]) {
                        indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
                        *stop = YES;
                    }
                } else {
                    if ([obj.tagName isEqualToString:tagName]) {
                        indexPath = [NSIndexPath indexPathForRow:idx - self.userTagModel.firstObject.count inSection:1];
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
    NSMutableArray* tempCustomTags = userInfoExt.customTags.mutableCopy;
    [tempCustomTags addObject:tagsModel];
//    __block BOOL isContainCustom;
//    __block NSInteger customIndex = 0;
//    [userInfoExt.customTags enumerateObjectsUsingBlock:^(YZHUserCustomTagModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if (obj.isDefault == NO) {
//            isContainCustom = YES;
//            [tempCustomTags addObject:obj];
//            customIndex = idx;
//        }
//    }];
//    [tempCustomTags addObject:tagsModel];
    
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
    
    if (self.userTagModel.lastObject.count > index) {
        [self.userTagModel.lastObject removeObjectAtIndex:index];
        if (tempCustomTags.count > index + self.userTagModel.firstObject.count) {
            [tempCustomTags removeObjectAtIndex:index + self.userTagModel.firstObject.count];
        }
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
    
//    if (YZHIsArray(userInfoExt.groupTags)) {
//        [userInfoExt.groupTags enumerateObjectsUsingBlock:^(YZHUserGroupTagModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            if ([obj.tagName isEqualToString:tagName]) {
//                isContain = YES;
//                *stop = YES;
//            }
//        }];
//    }
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
