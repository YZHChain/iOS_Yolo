//
//  YZHDiscoverVC.h
//  YZHYolo
//
//  Created by Jersey on 2018/9/19.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHBaseViewController.h"

#import <WebKit/WebKit.h>
@interface YZHDiscoverVC : YZHBaseViewController

@property (nonatomic, strong) NSString* url;
@property (nonatomic, strong) WKWebView* webView;
- (void)refreshView;

@end
