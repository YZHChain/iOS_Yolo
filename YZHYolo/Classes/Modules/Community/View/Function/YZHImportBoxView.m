//
//  YZHImportBoxView.m
//  YZHYolo
//
//  Created by Jersey on 2018/11/1.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHImportBoxView.h"
#import "NSString+YZHTool.h"

@implementation YZHImportBoxView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
       [self setupView];
    }
    return self;
}

- (void)setupView {
    
    self.backgroundColor = [UIColor whiteColor];
    
    FSTextView *textView = [[FSTextView alloc] init];
    self.importTextView = textView;
    textView.maxLength = 200;
    
    UIButton* clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.clearButton = clearButton;
    [clearButton setImage:[UIImage imageNamed:@"textfield_common_clearButton"] forState:UIControlStateNormal];
    self.clearButton.hidden = YES;
    clearButton.size = CGSizeMake(16, 16);
    
    UILabel* currentLengthLabel = [[UILabel alloc] init];
    currentLengthLabel.text = @"0";
    self.currentLengthLabel = currentLengthLabel;
    [currentLengthLabel sizeToFit];
    
    UILabel* maximumLengthLabel = [[UILabel alloc] init];
    maximumLengthLabel.text = @"/200";
    self.maximumLengthLabel = maximumLengthLabel;
    [maximumLengthLabel sizeToFit];
    
    [self addSubview:textView];
    [self addSubview:clearButton];
    [self addSubview:currentLengthLabel];
    [self addSubview:maximumLengthLabel];
    
    [self setupLayoutSubviews];
    
    // TODO: 待测试,在达到最大值时,出现内存泄漏
    @weakify(self)
    [textView addTextDidChangeHandler:^(FSTextView *textView) {
        @strongify(self)
        NSString* currentStringLength = [NSString stringWithFormat:@"%ld", [textView.text yzh_calculateStringLeng]];
        self.currentLengthLabel.text = currentStringLength;
        self.clearButton.hidden = !textView.text.length;
    }];
    
    [self.clearButton addTarget:self action:@selector(onTouchClear:) forControlEvents:UIControlEventTouchUpInside];
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)setupLayoutSubviews {
    
    [self.importTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(17);
        make.right.mas_equalTo(-17);
        make.top.mas_equalTo(5);
        make.bottom.mas_equalTo(0);
    }];
    
    [self.maximumLengthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-17);
        make.bottom.mas_equalTo(-7);
    }];
    
    [self.currentLengthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.maximumLengthLabel.mas_left);
        make.top.mas_equalTo(self.maximumLengthLabel.mas_top);
    }];
    
    [self.clearButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.currentLengthLabel.mas_left).mas_offset(-7);
        make.bottom.mas_equalTo(-9);
        make.width.height.mas_equalTo(16);
    }];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    /*
    self.importTextView.frame = CGRectMake(17, 5, self.width - 34, self.height - 5);
    
//    self.maximumLengthLabel.right = self.width - 17;
//    self.maximumLengthLabel.bottom = self.height - 7;
    [self.maximumLengthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-17);
        make.bottom.mas_equalTo(-7);
    }];
    
//    self.currentLengthLabel.right = self.maximumLengthLabel.x;
//    self.currentLengthLabel.y = self.maximumLengthLabel.y;
    [self.currentLengthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.maximumLengthLabel.mas_left);
        make.top.mas_equalTo(self.maximumLengthLabel.mas_top);
        
    }];
    
//    self.clearButton.right = self.currentLengthLabel.x - 7;
//    self.clearButton.bottom = self.height - 9;
    [self.clearButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(self.currentLengthLabel.mas_left).mas_offset(-7);
        make.bottom.mas_equalTo(-9);
        make.width.height.mas_equalTo(16);
    }];
     */
}

- (void)onTouchClear:(UIButton *)sender {
    
    self.importTextView.text = nil;
}

@end
