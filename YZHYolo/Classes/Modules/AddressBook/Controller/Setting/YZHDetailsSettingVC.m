//
//  YZHDetailsSettingVC.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/30.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHDetailsSettingVC.h"

#import "YZHDetailsSettingCell.h"
#import "UIButton+YZHTool.h"
#import "UIImage+YZHTool.h"
#import "YZHAlertManage.h"
#import "YZHProgressHUD.h"
#import "YZHBlackSettingCell.h"

@interface YZHDetailsSettingVC ()<UITableViewDelegate, UITableViewDataSource>


@property (weak, nonatomic) IBOutlet UIButton *removeButton;
@property (weak, nonatomic) IBOutlet UIButton *chatLogButton;
@property (weak, nonatomic) IBOutlet UISwitch *blackSwitch;

@end

@implementation YZHDetailsSettingVC

#pragma mark - 1.View Controller Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //1.设置导航栏
    [self setupNavBar];
    //2.设置view
    [self setupView];
    //3.请求数据
//    [self setupData];
    //4.设置通知
    [self setupNotification];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 2.SettingView and Style

- (void)setupNavBar {
    self.navigationItem.title = @"其他设置";
}

- (void)setupView {
    
    self.view.backgroundColor = [UIColor yzh_backgroundThemeGray];
    
    [self.removeButton setBackgroundImage:[UIImage yzh_getImageWithColor:YZHColorWithRGB(227, 41, 63)] forState:UIControlStateNormal];
    self.removeButton.layer.cornerRadius = 5;
    self.removeButton.layer.masksToBounds = YES;
    
    BOOL onBlackList = [[NIMSDK sharedSDK].userManager isUserInBlackList:self.userId];
    if (onBlackList) {
        self.blackSwitch.on = true;
    } else {
        self.blackSwitch.on = false;
    }
    
    [self.blackSwitch addTarget:self action:@selector(onTouchBlack:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 3.Request Data

#pragma mark - 4.UITableViewDataSource and UITableViewDelegate

#pragma mark - 5.Event Response

- (IBAction)trashliChatLog:(UIButton *)sender {
    
    [YZHAlertManage showAlertTitle:@"确定要清空此好友的聊天记录么？" message:@"此操作不可逆，请谨慎操作" actionButtons:@[@"取消",@"确认"] actionHandler:^(UIAlertController *alertController, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            NIMDeleteMessagesOption *option = [[NIMDeleteMessagesOption alloc] init];
            option.removeSession = NO;
            option.removeTable = NO;
            NIMSession* session = [NIMSession session:self.userId type:NIMSessionTypeP2P];
            [[NIMSDK sharedSDK].conversationManager deleteAllmessagesInSession:session option:option];
            
        }
    }];
}

- (IBAction)deleteFriend:(UIButton *)sender {
    
    if ([[[NIMSDK sharedSDK] userManager] isMyFriend:self.userId]) {
        @weakify(self)
        [YZHAlertManage showAlertTitle:@"删除该好友，并清空与TA的聊天记录" message:nil actionButtons:@[@"取消", @"删除"] actionHandler:^(UIAlertController *alertController, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                @strongify(self)
                YZHProgressHUD* hud = [YZHProgressHUD showLoadingOnView:self.view text:nil];
                
                [[NIMSDK sharedSDK].userManager deleteFriend:self.userId completion:^(NSError *error) {
                    if (!error) {
                        [hud hideWithText:@"已删除"];
                        //将用户从黑名单列表移除掉
                        [[NIMSDK sharedSDK].userManager removeFromBlackBlackList:self.userId completion:^(NSError * _Nullable error) {
                            
                        }];
                        NIMDeleteMessagesOption* option = [[NIMDeleteMessagesOption alloc] init];
                        option.removeSession = YES;
                        option.removeTable = YES;
                        NIMSession* session = [NIMSession session:self.userId type:NIMSessionTypeP2P];
                        [[NIMSDK sharedSDK].conversationManager deleteAllmessagesInSession:session option:option];
                        NIMRecentSession* recentSesession = [[NIMSDK sharedSDK].conversationManager recentSessionBySession:session];
                        if (recentSesession) {
                            [[NIMSDK sharedSDK].conversationManager deleteRecentSession:recentSesession];
                        }
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }else{
                        [hud hideWithText:@"删除失败,请重试"];
                    }
                }];
            }
        }];
    } else {
        [YZHAlertManage showAlertMessage:@"对方已经不是你好友"];
    }

}

- (void)onTouchBlack:(UISwitch *)sender {
    
    if (sender.isOn) {
        [[NIMSDK sharedSDK].userManager addToBlackList:self.userId completion:^(NSError * _Nullable error) {
            if (!error) {
                NSLog(@"添加成功");
            }
        }];
    } else {
        [[NIMSDK sharedSDK].userManager removeFromBlackBlackList:self.userId completion:^(NSError * _Nullable error) {
            if (!error) {
                NSLog(@"移除成功");
            }
        }];
    }
}

#pragma mark - 6.Private Methods

- (void)setupNotification {
    
}

#pragma mark - 7.GET & SET

@end
