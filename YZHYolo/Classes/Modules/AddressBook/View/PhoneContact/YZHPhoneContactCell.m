//
//  YZHPhoneContactCell.m
//  YZHYolo
//
//  Created by Jersey on 2018/10/2.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHPhoneContactCell.h"

#import "YZHPublic.h"
@interface YZHPhoneContactCell()


@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *datingButton;
@property (weak, nonatomic) IBOutlet UILabel *rusultLabel;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;

@end

static NSString* kPhoneContactCellDating = @"phoneContactCellDating";
static NSString* kPhoneContactCellReview = @"phoneContactCellReview";
@implementation YZHPhoneContactCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    if (self.datingButton) {
        self.datingButton.layer.borderWidth = 1;
        self.datingButton.layer.borderColor = [UIColor yzh_backgroundThemeGray].CGColor;
    }
    // TODO: 需要 masksToBounds 则调用此方法来解决性能问题,此方法必须在 image 赋值之前圆角才生效.
    [self.photoImageView zy_cornerRadiusAdvance:3.0f rectCornerType:UIRectCornerAllCorners];
    self.photoImageView.image = [UIImage imageNamed:@"addBook_cover_cell_photo_default"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
// TODO: 后期可以把这块单独提出来. 
+ (instancetype)tempTableViewCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath cellType:(YZHPhoneContactCellType)cellType {
    NSString* identifierID;
    if (cellType == YZHPhoneContactCellTypeDating) {
        identifierID = kPhoneContactCellDating;
    } else {
        identifierID = kPhoneContactCellReview;
    }
    
    YZHPhoneContactCell* cell = [tableView dequeueReusableCellWithIdentifier:identifierID];
    if (cell == nil) {
        UINib* nib = [UINib nibWithNibName:@"YZHPhoneContactCell" bundle:nil];
        cell = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:cellType];
    }
    
    return cell;
}

@end
