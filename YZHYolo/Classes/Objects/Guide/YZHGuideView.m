//
//  YZHGuideView.m
//  YZHYolo
//
//  Created by Jersey on 2018/12/21.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHGuideView.h"

@interface YZHGuideView()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *squareImageViewLayout;

@end

@implementation YZHGuideView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.squareImageViewLayout.constant = YZHScreen_Width / 5 + 20;
    
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    
    UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTouchNext:)];
    [self addGestureRecognizer:tapGest];
}

- (void)onTouchNext:(UITapGestureRecognizer *)sender {
    
    self.clickCompletion ? self.clickCompletion () : NULL;
    
}

@end
