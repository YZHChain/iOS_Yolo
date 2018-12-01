//
//  YZHMyInformationPhotoVC.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/22.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHMyInformationPhotoVC.h"

#import "YZHPhotoManage.h"
#import "UIButton+YZHTool.h"
#import "NIMKitFileLocationHelper.h"
#import "UIView+Toast.h"
//#import "NIMGlobalDefs.h"
//#import "NIMResourceManagerProtocol.h"
#import "UIImage+NIMKit.h"
#import "UIImageView+YZHImage.h"

static NSArray* buttonArray;
@interface YZHMyInformationPhotoVC ()<NIMUserManagerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *savePhotoButton;
@property (weak, nonatomic) IBOutlet UIButton *callPhotoButton;
@property (weak, nonatomic) IBOutlet UIButton *callCameraButton;

@end

@implementation YZHMyInformationPhotoVC

#pragma mark - 1.View Controller Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //1.设置导航栏
    [self setupNavBar];
    //2.设置view
    [self setupView];
    //3.请求数据
    [self setupData];
    //4.设置通知
    [self setupNotification];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
}

#pragma mark - 2.SettingView and Style

- (void)setupNavBar
{
    self.navigationItem.title = @"头像";
    self.hideNavigationBarLine = YES;
}

- (void)setupView
{
    self.view.backgroundColor = [UIColor yzh_backgroundDarkBlue];
    
    [self.callCameraButton yzh_setBackgroundColor:[UIColor yzh_backgroundThemeGray] forState:UIControlStateHighlighted];
    [self.callPhotoButton yzh_setBackgroundColor:[UIColor yzh_backgroundThemeGray] forState:UIControlStateHighlighted];
    [self.savePhotoButton yzh_setBackgroundColor:[UIColor yzh_backgroundThemeGray] forState:UIControlStateHighlighted];
    
    NIMUser* user = [[NIMSDK sharedSDK].userManager userInfo:[NIMSDK sharedSDK].loginManager.currentAccount];
    [self.photoImageView yzh_setImageWithString:user.userInfo.avatarUrl placeholder:@"my_myinformationShow_headPhoto_default"];
    
}

- (void)reloadView
{
    
}

#pragma mark - 3.Request Data

- (void)setupData
{
    
}

#pragma mark - 4.UITableViewDataSource and UITableViewDelegate

#pragma mark - 5.Event Response

- (IBAction)useCameraPictures:(UIButton *)sender {
    
    sender.backgroundColor = [UIColor whiteColor];
    @weakify(self)
    [YZHPhotoManage presentWithViewController:self sourceType:YZHImagePickerSourceTypeCamera finishPicking:^(UIImage * _Nonnull image) {
        @strongify(self)
        self.photoImageView.image = image;
        [self updatePhotoToIMDataWithImage:image];
    }];
}

- (IBAction)callMobilePhoto:(UIButton *)sender {
    
    sender.backgroundColor = [UIColor whiteColor];
    @weakify(self)
    [YZHPhotoManage presentWithViewController:self sourceType:YZHImagePickerSourceTypePhotoLibrary finishPicking:^(UIImage * _Nonnull image) {
        @strongify(self)
        self.photoImageView.image = image;
        [self updatePhotoToIMDataWithImage:image];
    }];
    
}

- (IBAction)performbSavePhoto:(UIButton *)sender {
    
    [self saveImageToPhotos:self.photoImageView.image];
}

- (void)highlightedBackground:(UIButton *)sender {
    

}


#pragma mark - 6.Private Methods

- (void)setupNotification
{
    
}

- (void)updatePhotoToIMDataWithImage:(UIImage* )image {
    
    UIImage *imageForAvatarUpload = [image nim_imageForAvatarUpload];
    NSString *fileName = [NIMKitFileLocationHelper genFilenameWithExt:@"jpg"];
    NSString *filePath = [[NIMKitFileLocationHelper getAppDocumentPath] stringByAppendingPathComponent:fileName];
    NSData *data = UIImageJPEGRepresentation(imageForAvatarUpload, 1.0);
    BOOL success = data && [data writeToFile:filePath atomically:YES];
    @weakify(self)
    if (success) {
        
        [SVProgressHUD show];
        [[NIMSDK sharedSDK].resourceManager upload:filePath progress:nil completion:^(NSString *urlString, NSError *error) {
            [SVProgressHUD dismiss];
            @strongify(self)
            if (!error && self) {
                [[NIMSDK sharedSDK].userManager updateMyUserInfo:@{@(NIMUserInfoUpdateTagAvatar):urlString} completion:^(NSError *error) {
                    if (!error) {
                        //                        [[NTESRedPacketManager sharedManager] updateUserInfo];
                        [[SDWebImageManager sharedManager] saveImageToCache:imageForAvatarUpload forURL:[NSURL URLWithString:urlString]];
                        //                        [wself refresh];
                    } else {
                        [self.view makeToast:@"设置头像失败，请重试"
                                     duration:2
                                     position:CSToastPositionCenter];
                    }
                }];
            } else {
                [self.view makeToast:@"图片上传失败，请重试"
                             duration:2
                             position:CSToastPositionCenter];
            }
        }];
    } else {
        [self.view makeToast:@"图片保存失败，请重试"
                    duration:2
                    position:CSToastPositionCenter];
    }
}

- (void)saveImageToPhotos:(UIImage*)savedImage {
    // TODO: 先检查设备是否授权访问相册
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error == nil) {
        [self.view makeToast:@"图片已经保存到相册"
                    duration:1
                    position:CSToastPositionCenter];
    }else{
        [self.view makeToast:@"图片保存失败,请重试"
                    duration:1
                    position:CSToastPositionCenter];
    }
}



#pragma mark - 7.GET & SET

@end
