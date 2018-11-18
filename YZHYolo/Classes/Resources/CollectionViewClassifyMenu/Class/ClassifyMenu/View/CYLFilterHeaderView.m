//
//  FilterHeaderView.m
//  http://cnblogs.com/ChenYilong/ 
//
//  Created by  https://github.com/ChenYilong  on 14-7-9.
//  Copyright (c)  http://weibo.com/luohanchenyilong/  . All rights reserved.
//

#import "CYLFilterHeaderView.h"

static float const kTitleButtonWidth = 250.f;
static float const kMoreButtonWidth  = 9;
static float const kCureOfLineHight  = 9;
static float const kCureOfLineOffX   = 0;

float const CYLFilterHeaderViewHeigt = 45;

@interface CYLFilterHeaderView()

@end

@implementation CYLFilterHeaderView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [self sharedInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self = [self sharedInit];
        
    }
    return self;
}

- (instancetype)sharedInit {
    
    self.backgroundColor = [UIColor whiteColor];
    
    UIView *cureOfLine = [[UIView alloc] initWithFrame:CGRectMake(kCureOfLineOffX, 0, YZHScreen_Width, kCureOfLineHight)];
    cureOfLine.backgroundColor = [UIColor yzh_backgroundThemeGray];
    [self addSubview:cureOfLine];
    
    UILabel* titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont yzh_commonStyleWithFontSize:15];
    titleLabel.frame = CGRectMake(13, 20, kTitleButtonWidth, 18);
    self.titleLabel = titleLabel;
    [self addSubview:titleLabel];
    
    UIButton* moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [moreButton setImage:[UIImage imageNamed:@"team_createTeam_selectedTag_default"] forState:UIControlStateNormal];
    [moreButton setImage:[UIImage imageNamed:@"team_createTeam_selectedTag_show"] forState:UIControlStateSelected];
    moreButton.frame = CGRectMake(YZHScreen_Width - kMoreButtonWidth - 20, 20, 20, 16);
    self.moreButton = moreButton;
    [self addSubview:moreButton];
    
    UIButton* headerViewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    headerViewButton.frame = CGRectMake(0, 10, YZHScreen_Width, 28);
    [headerViewButton addTarget:self action:@selector(moreBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:headerViewButton];
    
    return self;
}

//- (id)sharedInit {
//    UIView *cureOfLine = [[UIView alloc] initWithFrame:CGRectMake(kCureOfLineOffX, 0, YZHScreen_Width, kCureOfLineHight)];
//    cureOfLine.backgroundColor = [UIColor yzh_backgroundThemeGray];
//    [self addSubview:cureOfLine];
//    self.backgroundColor = [UIColor whiteColor];
//    //仅修改self.titleButton的宽度,xyh值不变
//    self.titleButton = [[CYLIndexPathButton alloc] init];
////    self.titleButton.titleEdgeInsets = UIEdgeInsetsMake(0, 16, 0, 0);
////    self.titleButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
//    self.titleButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    self.titleButton.titleLabel.textAlignment = NSTextAlignmentLeft;
//    self.titleButton.titleLabel.font = [UIFont yzh_commonStyleWithFontSize:15];
//    self.titleButton.frame = CGRectMake(13, 20, kTitleButtonWidth,  20);
//    [self.titleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [self.titleButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
//    [self addSubview:self.titleButton];
//    CGRect  moreBtnFrame = CGRectMake(self.moreButton.frame.origin.x, 20, kMoreButtonWidth, self.frame.size.height);
//    self.moreButton = [[CYLRightImageButton alloc] initWithFrame:moreBtnFrame];
//    //仅修改self.moreButton的x,ywh值不变
//    self.moreButton.frame = CGRectMake(YZHScreen_Width - moreBtnFrame.size.width  + 10, 9, self.moreButton.frame.size.width, self.moreButton.frame.size.height);
//    [self.moreButton setImage:[UIImage imageNamed:@"team_createTeam_selectedTag_default"] forState:UIControlStateNormal];
//    [self.moreButton setImage:[UIImage imageNamed:@"team_createTeam_selectedTag_show"] forState:UIControlStateSelected];
//    [self.moreButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [self.moreButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
////    [self.moreButton setTitle:@"更多" forState:UIControlStateNormal];
////    [self.moreButton setTitle:@"收起" forState:UIControlStateSelected];
//    self.moreButton.titleLabel.textAlignment = NSTextAlignmentRight;
//    self.moreButton.hidden = YES;
//    [self.moreButton addTarget:self action:@selector(moreBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:self.moreButton];
//    return self;
//}


- (void)moreBtnClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(filterHeaderViewMoreBtnClicked:)]) {
        [self.delegate filterHeaderViewMoreBtnClicked:self.moreButton];
    }
}

@end
