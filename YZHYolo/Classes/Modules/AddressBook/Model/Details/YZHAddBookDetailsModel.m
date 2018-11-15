//
//  YZHAddBookDetailsModel.m
//  YZHYolo
//
//  Created by Jersey on 2018/10/24.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHAddBookDetailsModel.h"

#import "YZHProgressHUD.h"
@implementation YZHAddBookDetailModel



@end

@implementation YZHAddBookHeaderModel

- (instancetype)initWithUserId:(NSString *)userId {
    
    self = [super init];
    if (self) {
        _userId = userId;
        [self configuration];
    }
    return self;
}

- (void)configuration {
    
    NIMUser* user = [[[NIMSDK sharedSDK] userManager] userInfo:_userId];
    NIMUserInfo* userInfo = user.userInfo;
    YZHUserInfoExtManage* userInfoExtManage = [YZHUserInfoExtManage targetUserInfoExtWithUserId:_userId];
//    YZHTargetUserExtManage* userExtManage = [YZHTargetUserExtManage targetUserExtWithUserId:_userId];
    self.photoImageName = userInfo.avatarUrl;
    self.remarkName = user.alias;
    if (YZHIsString(self.remarkName)) {
        //TODO:暂时不设置
        self.nickName = self.remarkName;
        
    } else {
        self.remarkName = userInfo.nickName;
        self.nickName = @"";
    }
    self.genderImageName = [YZHUserUtil genderImageNameString:userInfo.gender];
    self.yoloId = userInfoExtManage.userYolo.yoloID;
    self.cellClass = @"YZHAddBookUserIDCell";
    self.canSkip = NO;
    self.cellHeight = 55;
}

@end

@implementation YZHAddBookDetailsModel

- (instancetype)initDetailsModelWithUserId:(NSString *)userId {
    
    self = [super init];
    if (self) {
        _userId = userId;
        [self createData];
        [self updataUserData];
    }
    return self;
}

- (void)updataUserData {
    
    NIMUser* user = [[[NIMSDK sharedSDK] userManager] userInfo:_userId];
    _user = user;
//    if (!user.userInfo) {
//        YZHProgressHUD* hud = [YZHProgressHUD showLoadingOnView:YZHAppWindow text:nil];
        @weakify(self)
        [[[NIMSDK sharedSDK] userManager] fetchUserInfos:@[_userId] completion:^(NSArray<NIMUser *> * _Nullable users, NSError * _Nullable error) {
            @strongify(self)
            if (!error) {
                self.user = users.firstObject;
                [self createData];
                self.updataBlock ? self.updataBlock() : NULL;
            } else {
                [self createData];
            }
        }];
//    }
}

- (void)createData {
    
    YZHUserInfoExtManage* userInfoExtManage = [YZHUserInfoExtManage targetUserInfoExtWithUserId:_userId];
    _userInfoExt = userInfoExtManage;
    YZHTargetUserExtManage* userExtManage = [YZHTargetUserExtManage targetUserExtWithUserId:_userId];
    _targetUserExt = userExtManage;
    
    self.isMyFriend = [[[NIMSDK sharedSDK] userManager] isMyFriend:_userId]; // 用来控制备注和分类标签是否支持跳转修改.

    //详情头部数据
    YZHAddBookHeaderModel* headerModel = [[YZHAddBookHeaderModel alloc] initWithUserId:_userId];

    //添加好友验证消息;
    YZHAddBookDetailModel* requteAddModel = nil;
    if (!self.isFriend && self.requstAddFirend) {
        YZHAddBookDetailModel* requteAddModel = [[YZHAddBookDetailModel alloc] init];
        requteAddModel.title = @"我";
        requteAddModel.subtitle = userExtManage.requstAddText;
        requteAddModel.cellHeight = 126;
    }
    self.requteAddModel = requteAddModel;
    //备注
    YZHAddBookDetailModel* remarkModel = [[YZHAddBookDetailModel alloc] init];
    remarkModel.title = @"设置备注";
    remarkModel.subtitle = self.user.alias;
    remarkModel.canSkip = self.isMyFriend;
    remarkModel.cellClass = @"YZHAddBookSettingCell";
    remarkModel.cellHeight = 55;
    remarkModel.router = kYZHRouterAddressBookSetNote;
    YZHAddBookDetailModel* phoneModel = nil;
    
    if (YZHIsString(userExtManage.friend_phone)) {
        phoneModel = [[YZHAddBookDetailModel alloc] init];
        phoneModel.title = @"手机号码";
        phoneModel.subtitle = userExtManage.friend_phone;
        phoneModel.cellClass = @"YZHAddBookSettingCell";
        phoneModel.canSkip = NO;
        phoneModel.cellHeight = 55;
    }
    //分类标签
    YZHAddBookDetailModel* classTagModel = [[YZHAddBookDetailModel alloc] init];
    classTagModel.title = @"设置分类标签";
    classTagModel.canSkip = self.isMyFriend;
    classTagModel.cellClass = @"YZHAddBookSettingCell";
    classTagModel.cellHeight = 55;
    classTagModel.router = kYZHRouterAddressBookSetTag;
    if (YZHIsString(userExtManage.friend_tagName)) {
        classTagModel.subtitle = userExtManage.friend_tagName;
    }
    //地区
    YZHAddBookDetailModel* placeModel = [[YZHAddBookDetailModel alloc] init];
    placeModel.title = @"地区";
    placeModel.canSkip = NO;
    placeModel.cellClass = @"YZHAddBookSettingCell";
    placeModel.cellHeight = 55;
    placeModel.subtitle = userInfoExtManage.place.complete;
    
    self.isFriend = [[[NIMSDK sharedSDK] userManager] isMyFriend:_userId];
    self.userAllowAdd = userInfoExtManage.privateSetting.allowAdd;
    self.requstAddFirend = userExtManage.requteAddFirend;
    
    self.viewModel = [[NSMutableArray alloc] init];
    //头部数据
    NSArray* headerContentsArray = @[headerModel];
    //设置备注
    NSMutableArray* remarkContentsArray;
    
    if (phoneModel) {
        remarkContentsArray = @[remarkModel,phoneModel].mutableCopy;
        self.hasPhoneNumber = YES;
    } else {
        remarkContentsArray = @[remarkModel].mutableCopy;
        self.hasPhoneNumber = NO;
    }
    self.userNotePhoneArray = remarkContentsArray;
    //标签与地址
    NSArray* classTagArray = @[classTagModel, placeModel];
    self.classTagModel = classTagModel;
    self.placeModel = placeModel;
    // 拼装数据
    if (requteAddModel) {
       self.viewModel = @[
                          headerContentsArray,
                          requteAddModel,
                          remarkContentsArray,
                          classTagArray
                          ].mutableCopy;
    } else {
        self.viewModel = @[
                           headerContentsArray,
                           remarkContentsArray,
                           classTagArray
                           ].mutableCopy;
    }
    
}

@end
