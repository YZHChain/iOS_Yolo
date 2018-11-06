//
//  YZHUserLoginManage.m
//  YZHYolo
//
//  Created by Jersey on 2018/10/11.
//  Copyright © 2018年 YZHChain. All rights reserved.
//  

#import "YZHUserLoginManage.h"

#import "UIViewController+YZHTool.h"
#import "NIMKitFileLocationHelper.h"

static NSString* kYZHIMAccountKey     = @"account";
static NSString* kYZHIMTokenKey       = @"token";
static NSString* kYZHUserPhoneNumberKey = @"phoneNumber";
static NSString* kYZHIMAutoLoginKey   = @"kYZHIMAutoLogin";
static NSString* kYZHIMloginFilePath  = @"YZHIMloginFilePath";

@implementation YZHIMLoginData

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        _account = [aDecoder decodeObjectForKey:kYZHIMAccountKey];
        _token = [aDecoder decodeObjectForKey:kYZHIMTokenKey];
        _isAutoLogin = [[aDecoder decodeObjectForKey:kYZHIMAutoLoginKey] boolValue];
        _phoneNumber = [aDecoder decodeObjectForKey:kYZHUserPhoneNumberKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    if ([_account length]) {
        [encoder encodeObject:_account forKey:kYZHIMAccountKey];
    }
    if ([_token length]) {
        [encoder encodeObject:_token forKey:kYZHIMTokenKey];
    }
    if ([_phoneNumber length]) {
        [encoder encodeObject:_phoneNumber forKey:kYZHUserPhoneNumberKey];
    }
    [encoder encodeObject:@(self.isAutoLogin) forKey:kYZHIMAutoLoginKey];
    
}
//默认写入 YES
- (BOOL)isAutoLogin {

    return YES;
}

- (NSString *)phoneNumber {
    
    if (!_phoneNumber) {
        _phoneNumber = @"18888888888";
    }
    return _phoneNumber;
}

@end

@interface YZHUserLoginManage()

@property (nonatomic,copy) NSString *filepath;

@end

@implementation YZHUserLoginManage

#pragma mark -- init

+ (instancetype)sharedManager
{
    static YZHUserLoginManage *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *filepath = [[NIMKitFileLocationHelper getAppDocumentPath] stringByAppendingPathComponent:kYZHIMloginFilePath];
        instance = [[YZHUserLoginManage alloc] initWithPath:filepath];
    });
    return instance;
}

- (instancetype)initWithPath:(NSString* )filePath {
    
    if (self = [super init]) {
        _filepath = filePath;
        [self readData];
    }
    return self;
}

#pragma mark -- read write
//TODO:从文件中读取和保存用户名密码,建议上层开发对这个地方做加密. 对账号密码进行加密
- (void)readData {
    
    NSString *filepath = self.filepath;
    if ([[NSFileManager defaultManager] fileExistsAtPath:filepath])
    {
        id object = [NSKeyedUnarchiver unarchiveObjectWithFile:filepath];
        _currentLoginData = [object isKindOfClass:[YZHIMLoginData class]] ? object : nil;
    } else {
        
    }
    
}

- (void)saveData
{
    NSData *data = [NSData data];
    if (_currentLoginData)
    {
        data = [NSKeyedArchiver archivedDataWithRootObject:_currentLoginData];
    }
    [data writeToFile:[self filepath] atomically:YES];
}

#pragma mark -- AutoLogin
//检测是否存在登录信息
- (void)executeLogincheckout {
    // 如果当前存在账号,进一步判断
    BOOL hasLastLoginDate = [self checkoutAccountAndPassword];
    if (hasLastLoginDate) {
        // 检测是否要执行自动登录, 默认值是 YES.
        [self chckoutAutoLogin];
    } else {
        [self executeHandInputLogin];
    }
}
//检测上次保存的登录信息
- (BOOL)checkoutAccountAndPassword {
    
    if (self.currentLoginData) {
        NSString* IMAccount = self.currentLoginData.account;
        NSString* IMToken   = self.currentLoginData.token;
        //只检测账号密码是否存在即可
        BOOL hasAccount  = YZHIsString(IMAccount);
        BOOL hasPassword = YZHIsString(IMToken);
        if (hasAccount && hasPassword) {
            return YES;
        } else {
            return NO;
        }
    } else {
        return NO;
    }
}
//检测是否设置自动登录
- (void)chckoutAutoLogin {
    // 上层已检测过账号密码, 这里只需要校验是否需要自动登录即可.
    BOOL hasSettingAutoLogin = self.currentLoginData.isAutoLogin;
    if (hasSettingAutoLogin) {
        [self executeAutoLogin];
    } else {
        // 跳转至登录页
        [self executeHandInputLogin];
    }
}
//执行自动登录
- (void)executeAutoLogin {

    NIMAutoLoginData *loginData = [[NIMAutoLoginData alloc] init];
    loginData.account = self.currentLoginData.account;
    loginData.token = self.currentLoginData.token;
    [[[NIMSDK sharedSDK] loginManager] autoLogin:loginData];
    
    id LogintSucceedVC = [[NSClassFromString(@"YZHRootTabBarViewController") alloc] init];
    [UIViewController yzh_animationReplaceRootViewController:LogintSucceedVC];
}

- (void)executeHandInputLogin {
    
    // 减少文件 improt 使用映射方式初始化.
    id loginVC = [[NSClassFromString(@"YZHLoginVC") alloc] init];
    UINavigationController* YZHBaseNavigationController = [(UINavigationController* )([NSClassFromString(@"YZHBaseNavigationController") alloc]) initWithRootViewController:loginVC];
    YZHBaseNavigationController.navigationBar.hidden = YES;
    // 切换为根控制器.
    [UIViewController yzh_animationReplaceRootViewController:YZHBaseNavigationController];
}

#pragma mark -- Hand Imput Login

- (void)userLoginWithView:(UIView *)view Account:(NSString *)account andPassword:(NSString *)password successCompletion:(YZHVoidBlock)successCompletion failureCompletion:(YZHErrorBlock)failureCompletion {
    
    NSDictionary* parameter = @{@"account"  :account,
                                @"password" :password
                                };

    @weakify(self)
    [[YZHNetworkService shareService] POSTNetworkingResource:PATH_USER_LOGIN_LOGINVERIFY params:parameter successCompletion:^(id obj) {
        @strongify(self)
        [self serverloginSuccessWithResponData:obj successCompletion:successCompletion failureCompletion:failureCompletion];
    } failureCompletion:^(NSError *error) {
        //TODO: 失败处理
        failureCompletion ? failureCompletion(error) : NULL;
    }];
}

// 后台登录成功处理
- (void)serverloginSuccessWithResponData:(id)responData successCompletion:(YZHVoidBlock)successCompletion failureCompletion:(YZHErrorBlock)failureCompletion {
    // 缓存.
    YZHLoginModel* userLoginModel = [YZHLoginModel YZH_objectWithKeyValues:responData];
    NSString* account = userLoginModel.acctId;
    NSString* token = userLoginModel.token;
    [self IMServerLoginWithAccount:account token:token userLoginModel:userLoginModel successCompletion:successCompletion failureCompletion:failureCompletion];
}
// 请求登录云信
- (void)IMServerLoginWithAccount:(NSString *)account token:(NSString *)token userLoginModel:(YZHLoginModel* )userLoginModel successCompletion:(YZHVoidBlock)successCompletion failureCompletion:(YZHErrorBlock)failureCompletion {
    
    // 请求登录云信.
    [[[NIMSDK sharedSDK] loginManager] login:account token:token completion:^(NSError * _Nullable error) {
        if (error == nil) {
            successCompletion ? successCompletion() : NULL;
            [self IMServerLoginSuccessWithAccount:account token:token userLoginModel:userLoginModel];
        } else {
            // 错误提示 TODO:
            failureCompletion ? failureCompletion(error) : NULL;
        }
    }];
}

// 网易IM信登录成功处理
- (void)IMServerLoginSuccessWithAccount:(NSString *)account token:(NSString *)token userLoginModel:(YZHLoginModel* )userLoginModel {
    //暂时先到主要,后面还需要加上从云信获取信息的逻辑
    [UIViewController yzh_userLoginSuccessToHomePage];
    
    //TODO:开启子线程异步执行保存登录数据.
    YZHIMLoginData* currentLoginData = [[YZHIMLoginData alloc] init];
    currentLoginData.account = account;
    currentLoginData.token = token;
    currentLoginData.isAutoLogin = YES;
    currentLoginData.phoneNumber = userLoginModel.phone;
    // 赋值, 并且保存.
    self.currentLoginData = currentLoginData;
}

#pragma mark -- Set Get

- (NSString *)filepath {
    
    if (!_filepath) {
        _filepath = kYZHIMloginFilePath;
    }
    return _filepath;
}

- (void)setCurrentLoginData:(YZHIMLoginData *)currentLoginData {

    _currentLoginData = currentLoginData;
    [self saveData];
}

@end
