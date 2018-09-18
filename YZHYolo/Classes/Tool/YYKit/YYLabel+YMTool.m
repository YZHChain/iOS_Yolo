//
//  YYLabel+YMTool.m
//  YEAMoney
//
//  Created by jersey on 3/7/17.
//  Copyright © 2017年 YEAMoney. All rights reserved.
//

#import "YYLabel+YMTool.h"

@implementation YYLabel (YMTool)

- (void)yzh_setAgreeText:(NSString* )agreetext andProtocolText:(NSString* )protocolText
{
    NSMutableAttributedString* protocolSting = [[NSMutableAttributedString alloc] init];
    
    // 同意文本
    NSAttributedString* agreeAttString = [[NSAttributedString alloc] initWithString:agreetext attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14] ,NSForegroundColorAttributeName: [UIColor greenColor]}];
    // 拼接 同意文本
    [protocolSting appendAttributedString: agreeAttString];
    
    // 拼接 协议文本
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:protocolText attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14] ,NSForegroundColorAttributeName: [UIColor blueColor]}];
    
    [protocolSting appendAttributedString:attributedString];
    //    设置行间距
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:6];
    
    [protocolSting addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [protocolSting length])];
    
    self.numberOfLines = 0;
    
    self.attributedText = protocolSting;
    
    CGSize size = [self sizeThatFits:CGSizeMake(self.frame.size.width, MAXFLOAT)];
    //  由于计算的高度是刚刚好的。字体会太贴着顶部。让其高度+6、
    self.frame = CGRectMake(self.frame.origin.x,self.frame.origin.y,self.frame.size.width,size.height + 6);

}

- (void)yzh_setClickProtocalFormAgreeText:(NSString* )agreetext andProtocols:(NSArray* )protocols CompletionHandler:(void(^)(NSString* protocolUrl))completionHandler
{
    NSRange agreetextRange  = [agreetext rangeOfString:agreetext];
    // 实际内容
    NSString* protocol = [self.attributedText string];
    
    NSMutableArray* rangeArray = [[NSMutableArray alloc] initWithCapacity:5];
    
    for (NSInteger i = 0; i < protocols.count; i++) {
        NSRange range = [protocol rangeOfString:protocols[i][@"text"] ? protocols[i][@"text"] : @""];
        [rangeArray addObject:@(range.location)];
    }
    //整体内容长度，由于是用location对比判断所以+1
    [rangeArray addObject:@(protocol.length + 1)];
    __block NSString* protocolUrl = nil;
    self.textTapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        if (range.location >= agreetextRange.length && range.length) {
            for (NSInteger i = 0; i < rangeArray.count - 1; i++) {
                if (range.location >= [rangeArray[i] integerValue] && range.location < [rangeArray[i+1] integerValue]) {
                    protocolUrl = protocols[i][@"url"] ? protocols[i][@"url"] : nil;
                    if (protocolUrl) {
                        completionHandler ? completionHandler(protocolUrl) : NULL;
                        break;
                    }
                }
            }
        }
    };

}

@end
