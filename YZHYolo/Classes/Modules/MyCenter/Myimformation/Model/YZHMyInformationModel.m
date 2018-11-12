//
//  YZHMyInformationModel.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/21.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHMyInformationModel.h"

#import "YZHUserUtil.h"
#import "YZHUserModelManage.h"
#import "YZHUserLoginManage.h"

@implementation YZHMyInformationModel

@end


@implementation YZHMyInformationContentModel

+ (NSDictionary *)YZH_objectClassInArray{
    
    return @{
             @"content": @"YZHMyInformationModel"
             };
}

@end

@implementation YZHMyInformationListModel

+ (NSDictionary *)YZH_objectClassInArray{
    
    return @{
             @"content": @"YZHMyInformationContentModel"
                 };
}

- (NSMutableArray<YZHMyInformationContentModel *> *)list {

    if (!_list) {
        NIMUser* user = _userIMData;
        YZHUserLoginManage* manage = [YZHUserLoginManage sharedManager];
        YZHIMLoginData* _userLoginModel = manage.currentLoginData;
        
        NSString* phoneNumber = _userLoginModel.phoneNumber.length ? _userLoginModel.phoneNumber : @"";
        NSString* avatarUrl = user.userInfo.avatarUrl.length ? user.userInfo.avatarUrl : @"my_myinformationCell_headPhoto_default";
        //如果读不到, 或者后台未设置随便给个.
        NSString* nickName = user.userInfo.nickName.length ? user.userInfo.nickName : @"Yolo用户";
        NSString* gender = [YZHUserUtil genderString:user.userInfo.gender];
        NSString* genderImageName = [YZHUserUtil genderImageNameString:user.userInfo.gender];
        YZHUserInfoExtManage* userInfoExt = [YZHUserInfoExtManage currentUserInfoExt];
        NSString* yoloID = userInfoExt.userYolo.yoloID.length ? userInfoExt.userYolo.yoloID : @"Yolo默认用户";
        NSInteger yoloCellType = 2;
        if (userInfoExt.userYolo.hasSetting) {
            yoloCellType = 0;
        }
        NSString* myPlace = userInfoExt.place.complete.length ? userInfoExt.place.complete : @"";
        
        NSArray* list = @[
                          @{@"content": @[@{
                                              @"title":@"手机号",
                                              @"subtitle":phoneNumber,
                                              @"image":@"",
                                              @"route":@"",
                                              @"cellType" :@"0",
                                    }]},
                          @{@"content": @[@{
                                              @"title":@"头像",
                                              @"subtitle":@"",
                                              @"image":avatarUrl,
                                              @"route":kYZHRouterMyInformationPhoto,
                                              @"cellType" :@"1",
                                              }
                                          ]},
                          @{@"content": @[@{
                                              @"title":@"昵称",
                                              @"subtitle":nickName,
                                              @"image":@"",
                                              @"route":kYZHRouterMyInformationSetName,
                                              @"cellType" :@"2",
                                              },@{
                                              @"title":@"YOLO 号",
                                              @"subtitle":yoloID,
                                              @"image":@"",
                                              @"route":kYZHRouterMyInformationYoloID,
                                              @"cellType" :@(yoloCellType),
                                              }]},
                          @{@"content": @[@{
                                              @"title":@"性别",
                                              @"subtitle": gender,
                                              @"image": genderImageName,
                                              @"route":kYZHRouterMyInformationSetGender,
                                              @"cellType" :@"3",
                                              },@{
                                              @"title":@"地区",
                                              @"subtitle":myPlace,
                                              @"image":@"",
                                              @"route":kYZHRouterMyInformationMyPlace,
                                              @"cellType" :@"2",
                                              }]},
                          @{@"content": @[@{
                                              @"title":@"我的二维码",
                                              @"subtitle":@"",
                                              @"image":@"my_informationCell_QRCode",
                                              @"route":kYZHRouterMyInformationMyQRCode,
                                              @"cellType" :@"4",
                                              }]},
                          ];
        _list = [YZHMyInformationContentModel YZH_objectArrayWithKeyValuesArray:list];
    }
    return _list;
}

- (void)updateModelWithUserData:(NIMUser *)user {
    
    NSString* avatarUrl = user.userInfo.avatarUrl ? user.userInfo.avatarUrl : @"my_myinformationCell_headPhoto_default";
    NSString* nickName = user.userInfo.nickName ? user.userInfo.nickName : @"Yolo用户";
    NSString* gender = [YZHUserUtil genderString:user.userInfo.gender];
    NSString* genderImageName = [YZHUserUtil genderImageNameString:user.userInfo.gender];
    YZHUserInfoExtManage* userInfoExt = [YZHUserInfoExtManage currentUserInfoExt];
    NSString* yoloID = userInfoExt.userYolo.yoloID;
    NSInteger yoloCellType = 2;
    if (userInfoExt.userYolo.hasSetting) {
        yoloCellType = 0;
    }
    NSString* myPlace = userInfoExt.place.complete;
    //TODO:
    self.list[1].content[0].image = avatarUrl;
    self.list[2].content[0].subtitle = nickName;
    self.list[2].content[1].subtitle = yoloID;
    self.list[2].content[1].cellType = yoloCellType;
    self.list[3].content[0].subtitle = gender;
    self.list[3].content[0].image    = genderImageName;
    self.list[3].content[1].subtitle = myPlace;
}

- (BOOL )hasPhotoImage {
    
    if (YZHIsString(self.userIMData.userInfo.avatarUrl)) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)hasNickName {
    
    if (YZHIsString(self.userIMData.userInfo.nickName)) {
        return YES;
    } else {
        return NO;
    }
}

@end
