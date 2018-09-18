//
//  YZHRouterConfig.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/11.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHRouterConfig.h"

//TODO:规范Segue参数与非Segue参数(YZHRouteFromOutside,YZHRouteNeedLogin等)，Segue参数统一以YZHRouteSegue开头。
NSString *const kYZHRouteSegue           = @"YZHRouteSegue";
NSString *const kYZHRouteSeguePush       = @"YZHRouteSeguePush";
NSString *const kYZHRouteAnimated        = @"YZHRouteAnimated";
NSString *const kYZHRouteBackIndex       = @"YZHRouteBackIndex";
NSString *const kYZHRouteBackPage        = @"YZHRouteBackPage";
NSString *const kYZHRouteBackPageOffset  = @"YZHRouteBackPageOffset";
NSString *const kYZHRouteFromOutside     = @"YZHRouteFromOutside";

NSString *const kYZHRouteIndexRoot  = @"YZHRouteIndexRoot";

//NSString * const YZHRouteHomeTab     = @"/rootTab/0";
//NSString * const YZHRouteInvestTab   = @"/rootTab/1";
//NSString * const YZHRouteDiscoverTab = @"/rootTab/2";
//NSString * const YZHRouteWealthTab   = @"/rootTab/3";
//NSString * const YZHRouteInvestTabGB = @"/rootTab/1?tag=0";
//NSString * const YZHRouteInvestTabYX = @"/rootTab/1?tag=1";

NSString* const kYZHRouteViewControllerClassKey = @"class";
NSString* const kYZHRouteViewControllerNameKey = @"name";
NSString* const kYZHRouteViewControllerNotesKey = @"notes";
NSString* const kYZHRouteViewControllerNeedLoginKey = @"needLogin";

#pragma mark -- GuidePage

NSString* const kYZHRouterWelcome         = @"/guidePage/welcome";
NSString* const kYZHRouterLogin           = @"/guidePage/login";
NSString* const kYZHRouterRegister        = @"/guidePage/register";
NSString* const kYZHRouterFindPassword    = @"/guidePage/findPassword";


@implementation YZHRouterConfig

+ (NSDictionary *)configInfo{
    
    return @{kYZHRouterWelcome: @{
                 kYZHRouteViewControllerClassKey: @"YZHWelcomeVC",
                 kYZHRouteViewControllerNameKey: @"欢迎引导",
                 kYZHRouteViewControllerNotesKey: @"",
                 kYZHRouteViewControllerNeedLoginKey:@"0",
                     },
             kYZHRouterLogin: @{
                     kYZHRouteViewControllerClassKey: @"YZHLoginVC",
                     kYZHRouteViewControllerNameKey: @"登录",
                     kYZHRouteViewControllerNotesKey: @"",
                     kYZHRouteViewControllerNeedLoginKey:@"0",
                     },
             kYZHRouterRegister: @{
                     kYZHRouteViewControllerClassKey: @"YZHRegisterVC",
                     kYZHRouteViewControllerNameKey: @"注册",
                     kYZHRouteViewControllerNotesKey: @"",
                     kYZHRouteViewControllerNeedLoginKey:@"0",
                     },
             kYZHRouterFindPassword: @{
                     kYZHRouteViewControllerClassKey: @"YZHFindPasswordVC",
                     kYZHRouteViewControllerNameKey: @"找回密码",
                     kYZHRouteViewControllerNotesKey: @"",
                     kYZHRouteViewControllerNeedLoginKey:@"0",
                     },
             };
    
}

@end
