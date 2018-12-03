//
//  YZHChatContentHeaderView.m
//  YZHYolo
//
//  Created by Jersey on 2018/11/21.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHChatContentHeaderView.h"

#import "UIButton+YZHTool.h"
@interface YZHChatContentHeaderView()

@property (weak, nonatomic) IBOutlet UIButton *imageViewButton;
@property (weak, nonatomic) IBOutlet UIButton *cardButton;
@property (weak, nonatomic) IBOutlet UIButton *URLButton;
@property (nonatomic, strong) NSArray* buttonArray;
@property (nonatomic, assign) kYZHChatContentType contentType;

@end

@implementation YZHChatContentHeaderView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    [self.imageViewButton yzh_setBackgroundColor:[UIColor yzh_backgroundThemeGray] forState:UIControlStateNormal];
    [self.imageViewButton setTitleColor:[UIColor yzh_separatorLightGray] forState:UIControlStateNormal];
    [self.imageViewButton yzh_setBackgroundColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.imageViewButton setTitleColor:[UIColor yzh_fontShallowBlack] forState:UIControlStateSelected];
    self.imageViewButton.tag = kYZHChatContentTypeImage;
    
    [self.cardButton yzh_setBackgroundColor:[UIColor yzh_backgroundThemeGray] forState:UIControlStateNormal];
    [self.cardButton setTitleColor:[UIColor yzh_separatorLightGray] forState:UIControlStateNormal];
    [self.cardButton yzh_setBackgroundColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.cardButton setTitleColor:[UIColor yzh_fontShallowBlack] forState:UIControlStateSelected];
    self.cardButton.tag = kYZHChatContentTypeCard;
    
    [self.URLButton yzh_setBackgroundColor:[UIColor yzh_backgroundThemeGray] forState:UIControlStateNormal];
    [self.URLButton setTitleColor:[UIColor yzh_separatorLightGray] forState:UIControlStateNormal];
    [self.URLButton yzh_setBackgroundColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.URLButton setTitleColor:[UIColor yzh_fontShallowBlack] forState:UIControlStateSelected];
    self.URLButton.tag = kYZHChatContentTypeURL;
    
    self.buttonArray = @[self.imageViewButton, self.cardButton, self.URLButton];
    
    self.contentType = kYZHChatContentTypeImage;
    self.imageViewButton.selected = YES;
    
}

- (IBAction)onTouchSwitchType:(UIButton *)sender {
    
    [self.buttonArray enumerateObjectsUsingBlock:^(UIButton*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqual:sender]) {
            sender.selected = YES;
        } else {
            obj.selected = NO;
        }
    }];
    if (self.contentType != sender.tag) {
        self.switchTypeBlock(sender.tag);
        self.contentType = sender.tag;
    }
}


@end
