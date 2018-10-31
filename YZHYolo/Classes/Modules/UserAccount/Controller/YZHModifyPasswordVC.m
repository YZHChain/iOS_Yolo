//
//  YZHModifyPasswordVC.m
//  YZHYolo
//
//  Created by Jersey on 2018/10/15.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHModifyPasswordVC.h"

#import "YZHPublic.h"
#import "NSString+YZHTool.h"
#import "UIButton+YZHCountDown.h"

@interface YZHModifyPasswordVC ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *sendVerifyCodeButton;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scorllView;
@property (weak, nonatomic) IBOutlet UIButton *modifyTypeButton;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *modifyTypeTextField;
@property (weak, nonatomic) IBOutlet UIImageView *checkStatusImageView;
@property (weak, nonatomic) IBOutlet UIView *securityIndexView;
@property (weak, nonatomic) IBOutlet UILabel *securityIndexLable;
@property (nonatomic, assign) YZHModifyPasswordType currentType;

@end

@implementation YZHModifyPasswordVC

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

#pragma mark - 2.SettingView and Style

- (void)setupNavBar {
    self.navigationItem.title = @"修改密码";
}

- (void)setupView {
    
    self.view.backgroundColor = [UIColor yzh_backgroundThemeGray];
    
    self.currentType = YZHModifyPasswordTypeOriginalPW;
    [self.modifyTypeButton setTitle:@"原密码" forState:UIControlStateNormal];
    self.confirmButton.layer.cornerRadius = 4;
    self.confirmButton.layer.masksToBounds = YES;
    self.confirmButton.enabled = NO;
    self.sendVerifyCodeButton.hidden = YES;
    
    self.passwordTextField.delegate = self;
    self.confirmPasswordTextField.delegate = self;
    
    UITapGestureRecognizer *sigleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickBackView)];
    
    [_scorllView addGestureRecognizer:sigleTapRecognizer];
    
}

- (void)reloadView {
    
}

#pragma mark - 3.Request Data

- (void)setupData {
    
}

#pragma mark - 4.UITableViewDataSource and UITableViewDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([textField isEqual:self.passwordTextField]) {
        return  [self checkPasswordTextFieldWithinputCharacters:string];
    } else {
        return [self checkConfirmPasswordTextFieldWithinputCharacters:string];
    }
}

#pragma mark - 5.Event Response

-(void)clickBackView
{
    [_scorllView endEditing:YES];
}

- (IBAction)executeModification:(UIButton *)sender {
    
    if (self.currentType == YZHModifyPasswordTypeOriginalPW) {
    }
}

- (IBAction)sendVerifyCode:(UIButton *)sender {
    
    [sender yzh_startWithTime:60 title:sender.currentTitle countDownTitle:nil mainColor:nil countColor:nil];
}


- (IBAction)switchModifyPasswordType:(UIButton *)sender {
    
    if ([sender.titleLabel.text isEqualToString:@"原密码"]) {
        [sender setTitle:@"验证码" forState:UIControlStateNormal];
        self.currentType = YZHModifyPasswordTypePhone;
        self.modifyTypeTextField.placeholder = @"验证码";
        self.sendVerifyCodeButton.hidden = NO;
    } else {
        [sender setTitle:@"原密码" forState:UIControlStateNormal];
        self.currentType = YZHModifyPasswordTypeOriginalPW;
        self.modifyTypeTextField.placeholder = @"原密码";
        self.sendVerifyCodeButton.hidden = YES;
    }
    [sender layoutIfNeeded];
}


#pragma mark - 6.Private Methods

- (void)setupNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldEditChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)textFieldEditChanged:(NSNotification* )notification{
    
    //确认按钮检测规则: 验证码或密码输入大于等于 4 个字符.账号与密码大于等于 6 个字符。
    //密码强度检测规则: 新密码输入超过大于等于 6 个字符。否则隐藏掉.
    BOOL startingTest = (self.passwordTextField.text.length >= 6 && self.confirmPasswordTextField.text.length >= 6 && self.modifyTypeTextField.text.length >= 4);
    BOOL checkpasswordIndex = self.passwordTextField.text.length >= 6;
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
