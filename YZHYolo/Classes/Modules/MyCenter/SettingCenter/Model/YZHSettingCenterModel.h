//
//  YZHSettingCenterModel.h
//  YZHYolo
//
//  Created by Jersey on 2018/10/15.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YZHSettingCenterModel : NSObject

@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSString* route;

@end

@interface YZHSettingCenterContentModel : NSObject

@property (nonatomic, strong) NSArray<YZHSettingCenterModel* >* content;

@end

NS_ASSUME_NONNULL_END
