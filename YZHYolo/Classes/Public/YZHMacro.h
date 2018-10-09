//
//  YZHMacro.h
//  YZHYolo
//
//  Created by 😘王艳 on 2018/9/10.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#ifndef YZHMacro_h
#define YZHMacro_h

#pragma mark -- NSLog
//只在Debug模式下执行NSLog
#ifndef __OPTIMIZE__
//#define NSLog(fmt, ...) NSLog((@"\n[文件名:%s]\n" "[函数名:%s]\n" "[行号:%d] \n" fmt"\n\n"), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__)
//#define NSLog(fmt, ...) NSLog((@"%s" fmt), __FUNCTION__, ##__VA_ARGS__)
//#define NSLog(...) {}
#else
#define NSLog(...) {}
#endif

#pragma mark -- UI

//屏幕属性宏
#define YZHScreen_Width ([UIScreen mainScreen].bounds.size.width)
#define YZHScreen_Height ([UIScreen mainScreen].bounds.size.height)
// Get the screen's bounds.
#define YZHScreen_Bounds ([UIScreen mainScreen].bounds)
//self.view属性宏
#define YZHView_Width (self.view.bounds.size.width)
#define YZHView_Height (self.view.bounds.size.height)

#define YZHTabBarHeight 49
#define YZHNavigationStatusBarHeight 64

//分隔线1像素
#define YZHSepLine_Height (1.0 / [[UIScreen mainScreen] scale])

//RGB颜色
#define YZHColorWithRGB(r,g,b) ([UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.f])
//RGBA
#define YZHColorRGBAWithRGBA(r, g, b, a) ([UIColor colorWithRed:(r) / 255.0  \
    green:(g) / 255.0  \
    blue :(b) / 255.0  \
    alpha:(a)])

// get Window
#define YZHAppWindow [UIApplication sharedApplication].delegate.window

// More fast way to get app delegate
#define YZHAppDelegate ((AppDelegate *)[[UIApplication  sharedApplication] delegate])

#pragma mark - Load Font

// Generate font with size
#define YZHFontWithSize(size) [UIFont systemFontOfSize:size]

// Generate bold font with size.
#define YZHBoldFontWithSize(size) [UIFont boldSystemFontOfSize:size]

#pragma mark - Load Image

// More easy way to load an image.
#define YZHImage(Name) ([UIImage imageNamed:Name])

// More easy to load an image from file.
#define YZHImageOfFile(Name) ([UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:Name ofType:nil]])

#pragma mark - System Singletons

// More easy way to get user default object.
#define YZHUserDefaults [NSUserDefaults standardUserDefaults]

// More easy way to get NSNotificationCenter object.
#define YZHNotificationCenter  [NSNotificationCenter defaultCenter]

// More easy way to get [NSFileManager defaultManager]
#define YZHFileManager [NSFileManager defaultManager]

// More easy way to post a notification from notification center.
#define YZHPostNotificationWithName(notificationName) \
[kNotificationCenter postNotificationName:notificationName object:nil userInfo:nil]

// More easy way to post a notification with user info from notification center.
#define YZHPostNotificationWithNameAndUserInfo(notificationName, userInfo) \
[kNotificationCenter postNotificationName:notificationName object:nil userInfo:userInfo]

#pragma mark -- Fundation

#define YZHBundle [NSBundle mainBundle]

// Get dispatch_get_main_queue()
#define YZHMainThread (dispatch_get_main_queue())

// Get default dispatch_get_global_queue
#define YZHGlobalThread dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

// Radians convert to degress.
#define YZHRadiansToDegrees(radians) ((radians) * (180.0 / M_PI))

// Degrees convert to randians.
#define YZHDegreesToRadians(angle) ((angle) / 180.0 * M_PI)

// Fast to get iOS system version
#define YZHIOSVersion ([UIDevice currentDevice].systemVersion.floatValue)

#pragma mark - Judge

// Judge whether it is an empty string.
#define YZHIsEmptyString(s) (s == nil || [s isKindOfClass:[NSNull class]] || ([s isKindOfClass:[NSString class]] && s.length == 0))

// Judge whether it is a nil or null object.
#define kIsEmptyObject(obj) (obj == nil || [obj isKindOfClass:[NSNull class]])

// Judge whether it is a vaid dictionary.
#define kIsDictionary(objDict) (objDict != nil && [objDict isKindOfClass:[NSDictionary class]])

// Judge whether it is a valid array.
#define kIsArray(objArray) (objArray != nil && [objArray isKindOfClass:[NSArray class]])

#pragma mark weakify && strongify

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
