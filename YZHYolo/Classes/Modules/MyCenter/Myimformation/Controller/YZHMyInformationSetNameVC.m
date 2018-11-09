//
//  YZHMyInformationSetNameVC.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/23.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHMyInformationSetNameVC.h"

#import "YZHPublic.h"
#import "NIMKitDataProviderImpl.h"
#import "NSString+YZHTool.h"

@interface YZHMyInformationSetNameVC ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nickNameTextField;
@property (nonatomic, strong) NIMUserInfo* userInfo;

@end

@implementation YZHMyInformationSetNameVC

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

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
}

#pragma mark - 2.SettingView and Style

- (void)setupNavBar
{
    self.navigationItem.title = @"设置昵称";
    self.hideNavigationBarLine = YES;
    
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveNickName)];

    self.navigationItem.rightBarButtonItem = item;
}

- (void)setupView
{
    self.view.backgroundColor = [UIColor yzh_backgroundThemeGray];
    
    [self.nickNameTextField becomeFirstResponder];
}

- (void)reloadView
{
    
}

#pragma mark - 3.Request Data

- (void)setupData
{
    if (YZHIsString(self.userInfo.nickName)) {
        self.nickNameTextField.text = _userInfo.nickName;
    } else {
        self.nickNameTextField.text = @"Yolo用户";
    }
}

#pragma mark - 4.UITableViewDataSource and UITableViewDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSLog(@"将要输入代理方法");
    if (string.length == 0) {
        return YES;
    } else {
       return [NSString yzh_checkoutStringWithCurrenString:textField.text importString:string standardLength:20];
    }
    
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    return YES;
}

#pragma mark - 5.Event Response

- (void)saveNickName{
    
    if (![self.nickNameTextField.text isEqualToString:_userInfo.nickName]) {
        YZHProgressHUD* hud = [YZHProgressHUD showLoadingOnView:self.view text:nil];
        @weakify(self)
        [[NIMSDK sharedSDK].userManager updateMyUserInfo:@{@(NIMUserInfoUpdateTagNick) : self.nickNameTextField.text} completion:^(NSError *error) {
            @strongify(self)
            if (!error) {
                [hud hideWithText:@"昵称修改成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [hud hideWithText:error.domain];
            }
        }];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }

}

#pragma mark - 6.Private Methods

- (void)setupNotification
{
    
}

#pragma mark - 7.GET & SET

-(NIMUserInfo *)userInfo {
    
    if (!_userInfo) {
        NIMUser *user = [[NIMSDK sharedSDK].userManager userInfo: [NIMSDK sharedSDK].loginManager.currentAccount];
        _userInfo = user.userInfo;
    }
    return _userInfo;
}
@end
