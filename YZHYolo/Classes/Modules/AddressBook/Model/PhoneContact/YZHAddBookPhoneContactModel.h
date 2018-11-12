//
//  YZHAddBookPhoneContactModel.h
//  YZHYolo
//
//  Created by Jersey on 2018/11/9.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PPPersonModel;
NS_ASSUME_NONNULL_BEGIN

@interface YZHAddBookPhoneContactModel : NSObject

@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* orderLetter;
@property (nonatomic, copy) NSString* phone;
@property (nonatomic, copy) NSString* accid;
@property (nonatomic, assign) NSInteger status; //当前账户状态: 0-可添加,1-已添加, 2-可邀请
@property (nonatomic, copy) NSString* subtitle;
@property (nonatomic, copy) NSString* photoImageName;

@end

@interface YZHPhoneContactRequestModel : NSObject

@property (nonatomic, strong) NSMutableArray<YZHAddBookPhoneContactModel* >* namePhones;

@property (nonatomic, copy) NSString* userId;
@property (nonatomic, strong, nullable) NSDictionary* params;
@property (nonatomic, strong) NSArray* sortedGroupTitles;
@property (nonatomic, strong) NSArray* nameKeys;
@property (nonatomic, strong) NSMutableArray<NSMutableArray<YZHAddBookPhoneContactModel *> *>* phoneContactList;

- (void)updataPhoneContactDataWithNameKeys:(NSArray *)nameKeys addressBookDict:(NSDictionary<NSString *,NSArray *>*)addressBookDict;
- (void)sortPhoneContacts:(NSArray *)contacts;

@end

NS_ASSUME_NONNULL_END
