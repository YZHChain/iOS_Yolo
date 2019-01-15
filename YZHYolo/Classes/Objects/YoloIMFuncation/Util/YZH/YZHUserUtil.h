//
//  YZHUserUtil.h
//  YZHYolo
//
//  Created by Jersey on 2018/10/14.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NIMUser.h"

NS_ASSUME_NONNULL_BEGIN

@interface YZHUserUtil : NSObject

+ (NSString *)genderString:(NIMUserGender)gender;
+ (NSString *)genderImageNameString:(NIMUserGender)gender;

@end

NS_ASSUME_NONNULL_END
