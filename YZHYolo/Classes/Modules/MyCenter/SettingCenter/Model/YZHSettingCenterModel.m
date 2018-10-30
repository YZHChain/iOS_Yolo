//
//  YZHSettingCenterModel.m
//  YZHYolo
//
//  Created by Jersey on 2018/10/15.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHSettingCenterModel.h"

@implementation YZHSettingCenterModel

@end

@implementation YZHSettingCenterContentModel

+ (NSDictionary *)YZH_objectClassInArray {
    
    return @{
             @"content": @"YZHSettingCenterModel"
             };
}

- (NSArray<YZHSettingCenterModel *> *)content {
    
    if (!_content) {
        
        NSArray* contentArray = @[@{
                                      @"title": @"修改密码",
                                      @"route": @"",
                                      },
                                  @{
                                      @"title": @"清空聊天记录",
                                      @"route": @"",
                                      },];
        
        _content = [YZHSettingCenterModel YZH_objectArrayWithKeyValuesArray:contentArray];
    }
    return _content;
}

@end
