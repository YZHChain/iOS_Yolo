//
//  YZHSearchTeamShowCell.h
//  YZHYolo
//
//  Created by Jersey on 2018/12/14.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YZHSearchTeamShowCell : UITableViewCell

- (void)refresh:(NIMTeam* )model;
@property (nonatomic, strong) NIMTeam* model;

@end

NS_ASSUME_NONNULL_END
