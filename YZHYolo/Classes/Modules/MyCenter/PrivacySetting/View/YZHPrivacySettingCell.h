//
//  YZHPrivacySettingCell.h
//  YZHYolo
//
//  Created by Jersey on 2018/9/25.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YZHPrivacySettingModel.h"

@protocol YZHSwitchProtocol <NSObject>

- (void)selectedUISwitch:(UISwitch* )uiSwitch indexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_BEGIN

@interface YZHPrivacySettingCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UISwitch *chooseSwitch;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (nonatomic, strong) YZHPrivacySettingContent* viewModel;
@property (nonatomic, strong) NSIndexPath* indexPath;
@property (nonatomic, weak) id<YZHSwitchProtocol> delegate;

@end

NS_ASSUME_NONNULL_END
