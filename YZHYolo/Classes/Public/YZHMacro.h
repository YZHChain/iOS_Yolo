//
//  YZHMacro.h
//  YZHYolo
//
//  Created by 😘王艳 on 2018/9/10.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#ifndef YZHMacro_h
#define YZHMacro_h


//只在Debug模式下执行NSLog
#ifndef __OPTIMIZE__
//#define NSLog(fmt, ...) NSLog((@"\n[文件名:%s]\n" "[函数名:%s]\n" "[行号:%d] \n" fmt"\n\n"), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__)
//#define NSLog(fmt, ...) NSLog((@"%s" fmt), __FUNCTION__, ##__VA_ARGS__)
//#define NSLog(...) {}
#else
#define NSLog(...) {}
#endif

//屏幕属性宏
#define YZHSCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define YZHSCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
//self.view属性宏
#define YZHVIEW_WIDTH (self.view.bounds.size.width)
#define YZHVIEW_HEIGHT (self.view.bounds.size.height)

#define YZHTabBarHeight 49
#define YZHNavigationStatusBarHeight 64

//分隔线1像素
#define YZHSepLine_Height (1.0 / [[UIScreen mainScreen] scale])

//RGB颜色
#define YZHColorWithRGB(r,g,b) ([UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:1.f])

#define YZHWindow [UIApplication sharedApplication].delegate.window
#define YZHBundle [NSBundle mainBundle]


//weak对象，用于block，例：@weakify(self)
#ifndef    weakify
#if __has_feature(objc_arc)
#define weakify( x ) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
autoreleasepool{} __weak __typeof__(x) __weak_##x##__ = x; \
_Pragma("clang diagnostic pop")
#else
#define weakify( x ) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
autoreleasepool{} __block __typeof__(x) __block_##x##__ = x; \
_Pragma("clang diagnostic pop")
#endif
#endif
//strong对象，用于block，例：@strongify(self)
#ifndef    strongify
#if __has_feature(objc_arc)
#define strongify( x ) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
try{} @finally{} __typeof__(x) x = __weak_##x##__; \
_Pragma("clang diagnostic pop")
#else
#define strongify( x ) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
try{} @finally{} __typeof__(x) x = __block_##x##__; \
_Pragma("clang diagnostic pop")
#endif
#endif

#endif /* YZHMacro_h */
