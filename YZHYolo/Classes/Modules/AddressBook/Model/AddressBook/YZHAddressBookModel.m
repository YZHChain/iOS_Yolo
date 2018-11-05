//
//  YZHAddressBookModel.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/29.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHAddressBookModel.h"

@implementation YZHAddressBookModel

- (instancetype)initWithUser:(NIMUser *)user {
    
    self = [super init];
    if (self) {
        _user = user;
        _userInfo = user.userInfo;
    }
    return self;
}

- (NSString *)title {
    
    if (!_title) {
        //优先取备注名
        if (YZHIsString(_user.alias)) {
            _title = _user.alias;
        } else {
            _title = _userInfo.nickName;
        }
    }
    return _title;
}

- (NSString *)nickName {
    
    if (!_nickName) {
        if (YZHIsString(_user.alias)) {
            _nickName = _userInfo.nickName;
        } else {
            _nickName = nil;
        }
    }
    return _nickName;
}

@end

@implementation YZHAddressBookContent

@end

@implementation YZHAddressBookList

- (instancetype)init {
    
    self = [super init];
    if (self) {
       _myFirends = [[NIMSDK sharedSDK].userManager myFriends];
    }
    return self;
}
// 根据用户名首字母排序
- (void)sortWithUserName {
    
    _contactList = [[NSMutableArray alloc] init];
    for (NIMUser* user in _myFirends) {
        
    }
    
}


@end
