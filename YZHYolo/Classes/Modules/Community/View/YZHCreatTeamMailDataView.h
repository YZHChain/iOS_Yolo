//
//  YZHCreatTeamMailDataView.h
//  YZHYolo
//
//  Created by Jersey on 2018/10/31.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSTextView.h"
typedef enum : NSUInteger {
    YZHTeamTypePrivacy,
    YZHTeamTypePublic,
    YZHTeamTypeShare,
} YZHCreateTeamType;
NS_ASSUME_NONNULL_BEGIN

@interface YZHCreatTeamMailDataView : UIView

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *teamNameTextFiled;
@property (weak, nonatomic) IBOutlet UILabel *teamTypeLabel;
@property (weak, nonatomic) IBOutlet UISwitch *teamTypeSwitch;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIButton *updateAvatarButton;
@property (weak, nonatomic) IBOutlet UIView *teamSynopsisView;
@property (nonatomic, copy) YZHButtonExecuteBlock updataBlock;
@property (nonatomic, assign) YZHCreateTeamType teamType;
@property (nonatomic, strong) FSTextView* teamSynopsisTextView;
@property (weak, nonatomic) IBOutlet UILabel *currentTextLengthLabel;


@end

NS_ASSUME_NONNULL_END
