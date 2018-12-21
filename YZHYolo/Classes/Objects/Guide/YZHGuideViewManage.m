//
//  YZHGuideViewManage.m
//  YZHYolo
//
//  Created by Jersey on 2018/12/21.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHGuideViewManage.h"
#import "YZHGuideView.h"
#import "UIViewController+YZHTool.h"

@interface YZHGuideViewManage()

@property (nonatomic, strong) NSArray<UIView *>* guideViews;

@end

@implementation YZHGuideViewManage{
    
    NSArray* _guideViews;
}

- (void)startGuideView {

    if ([self detectionApplicationStatus]) {
        NSMutableArray* guidePages = [[NSMutableArray alloc] init];
        for (NSInteger i = 0 ; i < 3; i++) {
            
            YZHGuideView* guideView = [[[NSBundle mainBundle] loadNibNamed:@"YZHGuideView" owner:nil options:nil] objectAtIndex:i];
            guideView.frame = YZHAppWindow.frame;
            [guidePages addObject:guideView];
            guideView.clickCompletion = ^{
                [self executeNextPage:i];
            };
        }
        self.guideViews = guidePages.copy;
        [YZHAppWindow addSubview:self.guideViews.firstObject];
    }
}

- (void)executeNextPage:(NSInteger)page {
    
    switch (page) {
        case 2:
        {
            //如果点击到最后一页,则移除并且跳转到广场
            [self.guideViews[page] removeFromSuperview];
            UITabBarController* tabBarVC = (UITabBarController *)[UIViewController yzh_rootViewController];
            tabBarVC.selectedIndex = 3;
            [YZHAppWindow resignKeyWindow];
        }
            break;
            
        default:
            [self.guideViews[page] removeFromSuperview];
            [YZHAppWindow addSubview:self.guideViews[page + 1]];
            break;
    }
}

- (BOOL)detectionApplicationStatus {
    
    BOOL firstLaunching = false;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *lastAppVersion = [userDefaults objectForKey:@"LastAppVersion"];
    NSString *currentAppVersion = [[YZHBundle infoDictionary] objectForKey:@"CFBundleVersion"];
    
    if ([lastAppVersion floatValue] < [currentAppVersion floatValue])
    {
        [userDefaults setValue:currentAppVersion forKey:@"LastAppVersion"];
        [userDefaults synchronize];
        
        firstLaunching = true;
    }
    return firstLaunching;
}

@end
