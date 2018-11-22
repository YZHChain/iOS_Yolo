//
//  YZHTeamNoticeSelectedTeamCell.h
//  YZHYolo
//
//  Created by Jersey on 2018/11/21.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YZHTeamNoticeSelectedTeamCell : UITableViewCell

@property (nonatomic, strong) UIImageView* selectedImageView;
@property (weak, nonatomic) IBOutlet UILabel *teamNameLabel;

- (void)refresh:(NIMTeam *)team;

@end

NS_ASSUME_NONNULL_END
