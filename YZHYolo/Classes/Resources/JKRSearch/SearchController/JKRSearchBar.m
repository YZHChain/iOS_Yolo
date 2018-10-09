//
//  JKRSearchBar.m
//  JKRSearchDemo
//
//  Created by Joker on 2017/4/5.
//  Copyright © 2017年 Lucky. All rights reserved.
//

#import "JKRSearchBar.h"
#import "JKRSearchTextField.h"
#import "JKRSearchHeader.h"

JKRNotificationName * const  UISearchBarCancelNotification = @"UISearchBarCancelNotification";

@interface JKRSearchBar ()<UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) JKRSearchTextField *searchTextField;
@property (nonatomic, assign) BOOL isEditing;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UIButton *cancelButton;

@end

@implementation JKRSearchBar

- (instancetype)initWithFrame:(CGRect)frame {
    //默认高度 50, 如需适合 X 则需调整
    frame = CGRectMake(0, 0, kScreenWidth, 50);
    self = [super initWithFrame:frame];
    
    self.backgroundColor = [UIColor whiteColor];
    [self addSubTextFieldAndConstraint];
    [self addSubview:self.cancelButton];
    
    return self;
}

- (void)setIsEditing:(BOOL)isEditing {
    // 处于编辑页时 UI.
    _isEditing = isEditing;
    if (_isEditing) {
        [UIView animateWithDuration:0.2 animations:^{
            [self.cancelButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-12);
                make.centerY.mas_equalTo(self);
            }];
            [self.searchTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(15);
                make.right.mas_equalTo(-50);
                make.bottom.mas_equalTo(-10);
                make.height.mas_equalTo(30);
            }];
        } completion:^(BOOL finished) {
        }];
        self.searchTextField.canTouch = YES;
        self.searchTextField.backgroundColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor yzh_backgroundDarkBlue];
        [self.searchTextField becomeFirstResponder];
    } else {
        // 非编辑状态.
        self.searchTextField.text = @"";
        self.text = @"";
        [UIView animateWithDuration:0.2 animations:^{
            [self.searchTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(-10);
                make.center.mas_equalTo(self);
                make.height.mas_equalTo(30);
                make.left.mas_equalTo(58);
                make.right.mas_equalTo(-58);
            }];
            [self.cancelButton mas_updateConstraints:^(MASConstraintMaker *make) {
                
            }];
        } completion:^(BOOL finished) {
        }];
        self.searchTextField.canTouch = NO;
        self.searchTextField.backgroundColor = YZHColorWithRGB(247, 247, 247);
        self.backgroundColor = [UIColor whiteColor];
        [self.searchTextField resignFirstResponder];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(searchBarTextDidBeginEditing:)]) {
        [self.delegate searchBarTextDidBeginEditing:self];
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {

    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(searchBarTextDidEndEditing:)]) {
        [self.delegate searchBarTextDidEndEditing:self];
    }
}

- (void)textFieldDidChange {
    if ([self.delegate respondsToSelector:@selector(searchBar:textDidChange:)]) {
        [self.delegate searchBar:self textDidChange:self.searchTextField.text];
    }
    self.text = self.searchTextField.text;
    if (self.searchTextField.text.length) {
//        [_rightButton setImage:[UIImage imageNamed:@"card_delete"] forState:UIControlStateNormal];
//        [_rightButton setImage:[UIImage imageNamed:@"card_delete"] forState:UIControlStateHighlighted];
    } else {
//        [_rightButton setImage:[UIImage imageNamed:@"VoiceSearchStartBtn"] forState:UIControlStateNormal];
//        [_rightButton setImage:[UIImage imageNamed:@"VoiceSearchStartBtnHL"] forState:UIControlStateHighlighted];
    }
}

- (void)cancelButtonClick {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UISearchBarCancelNotification object:nil];
}

- (void)rightButtonClick {
    if (self.searchTextField.text) {
        self.searchTextField.text = @"";
        self.text = nil;
        [_rightButton setImage:[UIImage imageNamed:@"VoiceSearchStartBtn"] forState:UIControlStateNormal];
        [_rightButton setImage:[UIImage imageNamed:@"VoiceSearchStartBtnHL"] forState:UIControlStateHighlighted];
    }
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.searchTextField.placeholder = self.placeholder;
}

- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
    }
    return _backgroundImageView;
}

- (UITextField *)searchTextField {
    if (!_searchTextField) {
        _searchTextField = [[JKRSearchTextField alloc] init];
        _searchTextField.canTouch = NO;
        UIImageView *searchIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"addBook_cover_search_default"]];
        searchIcon.contentMode = UIViewContentModeScaleAspectFit;
        searchIcon.frame = CGRectMake(0, 0, 30, 14);
        _searchTextField.leftView = searchIcon;
        _searchTextField.leftViewMode = UITextFieldViewModeAlways;
//        _searchTextField.clearsOnBeginEditing = YES;
        _searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _searchTextField.font = [UIFont systemFontOfSize:15.0f];
        [_searchTextField addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
        _searchTextField.backgroundColor = [UIColor yzh_backgroundThemeGray];
        // TODO: 设配各个设备.
        _searchTextField.layer.cornerRadius = 15;
        _searchTextField.delegate = self;
    }
    return _searchTextField;
}

- (UIButton *)rightButton {
    if (!_rightButton) {
//        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_rightButton setImage:[UIImage imageNamed:@"VoiceSearchStartBtn"] forState:UIControlStateNormal];
//        [_rightButton setImage:[UIImage imageNamed:@"VoiceSearchStartBtnHL"] forState:UIControlStateHighlighted];
//        [_rightButton addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
//        _rightButton.frame = CGRectMake(kScreenWidth - 38, 8, 28, 28);
    }
    return _rightButton;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (void)addSubTextFieldAndConstraint {
    
    [self addSubview:self.searchTextField];
    [self.searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-10);
        make.center.mas_equalTo(self);
        make.height.mas_equalTo(30);
        make.left.mas_equalTo(58);
        make.right.mas_equalTo(-58);
    }];
    
}

- (void)dealloc {
    NSLog(@"JKRSearchBar dealloc");
}

@end
