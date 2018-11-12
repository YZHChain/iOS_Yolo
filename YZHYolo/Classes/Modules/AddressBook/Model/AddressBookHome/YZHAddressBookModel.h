//
//  YZHAddressBookModel.h
//  YZHYolo
//
//  Created by Jersey on 2018/9/29.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NIMUserManagerProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface YZHAddressBookModel : NSObject

@property (nonatomic, copy) NSString* title; //表示备注名,也表示昵称,如果有备注名则默认展示备注名,在到昵称.
@property (nonatomic, copy) NSString* nickName; //昵称.如果无备注名时,其位置会在备注名的位置.有备注名时,显示在其后面 并且需要用此格式拼接: (nickName)
@property (nonatomic, copy) NSString* image;

@property (nonatomic, strong) NIMUserInfo* userInfo;
@property (nonatomic, strong) NIMUser* user;

- (instancetype)initWithUser:(NIMUser *)user;

@end

@interface YZHAddressBookContent : NSObject

@property (nonatomic, strong) NSMutableArray<YZHAddressBookModel* >* contactContent;

@end

@interface YZHAddressBookList : NSObject

@property (nonatomic, strong) NSMutableArray<YZHAddressBookContent* >* contactList;
@property (nonatomic, strong) NSArray<NIMUser *>* myFirends;

@end

NS_ASSUME_NONNULL_END
