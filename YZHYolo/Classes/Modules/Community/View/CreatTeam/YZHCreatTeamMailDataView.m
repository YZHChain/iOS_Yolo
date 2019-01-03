//
//  YZHCreatTeamMailDataView.m
//  YZHYolo
//
//  Created by Jersey on 2018/10/31.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHCreatTeamMailDataView.h"

#import "UIImageView+YZHImage.h"
#import "NSString+YZHTool.h"

@interface YZHCreatTeamMailDataView()<UITextFieldDelegate>

@end

@implementation YZHCreatTeamMailDataView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    [self setupView];
}

- (void)setupView {
    
    self.teamSynopsisTextView.maximumLengthLabel.text = @"/200";
    self.teamSynopsisTextView.importTextView.maxLength = 200;
    
    //默认是私密群
    self.teamType = YZHTeamTypePrivacy;
    
//    NSMutableAttributedString* nameAttributedString = [[NSMutableAttributedString alloc] initWithString:@"群聊 (默认)"];
//    [nameAttributedString addAttributes:@{
//                                      NSForegroundColorAttributeName: [UIColor yzh_fontShallowBlack],
//                                      NSFontAttributeName: [UIFont yzh_commonStyleWithFontSize:15]
//                                      } range:NSMakeRange(0, 2)];
//    [nameAttributedString addAttributes:@{
//                                      NSForegroundColorAttributeName: [UIColor colorWithRed:125 / 255.0 green:125 / 255.0 blue:125 / 255.0 alpha:1],
//                                      NSFontAttributeName: [UIFont yzh_commonStyleWithFontSize:12]
//                                      } range:NSMakeRange(2, nameAttributedString.length - 2)];
    
    self.teamNameTextFiled.placeholder = @"群聊 (默认)";
    
    NSMutableAttributedString* synopsisAttributedString =  [[NSMutableAttributedString alloc] initWithString:@"无 (默认)"];
    
    [synopsisAttributedString addAttributes:@{
                                          NSForegroundColorAttributeName: [UIColor yzh_fontShallowBlack],
                                          NSFontAttributeName: [UIFont yzh_commonStyleWithFontSize:15]
                                          } range:NSMakeRange(0, 1)];
    [synopsisAttributedString addAttributes:@{
                                          NSForegroundColorAttributeName: [UIColor colorWithRed:125 / 255.0 green:125 / 255.0 blue:125 / 255.0 alpha:1],
                                          NSFontAttributeName: [UIFont yzh_commonStyleWithFontSize:12]
                                          } range:NSMakeRange(1, synopsisAttributedString.length - 1)];
//    [self.teamSynopsisTextView setAttributedText:synopsisAttributedString];
//    [self.teamSynopsisTextView setTextColor:[UIColor yzh_fontShallowBlack]];
//    [self.teamSynopsisTextView setFont:[UIFont systemFontOfSize:15]];
    
    [self.avatarImageView yzh_cornerRadiusAdvance:3 rectCornerType:UIRectCornerAllCorners];
    self.teamType = YZHTeamTypePublic;
    
    self.teamNameTextFiled.delegate = self;
    
}

- (IBAction)updateAvatar:(UIButton *)sender {
    
    self.updataBlock ? self.updataBlock(sender) : NULL;
}

- (IBAction)switchTeamType:(UISwitch *)sender {
    
    if (sender.isOn) {
        self.teamTypeLabel.text = @"公开";
        self.teamType = YZHTeamTypePublic;
    } else {
        self.teamTypeLabel.text = @"私密";
        self.teamType = YZHTeamTypePrivacy;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([textField isEqual:self.teamNameTextFiled]) {
        
        BOOL checkout =  [NSString yzh_checkoutStringWithCurrenString:textField.text importString:string standardLength:30];
        return checkout;
    } else {
        return YES;
    }
}

@end
