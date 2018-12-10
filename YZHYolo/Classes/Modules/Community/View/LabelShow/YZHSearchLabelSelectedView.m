//
//  YZHSearchLabelSelectedView.m
//  YZHYolo
//
//  Created by Jersey on 2018/12/10.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHSearchLabelSelectedView.h"

static NSInteger kYZHTagViewHeight = 21;
static NSInteger kYZHTagViewSpace = 11;
static NSInteger kYZHTagViewSuperViewSpace = 18;
static NSInteger kYZHTagViewRowHeight = 35;
static NSInteger kYZHTagViewRowSpace = 8.5;

@interface YZHSearchLabelSelectedView()

@property (nonatomic, strong) NSArray* selectedLabelArray;

@end

@implementation YZHSearchLabelSelectedView

- (CGFloat)refreshLabelButtonWithLabelArray:(NSArray *)labelArray {
    
    if (labelArray.count == 0) {
        return 50;
    }
    
    self.selectedLabelArray = labelArray;
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    //    self.createTeamView.teamTagViewLayoutConstraint.constant = 80;
    UIView* lastView;    // 代表同意行的上一个 TagView. 第一个则为 nil
    NSInteger level = 0; //代表目前已新增的行数
    NSInteger lastViewRight = 0;  //上一个 TagView的 X + Widtg
    
    for (NSInteger i = 0 ; i < self.selectedLabelArray.count; i++) {
        
        UIView* labelView = [[UIView alloc] init];
        labelView.layer.cornerRadius = 3;
        labelView.layer.borderWidth = 1;
        labelView.layer.borderColor = [UIColor yzh_backgroundThemeGray].CGColor;
        labelView.backgroundColor = [UIColor whiteColor];
        
        UIButton* tagLabel = [UIButton buttonWithType:UIButtonTypeSystem];
        tagLabel.tag = i;
        [tagLabel addTarget:self action:@selector(clickTag:) forControlEvents:UIControlEventTouchUpInside];
        [tagLabel setTitle:self.selectedLabelArray[i] forState:UIControlStateNormal];
        [tagLabel.titleLabel setFont:[UIFont yzh_commonFontStyleFontSize:12]];
        [tagLabel setTitleColor:[UIColor yzh_sessionCellGray] forState:UIControlStateNormal];
        CGSize tagSize = [tagLabel sizeThatFits: CGSizeMake([UIScreen mainScreen].bounds.size.width, MAXFLOAT)];
        [self addSubview:labelView];
        [labelView addSubview:tagLabel];
        NSInteger viewWidth = tagSize.width + 32;
        if (lastView) {
            //如果新增加的 TagViewWide + 左边间距 + 与最右边的间距 超出了 SuperViewWidth 则需要向下新增一行.
            if (self.width - lastViewRight < (viewWidth + kYZHTagViewSpace + kYZHTagViewSuperViewSpace)) {
                lastView = nil;
                level++;
            }
        }
        // 判断是否有上一个
        if (lastView) {
            [labelView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(lastView.mas_right).mas_offset(kYZHTagViewSpace);
                make.width.mas_equalTo(viewWidth);
                make.top.bottom.mas_equalTo(lastView);
            }];
        } else {
            [labelView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(kYZHTagViewSuperViewSpace);
                make.top.mas_equalTo(kYZHTagViewRowSpace + level * kYZHTagViewRowHeight);
                make.height.mas_equalTo(kYZHTagViewHeight);
                make.width.mas_equalTo(viewWidth);
            }];
        }
        [tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(labelView);
            make.height.mas_equalTo(20);
        }];
        if (lastView) {
            lastViewRight += viewWidth + kYZHTagViewSpace;
        } else {
            lastViewRight = viewWidth + kYZHTagViewSuperViewSpace; // diydiy
        }
        lastView = labelView;
    }
    
    return (level * kYZHTagViewRowHeight);
}

- (void)clickTag:(UIButton* )sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedTagLabel:)]) {
        [self.delegate selectedTagLabel:sender];
    }
}

@end
