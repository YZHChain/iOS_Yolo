//
//  YZHAddBookDetailsModel.h
//  YZHYolo
//
//  Created by Jersey on 2018/10/24.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YZHUserUtil.h"
#import "YZHUserModelManage.h"
#import "YZHTargetUserDataManage.h"
NS_ASSUME_NONNULL_BEGIN

@interface YZHAddBookDetailModel : NSObject

@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSString* subtitle;
@property (nonatomic, copy) NSString* cellClass;
@property (nonatomic, assign) NSInteger cellHeight;
@property (nonatomic, assign) BOOL canSkip;
@property (nonatomic, copy) NSString* router;

@end

@interface YZHAddBookHeaderModel : NSObject

@property (nonatomic, copy) NSString* photoImageName;
@property (nonatomic, copy) NSString* genderImageName;
@property (nonatomic, copy) NSString* remarkName;
@property (nonatomic, copy) NSString* nickName;
@property (nonatomic, copy) NSString* yoloId;
@property (nonatomic, copy) NSString* cellClass;
@property (nonatomic, assign) BOOL canSkip;
@property (nonatomic, copy) NSString* router;
@property (nonatomic, assign) NSInteger cellHeight;
@property (nonatomic, copy) NSString* userId;

- (instancetype)initWithUserId:(NSString *)userId;
- (void)configuration;

@end

@interface YZHAddBookDetailsModel : NSObject

@property (nonatomic, strong) YZHAddBookHeaderModel* headerModel;
@property (nonatomic, strong) NSMutableArray<NSMutableArray* >* viewModel;
@property (nonatomic, copy) NSString* userId;

@property (nonatomic, strong) NIMUser* user;
@property (nonatomic, strong) YZHTargetUserExtManage* targetUserExt;
@property (nonatomic, strong) NSMutableArray* remarkContentsArray;
@property (nonatomic, strong) YZHUserInfoExtManage* userInfoExt;
@property (nonatomic, strong) YZHAddBookDetailModel* classTagModel;
@property (nonatomic, strong) YZHAddBookDetailModel* placeModel;
@property (nonatomic, strong) YZHAddBookDetailModel* chatModel;
@property (nonatomic, strong) NSMutableArray<YZHAddBookDetailModel*>* userNotePhoneArray;
@property (nonatomic, strong) YZHAddBookDetailModel* requteAddModel;

@property (nonatomic, assign) BOOL isMyFriend;
@property (nonatomic, assign) BOOL hasPhoneNumber;
@property (nonatomic, assign) BOOL userAllowAdd;   //是否允许添加
@property (nonatomic, assign) BOOL requstAddFirend;//是否发起好友请求

@property (nonatomic, copy) YZHVoidBlock updataBlock;

- (instancetype)initDetailsModelWithUserId:(NSString *)userId;

@end

NS_ASSUME_NONNULL_END
