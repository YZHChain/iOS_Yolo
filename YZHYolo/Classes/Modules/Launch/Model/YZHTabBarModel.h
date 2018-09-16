//
//  YZHTabBarModel.h
//  YZHYolo
//
//  Created by Jersey on 2018/9/11.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZHTabBarModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *selectedImage;
@property (nonatomic, copy) NSString *color;
@property (nonatomic, copy) NSString *selectedColor;
@property (nonatomic, copy) NSString *viewController;
@property (nonatomic, assign) BOOL hasNavigation;

@end

@interface YZHTabBarItems : NSObject

@property(nonatomic, strong)NSArray <YZHTabBarModel *>* itemsModel;

@end
