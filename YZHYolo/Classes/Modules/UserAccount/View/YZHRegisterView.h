//
//  YZHRegisterView.h
//  YZHYolo
//
//  Created by Jersey on 2018/9/17.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YZHRegisterView : UIView

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField; // YOLO ID
@property (weak, nonatomic) IBOutlet UITextField *codeTextField; //邀请码
@property (weak, nonatomic) IBOutlet UILabel *codeTipLabel; // 邀请码输入校验提示

@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UIButton *getCodeButton;
@property (weak, nonatomic) IBOutlet UIButton *backIconButton;
@property (weak, nonatomic) IBOutlet UIButton *backTextButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *protocolLabel;
@property (weak, nonatomic) IBOutlet UIButton *protocolSlectedButton;
@property (weak, nonatomic) IBOutlet UIButton *protocolButton;

@end
