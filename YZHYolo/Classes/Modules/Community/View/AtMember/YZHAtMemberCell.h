//
//  YZHAtMemberCell.h
//  YZHYolo
//
//  Created by Jersey on 2018/11/23.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YZHContactMemberModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface YZHAtMemberCell : UITableViewCell

@property (nonatomic, strong) UIImageView* selectedImageView;

- (void)refreshAtmember:(YZHContactMemberModel *)member;
@property (nonatomic, copy) NSString* teamId;

@end

NS_ASSUME_NONNULL_END
