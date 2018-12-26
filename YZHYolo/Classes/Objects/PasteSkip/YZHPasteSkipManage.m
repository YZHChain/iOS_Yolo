//
//  YZHPasteSkipManage.m
//  YZHYolo
//
//  Created by Jersey on 2018/12/25.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHPasteSkipManage.h"

#import "YZHAlertManage.h"
@interface YZHPasteSkipManage()

@property (nonatomic, copy) NSString* lastTeamId;
@property (nonatomic, copy) NSString* lastTeamURL;

@end

@implementation YZHPasteSkipManage

+ (instancetype)sharedInstance {
    
    static YZHPasteSkipManage *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[YZHPasteSkipManage alloc] init];
    });
    return instance;
}

- (void)checkoutTeamPasteboard {
    
    NSString* pasteBoradText = [UIPasteboard generalPasteboard].string;
    if (![pasteBoradText isEqualToString:self.lastTeamId]) {
        if ([pasteBoradText containsString:kYZHTeamURLHostKey] && [pasteBoradText containsString:@"teamId="]) {
            NSString* teamIdBase64 = [pasteBoradText componentsSeparatedByString:@"teamId="].lastObject;
            NSData* decodedData = [[NSData alloc] initWithBase64EncodedString:teamIdBase64 options:0];
            NSString* teamIdString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
            if (YZHIsString(self.lastTeamId)) {
                if (![self.lastTeamId isEqualToString:teamIdString]) {
                    [self gotoTeamCardWithTeamId:teamIdString];
                }
            } else {
                [self gotoTeamCardWithTeamId:teamIdString];
            }
        }
    }
}

- (void)gotoTeamCardWithTeamId:(NSString *)teamId {
    
    self.lastTeamId = teamId;
    [YZHAlertManage showAlertTitle:@"" message:@"检测到您粘贴板中有群链接信息, 是否马上查看该群？" actionButtons:@[@"跳过", @"去查看"] actionHandler:^(UIAlertController *alertController, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [YZHRouter openURL:kYZHRouterCommunityCardIntro info:@{
                                                                   @"teamId": teamId ? teamId: @"",
                                                                   kYZHRouteSegue: kYZHRouteSegueModal,
                                                                   kYZHRouteSegueNewNavigation: @(YES)
                                                                   }];
        }
    }];
}

@end
