//
//  YZHPrivacySettingCell.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/25.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHPrivacySettingCell.h"

@implementation YZHPrivacySettingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.chooseSwitch addTarget:self action:@selector(settingStatus:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)settingStatus:(UISwitch *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedUISwitch:indexPath:)]) {
        [self.delegate selectedUISwitch:sender indexPath:_indexPath];
    }
    YZHPrivacySettingModel* model = self.viewModel.content[_indexPath.row];
    if (_indexPath.row == 0) {
        if (self.chooseSwitch.isOn == NO) {
            model.subTitle = @"不允许";
        } else {
            model.subTitle = @"允许";
        }
    } else if (_indexPath.row == 1) {
        if (self.chooseSwitch.isOn == NO) {
            model.subTitle = @"无需验证";
        } else {
            model.subTitle = @"需要验证";
        }
    } else {
        if (self.chooseSwitch.isOn == NO) {
            model.subTitle = @"不允许";
        } else {
            model.subTitle = @"允许";
        }
    }
    model.isSelected = self.chooseSwitch.isOn;
    self.subtitleLabel.text = self.viewModel.content[_indexPath.row].subTitle;
}


@end
