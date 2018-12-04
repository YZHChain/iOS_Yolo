//
//  YZHRegisterView.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/17.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHRegisterView.h"

#import "UIViewController+YZHTool.h"
#import "NSString+YZHTool.h"
@interface YZHRegisterView()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *topContentView;

@end
@implementation YZHRegisterView

- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    [self setupView];
    
    [self setupNotification];
}

- (void)setupView{
    
    self.backgroundColor = [UIColor yzh_backgroundDarkBlue];
    self.contentMode = UIViewContentModeTop;
    self.contentView.layer.cornerRadius = 5;
    
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont yzh_commonFontStyleFontSize:13];
    
    self.registerButton.layer.cornerRadius = 3;
    self.registerButton.layer.masksToBounds = YES;
    [self.registerButton.titleLabel setFont:[UIFont yzh_commonStyleWithFontSize:15]];
    [self.registerButton.titleLabel setTextColor:[UIColor whiteColor]];
    
    self.codeTipLabel.textColor = [UIColor yzh_buttonBackgroundPinkRed];
    self.codeTipLabel.font = [UIFont yzh_commonLightStyleWithFontSize:12];
    self.codeTipLabel.hidden = YES;
    
    self.registerButton.enabled = NO;
    
    self.protocolSlectedButton.selected = NO;
    //
    UIColor* startColor = [UIColor yzh_colorWithHexString:@"#002E60"];
    UIColor* endColor = [UIColor yzh_colorWithHexString:@"#204D75"];
    CAGradientLayer *layer = [CAGradientLayer new];
    //存放渐变的颜色的数组
    layer.colors = @[(__bridge id)startColor.CGColor, (__bridge id)endColor.CGColor];
    //起点和终点表示的坐标系位置，(0,0)表示左上角，(1,1)表示右下角
    layer.startPoint = CGPointMake(0.0, 0.0);
    layer.endPoint = CGPointMake(1, 0.0);
    
//    layer.frame = _topContentView.frame;
//    CGRect rect = _topContentView.frame;
    layer.frame = CGRectMake(0, 0, YZHScreen_Width, 135);
    CGRect rect = CGRectMake(0, 0, YZHScreen_Width, 135);
    UIView* view = [[UIView alloc] initWithFrame:rect];
    [view.layer addSublayer:layer];
    
    [_topContentView insertSubview:view atIndex:0];
}

- (void)setupNotification{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldEditChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}
//根据长度改变注册按钮状态
- (void)textFieldEditChanged:(NSNotification *)notification{
    
    if ([notification.object isKindOfClass:[UITextField class]]){
        
//        BOOL hasPhone = self.phoneTextField.text.length >= 11;
//        BOOL hasCode  = self.codeTextField.text.length >= 4;
//        if (hasCode && hasPhone) {
//            self.confirmButton.enabled = YES;
//        } else {
//            self.confirmButton.enabled = NO;
//        }
        BOOL hasYoloId = self.phoneTextField.text.length >= 4;
        BOOL hasProtocol = self.protocolSlectedButton.isSelected;
        if (hasYoloId && hasProtocol) {
            self.registerButton.enabled = YES;
        } else {
            self.registerButton.enabled = NO;
        }
        //当邀请码输入大于等于 4 时对邀请码进行后台校验.
//        if (self.codeTextField.text.length >= 4) {
//            // 校验邀请码
//            NSDictionary* dic = @{
//                                  @"inviteCode":self.codeTextField.text
//                                  };
//            @weakify(self)
//             [[YZHNetworkService shareService] GETNetworkingResource:PATH_USER_REGISTERED_CHECKINVITECODE params:dic successCompletion:^(id obj) {
//                 @strongify(self)
//                 self.codeTipLabel.hidden = YES;
//                 self.codeTipLabel.text = nil;
//             } failureCompletion:^(NSError *error) {
//                 self.codeTipLabel.hidden = NO;
//                 if (error.domain) {
//                     self.codeTipLabel.text = error.domain;
//                 } else {
//                     self.codeTipLabel.text = @"邀请码输入错误";
//                 }
//             }];
//        }
        if (self.codeTextField.text.length == 0) {
            self.codeTipLabel.hidden = YES;
        }
    }
}
// YOLO ID 限制
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (string.length == 0) {
        return YES;
    }
    if ([textField isEqual:self.phoneTextField]) {
        //开头限制英文.
        if (textField.text.length == 0) {
            if ([string yzh_isLowerBigCaseEnglishChars]) {
                return YES;
            } else {
                return NO;
            }
        }
        BOOL isLegal = [NSString yzh_checkoutStringWithCurrenString:textField.text importString:string standardLength:30];
        if (isLegal) {
            return YES;
        } else {
            return NO;
        }
    } else {
        // 邀请码不做校验
        return YES;
    }

    return YES;
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//
//    if (string.length == 0) {
//        return YES;
//    }
//    if ([textField isEqual:self.phoneTextField]) {
//        if (self.phoneTextField.text.length >= 30) {
//            return NO;
//        }
//    } else {
////        if (self.codeTextField.text.length >= ) {
////            return NO;
////        }
//    }
//
//    return YES;
//}
- (IBAction)backThePreviousPage:(UIButton *)sender {
    
        [[UIViewController yzh_findTopViewController].navigationController popViewControllerAnimated:YES];
}

- (IBAction)gotoLogin:(UIButton *)sender {
    
    [YZHRouter openURL:kYZHRouterLogin info:@{
                                              @"phoneString": self.phoneTextField.text ? self.phoneTextField.text : @""
                                              }];
}

//根据输入框长度和是否选择协议改变注册按钮状态
- (IBAction)selectedProtocol:(UIButton *)sender {
    
    self.protocolSlectedButton.selected = !sender.isSelected;
    BOOL hasYoloId = self.phoneTextField.text.length >= 4;
    BOOL hasProtocol = self.protocolSlectedButton.isSelected;
    if (hasYoloId && hasProtocol) {
        self.registerButton.enabled = YES;
    } else {
        self.registerButton.enabled = NO;
    }
}

@end
