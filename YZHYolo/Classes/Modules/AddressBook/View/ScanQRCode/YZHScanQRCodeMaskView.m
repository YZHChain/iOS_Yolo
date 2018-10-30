//
//  YZHScanQRCodeMaskView.m
//  YZHYolo
//
//  Created by Jersey on 2018/10/10.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHScanQRCodeMaskView.h"

@implementation YZHScanQRCodeMaskView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    
    return  self;
}

- (void)setup {
    //
    self.alpha = 0.5;
    self.backgroundColor = [UIColor blackColor];
}

@end
