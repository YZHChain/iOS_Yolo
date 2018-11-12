//
//  YZHAddFirendSearchModel.m
//  YZHYolo
//
//  Created by Jersey on 2018/11/12.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHAddFirendSearchModel.h"



@implementation YZHAddFirendSearchModel

+ (NSDictionary *)YZH_replacedKeyFromPropertyName {
    
    return @{
             @"yoloId": @"yoloNo",
             @"phoneNumber": @"mobile",
             @"userId": @"accid",
             };
}

- (NSString *)addText {
    
    if (!_addText) {
        _addText = @"添加";
    }
    return _addText;
}

- (void)configurationUserData {
    
    self.userModel = [[YZHAddressBookModel alloc] initWithUser:self.user];
    // 判断是否为好友
    if ([[[NIMSDK sharedSDK] userManager] isMyFriend:self.userId]) {
        self.isMyFriend = YES;
    } else {
        self.isMyFriend = NO;
        //判断当前用户是否允许添加.
        YZHUserInfoExtManage* userInfoExt = [YZHUserInfoExtManage targetUserInfoExtWithUserId:self.userId];
        _userInfoExt = userInfoExt;
        self.allowAdd = userInfoExt.privateSetting.allowAdd;
    }
}



@end
