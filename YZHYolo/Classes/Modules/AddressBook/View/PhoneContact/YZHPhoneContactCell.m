
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

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
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
    [self.photoImageView yzh_cornerRadiusAdvance:3 rectCornerType:UIRectCornerAllCorners];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
// TODO: 后期可以把这块单独提出来. 
+ (instancetype)tempTableViewCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath cellType:(YZHPhoneContactCellType)cellType {
    NSString* identifierID;
    //主要分两种, 一种是可以进行交互的按钮, 一种是只能看当前关系状态的 Label.
    NSInteger cellAtNibIndex;
    if (cellType == YZHPhoneContactCellTypeAlreadyAdd) {
        identifierID = kPhoneContactCellReview;
        cellAtNibIndex = 1;
        
    } else {
        identifierID = kPhoneContactCellDating;
        cellAtNibIndex = 0;
    }
    
    YZHPhoneContactCell* cell = [tableView dequeueReusableCellWithIdentifier:identifierID];
    if (cell == nil) {
        UINib* nib = [UINib nibWithNibName:@"YZHPhoneContactCell" bundle:nil];
        cell = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:cellAtNibIndex];
    }
    
    return cell;
}

-(void)setContactModel:(YZHAddBookPhoneContactModel *)contactModel {
    
    _contactModel = contactModel;
    if (contactModel.status == YZHPhoneContactCellTypeAllowAdd || contactModel.status == YZHPhoneContactCellTypeAllowInvite) {
        [self.datingButton setTitle:contactModel.subtitle forState:UIControlStateNormal];
    } else {
        [self.rusultLabel setText:contactModel.subtitle];
    }
    
    if (contactModel.status == 0 || contactModel.status == 1) {
        
        [self.photoImageView yzh_setImageWithString:contactModel.photoImageName placeholder:@"addBook_cover_cell_photo_default"];
//        [self.photoImageView yzh_cornerRadiusAdvance:3 rectCornerType:UIRectCornerAllCorners];
    } else {
        self.photoImageView.image = [UIImage imageNamed:@"addBook_phoneContact_cell_unregistered_default"];
//        [self.photoImageView yzh_cornerRadiusAdvance:3 rectCornerType:UIRectCornerAllCorners];
    }
    
    self.nameLabel.text = contactModel.name;
}

- (void)setSearchModel:(YZHAddFirendSearchModel *)searchModel {
    
    _searchModel = searchModel;
    
    if (searchModel.isMyFriend) {
        [self.datingButton removeFromSuperview];
        self.datingButton = nil;
    } else {
        if (searchModel.allowAdd) {
            [self.datingButton setTitle:searchModel.addText forState:UIControlStateNormal];
        } else {
            [self.datingButton removeFromSuperview];
            self.datingButton = nil;
        }
    }
    if (YZHIsString(searchModel.memberModel.info.avatarUrlString)) {
        [self.photoImageView yzh_setImageWithString:searchModel.memberModel.info.avatarUrlString placeholder:@"addBook_cover_cell_photo_default"];
    }

    self.nameLabel.text = searchModel.memberModel.info.showName;
    if (YZHIsString(searchModel.memberModel.info.nickName)) {
        self.nickNameLabel.text = [NSString stringWithFormat:@"(%@)", searchModel.memberModel.info.nickName];
    }
}

- (IBAction)clickRequestButton:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(onSelectedCellAddFirendButtonWithModel:)]) {
        if (_contactModel) {
            [self.delegate onSelectedCellAddFirendButtonWithModel:_contactModel];
        } else {
            [self.delegate onSelectedCellAddFirendButtonWithModel:_searchModel];
        }
    }
    
}

@end
