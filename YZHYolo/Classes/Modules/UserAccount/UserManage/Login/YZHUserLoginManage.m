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
#import "NIMLoginClient.h"
#import "YZHStartInfo.h"

static NSString* kYZHIMAccountKey     = @"account";
static NSString* kYZHIMTokenKey       = @"token";
static NSString* kYZHIMYoloNoKey       = @"yoloId";
static NSString* kYZHServerUserIdKey       = @"userId"; //
static NSString* kYZHServerUserWordKey       = @"mnemonicWord"; // 助记词
static NSString* kYZHUserPhoneNumberKey = @"phoneNumber";
static NSString* kYZHIMAutoLoginKey   = @"kYZHIMAutoLogin";
static NSString* kYZHIMloginFilePath  = @"YZHIMloginFilePath";
static NSString* kYZHUserAccountKey   = @"userAccount";

@implementation YZHIMLoginData

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        _account      = [aDecoder decodeObjectForKey:kYZHIMAccountKey];
        _token        = [aDecoder decodeObjectForKey:kYZHIMTokenKey];
        _yoloId       = [aDecoder decodeObjectForKey:kYZHIMYoloNoKey];
        _userId       = [aDecoder decodeObjectForKey:kYZHServerUserIdKey];
        _isAutoLogin  = [[aDecoder decodeObjectForKey:kYZHIMAutoLoginKey] boolValue];
        _mnemonicWord = [aDecoder decodeObjectForKey:kYZHServerUserWordKey];
        _phoneNumber  = [aDecoder decodeObjectForKey:kYZHUserPhoneNumberKey];
        _userAccount  = [aDecoder decodeObjectForKey:kYZHUserAccountKey];
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
    if ([_yoloId length]) {
        [encoder encodeObject:_yoloId forKey:kYZHIMYoloNoKey];
    }
    if ([_mnemonicWord length]) {
        [encoder encodeObject:_mnemonicWord forKey:kYZHServerUserWordKey];
    }
//    if (_userId != 0) {
//        [encoder encodeInteger:_userId forKey:kYZHServerUserIdKey];
//    }
    if ([_userId length]) {
        [encoder encodeObject:_userId forKey:kYZHServerUserIdKey];
    }
    if ([_userAccount length]) {
        [encoder encodeObject:_userAccount forKey:kYZHUserAccountKey];
    }
    [encoder encodeObject:@(self.isAutoLogin) forKey:kYZHIMAutoLoginKey];
    
}
//默认写入 YES
- (BOOL)isAutoLogin {

    return YES;
}

@end

@interface YZHUserLoginManage()<NIMLoginManagerDelegate>

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
        [[[NIMSDK sharedSDK] loginManager] addDelegate:self];
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
        _currentLoginData = [object isKindOfClass:[YZHIMLoginData class]] ? object : [[YZHIMLoginData alloc] init];
    } else {
        _currentLoginData = [[YZHIMLoginData alloc] init];
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
    [[YZHNetworkService shareService] POSTNetworkingResource:SERVER_LOGIN(PATH_USER_LOGIN_LOGINVERIFY) params:parameter successCompletion:^(id obj) {
        @strongify(self)
        [self serverloginSuccessWithResponData:obj userAccount:account successCompletion:successCompletion failureCompletion:failureCompletion];
    } failureCompletion:^(NSError *error) {
        //TODO: 失败处理
        failureCompletion ? failureCompletion(error) : NULL;
    }];
}

// 后台登录成功处理
- (void)serverloginSuccessWithResponData:(id)responData userAccount:(NSString *)userAccount successCompletion:(YZHVoidBlock)successCompletion failureCompletion:(YZHErrorBlock)failureCompletion {
    // 缓存.
    YZHLoginModel* userLoginModel = [YZHLoginModel YZH_objectWithKeyValues:responData];
    userLoginModel.userAccount = userAccount;
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
            NSString *appKey        = userLoginModel.appKey;
            NIMSDKOption *option    = [NIMSDKOption optionWithAppKey:appKey];
            option.apnsCername      = nil;
            option.pkCername        = nil;
            [[NIMSDK sharedSDK] registerWithOption:option];
            failureCompletion ? failureCompletion(error) : NULL;
        }
    }];
}
// 网易IM信登录成功处理  //每次登录成功之后数据持久化处理.
- (void)IMServerLoginSuccessWithAccount:(NSString *)account token:(NSString *)token userLoginModel:(YZHLoginModel* )userLoginModel {
    //TODO:开启子线程异步执行保存登录数据. //
    YZHIMLoginData* currentLoginData = [[YZHIMLoginData alloc] init];
    currentLoginData.account = account;
    currentLoginData.token = token;
    currentLoginData.userId = userLoginModel.userId;
    currentLoginData.yoloId = userLoginModel.yoloNo;
    currentLoginData.mnemonicWord = userLoginModel.mnemonicWord; //助记词.
    currentLoginData.isAutoLogin = YES;
    currentLoginData.phoneNumber = userLoginModel.phone;
    currentLoginData.userAccount = userLoginModel.userAccount;
    // 赋值, 并且保存.
    self.currentLoginData = currentLoginData;
    //暂时先到主要,后面还需要加上从云信获取信息的逻辑
    [UIViewController yzh_userLoginSuccessToHomePage];
}

#pragma mark -- LoginDelegate

- (void)onAutoLoginFailed:(NSError *)error {
    
    if (error) {
        //清空缓存数据;
        [self setCurrentLoginData:nil];
        [self executeHandInputLogin];
    }
}

- (void)onLogin:(NIMLoginStep)step {
    
    NSLog(@"登录状态回调%ld", step);
    //等待数据同步成功之后,调用积分任务接口。
    if (step == NIMLoginStepSyncOK) {
        // 登录成功之后, 将数据发送到后台.
        YZHStartInfo* startInfo = [YZHStartInfo shareInstance];
        [startInfo checkUserEveryDayTask];
    }
}

#pragma mark -- Set Get

- (NSString *)filepath {
    
    if (!_filepath) {
        _filepath = [[NIMKitFileLocationHelper getAppDocumentPath] stringByAppendingPathComponent:kYZHIMloginFilePath];
    }
    return _filepath;
}

- (void)setCurrentLoginData:(YZHIMLoginData *)currentLoginData {

    _currentLoginData = currentLoginData;
    [self saveData];
}

@end
