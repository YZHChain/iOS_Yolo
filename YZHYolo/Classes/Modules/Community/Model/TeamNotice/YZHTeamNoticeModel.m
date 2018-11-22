//
//  YZHTeamNoticeModel.m
//  YZHYolo
//
//  Created by Jersey on 2018/11/21.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHTeamNoticeModel.h"

@implementation YZHTeamNoticeModel

@end

@implementation YZHTeamNoticeList

+ (NSDictionary *)YZH_objectClassInArray {
    
    return @{
             @"noticeArray": [YZHTeamNoticeModel class]
             };
}

- (NSMutableArray<YZHTeamNoticeModel *> *)noticeArray {
    
    if (!_noticeArray) {
        YZHTeamNoticeModel *model = [[YZHTeamNoticeModel alloc] init];
        model.announcement = @"公共内容公告内容公共内容公告内容公共内容公告内容公共内容公告内容公共内容公告内容公共内容公告内容公共内容公告内容公共内容公告内公共内容公告内容公共内容公告内容公共内容公告内容公共内容公告内容公共内容公告内容公共内容公告内容公共内容公告内容公共内容公告内公共内容公告内容公共内容公告内容公共内容公告内容公共内容公告内容公共内容公告内容公共内容公告内容公共内容公告内容公共内容公告内";
        model.sendTime = @"99999";
        model.endTime = @"123456";
        YZHTeamNoticeModel *model2 = [[YZHTeamNoticeModel alloc] init];
        model2.announcement = @"公共内容公告内容公共内容公告内容公共内容公告内容公共内容公告内容公共内容公告内容公共内容公告内容公共内容公告内容公共内容公告内公共内容公告内容公共内容公告内容公共内容公告内容公共内容公告内容公共内容公告内容公共内容公告内容公共内容公告内容公共内容公告内";
        model2.sendTime = @"99999";
        model2.endTime = @"123456";
        YZHTeamNoticeModel *model3 = [[YZHTeamNoticeModel alloc] init];
        model3.announcement = @"公共内容公告内容公共内容公告内容公共内容公告内容公共内容公告内容公共内容公告内容公共内容公告内容公共内容公告内容公共内容公告内公共内容公告内容公共内容公告内容公共内容公告内容公共内容公告内容公共内容公告内容公共内容公告内容公共内容公告内容公共内容公告内公共内容公告内容公共内容公告内容公共内容公告内容公共内容公告内容公共内容公告内容公共内容公告内容公共内容公告内容公共内容公告内公共内容公告内容公共内容公告内容公共内容公告内容公共内容公告内容公共内容公告内容公共内容公告内容公共内容公告内容公共内容公告内公共内容公告内容公共内容公告内容公共内容公告内容公共内容公告内容公共内容公告内容公共内容公告内容公共内容公告内容公共内容公告内公共内容公告内容公共内容公告内容公共内容公告内容公共内容公告内容公共内容公告内容公共内容公告内容公共内容公告内容公共内容公告内公共内容公告内容公共内容公告内容公共内容公告内容公共内容公告内容公共内容公告内容公共内容公告内容公共内容公告内容公共内容公告内";
        model3.sendTime = @"99999";
        model3.endTime = @"123456";
        YZHTeamNoticeModel *model4 = [[YZHTeamNoticeModel alloc] init];
        model4.announcement = @"公共内容公告内容公共内容公告内容公共内";
        model4.sendTime = @"99999";
        model4.endTime = @"123456";
        YZHTeamNoticeModel *model5 = [[YZHTeamNoticeModel alloc] init];
        model5.announcement = @"公共内容公告内容公共内容公告内容公共内容公告内容公共内容公告内容公共内容公告内容公共内容公告内容公共内容公告内容公共内容公告内公共内容公告内容公共内容公告内容公共内容公告内容公共内容公告内容公共内容公告内容公共内容公告内容公共内容公告内容公共内容公告内公共内容公告内容公共内容公告内容公共内容公告内容公共内容公告内容公共内容公告内容公共内容公告内容公共内容公告内容公共内容公告内公共内容公告内容公共内容公告内容公共内容公告内容公共内容公告内容公共内容公告内容公共内容公告内容公共内容公告内容公共内容公告内";
        model5.sendTime = @"99999";
        model5.endTime = @"123456";
        
        _noticeArray = [[NSMutableArray alloc] initWithObjects:model,model2,model3,model4,model5, nil];
//        _noticeArray = @[model,model2,model3,model4,model5];
    }
    return _noticeArray;
}

@end
