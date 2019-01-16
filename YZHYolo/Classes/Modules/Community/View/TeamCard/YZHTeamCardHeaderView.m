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
@property (weak, nonatomic) IBOutlet UIView *synopisisView;

@end

@implementation YZHTeamCardHeaderView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.guideImageView.image = [UIImage imageNamed:@"my_cover_cell_back"];
    [self.avatarImageView yzh_cornerRadiusAdvance:5 rectCornerType:UIRectCornerAllCorners];
    self.nameLabel.font = [UIFont yzh_commonFontStyleFontSize:15];
    self.nameLabel.textColor = [UIColor yzh_fontShallowBlack];
    self.synopisisLabel.font = [UIFont yzh_commonFontStyleFontSize:11];
    self.synopisisLabel.textColor = [UIColor yzh_sessionCellGray];
    self.synopisisLabel.numberOfLines = 0;
    
    self.backgroundView = ({
        UIView* view = [[UIView alloc] initWithFrame:self.bounds];
        view.backgroundColor = [UIColor whiteColor];
        view;
    });
}

- (void)refreshWithModel:(YZHTeamHeaderModel *)model {
    
    [self refreshModel: model];
//    NSInteger labelAddHeight = [self.labelShowView refreshLabelViewWithLabelArray:model.labelArray];
//    self.updateHeight = self.synopisisView.height + 35 + labelAddHeight;
    [self.labelShowView refreshLabelViewWithLabelArray:model.labelArray];
    [self layoutIfNeeded];
}

- (void)refreshIntroWithModel:(YZHTeamHeaderModel *)model {
    
    [self refreshModel: model];
//    NSInteger labelAddHeight = [self.labelShowView refreshLabelViewWithLabelArray:model.labelArray];
//    self.updateHeight = self.synopisisView.height + 35 + labelAddHeight;
//    self.y = self.updateHeight;
    [self.labelShowView refreshLabelViewWithLabelArray:model.labelArray];
    [self layoutIfNeeded];
}

- (void)refreshModel:(YZHTeamHeaderModel *)model {
    
    if (model.avatarImageName) {
        [self.avatarImageView yzh_setImageWithString:model.avatarImageName placeholder:@"team_teamDetails_photoImage_default"];
    } else {
        self.avatarImageView.image = [UIImage imageNamed:@"team_teamDetails_photoImage_default"];
    }
    
    self.nameLabel.text = model.teamName;
    if (YZHIsString(model.teamSynopsis)) {
        self.synopisisLabel.text = [NSString stringWithFormat:@"简介: %@", model.teamSynopsis];
    } else {
        self.synopisisLabel.text = @"简介: 无";
    }
    if (!model.canEdit) {
        [self.guideImageView removeFromSuperview];
    }
}

@end
