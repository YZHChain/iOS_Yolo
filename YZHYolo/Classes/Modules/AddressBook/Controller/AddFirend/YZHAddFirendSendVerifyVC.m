//
//  YZHAddFirendSendVerifyVC.m
//  YZHYolo
//
//  Created by Jersey on 2018/11/14.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHAddFirendSendVerifyVC.h"

#import "UIButton+YZHTool.h"
#import "NSString+YZHTool.h"
#import "YZHProgressHUD.h"
#import "YZHRequstAddFirendAttachment.h"
#import "YZHSessionMsgConverter.h"

@interface YZHAddFirendSendVerifyVC ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *verifyMessageTextField;
@property (weak, nonatomic) IBOutlet UIButton *sendMessage;

@end

@implementation YZHAddFirendSendVerifyVC


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
    
    self.navigationItem.title = @"添加好友";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(shutdown:)];
}

- (void)setupView {
    
    self.view.backgroundColor = [UIColor yzh_backgroundThemeGray];
    
    self.verifyMessageTextField.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldEditChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    
    [self.sendMessage addTarget:self action:@selector(senderVerifyMessage:) forControlEvents:UIControlEventTouchUpInside];
    self.sendMessage.enabled = NO;
    self.sendMessage.layer.cornerRadius = 5;
    self.sendMessage.layer.masksToBounds = YES;
    
}

- (void)reloadView {
    
}

#pragma mark - 3.Request Data

- (void)setupData {
    
}

#pragma mark - 4.UITableViewDataSource and UITableViewDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (string.length == 0) {
        return YES;
    } else {
        return [NSString yzh_checkoutStringWithCurrenString:textField.text importString:string standardLength:50];
    }
}

#pragma mark - 5.Event Response

- (void)shutdown:(UIBarButtonItem* )sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
          
    }];
}

- (void)senderVerifyMessage:(UIButton *)sender {
    
    NIMUserRequest *request = [[NIMUserRequest alloc] init];
    request.userId = self.userId;
    request.operation = NIMUserOperationRequest;
    NSString *successText = @"请求成功";
    NSString *failedText =  @"请求失败";
    YZHProgressHUD* hud = [YZHProgressHUD showLoadingOnView:YZHAppWindow text:nil];
    @weakify(self)
    [[NIMSDK sharedSDK].userManager requestFriend:request completion:^(NSError *error) {
        @strongify(self)
        if (!error) {
            //添加成功文案;
            [hud hideWithText:successText];
            if (self.isPrivate) {
                //发送添加请求成功,则发送一条已添加消息.
                YZHRequstAddFirendAttachment* addFirendAttachment = [[YZHRequstAddFirendAttachment alloc] init];
                addFirendAttachment.addFirendTitle = @"好友申请已发出";
                //插入一条添加好友申请回话.
                [[NIMSDK sharedSDK].conversationManager saveMessage:[YZHSessionMsgConverter msgWithRequstAddFirend:addFirendAttachment] forSession:self.session completion:nil];
            }
            self.sendMessage.enabled = NO;
        }else{
            [hud hideWithText:failedText];
        }
    }];
}

#pragma mark - 6.Private Methods

- (void)textFieldEditChanged:(NSNotification* )notification{
    
    NSInteger stringLength = [self.verifyMessageTextField.text yzh_calculateStringLeng];
    BOOL hasConform = stringLength >= 1 && stringLength <= 50;
    if (hasConform) {
        self.sendMessage.enabled = YES;
    } else {
        self.sendMessage.enabled = NO;
    }
}

- (void)setupNotification {
    
}

#pragma mark - 7.GET & SET

@end
