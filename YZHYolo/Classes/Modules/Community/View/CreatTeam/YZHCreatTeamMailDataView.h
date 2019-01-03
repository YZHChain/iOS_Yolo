//
//  YZHCreatTeamMailDataView.h
//  YZHYolo
//
//  Created by Jersey on 2018/10/31.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSTextView.h"
#import "YZHLabelShowView.h"
#import "YZHImportBoxView.h"

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
@property (nonatomic, copy) YZHButtonExecuteBlock updataBlock;
@property (nonatomic, assign) YZHCreateTeamType teamType;
@property (weak, nonatomic) IBOutlet YZHImportBoxView *teamSynopsisTextView;
@property (weak, nonatomic) IBOutlet UIView *teamTagView;
@property (weak, nonatomic) IBOutlet UIView *teamTagTitleView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *teamTagViewLayoutConstraint;
@property (weak, nonatomic) IBOutlet YZHLabelShowView *teamTagShowView;

@end

NS_ASSUME_NONNULL_END
