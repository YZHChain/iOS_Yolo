//
//  YZHPrivacySettingModel.m
//  YZHYolo
//
//  Created by Jersey on 2018/10/15.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHPrivacySettingModel.h"

@implementation YZHPrivacySettingModel

@end

static id instance;
@implementation YZHPrivacySettingContent

+ (instancetype)sharePrivacySettingContent {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        [self defaultModelArray];
    }
    return self;
}

- (void)defaultModelArray {
    
        YZHPrivacySettingModel* addFirendModel = [[YZHPrivacySettingModel alloc] init];
        YZHUserPrivateSettingModel* userSetting = [YZHUserInfoExtManage currentUserInfoExt].privateSetting;
        addFirendModel.title = @"是否允许其他人添加我";
        if (userSetting.allowAdd) {
            addFirendModel.subTitle = @"允许";
            addFirendModel.isSelected = YES;
        } else {
            addFirendModel.subTitle = @"不允许";
            addFirendModel.isSelected = NO;
        }
        YZHPrivacySettingModel* addVerifyModel = [[YZHPrivacySettingModel alloc] init];
        addVerifyModel.title = @"加好友时是否需要验证";
        if (userSetting.addVerift) {
            addVerifyModel.subTitle = @"需验证";
            addVerifyModel.isSelected = YES;
        } else {
            addVerifyModel.subTitle = @"无需验证";
            addVerifyModel.isSelected = NO;
        }
        YZHPrivacySettingModel* phoneAddModel = [[YZHPrivacySettingModel alloc] init];
        phoneAddModel.title = @"是否通过手机号码添加我";
        if (userSetting.allowPhoneAdd) {
            phoneAddModel.subTitle = @"允许";
            phoneAddModel.isSelected = YES;
        } else {
            phoneAddModel.subTitle = @"不允许";
            phoneAddModel.isSelected = NO;
        }
        _content = @[addFirendModel,
                        addVerifyModel,
                        phoneAddModel,
                        ];
}

- (void)updateModel {
    
    [self defaultModelArray];
}

@end
