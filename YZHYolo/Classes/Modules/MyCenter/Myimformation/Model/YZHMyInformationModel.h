//
//  YZHMyInformationModel.h
//  YZHYolo
//
//  Created by Jersey on 2018/9/21.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZHMyInformationModel : NSObject

@property(nonatomic, copy)NSString* title;
@property(nonatomic, copy)NSString* subtitle;
@property(nonatomic, copy)NSString* image;
@property(nonatomic, copy)NSString* route;
@property(nonatomic, assign)NSInteger cellType;

@end

@interface YZHMyInformationContentModel : NSObject

@property(nonatomic, strong)NSMutableArray<YZHMyInformationModel *> *content;

@end

@interface YZHMyInformationListModel : NSObject

@property(nonatomic, strong)NSMutableArray<YZHMyInformationContentModel* >* list;

@end
