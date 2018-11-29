//
//  YZHTeamNoticeShowView.h
//  YZHYolo
//
//  Created by Jersey on 2018/11/29.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YZHTeamNoticeShowView : UIView

@property (nonatomic, strong) UIView* shadowView;
@property (nonatomic, strong) UIButton* shadowButton;

@property (nonatomic, strong) UIView* titleView;
@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UIButton* showButton;

@property (nonatomic, strong) UIView* contentView;
@property (nonatomic, strong) UIView* lineView;
@property (nonatomic, strong) UILabel* contentLabel;

@property (nonatomic, assign) BOOL isValid;

-(void)setLabelSpace:(UILabel*)label withValue:(NSString*)str withFont:(UIFont*)font;

@end

NS_ASSUME_NONNULL_END
