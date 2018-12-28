//
//  YZHLaunchModel.m
//  YZHYolo
//
//  Created by Jersey on 2018/12/29.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHLaunchModel.h"

@implementation YZHLaunchModel

//根据build后app中的info.plist取对应LaunchImageName
- (NSString *)launchImageName
{
    CGSize viewSize = [UIScreen mainScreen].bounds.size;
    NSString *viewOrientation = @"Portrait"; //横屏请设置成 @”Landscape”
    NSString *launchImageName = nil;
    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    
    for (NSDictionary* dict in imagesDict) {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]]) {
            launchImageName = dict[@"UILaunchImageName"];
        }
    }
    
    return launchImageName;
}

#pragma mark - GET & SET

- (NSString *)image {
    return _image ? _image : [self launchImageName];
}

@end
