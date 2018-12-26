//
//  YZHAddFirendRecordSectionHeader.m
//  YZHYolo
//
//  Created by Jersey on 2018/10/9.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHAddFirendRecordSectionHeader.h"

@implementation YZHAddFirendRecordSectionHeader

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.backgroundView = ({
        UIView* view = [[UIView alloc] init];
        view.backgroundColor = [UIColor yzh_backgroundThemeGray];
        view;
    });
}

@end
