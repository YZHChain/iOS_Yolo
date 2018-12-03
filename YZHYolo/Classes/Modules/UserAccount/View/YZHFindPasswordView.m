//
//  YZHFindPasswordView.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/17.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHFindPasswordView.h"

#import "YZHPublic.h"
#import "UIViewController+YZHTool.h"

@interface YZHFindPasswordView()<UITextFieldDelegate, UITextViewDelegate>



@end

@implementation YZHFindPasswordView

- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    [self setupView];
    
    [self setupNotification];
}

- (void)setupView {
    
    self.backgroundColor = [UIColor yzh_backgroundDarkBlue];
    self.contentMode = UIViewContentModeTop;
    self.contentView.layer.cornerRadius = 5;
    
    UIColor* startColor = [UIColor yzh_colorWithHexString:@"#002E60"];
    UIColor* endColor = [UIColor yzh_colorWithHexString:@"#204D75"];
    CAGradientLayer *layer = [CAGradientLayer new];
    //存放渐变的颜色的数组
    layer.colors = @[(__bridge id)startColor.CGColor, (__bridge id)endColor.CGColor];
    //起点和终点表示的坐标系位置，(0,0)表示左上角，(1,1)表示右下角
    layer.startPoint = CGPointMake(0.0, 0.0);
    layer.endPoint = CGPointMake(1, 0.0);
    
    layer.frame = _topContentView.frame;
    CGRect rect = _topContentView.frame;
    UIView* view = [[UIView alloc] initWithFrame:rect];
    [view.layer addSublayer:layer];
    
    [_topContentView insertSubview:view atIndex:0];
    
    //新版
    
    self.titleLabel.font = [UIFont yzh_commonLightStyleWithFontSize:12];
    self.titleLabel.textColor = [UIColor yzh_sessionCellGray];
    self.titleLabel.text = @"单词之间使用空格隔开";
    
    self.passwordTextView.layer.cornerRadius = 2;
    self.passwordTextView.layer.borderWidth = 1;
    self.passwordTextView.layer.borderColor = [UIColor yzh_separatorLightGray].CGColor;
    self.passwordTextView.layer.masksToBounds = YES;
    self.passwordTextView.delegate = self;
    [self.passwordTextView becomeFirstResponder];
    
    self.nextButton.enabled = NO;
    self.nextButton.layer.cornerRadius = 4;
    self.nextButton.layer.masksToBounds = YES;
    [self.nextButton.titleLabel setFont:[UIFont yzh_commonStyleWithFontSize: 18]];
    self.nextButton.titleLabel.text = @"下一步";
    self.nextButton.titleLabel.textColor = [UIColor whiteColor];
    
    self.tipButton.titleLabel.text = @"手机号码获取密钥?";
    self.tipButton.titleLabel.font = [UIFont yzh_commonFontStyleFontSize:12];
    self.tipButton.titleLabel.textColor = YZHColorRGBAWithRGBA(0, 46, 96, 1);
    
}

- (IBAction)backThePreviousPage:(UIButton *)sender {

    [[UIViewController yzh_findTopViewController].navigationController popViewControllerAnimated:YES];
}

- (void)setupNotification{
 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldEditChanged:) name:UITextFieldTextDidChangeNotification object:nil];
 
}

- (void)textFieldEditChanged:(NSNotification* )notification{
    
    BOOL hasConform = self.accountTextField.text.length >= 11 && self.SMSCodeTextField.text.length >= 4;
    if (hasConform) {
        self.confirmButton.enabled = YES;
    } else {
        self.confirmButton.enabled = NO;
    }
}

#pragma makr -- TextDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([textField isEqual:self.accountTextField]) {
        return  [self checkAccountTextFieldWithinputCharacters:string];
    } else {
        return [self checkSMSCodePasswordTextFieldWithinputCharacters:string];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if (self.passwordTextView.text.length > 0) {
        self.nextButton.enabled = YES;
    } else {
        self.nextButton.enabled = NO;
    }
    
    return YES;
}

#pragma mark -- checkTextField

- (BOOL)checkAccountTextFieldWithinputCharacters:(NSString* )characters{
    
    if (self.accountTextField.text.length >= 15 && characters.length != 0) {
        return NO;
    } else {
        return YES;
    }
}

- (BOOL)checkSMSCodePasswordTextFieldWithinputCharacters:(NSString* )characters{
    
    if (self.SMSCodeTextField.text.length >= 8 && characters.length != 0) {
        return NO;
    } else {
        return YES;
    }
}

@end
