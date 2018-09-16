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

//分隔线1像素
#define YZHSepLine_Height (1.0 / [[UIScreen mainScreen] scale])

//RGB颜色
#define YZHColorWithRGB(r,g,b) ([UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:1.f])

#define YZHWindow [UIApplication sharedApplication].delegate.window

#define YZHBundle [NSBundle mainBundle]

#endif /* YZHMacro_h */
