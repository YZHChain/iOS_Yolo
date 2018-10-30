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
        addFirendModel.title = @"是否允许其他人添加我";
        addFirendModel.subTitle = @"允许";
        addFirendModel.isSelected = YES;
        YZHPrivacySettingModel* addVerifyModel = [[YZHPrivacySettingModel alloc] init];
        addVerifyModel.title = @"加好友时是否需要验证";
        addVerifyModel.subTitle = @"无需验证";
        addVerifyModel.isSelected = NO;
        YZHPrivacySettingModel* phoneAddModel = [[YZHPrivacySettingModel alloc] init];
        phoneAddModel.title = @"是否通过手机号码添加我";
        phoneAddModel.subTitle = @"不允许";
        phoneAddModel.isSelected = NO;
        
        _modelArray = @[addFirendModel,
                        addVerifyModel,
                        phoneAddModel,
                        ];
}

@end
