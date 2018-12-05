//
//  YZHTeamNoticeView.h
//  YZHYolo
//
//  Created by Jersey on 2018/11/21.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YZHTeamNoticeModel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol YZHTeamNoticeProtecol <NSObject>

- (void)onTouchRemove:(YZHTeamNoticeModel* )modle section:(NSInteger)section;

@end

@interface YZHTeamNoticeView : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *removeButton;
@property (nonatomic, strong) YZHTeamNoticeModel* model;
- (void)refresh:(YZHTeamNoticeModel *)model;
@property (nonatomic, weak) id<YZHTeamNoticeProtecol> delegete;
@property (nonatomic, assign) NSInteger section;
//-(void)setLabelSpace:(UILabel*)label withValue:(NSString*)str withFont:(UIFont*)font;


@end

NS_ASSUME_NONNULL_END
