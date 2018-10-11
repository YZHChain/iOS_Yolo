//
//  YZHWelcomeView.h
//  YZHYolo
//
//  Created by Jersey on 2018/9/17.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YZHWelcomeView : UIView

@property (nonatomic, copy) YZHButtonExecuteBlock regesterButtonBlock;
@property (nonatomic, copy) YZHButtonExecuteBlock loginButtonBlock;
@property (weak, nonatomic) IBOutlet UIView *bannerView;
@property (weak, nonatomic) IBOutlet UIView *LoginRigesterView;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

@end
