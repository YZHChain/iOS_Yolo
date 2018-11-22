//
//  YZHSharedFunctionView.m
//  YZHYolo
//
//  Created by Jersey on 2018/11/20.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHSharedFunctionView.h"

@interface YZHSharedFunctionView()

@property (weak, nonatomic) IBOutlet UIButton *sharedFirendButton;
@property (weak, nonatomic) IBOutlet UIButton *sharedTeamButton;
@property (weak, nonatomic) IBOutlet UILabel *friendLabel;
@property (weak, nonatomic) IBOutlet UILabel *teamLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@end

@implementation YZHSharedFunctionView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.friendLabel.textColor = [UIColor yzh_sessionCellGray];
    self.friendLabel.font = [UIFont yzh_commonStyleWithFontSize:13];
    self.teamLabel.textColor = [UIColor yzh_sessionCellGray];
    self.teamLabel.font = [UIFont yzh_commonStyleWithFontSize:13];
    [self.cancelButton setTitleColor:[UIColor yzh_sessionCellGray] forState: UIControlStateNormal];
    [self.cancelButton.titleLabel setFont:[UIFont yzh_commonStyleWithFontSize:14]];
    self.friendLabel.height = 14;
    self.teamLabel.height = 14;
    self.cancelButton.height = 15;
    
}

- (IBAction)clickFirendShared:(UIButton *)sender {
    
    self.firendSharedBlock ? self.firendSharedBlock(sender) : NULL;
}

- (IBAction)clickTeamShared:(UIButton *)sender {
    
    self.teamSharedBlock ? self.teamSharedBlock(sender) : NULL;
}

- (IBAction)clickCancel:(UIButton *)sender {
    
    self.cancelBlock ? self.cancelBlock(sender) : NULL;
}

@end
