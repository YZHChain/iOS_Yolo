//
//  YZHMyInformationYoloIDVC.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/23.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHMyInformationYoloIDVC.h"

#import "NSString+YZHTool.h"
#import "YZHUserModelManage.h"
#import "YZHPublic.h"
#import "YZHUserLoginManage.h"
#import "YZHAlertManage.h"

@interface YZHMyInformationYoloIDVC ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *yoloIDTextField;
@property (weak, nonatomic) IBOutlet UILabel *remindLabel;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;
@property (weak, nonatomic) IBOutlet UIImageView *checkResultImageView;
@property (weak, nonatomic) IBOutlet UILabel *checkResultLabel;
@property (weak, nonatomic) IBOutlet UIView *checkResultView;
@property (nonatomic, strong) YZHUserInfoExtManage* userInfoExt;
@property (nonatomic, assign) BOOL hasSetting;
@property (nonatomic, strong) NSString* phoneNum;


@end

@implementation YZHMyInformationYoloIDVC

#pragma mark - 1.View Controller Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //1.设置导航栏
    [self setupNavBar];
    //2.设置view
    [self setupView];
    //4.设置通知
    [self setupNotification];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
}

#pragma mark - 2.SettingView and Style

- (void)setupNavBar
{
    self.navigationItem.title = @"设置 YOLO号";
    self.hideNavigationBarLine = YES;
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveSetting)];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]} forState:UIControlStateNormal];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor yzh_separatorLightGray]} forState:UIControlStateDisabled];
    item.enabled = NO;
    self.navigationItem.rightBarButtonItem = item;
}

- (void)setupView
{
    self.view.backgroundColor = [UIColor yzh_backgroundThemeGray];
    
    self.yoloIDTextField.returnKeyType = UIReturnKeyDone;
    [self.yoloIDTextField becomeFirstResponder];
    
    self.remindLabel.text = @"请注意:\nyolo号支持英文大小写、数字和特殊字符，必须是英文开头 且仅可设置一次，设置后不能再更改.";
    self.checkResultView.hidden = YES;
    
}

- (void)reloadView
{
    
}

#pragma mark - 3.Request Data

#pragma mark - 4.UITableViewDataSource and UITableViewDelegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (string.length == 0) {
        self.checkResultView.hidden = YES;
        self.navigationItem.rightBarButtonItem.enabled = NO;
        return YES;
    }
    if ([string isEqualToString:@"_"] || [string yzh_isSpecialChars]) {
    } else {
        return NO;
    }
    BOOL isLegal = [NSString yzh_checkoutStringWithCurrenString:textField.text importString:string standardLength:30];
    if (isLegal) {
        self.checkResultView.hidden = YES;
        self.navigationItem.rightBarButtonItem.enabled = NO;
        return YES;
    }
    return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self checkoutYoloID:nil];
    return YES;
}

#pragma mark - 5.Event Response

- (void)saveSetting {

    YZHUserInfoExtManage* userInfoExt = [YZHUserInfoExtManage currentUserInfoExt];
    userInfoExt.userYolo.yoloID = self.yoloIDTextField.text;
    YZHProgressHUD* hud = [YZHProgressHUD showLoadingOnView:self.view text:nil];
    if (!userInfoExt.userYolo.hasSetting) {
        NSDictionary* dic;
        if (YZHIsString(self.phoneNum)) {
            dic = @{
                                  @"phoneNum":self.phoneNum,
                                  @"yoloNo": self.yoloIDTextField.text
                                  };
        }
        @weakify(self)
        [[YZHNetworkService shareService] POSTNetworkingResource:PATH_USER_UPDATELOGIN params:dic successCompletion:^(NSObject* obj) {
            @strongify(self)
            if (obj.yzh_apiEmptyValue) {
              //使用后台返回数据去通知云信修改.
                [self updateYoloIDWithYoloID:nil HUD:hud];
            } else {
              //通知云信修改
                NSString* yoloID = (NSString* )obj;
                [self updateYoloIDWithYoloID:yoloID HUD:hud];
            }
            
        } failureCompletion:^(NSError *error) {
            [hud hideWithText:error.domain];
        }];
        
    } else {
        [hud hideWithText:@"已设置过,无法重新设置"];
    }
}

- (void)updateYoloIDWithYoloID:(NSString *)yoloID HUD:(YZHProgressHUD* )hud {
    
    if (YZHIsString(yoloID)) {
        self.userInfoExt.userYolo.yoloID = yoloID;
        self.userInfoExt.userYolo.hasSetting = YES;
        NSString* userInfoExtString = [self.userInfoExt userInfoExtString];
        if (YZHIsString(userInfoExtString)) {
            [[NIMSDK sharedSDK].userManager updateMyUserInfo:@{
                                                               @(NIMUserInfoUpdateTagExt): userInfoExtString
                                                               } completion:^(NSError * _Nullable error) {
                                                                   if (!error) {
                                                
                                                    [hud hideWithText:[NSString stringWithFormat:@"已设置过,无法重新设置,当前ID为:%@", yoloID]];
                                                                       self.yoloIDTextField.text = yoloID;
                                                                   } else {
                                                                       [hud hideWithText:@"修改失败"];
                                                                   }
                                                               }];
        } else {
            // 解析错误
            [YZHProgressHUD showText:@"客户端数据解析错误" onView:self.view];
        }
    } else {
        self.userInfoExt.userYolo.yoloID = self.yoloIDTextField.text;
        self.userInfoExt.userYolo.hasSetting = YES;
        NSString* userInfoExtString = [self.userInfoExt userInfoExtString];
        if (YZHIsString(userInfoExtString)) {
            [[NIMSDK sharedSDK].userManager updateMyUserInfo:@{
                                                               @(NIMUserInfoUpdateTagExt): userInfoExtString
                                                               } completion:^(NSError * _Nullable error) {
                                                                   if (!error) {
                                                                       [hud hideWithText:@"修改成功"];
                                                                   } else {
                                                                       [hud hideWithText:@"修改失败"];
                                                                   }
                                                               }];
        } else {
            // 解析错误
            [YZHProgressHUD showText:@"客户端数据解析错误" onView:self.view];
        }
    }
}

- (IBAction)checkoutYoloID:(UIButton *)sender {
    
    if (YZHIsString(self.yoloIDTextField.text)) {
        self.checkResultView.hidden = NO;
        NSDictionary* dic = @{
                              @"yoloNo":self.yoloIDTextField.text.length ? self.yoloIDTextField.text : @""
                              };
        @weakify(self)
        [[YZHNetworkService shareService] POSTNetworkingResource:PATH_USER_CHECKOUTYOLOID params:dic successCompletion:^(id obj) {
            @strongify(self)
            self.checkResultImageView.image = [UIImage imageNamed:@"my_information_setYoloID_correct"];
            self.checkResultLabel.text = @"YOLO号可以正常使用";
            self.navigationItem.rightBarButtonItem.enabled = YES;
        } failureCompletion:^(NSError *error) {
            self.checkResultImageView.image = [UIImage imageNamed:@"my_information_setYoloID_fault"];
            self.checkResultLabel.text = error.domain;
        }];
    } else {
        [YZHAlertManage showAlertMessage:@"Yolo ID不可为空,请重新输入"];
    }

}

#pragma mark - 6.Private Methods

- (void)setupNotification
{
    
}

#pragma mark - 7.GET & SET

- (YZHUserInfoExtManage *)userInfoExt {
    
    if (!_userInfoExt) {
        _userInfoExt = [YZHUserInfoExtManage currentUserInfoExt];
    }
    return _userInfoExt;
}

- (BOOL)hasSetting {
    
    return self.userInfoExt.userYolo.hasSetting;
}

- (NSString *)phoneNum {
    
    if (!_phoneNum) {
        YZHUserLoginManage* manage = [YZHUserLoginManage sharedManager];
        YZHIMLoginData* userData = manage.currentLoginData;
        _phoneNum = userData.phoneNumber;
    }
    return _phoneNum;
}
@end
