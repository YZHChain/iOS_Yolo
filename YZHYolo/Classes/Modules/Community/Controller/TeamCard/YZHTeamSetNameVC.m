//
//  YZHTeamSetNameVC.m
//  YZHYolo
//
//  Created by Jersey on 2018/11/21.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHTeamSetNameVC.h"

#import "YZHProgressHUD.h"
#import "NSString+YZHTool.h"
#import "YZHAlertManage.h"
/*
@interface YZHTeamSetNameVC()

@property (nonatomic, copy) NSString* teamNickName;

@end

@implementation YZHTeamSetNameVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)setupView {
    
    [super setupView];
    self.nickNameTextField.text = self.teamNickName;
}

- (void)saveNickName{
    
    //    && self.nickNameTextField.text
    if (YZHIsString(self.nickNameTextField.text)) {
        NSString* nickName = [self.nickNameTextField.text yzh_clearBeforeAndAfterblankString];
        //加入用户输入名字为空格,则只计算一位。。
        if (!YZHIsString(nickName)) {
            nickName = @" ";
        }
        if (![nickName isEqualToString:self.teamNickName]) {
            YZHProgressHUD* hud = [YZHProgressHUD showLoadingOnView:self.view text:nil];
            @weakify(self)
             NSString* userId = [[[NIMSDK sharedSDK] loginManager] currentAccount];
             [[NIMSDK sharedSDK].teamManager updateUserNick:userId newNick:nickName inTeam:self.teamId completion:^(NSError * _Nullable error) {
                 @strongify(self)
                 if (!error) {
                     [hud hideWithText:@"昵称修改成功"];
                     [self.navigationController popViewControllerAnimated:YES];
                 } else {
                     [hud hideWithText:error.domain];
                 }
             }];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else {
        //空限制.
        [YZHAlertManage showAlertMessage:@"没有输入名字,请重新填写"];
    }
}

- (NSString *)teamNickName {
    
    if (!_teamNickName) {
        NSString* userId = [[[NIMSDK sharedSDK] loginManager] currentAccount];
        NIMTeamMember *teamMember = [[[NIMSDK sharedSDK] teamManager] teamMember:userId inTeam:self.teamId];
        _teamNickName = teamMember.nickname;
    }
    return _teamNickName;
}

@end
*/
