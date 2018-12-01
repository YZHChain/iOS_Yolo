//
//  YZHAddBookPhoneContactModel.m
//  YZHYolo
//
//  Created by Jersey on 2018/11/9.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHAddBookPhoneContactModel.h"

#import "YZHUserLoginManage.h"
#import "PPPersonModel.h"
#import "YZHUserModelManage.h"

static NSString* subTitleAllowAddText = @"添加";
static NSString* subTitleAlreadyAddText = @"已添加";
static NSString* subTitleAllowInviteText = @"邀请";
static NSString* subTitleAlreadyInviteText = @"已邀请";

@implementation YZHAddBookPhoneContactModel

- (NSDictionary *)configurationWithContact:(PPPersonModel* )contact orderLetter:(nonnull NSString *)orderLetter{

    if (contact) {
        self.name = contact.name;
        self.phone = contact.mobileArray.firstObject;
        self.orderLetter = orderLetter;
        NSDictionary* phoneDic = [self YZH_keyValues];
        return phoneDic;
    } else {
        return nil;
    }
}

- (NSString *)name {
    
    if (YZHIsString(self.accid)) {
//        拼接当前用户在云信的 NickName
//        NIMUserInfo *
//        NSString* iMNickName = [[[NIMSDK sharedSDK] userManager ] userInfo:self.accid].userInfo.nickName;
//        if (YZHIsString(iMNickName)) {
//
//        }
        
    } else {
        //只需要展示当前用户手机号备注的名字即可
    }
    return _name;
}

- (NSString *)subtitle {
    
    switch (self.status) {
        case 0:
            _subtitle = subTitleAllowAddText;
            break;
        case 1:
            _subtitle = subTitleAlreadyAddText;
            break;
        case 2:
            _subtitle = subTitleAllowInviteText;
            break;
        case 3:
            _subtitle = subTitleAlreadyInviteText;
            break;
        default:
            _subtitle = @"添加"; //默认.
            break;
    }
    return _subtitle;
}

- (NSString *)photoImageName {
    
    if (self.status == 0) {
        
    } else if (self.status == 1) {
        
    }
    //读取 IM 头像信息
    return nil;
}

- (BOOL)needVerfy {
    
    YZHUserInfoExtManage* userInfoExt = [YZHUserInfoExtManage targetUserInfoExtWithUserId:self.accid];
    return userInfoExt.privateSetting.addVerift;
}

@end

@implementation YZHPhoneContactRequestModel

- (void)updataPhoneContactDataWithNameKeys:(NSArray *)nameKeys addressBookDict:(NSDictionary<NSString *,NSArray *>*)addressBookDict {
    
    self.nameKeys = nameKeys;
    NSMutableArray* phoneContactArray = [[NSMutableArray alloc] init];
    for (NSString* nameKey in nameKeys) {
        NSArray* contactArray = [addressBookDict objectForKey:nameKey];
        for (NSInteger i = 0; i < contactArray.count; i++) {
            PPPersonModel* personModel = contactArray[i];
            NSDictionary* contactDic = nil;
            NSString* name = personModel.name;
            NSString* phone = personModel.mobileArray.firstObject;
            NSString* orderLetter = nameKey;
            if (YZHIsString(name) && YZHIsString(phone) && YZHIsString(orderLetter)) {
                contactDic = @{
                               @"name": name,
                               @"phone": phone,
                               @"orderLetter": orderLetter
                               };
            }
            if (YZHIsDictionary(contactDic)) {
                [phoneContactArray addObject:contactDic];
            }
        }
    }
    self.namePhones = phoneContactArray.copy;
    //UserId
    self.userId = [YZHUserLoginManage sharedManager].currentLoginData.userId;
    if (YZHIsString(_userId) && YZHIsArray(self.namePhones)) {
        self.params = @{
                             @"namePhones": self.namePhones,
                             @"userId": [NSNumber numberWithLong:self.userId.longLongValue]
                             };
    } else {
        self.params = nil;
    }
}

- (void)sortPhoneContacts:(NSArray *)contacts {
    
    NSMutableArray* phoneContactList = [[NSMutableArray alloc] init];
    NSMutableArray* sortedGroupTitles = [[NSMutableArray alloc] init];
    [contacts enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       YZHAddBookPhoneContactModel* model = [YZHAddBookPhoneContactModel YZH_objectWithKeyValues:obj];
       [self.nameKeys enumerateObjectsUsingBlock:^(NSString*  _Nonnull nameKey, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([nameKey isEqualToString:model.orderLetter]) {
                NSMutableArray *nameKeyContactArray;
                if (idx >= phoneContactList.count) {
                    nameKeyContactArray = [[NSMutableArray alloc] init];
                    [phoneContactList addObject:nameKeyContactArray];
                    [sortedGroupTitles addObject:nameKey];
                } else {
                    nameKeyContactArray = [phoneContactList objectAtIndex:idx];
                    [nameKeyContactArray addObject:model];
                }
                *stop = YES;
            }
        }];
    }];
    
    _phoneContactList = phoneContactList;
    _sortedGroupTitles = sortedGroupTitles;
}

@end

