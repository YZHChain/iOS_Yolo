//
//  YZHAboutYoloModel.h
//  YZHYolo
//
//  Created by Jersey on 2018/10/15.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YZHAboutYoloModel : NSObject

@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSString* subtitle;
@property (nonatomic, copy) NSString* route;

@end

@interface YZHAboutYoloContentModel : NSObject

@property (nonatomic, strong) NSArray<YZHAboutYoloModel* >* content;

@end

@interface YZHAboutYoloListModel : NSObject

@property (nonatomic, strong) NSArray<YZHAboutYoloContentModel* >* list;

@end



NS_ASSUME_NONNULL_END
