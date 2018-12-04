//
//  YZHReadPasswordView.h
//  YZHYolo
//
//  Created by Jersey on 2018/12/4.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YZHReadPasswordView : UIView
@property (weak, nonatomic) IBOutlet UITextField *accountPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;
@property (weak, nonatomic) IBOutlet UIButton *tipButton;

@end

NS_ASSUME_NONNULL_END
