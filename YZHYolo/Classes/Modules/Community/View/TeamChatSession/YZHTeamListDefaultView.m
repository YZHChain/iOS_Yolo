//
//  YZHTeamListDefaultView.m
//  YZHYolo
//
//  Created by Jersey on 2018/11/22.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHTeamListDefaultView.h"

#import "UIButton+YZHTool.h"
@interface YZHTeamListDefaultView()

@property (weak, nonatomic) IBOutlet UIImageView *publictyImageView;

@end

@implementation YZHTeamListDefaultView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor yzh_backgroundThemeGray];
    
    self.titleLabel.textColor = [UIColor yzh_sessionCellGray];
    self.titleLabel.numberOfLines = 0;
    
    self.findTeamButton.layer.cornerRadius = 4;
    self.findTeamButton.layer.masksToBounds = YES;
    
    _searchView = [YZHSearchView yzh_viewWithFrame:CGRectMake(0, 0, YZHScreen_Width, 50)];
    [self addSubview:_searchView];
    [_searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    
}

@end
