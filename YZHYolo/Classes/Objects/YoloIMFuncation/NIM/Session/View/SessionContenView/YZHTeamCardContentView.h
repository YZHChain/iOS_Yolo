//
//  YZHTeamCardContentView.h
//  YZHYolo
//
//  Created by Jersey on 2018/10/26.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YZHTeamCardAttachment.h"
NS_ASSUME_NONNULL_BEGIN

@interface YZHTeamCardContentView : NIMSessionMessageContentView

//- (void)refresh:(NIMMessageModel *)data;
@property (nonatomic, strong) YZHTeamCardAttachment* attachment;


@end

NS_ASSUME_NONNULL_END
