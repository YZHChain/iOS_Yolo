//
//  YZHDiscountVC.h
//  YZHYolo
//
//  Created by Jersey on 2018/12/11.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHBaseViewController.h"

#import <WebKit/WebKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface YZHDiscountVC : YZHBaseViewController

@property (nonatomic, strong) NSString* url;
@property (nonatomic, assign) BOOL isPlay;
@property (nonatomic, strong) WKWebView* webView;

@end

NS_ASSUME_NONNULL_END
