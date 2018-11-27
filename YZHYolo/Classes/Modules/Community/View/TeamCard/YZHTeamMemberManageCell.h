//
//  YZHTeamMemberManageCell.h
//  YZHYolo
//
//  Created by Jersey on 2018/11/27.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YZHContactMemberModel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol YZHTeamMemberManageProtocol <NSObject>

- (void)onTouchBannedWithMember:(YZHContactMemberModel* )member;
- (void)onTouchKickOutWithMember:(YZHContactMemberModel* )member;

@end

@interface YZHTeamMemberManageCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *bannedButton;
@property (weak, nonatomic) IBOutlet UIButton *kickOutButton;
@property (nonatomic, strong) YZHContactMemberModel* member;

@property (nonatomic, weak) id<YZHTeamMemberManageProtocol> delegete;
- (void)refresh:(YZHContactMemberModel *)member;

@end

NS_ASSUME_NONNULL_END
