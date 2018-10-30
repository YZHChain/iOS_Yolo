//
//  YZHPrivacySettingModel.h
//  YZHYolo
//
//  Created by Jersey on 2018/10/15.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YZHPrivacySettingModel : NSObject

@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSString* subTitle;
@property (nonatomic, assign) BOOL isSelected;

@end

@interface YZHPrivacySettingContent : NSObject<NSSecureCoding>

@property (nonatomic, strong) NSArray<YZHPrivacySettingModel* >* modelArray;

+ (instancetype)sharePrivacySettingContent;

@end

NS_ASSUME_NONNULL_END
