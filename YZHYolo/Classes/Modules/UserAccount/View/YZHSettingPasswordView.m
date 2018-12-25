//
//  YZHSettingPasswordView.m
//  YZHYolo
//
//  Created by 😘王艳 on 2018/9/18.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHSettingPasswordView.h"

#import "NSString+YZHTool.h"
#import "UIViewController+YZHTool.h"
@interface YZHSettingPasswordView()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *topContentView;

@end

@implementation YZHSettingPasswordView

- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    [self setupView];
    
    [self setupNotification];
}

- (void)setupView{
    
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
    
    self.confirmButton.layer.cornerRadius = 4;
    self.confirmButton.layer.masksToBounds = YES;
    
    [_topContentView insertSubview:view atIndex:0];
    
}

- (IBAction)backThePreviousPage:(UIButton *)sender {
    
    [[UIViewController yzh_findTopViewController].navigationController popViewControllerAnimated:YES];
}

- (void)setupNotification{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldEditChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)textFieldEditChanged:(NSNotification* )notification{

    BOOL startingTest = (self.passwordTextField.text.length >= 6 && self.confirmPasswordTextField.text.length >= 6);
    BOOL checkpasswordIndex = self.passwordTextField.text.length >= 6;
//    BOOL checkConfirmIndex = self.confirmPasswordTextField.text.length >= 6;
    if (checkpasswordIndex) {
        [self checkPasswordTextSecurityIndex];
        if (startingTest) {
            BOOL checkPasswordStatus = [self.passwordTextField.text isEqualToString:self.confirmPasswordTextField.text];
            UIImage* checkImage;
            if (checkPasswordStatus) {
                checkImage = [UIImage imageNamed:@"password_status_correct"];
                self.confirmButton.enabled = YES;
            } else {
                checkImage = [UIImage imageNamed:@"password_status_error"];
                self.confirmButton.enabled = NO;
            }
            self.checkStatusImageView.image = checkImage;
        } else {
            self.confirmButton.enabled = NO;
            self.checkStatusImageView.image = nil;
        }
    } else {
        self.securityIndexView.hidden = YES;
        self.confirmButton.enabled = NO;
        self.checkStatusImageView.image = nil;
    }

}

#pragma makr -- TextDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([textField isEqual:self.passwordTextField]) {
        return  [self checkPasswordTextFieldWithinputCharacters:string];
    } else {
        return [self checkConfirmPasswordTextFieldWithinputCharacters:string];
    }
}

#pragma mark -- checkPasswordTextField

- (void)checkPasswordTextSecurityIndex{
    
    // 先判断是否都是一种类型数字 或 英文
    UIColor* statusColor;
    NSString* statusTypeString;
    NSString* passwordText = self.passwordTextField.text;
    if ([passwordText yzh_isNumberChars] || [passwordText yzh_isLowercaseEnglishChars]) {
        statusColor  = YZHColorWithRGB(85, 195, 158);
        statusTypeString = @"弱";
    } else if ([passwordText yzh_isSpecialChars]) {
        statusColor  = YZHColorWithRGB(236, 198, 78);
        statusTypeString = @"中";
    } else {
        statusColor  = YZHColorWithRGB(225, 44, 68);
        statusTypeString = @"强";
    }
    self.securityIndexView.backgroundColor = statusColor;
    self.securityIndexLable.text = statusTypeString;
    self.securityIndexView.hidden = NO;
}

- (BOOL)checkPasswordTextFieldWithinputCharacters:(NSString* )characters{
    
    if (self.passwordTextField.text.length >= 18 && characters.length != 0) {
        return NO;
    }
    return YES;
}

-(BOOL)checkConfirmPasswordTextFieldWithinputCharacters:(NSString* )characters{
    if (self.confirmPasswordTextField.text.length >= 18 && characters.length != 0) {
        return NO;
    }
    return YES;
}


@end
