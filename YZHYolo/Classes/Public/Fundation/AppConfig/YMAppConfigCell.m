//
//  YMAppConfigCell.m
//  YEAMoney
//
//  Created by suke on 2016/10/31.
//  Copyright © 2016年 YEAMoney. All rights reserved.
//

#import "YMAppConfigCell.h"

@implementation YMAppConfigCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Action

- (IBAction)editEndAction:(UITextField *)sender
{
    self.editEndHandler ? self.editEndHandler(sender.text) : NULL;
}

- (IBAction)switchAction:(UISwitch *)sender
{
    self.switchHandler ? self.switchHandler(sender.on) : NULL;
}

@end
