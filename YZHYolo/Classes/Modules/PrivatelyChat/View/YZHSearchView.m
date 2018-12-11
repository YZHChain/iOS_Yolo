//
//  YZHSearchView.m
//  YZHYolo
//
//  Created by Jersey on 2018/12/10.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHSearchView.h"

@interface YZHSearchView()

@property (weak, nonatomic) IBOutlet UIView *searchContentView;

@end

@implementation YZHSearchView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    _searchContentView.layer.cornerRadius = 4;
    _searchContentView.layer.masksToBounds = YES;
    _searchContentView.backgroundColor = YZHColorWithRGB(247, 247, 247);
    
    self.backgroundColor = [UIColor whiteColor];
}



@end
