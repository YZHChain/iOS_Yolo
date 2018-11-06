//
//  YZHMyCenterHeaderView.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/19.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHMyCenterHeaderView.h"

#import "UIImageView+YZHImage.h"
#import "YZHUserLoginManage.h"
@interface YZHMyCenterHeaderView()

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userYoloIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumLabel;
@property (weak, nonatomic) IBOutlet UIImageView *QRCodeImageView;

@end

@implementation YZHMyCenterHeaderView {
    YZHIMLoginData* _userLoginModel;
}

- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    [self setupView];
    
    YZHUserLoginManage* manage = [YZHUserLoginManage sharedManager];
    _userLoginModel = manage.currentLoginData;
}

- (void)setupView{
    
}

- (IBAction)clickHeader:(UIButton *)sender {
    
    self.executeHeaderBlock ? self.executeHeaderBlock(sender) : NULL;
}


- (IBAction)clickQRCode:(UIButton *)sender {
    
    self.executeQRCodeBlock ? self.executeQRCodeBlock(sender) : NULL;
}

- (void)setUserModel:(YZHUserDetailsModel *)userModel {
    
    _userModel = userModel;
    NIMUser* user = [userModel userIMData];
    NSString* avatarUrl = userModel.hasPhotoImage ? user.userInfo.avatarUrl : @"my_cover_headPhoto_default";
    NSString* nickName = userModel.hasNickName ? user.userInfo.nickName : @"Yolo用户";

    self.nickNameLabel.text = nickName;
    if (userModel.hasPhotoImage) {
        [self.photoImageView yzh_setImageWithString:avatarUrl];
        CGFloat radius = self.photoImageView.size.height / 2;
        [self.photoImageView yzh_cornerRadiusAdvance:radius rectCornerType:UIRectCornerAllCorners];
    }
    if (YZHIsString(userModel.yoloID)) {
        self.userYoloIDLabel.text = [NSString stringWithFormat:@"%@%@",self.userYoloIDLabel.text, userModel.yoloID];
    }
    if (YZHIsString(_userLoginModel.phoneNumber)) {
        self.phoneNumLabel.text = [NSString stringWithFormat:@"%@%@",self.phoneNumLabel.text, _userLoginModel.phoneNumber];
    }

}

@end
