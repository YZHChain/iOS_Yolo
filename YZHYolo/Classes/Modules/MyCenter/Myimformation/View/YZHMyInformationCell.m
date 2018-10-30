//
//  YZHMyInformationCell.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/20.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHMyInformationCell.h"
#import "NIMAvatarImageView.h"
#import "UIImageView+YZHImage.h"

@implementation YZHMyInformationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setViewModel:(YZHMyInformationModel *)viewModel
{
    self.titleLabel.text = viewModel.title;
    if (viewModel.subtitle.length) {
        self.subTitleLabel.text = viewModel.subtitle;
    }
    if (viewModel.image.length) {
        NSString* placeholderImageName;
        if ([viewModel.title isEqualToString:@"头像"]) {
            placeholderImageName = @"my_informationCell_headPhoto_default";
        } else {
            placeholderImageName = nil;
        }
        BOOL hasDefaultImageView = [viewModel.image hasPrefix:@"my_informationCell"];
        if (hasDefaultImageView) {
            self.photoImageView.image = [UIImage imageNamed:viewModel.image];
            return;
        }
        [self.photoImageView yzh_setImageWithString:viewModel.image placeholder:placeholderImageName];
        CGFloat radius = self.photoImageView.size.height / 2;
        [self.photoImageView yzh_cornerRadiusAdvance:radius rectCornerType:UIRectCornerAllCorners];
    }
}

+ (instancetype)tempTableViewCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath cellType:(NSInteger)cellType {
    
    NSString* identifierID;
    switch (cellType) {
        case 0:
            identifierID = @"phoneCellIdentifler";
            break;
        case 1:
            identifierID = @"photoCellIdentifler";
            break;
        case 2:
            identifierID = @"nickNameCellIdentifler";
            break;
        case 3:
            identifierID = @"genderCellIdentifler";
            break;
        case 4:
            identifierID = @"phoneCellIdentifler";
            break;
            
        default:
            identifierID = @"QRCodeCellIdentifler";
            break;
    }
    
    YZHMyInformationCell* cell = [tableView dequeueReusableCellWithIdentifier:identifierID];
    if (!cell) {
        UINib* nib = [UINib nibWithNibName:@"YZHMyInformationCell" bundle:nil];
        cell = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:cellType];
    }
    
    return cell;
}

@end
