//
//  YZHPhoneContactCell.h
//  YZHYolo
//
//  Created by Jersey on 2018/10/2.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YZHAddBookPhoneContactModel.h"
#import "YZHAddFirendSearchModel.h"
NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    YZHPhoneContactCellTypeAllowAdd = 0,
    YZHPhoneContactCellTypeAlreadyAdd = 1,
    YZHPhoneContactCellTypeAllowInvite = 2,
    YZHPhoneContactCellTypeAlreadyInvite = 3,
} YZHPhoneContactCellType;

@interface YZHPhoneContactCell : UITableViewCell

@property (nonatomic, strong) YZHAddBookPhoneContactModel* contactModel;
@property (nonatomic, strong) YZHAddFirendSearchModel* searchModel;

+ (instancetype)tempTableViewCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath cellType:(YZHPhoneContactCellType)cellType;



@end

NS_ASSUME_NONNULL_END
