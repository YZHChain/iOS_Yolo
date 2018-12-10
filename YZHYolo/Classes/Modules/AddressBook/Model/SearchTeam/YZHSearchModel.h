//
//  YZHSearchModel.h
//  YZHYolo
//
//  Created by Jersey on 2018/12/6.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YZHSearchModel : NSObject

@property (nonatomic, strong) NSString* teamIcon;
@property (nonatomic, strong) NSString* teamName;
@property (nonatomic, strong) NSString* teamId;

@end

@interface YZHSearchListModel : NSObject

@property (nonatomic, strong) NSMutableArray<YZHSearchModel *>* searchArray;
@property (nonatomic, strong) NSMutableArray<YZHSearchModel *>* recommendArray;
@property (nonatomic, assign) int pageTotal; //总页数

@end

NS_ASSUME_NONNULL_END
