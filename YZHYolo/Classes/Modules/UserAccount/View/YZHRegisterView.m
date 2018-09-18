//
//  YZHRegisterView.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/17.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHRegisterView.h"

@implementation YZHRegisterView

+ (instancetype)yzh_configXibView{
    
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
}

- (void)awakeFromNib{
    
    [super awakeFromNib];
}

@end
