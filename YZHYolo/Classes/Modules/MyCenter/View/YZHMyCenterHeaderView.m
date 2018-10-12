//
//  YZHMyCenterHeaderView.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/19.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHMyCenterHeaderView.h"

@implementation YZHMyCenterHeaderView

- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    [self setupView];
}

- (void)setupView{
    
}

- (IBAction)clickQRCode:(UIButton *)sender {
    
    NSLog(@"单击二维码");
}

@end
