//
//  YZHCheckVersion.m
//  YZHYolo
//
//  Created by Jersey on 2018/12/12.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHCheckVersion.h"
#import "YZHChekoutVersionModel.h"
#import "YZHAlertManage.h"
#import "AppDelegate.h"

NSString* const kYZHAppID = @"";

@implementation YZHCheckVersion

+ (instancetype)shareInstance {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)checkoutCurrentVersionUpdataCompletion:(YZHVoidBlock)completion {
    
    
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSLog(@"当前版本%@", currentVersion);
    NSDictionary* dic = @{
                          @"appSource": @"1", // iOS
                          @"appVersion": currentVersion
                          };
    @weakify(self)
    [[YZHNetworkService shareService] GETNetworkingResource:SERVER_LOGIN(PATH_USER_CHECKOUAPPUPDATE) params:dic successCompletion:^(id obj) {
        
        YZHChekoutVersionModel* model = [YZHChekoutVersionModel YZH_objectWithKeyValues:obj];
        @strongify(self)
        // 先判断是否需要强更
        if (!model.updateForced) {
            [YZHAlertManage showAlertTitle:model.title message:model.updateContent actionButtons:@[@"退出",@"马上更新"] actionHandler:^(UIAlertController *alertController, NSInteger buttonIndex) {
                if (buttonIndex == 0) {
                    [self exitApplication];
                } else {
                    //跳转至 App Store
                    completion ? completion() : NULL;
                }
            }];
        } else {
            if (model.updateState == 0) {
                [YZHAlertManage showAlertTitle:model.title message:model.updateContent actionButtons:@[@"取消",@"确定"] actionHandler:^(UIAlertController *alertController, NSInteger buttonIndex) {
                    if (buttonIndex == 0) {
                        completion ? completion() : NULL;
                    } else {
                        //跳转至 App Store
                        completion ? completion() : NULL;
                        NSString *urlStr = [NSString stringWithFormat:@"https://itunes.apple.com/cn/app/id%@", kYZHAppID];
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
                    }
                }];
            } else {
                completion ? completion() : NULL;
            }
        }

    } failureCompletion:^(NSError *error) {
        completion ? completion() : NULL;
    }];
}

- (void)exitApplication
{
    [UIView animateWithDuration:0.4f animations:^{
        CGAffineTransform curent =  YZHAppWindow.transform;
        CGAffineTransform scale = CGAffineTransformScale(curent, 0.1,0.1);
        [YZHAppWindow setTransform:scale];
    } completion:^(BOOL finished) {
        exit(0);
    }];
    
}


@end
