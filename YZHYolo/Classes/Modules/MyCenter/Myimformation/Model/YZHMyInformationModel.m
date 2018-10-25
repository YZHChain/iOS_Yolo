//
//  YZHMyInformationModel.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/21.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHMyInformationModel.h"

#import "YZHUserUtil.h"
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
        NSString* avatarUrl = user.userInfo.avatarUrl ? user.userInfo.avatarUrl : @"my_myinformationCell_headPhoto_default";
        NSString* nickName = user.userInfo.nickName ? user.userInfo.nickName : @"YOLOName";
        NSString* gender = [YZHUserUtil genderString:user.userInfo.gender];
        NSString* genderImageName = [YZHUserUtil genderImageNameString:user.userInfo.gender];
        //TODO:地区读扩展字段, 有时间在单独写个处理 UserExt 的类.
        
        NSArray* list = @[
                          @{@"content": @[@{
                                              @"title":@"手机号",
                                              @"subtitle":@"18574352255",
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
                                              @"subtitle":@"8855842",
                                              @"image":@"",
                                              @"route":kYZHRouterMyInformationYoloID,
                                              @"cellType" :@"2",
                                              }]},
                          @{@"content": @[@{
                                              @"title":@"性别",
                                              @"subtitle": gender,
                                              @"image": genderImageName,
                                              @"route":kYZHRouterMyInformationSetGender,
                                              @"cellType" :@"3",
                                              },@{
                                              @"title":@"地区",
                                              @"subtitle":@"中国,深圳",
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
    NSString* nickName = user.userInfo.nickName ? user.userInfo.nickName : @"YOLOName";
    NSString* gender = [YZHUserUtil genderString:user.userInfo.gender];
    NSString* genderImageName = [YZHUserUtil genderImageNameString:user.userInfo.gender];
    //TODO:
    self.list[1].content[0].image = avatarUrl;
    self.list[2].content[0].subtitle = nickName;
    self.list[3].content[0].subtitle = gender;
    self.list[3].content[0].image    = genderImageName;
    
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
