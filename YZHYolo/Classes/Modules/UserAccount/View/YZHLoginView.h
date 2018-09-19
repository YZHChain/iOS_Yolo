//
//  YZHLoginView.h
//  YZHYolo
//
//  Created by Jersey on 2018/9/17.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YZHLoginView : UIView<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIButton *findPasswrodButton;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@end
