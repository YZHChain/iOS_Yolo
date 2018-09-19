//
//  YZHSettingPasswordView.h
//  YZHYolo
//
//  Created by 😘王艳 on 2018/9/18.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YZHSettingPasswordView : UIView

@property (weak, nonatomic) IBOutlet UILabel *tileTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *navigationTitleLaebl;

@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;
@property (weak, nonatomic) IBOutlet UIImageView *checkStatusImageView;
@property (weak, nonatomic) IBOutlet UIView *securityIndexView;
@property (weak, nonatomic) IBOutlet UILabel *securityIndexLabel;

@end
