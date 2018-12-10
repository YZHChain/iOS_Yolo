//
//  YZHSearchRecommendSectionView.m
//  YZHYolo
//
//  Created by Jersey on 2018/12/9.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHSearchRecommendSectionView.h"

#import "UIButton+YZHTool.h"
@interface YZHSearchRecommendSectionView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *switchButton;
@property (weak, nonatomic) IBOutlet UIButton *switchRangeButton;


@end

@implementation YZHSearchRecommendSectionView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    [self setupView];
}

- (void)setupView {
    
    self.titleLabel.font = [UIFont yzh_commonLightStyleWithFontSize:13];
    self.titleLabel.textColor = [UIColor yzh_sessionCellGray];
    self.titleLabel.text = @"推荐群";
    
    [self.switchButton yzh_setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.switchButton.layer.cornerRadius = 3;
    self.switchButton.layer.borderWidth = 1;
    self.switchButton.layer.borderColor = YZHColorWithRGB(229, 229, 229).CGColor;
    self.switchButton.layer.masksToBounds = YES;
    [self.switchButton setTitle:@"换一批" forState:UIControlStateNormal];
    [self.switchButton setTitleColor:[UIColor yzh_sessionCellGray] forState:UIControlStateNormal];
    [self.switchButton.titleLabel setFont:[UIFont yzh_commonLightStyleWithFontSize:12]];
    [self.switchButton addTarget:self action:@selector(clickSwitch:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.switchRangeButton yzh_setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.switchRangeButton.layer.cornerRadius = 3;
    self.switchRangeButton.layer.borderWidth = 1;
    self.switchRangeButton.layer.borderColor = YZHColorWithRGB(229, 229, 229).CGColor;
    self.switchRangeButton.layer.masksToBounds = YES;
    [self.switchRangeButton setTitle:@"更换推荐范围" forState:UIControlStateNormal];
    [self.switchRangeButton setTitleColor:[UIColor yzh_sessionCellGray] forState:UIControlStateNormal];
    [self.switchRangeButton.titleLabel setFont:[UIFont yzh_commonLightStyleWithFontSize:12]];
    [self.switchRangeButton addTarget:self action:@selector(clickSwitchRange:) forControlEvents:UIControlEventTouchUpInside];
    
    self.backgroundView = ({
        UIView * view = [[UIView alloc] initWithFrame:self.bounds];
        view.backgroundColor = [UIColor yzh_backgroundThemeGray];
        view;
    });
    
}

- (void)clickSwitch:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(onTouchSwitch:)]) {
        [self.delegate onTouchSwitch:self.switchRangeButton];
    }
}

- (void)clickSwitchRange:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(onTouchSwitchRange:)]) {
        [self.delegate onTouchSwitchRange:self.switchRangeButton];
    }
}

@end
