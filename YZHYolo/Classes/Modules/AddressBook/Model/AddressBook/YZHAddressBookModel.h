//
//  YZHAddressBookModel.h
//  YZHYolo
//
//  Created by Jersey on 2018/9/29.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YZHAddressBookModel : NSObject

@property (nonatomic, copy)NSString* title; //表示备注名,也表示昵称,如果有备注名则默认展示备注名,在到昵称.
@property (nonatomic, copy)NSString* nickName; //昵称.如果无备注名时,其位置会在备注名的位置.有备注名时,显示在其后面 并且需要用此格式拼接: (nickName)
@property (nonatomic, copy)NSString* image;


@end

NS_ASSUME_NONNULL_END
