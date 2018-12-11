//
//  YZHCommandTipLabelView.m
//  YZHYolo
//
//  Created by Jersey on 2018/12/11.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHCommandTipLabelView.h"

@implementation YZHCommandTipLabelView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.contentView.backgroundColor = [UIColor yzh_backgroundThemeGray];
    
    self.titleView.backgroundColor = [UIColor yzh_backgroundThemeGray];
    self.showLabelView.backgroundColor = [UIColor yzh_backgroundThemeGray];    
}



@end
