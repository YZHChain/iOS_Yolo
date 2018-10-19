//
//  YZHExtensionFunctionView.m
//  YZHYolo
//
//  Created by Jersey on 2018/10/15.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHExtensionFunctionView.h"

#import "UIView+YZHTool.h"

@implementation YZHExtensionFunctionView

#pragma mark -- Button Event Response

- (IBAction)creatGroupChat:(UIButton *)sender {
    
    [self hideExtensionFunctionView];
}

- (IBAction)addFriend:(UIButton *)sender {
    
    [YZHRouter openURL:kYZHRouterAddressBookAddFirend];
    [self hideExtensionFunctionView];
}

- (IBAction)transfer:(UIButton *)sender {
    
    [self hideExtensionFunctionView];
}

- (IBAction)scanQRCode:(UIButton *)sender {
    
    [YZHRouter openURL:kYZHRouterAddressBookScanQRCode info: @{kYZHRouteSegue : kYZHRouteSegueModal, kYZHRouteSegueNewNavigation: @(YES)}];
    [self hideExtensionFunctionView];
}

#pragma mark -- View Show and Hide

- (void)showExtensionFunctionView {
    
    //TODO: 未适配 iPHoneX MASConstraint 无法在 UIView 里面执行动画.
    @weakify(self)
    [self yzh_showOnWindowCallShowBlock:^{
        @strongify(self)
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.top.mas_equalTo(YZHNavigationStatusBarHeight);
            make.width.mas_equalTo(154);
            make.height.mas_equalTo(188);
        }];
    }];
}

- (void)hideExtensionFunctionView {
    
    [self yzh_hideFromWindowAnimations:nil];
}

@end
