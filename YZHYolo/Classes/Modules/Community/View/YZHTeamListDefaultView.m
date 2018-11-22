//
//  YZHTeamListDefaultView.m
//  YZHYolo
//
//  Created by Jersey on 2018/11/22.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHTeamListDefaultView.h"

#import "UIButton+YZHTool.h"
@interface YZHTeamListDefaultView()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *publictyImageView;

@end

@implementation YZHTeamListDefaultView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor yzh_backgroundThemeGray];
    
    self.titleLabel.textColor = [UIColor yzh_sessionCellGray];
    
    self.findTeamButton.layer.cornerRadius = 4;
    self.findTeamButton.layer.masksToBounds = YES;
    
}

@end
