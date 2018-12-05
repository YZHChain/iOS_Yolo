//
//  YZHTeamCardSwitchCell.m
//  YZHYolo
//
//  Created by Jersey on 2018/11/19.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHTeamCardSwitchCell.h"

#import "YZHUserModelManage.h"
#import "YZHAlertManage.h"

@interface YZHTeamCardSwitchCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UISwitch *functionSwitch;
@property (nonatomic, strong) UIButton* tipButton;
@property (nonatomic, strong) UILabel* titleTipLabel;

@end

@implementation YZHTeamCardSwitchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.titleLabel.font = [UIFont yzh_commonStyleWithFontSize:15];
    self.titleLabel.textColor = [UIColor yzh_fontShallowBlack];
    
    self.subtitleLabel.font = [UIFont yzh_commonStyleWithFontSize:14];
    self.subtitleLabel.textColor = [UIColor yzh_sessionCellGray];
    
    [self.functionSwitch addTarget:self action:@selector(changeStatus:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)changeStatus:(UISwitch *)sender {
    //TODO修改成使用 Switch

    if ([self.model.title isEqualToString:@"是否公开本群"]) {
        self.model.subtitle = sender.isOn ? @"公开" : @"私密";
    } else if ([self.model.title isEqualToString:@"允许群成员添加好友进群"]) {
        self.model.subtitle = sender.isOn ? @"允许" : @"不允许";
    } else if ([self.model.title isEqualToString:@"是否可互享"]) {
        self.model.subtitle = sender.isOn ? @"可互享" : @"不可互享";
        if (sender.isOn) {
            [YZHAlertManage showAlertMessage:@"此功能暂未开放, 尽请期待"];
        }
    } else if ([self.model.title isEqualToString:@"允许向群里分享其他群名片"]) {
        self.model.subtitle = sender.isOn ? @"允许" : @"不允许";
    } else if ([self.model.title isEqualToString:@"群消息免打扰"]) {
        
    } else if ([self.model.title isEqualToString:@"群置顶"]) {
        
    } else if ([self.model.title isEqualToString:@"允许群成员加好友"]) {
        
    } else if ([self.model.title isEqualToString:@"允许群成员和我私聊"]) {
        
    } else if ([self.model.title isEqualToString:@"群上锁"]) {
        self.model.subtitle = sender.isOn ? @"上锁" : @"不上锁";
        //如果切换为群上锁时,需要检测当前是否有上锁密码.如果无则引导去设置
        if (sender.isOn) {
            YZHUserInfoExtManage* userInfoExt = [YZHUserInfoExtManage currentUserInfoExt];
            BOOL havaReadPassword = YZHIsString(userInfoExt.privateSetting.groupPassword);
            if (!havaReadPassword) {
                [YZHRouter openURL:kYZHRouterPrivacySetting];
            }
        }
    }
    self.model.isOpenStatus = sender.isOn;
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedUISwitch:indexPath:)]) {
        [self.delegate selectedUISwitch:sender indexPath:_indexPath];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refreshWithModel:(YZHTeamDetailModel *)model {
    
    _model = model;
    self.titleLabel.text = model.title;
    self.subtitleLabel.text = model.subtitle;
    self.functionSwitch.on = model.isOpenStatus;
    
    if ([model.title isEqualToString:@"是否可互享"]) {
        [self.titleTipLabel removeFromSuperview];
        [self.contentView addSubview:self.tipButton];
    } else if ([model.title isEqualToString:@"群上锁"]) {
        self.titleTipLabel.text = model.titleTip;
        [self.titleTipLabel sizeToFit];
        [self.contentView addSubview:self.titleTipLabel];
        [self.tipButton removeFromSuperview];
    } else {
        [self.tipButton removeFromSuperview];
        [self.titleTipLabel removeFromSuperview];
    }
}

- (UIButton *)tipButton {
    
    if (!_tipButton) {
        UIButton* tipButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [tipButton setImage:[UIImage imageNamed:@"team_createTeam_ introduce_normal"] forState:UIControlStateNormal];
        [tipButton sizeToFit];
        tipButton.x = 102;
        tipButton.y = self.titleLabel.y + 2;
        _tipButton = tipButton;
    }
    return _tipButton;
}

- (UILabel *)titleTipLabel {
    
    if (!_titleTipLabel) {
        UILabel *titleTipLabel = [[UILabel alloc] init];
        titleTipLabel.font = [UIFont yzh_commonStyleWithFontSize:13];
        titleTipLabel.textColor = [UIColor yzh_sessionCellGray];
        titleTipLabel.x = 55;
        titleTipLabel.centerY = 6.5;
        _titleTipLabel = titleTipLabel;
    }
    return _titleTipLabel;
}

@end
