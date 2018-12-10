//
//  YZHTeamCardHeaderView.m
//  YZHYolo
//
//  Created by Jersey on 2018/11/19.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHTeamCardHeaderView.h"

#import "YZHLabelShowView.h"
#import "UIImageView+YZHImage.h"
@interface YZHTeamCardHeaderView()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopisisLabel;
@property (weak, nonatomic) IBOutlet UIImageView *guideImageView;
@property (weak, nonatomic) IBOutlet YZHLabelShowView *labelShowView;
@property (weak, nonatomic) IBOutlet UIButton *headerButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelViewLayoutConstraint;

@end

@implementation YZHTeamCardHeaderView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.guideImageView.image = [UIImage imageNamed:@"my_cover_cell_back"];
    [self.avatarImageView yzh_cornerRadiusAdvance:5 rectCornerType:UIRectCornerAllCorners];
    self.nameLabel.font = [UIFont yzh_commonStyleWithFontSize:15];
    self.nameLabel.textColor = [UIColor yzh_fontShallowBlack];
    self.synopisisLabel.font = [UIFont systemFontOfSize:11];
    self.synopisisLabel.textColor = [UIColor yzh_sessionCellGray];
    self.synopisisLabel.numberOfLines = 2;
    
    self.backgroundView = ({
        UIView* view = [[UIView alloc] initWithFrame:self.bounds];
        view.backgroundColor = [UIColor whiteColor];
        view;
    });
}

- (void)refreshWithModel:(YZHTeamHeaderModel *)model {
    
    if (model.avatarImageName) {
        [self.avatarImageView yzh_setImageWithString:model.avatarImageName placeholder:@"team_teamDetails_photoImage_default"];
    } else {
        self.avatarImageView.image = [UIImage imageNamed:@"team_teamDetails_photoImage_default"];
    }
    
    self.nameLabel.text = model.teamName;
    self.synopisisLabel.text = model.teamSynopsis;
    if (!model.canEdit) {
        [self.guideImageView removeFromSuperview];
    }
    
    NSInteger labelAddHeight = [self.labelShowView refreshLabelViewWithLabelArray:model.labelArray];
    
    self.height = 115 + labelAddHeight;
}

@end
