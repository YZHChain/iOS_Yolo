//
//  YZHRouter+Skip.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/11.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHRouter+Skip.h"

#import "YZHRouterConfig.h"
#import "UIViewController+YZHTool.h"

@implementation YZHRouter (Skip)

//+ (void)initialize
+ (void)load {
    // TODO: 这里考虑将此方法改成 initialize 并且在子线程中去完成. 在不影响业务的情况下. 因为如果后期 Route 不断增加, 会影响到 App 启动时间.
    [self performSelectorOnMainThread:@selector(addRoute) withObject:nil waitUntilDone:NO];
}

//读取Router配置文件
+ (NSDictionary *)routerConfig
{
    return [YZHRouterConfig configInfo];
}

+ (void)addRoute{
    
    //根据Router配置文件添加Route
    NSDictionary *routerInfo = [self routerConfig];
    
    for (NSString* routeConst in routerInfo.allKeys) {
        NSString* viewControllerClassName = routerInfo[routeConst][kYZHRouteViewControllerClassKey];
        BOOL needLogin = [routerInfo[routerInfo][kYZHRouteViewControllerNeedLoginKey] boolValue];
        if (viewControllerClassName.length) {
            // 注册Route TODO: 注册方法还有一种是数组传参的形式.
            [self configRoute:routeConst handler:^BOOL(NSDictionary *parameters) {
                NSMutableDictionary* info = [NSMutableDictionary dictionaryWithDictionary:parameters];
                if (needLogin) {
                    [info setObject:@(YES) forKey:kYZHRouteViewControllerNeedLoginKey];
                }
                return [self routeWithClass:viewControllerClassName info:info];
            }];
        }
    }
    
}

#pragma mark -- Private Method

//通过类名和参数route
+ (BOOL)routeWithClass:(NSString *)class info:(NSDictionary *)info{
    
    //如果是需要登录才能进的页面，未登录时直接跳到登录页
    BOOL needLogin = info[kYZHRouteViewControllerNeedLoginKey] ? [info[kYZHRouteViewControllerNeedLoginKey] boolValue] : NO;
    if (needLogin) {
        //TODO: 判断用户登录状态. 如果需要则执行登录相应跳转
//        if (<#condition#>) {
//            <#statements#>
//        }
        return NO;
    }
    // 初始化控制器
    UIViewController* viewController = [self initWithControllerFromClassName:class info:info];
    // 跳转
    [self skpiToViewController:viewController parameters:info];
    return YES;
}

// 通过控制器类名和参数 实例化ViewController 与 Property
+ (UIViewController* )initWithControllerFromClassName:(NSString *)class info:(NSDictionary* )info{
    
    id viewController = [[NSClassFromString(class) alloc] init];
    // 防止控制器类名传输错误.
    NSAssert([viewController isKindOfClass:[UIViewController class]] , @"%s: %@ is not kind of UIViewController class",__func__ ,class);
    if ([viewController isKindOfClass:[UIViewController class]]) {
        [self setupViewControllerParamsWithObject:viewController fromParams:info];
    }
    
    return viewController;
}

// 控制器属性配置
+ (void)setupViewControllerParamsWithObject:(id)object fromParams:(NSDictionary *)params{
    
    for (NSString* key in params.allKeys) {
        BOOL hasProperty = [object respondsToSelector:NSSelectorFromString(key)];
        // 如果控制器 设置了 get 方法, 则不赋值.
        BOOL hasValue = params[key] != nil;
        if (hasProperty && hasValue) {
            [object setValue:params[key] forKey:key];
        }
        
#if DEBUG
        //控制器属性与传入属性不一致.
        //viewController没有相应属性，但却传了值。 TODO:
        if ([key hasPrefix:@"JLRoute"]==NO &&
            [key hasPrefix:@"YZHRoute"]==NO &&
            [params[@"JLRoutePattern"] rangeOfString:[NSString stringWithFormat:@":%@",key]].location==NSNotFound) {
            NSAssert(hasProperty==YES , @"%s: %@ is not property for the key %@",__func__ ,object, key);
        }
#endif
    }
    
}

+ (void)skpiToViewController:(UIViewController* )viewController parameters:(NSDictionary* )parameters{
    
    UIViewController* visibleViewController = [UIViewController yzh_findTopViewController];
    NSString* segue = parameters[kYZHRouteSegue] ? [NSString stringWithFormat:@"%@", parameters[kYZHRouteSegue]] : kYZHRouteSeguePush;
    BOOL animated = parameters[kYZHRouteAnimated] ? [parameters[kYZHRouteAnimated] boolValue] : YES;
    NSString* backIndexString = [NSString stringWithFormat:@"%@",parameters[kYZHRouteBackIndex]];
    
    NSLog(@"%s %@ ---> %@", __func__ , visibleViewController , viewController);
    
    //segue为push且有导航控制器
    if ([segue isEqualToString:kYZHRouteSeguePush] && visibleViewController.navigationController) {
        UINavigationController *nav = visibleViewController.navigationController;
        if ([backIndexString isEqualToString:kYZHRouteIndexRoot]) {
            //从跟控制器push
            NSMutableArray *viewControllers = [NSMutableArray arrayWithObject:nav.viewControllers.firstObject];
            [viewControllers addObject:viewController];
            [nav setViewControllers:viewControllers animated:animated];
        } else if ([backIndexString integerValue]) {
            //回退index步后再push
            NSUInteger index = [backIndexString integerValue];
            NSMutableArray *viewControllers = [nav.viewControllers mutableCopy];
            if (viewControllers.count > index) {
                [viewControllers removeObjectsInRange:NSMakeRange(viewControllers.count-index, index)];
            }
            [viewControllers addObject:viewController];
            [nav setViewControllers:viewControllers animated:animated];
        } else {
            //直接push
            [nav pushViewController:viewController animated:animated];
        }
    }
    //segue为push且没导航控制器
    else if ([segue isEqualToString:kYZHRouteSeguePush] && visibleViewController.navigationController==nil) {
        UINavigationController *navviewController = [[UINavigationController alloc] initWithRootViewController:viewController];
        navviewController.navigationBar.translucent = NO;
        [visibleViewController presentViewController:navviewController animated:animated completion:nil];
    }
    //segue为modal
    else {
        [visibleViewController presentViewController:viewController animated:animated completion:nil];
    }
}

@end
