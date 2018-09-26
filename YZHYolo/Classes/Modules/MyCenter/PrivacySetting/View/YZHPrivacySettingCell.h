//
//  YZHPrivacySettingCell.h
//  YZHYolo
//
//  Created by Jersey on 2018/9/25.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YZHPrivacySettingCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UISwitch *chooseSwitch;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@end

NS_ASSUME_NONNULL_END
