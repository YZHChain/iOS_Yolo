//
//  YZHTagContactManage.h
//  YZHYolo
//
//  Created by Jersey on 2018/11/12.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YZHGroupedDataCollection.h"
#import "YZHContactMemberModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YZHTagContactManage : NSObject

@property (nonatomic, strong) NSMutableArray* tagNameArray;
@property (nonatomic, strong) NSMutableArray* showTagNameArray;
@property (nonatomic, strong) NSMutableArray<NSMutableArray<YZHContactMemberModel*>* >* tagContacts;

@end

NS_ASSUME_NONNULL_END
