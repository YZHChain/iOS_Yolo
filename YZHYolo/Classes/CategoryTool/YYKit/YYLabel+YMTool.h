//
//  YYLabel+YMTool.h
//  YEAMoney
//
//  Created by jersey on 3/7/17.
//  Copyright © 2017年 YEAMoney. All rights reserved.
//

#import <YYText/YYText.h>

@interface YYLabel (YMTool)

// 拼接协议内容
- (void)yzh_setAgreeText:(NSString* )agreetext andProtocolText:(NSString* )protocolText;
// 设置点击内容事件
- (void)yzh_setClickProtocalFormAgreeText:(NSString* )agreetext andProtocols:(NSArray* )protocols CompletionHandler:(void(^)(NSString* protocolUrl))completionHandler;
@end
