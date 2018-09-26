//
//  YZHMyCenterModel.h
//  YZHYolo
//
//  Created by Jersey on 2018/9/25.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YZHMyCenterModel : NSObject

@property(nonatomic, copy)NSString* title;
@property(nonatomic, copy)NSString* subtitle;
@property(nonatomic, copy)NSString* image;
@property(nonatomic, copy)NSString* route;
@property(nonatomic, assign)NSInteger type;

@end

@interface YZHMyCenterContentModel : NSObject

@property(nonatomic, strong)NSArray<YZHMyCenterModel *> *content;

@end

@interface YZHMyCenterListModel : NSObject

@property(nonatomic, strong)NSArray<YZHMyCenterContentModel* >* list;

@end

NS_ASSUME_NONNULL_END
