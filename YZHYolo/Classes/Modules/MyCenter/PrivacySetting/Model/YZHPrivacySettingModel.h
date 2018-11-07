//
//  YZHPrivacySettingModel.h
//  YZHYolo
//
//  Created by Jersey on 2018/10/15.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YZHUserModelManage.h"
NS_ASSUME_NONNULL_BEGIN

@interface YZHPrivacySettingModel : NSObject

@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSString* subTitle;
@property (nonatomic, assign) BOOL isSelected;

@end

@interface YZHPrivacySettingContent : NSObject

@property (nonatomic, strong) NSArray<YZHPrivacySettingModel* >* content;

@property (nonatomic, strong) YZHUserInfoExtManage* userInfoExt;

+ (instancetype)sharePrivacySettingContent;
- (void)updateModel;

@end

NS_ASSUME_NONNULL_END
