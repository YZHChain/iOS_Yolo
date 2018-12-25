//
//  YZHTeamMmemberDefaultFooterView.m
//  YZHYolo
//
//  Created by Jersey on 2018/12/25.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHTeamMmemberDefaultFooterView.h"

#import "YZHPublic.h"
@implementation YZHTeamMmemberDefaultFooterView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    [self.tipButton yzh_setupButton];
}

- (IBAction)onTouchTip:(UIButton *)sender {
}


@end
