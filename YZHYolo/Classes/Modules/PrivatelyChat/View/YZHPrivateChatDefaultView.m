//
//  YZHPrivateChatDefaultView.m
//  YZHYolo
//
//  Created by Jersey on 2018/12/14.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHPrivateChatDefaultView.h"

@interface YZHPrivateChatDefaultView()

@property (weak, nonatomic) IBOutlet UIImageView *publictyImageView;

@end

@implementation YZHPrivateChatDefaultView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor yzh_backgroundThemeGray];
    
    self.titleLabel.font = [UIFont yzh_commonStyleWithFontSize:14];
    self.titleLabel.textColor = [UIColor yzh_sessionCellGray];
    self.titleLabel.numberOfLines = 0;
    
    _searchView = [YZHSearchView yzh_viewWithFrame:CGRectMake(0, 0, YZHScreen_Width, 50)];
    [self addSubview:_searchView];
    [_searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    
}

@end
