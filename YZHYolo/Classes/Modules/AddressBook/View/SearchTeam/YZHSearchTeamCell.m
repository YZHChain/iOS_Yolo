//
//  YZHSearchTeamCell.m
//  YZHYolo
//
//  Created by Jersey on 2018/12/6.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHSearchTeamCell.h"

#import "UIImageView+YZHImage.h"
@interface YZHSearchTeamCell()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *joinButton;

@end

@implementation YZHSearchTeamCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.avatarImageView.layer.cornerRadius = 2;
    self.avatarImageView.layer.masksToBounds = YES;
    
    [self.joinButton.titleLabel setFont:[UIFont yzh_commonLightStyleWithFontSize:12]];
    self.joinButton.titleLabel.textColor = [UIColor yzh_sessionCellGray];
    self.joinButton.layer.cornerRadius = 2;
    self.joinButton.layer.masksToBounds = YES;
    self.joinButton.layer.borderWidth = 1;
    self.joinButton.layer.borderColor = YZHColorWithRGB(229, 229, 229).CGColor;
    
    [self.joinButton addTarget:self action:@selector(onTouchJoin:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refresh:(YZHSearchModel *)model {
    
    self.model = model;
    if (YZHIsString(model.teamIcon)) {
        [self.avatarImageView yzh_setImageWithString:model.teamIcon placeholder:@"team_cell_photoImage_default"];
    } else {
        self.avatarImageView.image = [UIImage imageNamed:@"team_cell_photoImage_default"];
    }
    self.titleLabel.text = model.teamName ? model.teamName : @"群聊";
    
}

- (void)onTouchJoin:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(onTouchJoinTeam:)]) {
        [self.delegate onTouchJoinTeam:self.model];
    }
}

@end
