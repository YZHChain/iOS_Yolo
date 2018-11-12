//
//  YZHAddBookDetailsModel.m
//  YZHYolo
//
//  Created by Jersey on 2018/10/24.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHAddBookDetailsModel.h"

@implementation YZHAddBookDetailModel



@end

@implementation YZHAddBookHeaderModel



@end

@implementation YZHAddBookDetailsModel

- (instancetype)initDetailsModelWithUserId:(NSString *)userId {
    
    self = [super init];
    if (self) {
        _userId = userId;
        [self createData];
    }
    return self;
}

- (void)createData {
    
    NIMUser* user = [[[NIMSDK sharedSDK] userManager] userInfo:_userId];
    _user = user;
    NIMUserInfo* userInfo = user.userInfo;
    YZHUserInfoExtManage* userInfoExtManage = [YZHUserInfoExtManage targetUserInfoExtWithUserId:_userId];
    _userInfoExt = userInfoExtManage;
    YZHTargetUserExtManage* userExtManage = [YZHTargetUserExtManage targetUserExtWithUserId:_userId];
    _targetUserExt = userExtManage;
    
    //详情头部数据
    YZHAddBookHeaderModel* headerModel = [[YZHAddBookHeaderModel alloc] init];
//    headerModel.photoImageName = userInfo.thumbAvatarUrl;
    headerModel.photoImageName = userInfo.avatarUrl;
    headerModel.remarkName = user.alias;
    if (YZHIsString(headerModel.remarkName)) {
        //TODO:暂时不设置
        headerModel.nickName = headerModel.remarkName;
        
    } else {
        headerModel.remarkName = userInfo.nickName;
        headerModel.nickName = @"";
    }
    headerModel.genderImageName = [YZHUserUtil genderImageNameString:userInfo.gender];
    headerModel.yoloId = userInfoExtManage.userYolo.yoloID;
    headerModel.cellClass = @"YZHAddBookUserIDCell";
    headerModel.canSkip = NO;
    headerModel.cellHeight = 55;
    //添加好友验证消息;
    YZHAddBookDetailModel* requteAddModel = nil;
    if (!self.isFriend && self.requstAddFirend) {
        YZHAddBookDetailModel* requteAddModel = [[YZHAddBookDetailModel alloc] init];
        requteAddModel.title = @"我";
        requteAddModel.subtitle = userExtManage.requstAddText;
        requteAddModel.cellHeight = 126;
    }
    //备注
    YZHAddBookDetailModel* remarkModel = [[YZHAddBookDetailModel alloc] init];
    remarkModel.title = @"设置备注";
    remarkModel.subtitle = user.alias;
    remarkModel.canSkip = YES;
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
    classTagModel.canSkip = YES;
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
    } else {
        remarkContentsArray = @[remarkModel].mutableCopy;
    }
    //标签与地址
    NSArray* classTagArray = @[classTagModel, placeModel];
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

-  (YZHAddBookDetailModel *)classTagModel {
    
    if (!_classTagModel) {
        _classTagModel = self.viewModel.lastObject.firstObject;
    }
    return _classTagModel;
}

@end
