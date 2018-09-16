//
//  YZHRouterConfig.h
//  YZHYolo
//
//  Created by Jersey on 2018/9/11.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZHRouterConfig : NSObject

#pragma mark -- RouterKey

extern NSString *const kYZHRouteViewControllerClassKey;
extern NSString *const kYZHRouteViewControllerNameKey;
extern NSString *const kYZHRouteViewControllerNotesKey;
extern NSString *const kYZHRouteViewControllerNeedLoginKey;

#pragma mark -- RouteSkipConst

extern NSString * const kYZHRouteSegue;
extern NSString * const kYZHRouteAnimated;
extern NSString * const kYZHRouteBackIndex;
extern NSString * const kYZHRouteBackPage;
extern NSString * const kYZHRouteBackPageOffset;
extern NSString * const kYZHRouteFromOutside;
extern NSString * const kYZHRouteNeedLogin;

extern NSString * const kYZHRouteIndexRoot;
extern NSString * const kYZHRouteSeguePush;

#pragma mark -- GuidePage

extern NSString *const kYZHRouterWelcome;
extern NSString *const kYZHRouterLogin;
extern NSString *const kYZHRouterRegister;


+ (NSDictionary* )configInfo;

@end
