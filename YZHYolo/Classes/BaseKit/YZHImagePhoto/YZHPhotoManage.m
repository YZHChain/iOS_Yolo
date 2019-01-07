//
//  YZHPhotoManage.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/25.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHPhotoManage.h"
#import "UIViewController+YZHTool.h"

@interface YZHPhotoManage () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property(nonatomic, assign) YZHImagePickerSourceType sourceType;
@property (nonatomic, copy) void (^finishPicking)(UIImage *image);

@end

@implementation YZHPhotoManage

+ (instancetype)sharePhotoManage {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

#pragma mark - Method

+ (void)presentWithViewController:(UIViewController *)viewController sourceType:(YZHImagePickerSourceType)sourceType finishPicking:(void (^)(UIImage *))finishPicking
{
    [YZHPhotoManage sharePhotoManage].sourceType = sourceType;
    [YZHPhotoManage sharePhotoManage].finishPicking = finishPicking;
    [[YZHPhotoManage sharePhotoManage] presentWithViewController:viewController];
}

#pragma mark - Private Method

- (void)presentWithViewController:(UIViewController *)viewController
{
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
//    //修复警告 Snapshotting a view that has not been rendered results in an empty snapshot. Ensure your view has been rendered at least once before snapshotting or snapshot after screen updates.
//    UIViewController* currentVC = [UIViewController yzh_findTopViewController];
//    currentVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    
    switch (self.sourceType) {
        case YZHImagePickerSourceTypeCamera:
        {
            if (self.isCameraAvailable && [self doesCameraSupportTakingPhotos]) {
                controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            } else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"本设备不支持拍照" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
                [alertView show];
                return;
            }
        }
            break;
        case YZHImagePickerSourceTypePhotoLibrary:
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            break;
            
            case YZHImagePickerSourceTypePhotosAlbum:
            controller.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            break;
        default:
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            break;
    }
    //    NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
    //    [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
    //    controller.mediaTypes = mediaTypes;
    controller.delegate = self;
    controller.allowsEditing = YES;
    // 修改导航栏字体颜色.
    [controller.navigationBar setTintColor:[UIColor yzh_backgroundDarkBlue]];
    [viewController presentViewController:controller animated:YES completion:nil];
    
    //    if ([self isPhotoLibraryAvailable]) {
    //        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    //        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //        NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
    //        [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
    //        controller.mediaTypes = mediaTypes;
    //        controller.delegate = self;
    //        [self presentViewController:controller animated:YES completion:^(void) {
    //            NSLog(@"Picker View Controller is presented");
    //        }];
    //    }
    
}

- (void)clean
{
    self.sourceType = YZHImagePickerSourceTypePhotoLibrary;
    self.finishPicking = nil;
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        //        CGRect crop = [[info valueForKey:UIImagePickerControllerCropRect] CGRectValue];
        //        UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        //        BOOL isContained = CGRectContainsRect(CGRectMake(0, 0, originalImage.size.width, originalImage.size.height), crop);
        
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        self.finishPicking ? self.finishPicking(image) : NULL;
    }];
    
    //    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
    //        [picker dismissViewControllerAnimated:YES completion:^{
    //            [info objectForKey:UIImagePickerControllerEditedImage];
    //        }];
    //    } else {
    //        [picker dismissViewControllerAnimated:NO completion:^() {
    //            [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    //        }];
    //    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^(){
        
    }];
}

- (BOOL)isCameraAvailable
{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL)isRearCameraAvailable
{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL)isFrontCameraAvailable
{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL)doesCameraSupportTakingPhotos
{
//    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
    return YES;
}

- (BOOL)isPhotoLibraryAvailable
{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL)canUserPickVideosFromPhotoLibrary
{
//    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    return YES;
}

- (BOOL)canUserPickPhotosFromPhotoLibrary
{
//    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    return YES;
}

- (BOOL)cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType
{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop = YES;
        }
    }];
    return result;
}


@end

