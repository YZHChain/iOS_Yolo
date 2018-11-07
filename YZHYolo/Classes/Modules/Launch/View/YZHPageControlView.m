//
//  YZHPageControlView.m
//  YZHYolo
//
//  Created by Jersey on 2018/11/7.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHPageControlView.h"

@interface YZHPageControlView()

@property (nonatomic, strong) NSArray<UIButton *>* buttonArray;

@end

@implementation YZHPageControlView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        NSMutableArray* tempButtonArray = [[NSMutableArray alloc] initWithCapacity:3];
        for (NSInteger i = 0; i < 3; i++) {
            
            UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(0 + 33 * i + i * 19, 0, 33, 10)];
            [tempButtonArray addObject:button];
            [button setImage:[UIImage imageNamed:@"welcome_cover_pageDotImage"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"welcome_cover_currentPageDotImage"] forState:UIControlStateSelected];
            button.tag = i;
            [button addTarget:self action:@selector(clickControllerButton:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
        }
        _buttonArray = tempButtonArray;
    }
    return self;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    
    if (selectedIndex <= self.buttonArray.count) {
        _selectedIndex = selectedIndex;
        for (NSInteger i = 0; i < self.buttonArray.count; i++) {
            UIButton* button = self.buttonArray[i];
            if (_selectedIndex == i) {
                button.selected = YES;
            } else {
                button.selected = NO;
            }
        }
    }
}

- (void)clickControllerButton:(UIButton *)button {
    
    self.executeBlock ? self.executeBlock(button.tag) : NULL;
}

@end
