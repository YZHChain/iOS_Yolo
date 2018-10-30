//
//  YZHPhotoManage.h
//  YZHYolo
//
//  Created by Jersey on 2018/9/25.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, YZHImagePickerSourceType) {
    YZHImagePickerSourceTypePhotoLibrary = 0,
    YZHImagePickerSourceTypeCamera,
    YZHImagePickerSourceTypePhotosAlbum,
};
@interface YZHPhotoManage : NSObject

+ (void)presentWithViewController:(UIViewController *)viewController
                       sourceType:(YZHImagePickerSourceType)sourceType
                    finishPicking:(void (^)(UIImage *image))finishPicking;

@end

NS_ASSUME_NONNULL_END
