//
//  YZHAtMemberHeaderView.m
//  YZHYolo
//
//  Created by Jersey on 2018/11/22.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHAtMemberHeaderView.h"

@interface YZHAtMemberHeaderView()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;


@end

@implementation YZHAtMemberHeaderView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.statusLabel.font = [UIFont yzh_commonStyleWithFontSize:13];
    self.statusLabel.textColor = [UIColor yzh_separatorLightGray];
    
    self.titleLabel.font = [UIFont yzh_commonStyleWithFontSize:15];
    self.titleLabel.textColor = [UIColor yzh_fontShallowBlack];
    
    [self.respondSwitch addTarget:self action:@selector(selectedSwitch:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)selectedSwitch:(UISwitch*)sender {
    
    self.statusLabel.text = sender.isOn ? @"开启": @"关闭";
}

@end
