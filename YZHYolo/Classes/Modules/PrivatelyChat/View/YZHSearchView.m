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
        self.height = 50;
        self.width = YZHScreen_Width;
    }
    return self;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    _searchContentView.layer.cornerRadius = 4;
    _searchContentView.layer.masksToBounds = YES;
    _searchContentView.backgroundColor = YZHColorWithRGB(247, 247, 247);
    
    [_searchButton setTitleColor:[UIColor yzh_separatorLightGray] forState:UIControlStateNormal];
    [_searchButton setTitleColor:[UIColor yzh_separatorLightGray] forState:UIControlStateSelected];
    _searchButton.titleLabel.font = [UIFont yzh_commonLightStyleWithFontSize:11];
    [_searchButton setIcon:[UIImage imageNamed:@"addBook_cover_search_default"]];
    [_searchButton setIconSelected:[UIImage imageNamed:@"addBook_cover_search_default"]];
    
    self.backgroundColor = [UIColor whiteColor];
}



@end
