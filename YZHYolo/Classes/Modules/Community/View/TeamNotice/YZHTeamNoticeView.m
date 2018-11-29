//
//  YZHTeamNoticeView.m
//  YZHYolo
//
//  Created by Jersey on 2018/11/21.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHTeamNoticeView.h"

@interface YZHTeamNoticeView()

@property (weak, nonatomic) IBOutlet UILabel *sendTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *noticeTextLabel;

@end

@implementation YZHTeamNoticeView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.sendTimeLabel.textColor = [UIColor yzh_sessionCellGray];
    self.endTimeLabel.textColor  = [UIColor yzh_sessionCellGray];
    self.noticeTextLabel.textColor = [UIColor yzh_fontShallowBlack];
    self.removeButton.tintColor = [UIColor yzh_sessionCellGray];
    self.removeButton.layer.cornerRadius = 3;
    self.removeButton.layer.borderWidth = 1;
    self.removeButton.layer.borderColor = [UIColor yzh_backgroundThemeGray].CGColor;
    self.removeButton.layer.masksToBounds = YES;
    
    [self.removeButton addTarget:self action:@selector(clickRemove:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refresh:(YZHTeamNoticeModel *)model {
    
    _model = model;
    
    self.sendTimeLabel.text = [NSString stringWithFormat:@"发布时间: %@", model.sendTime];
    if (YZHIsString(model.endTime)) {
       self.endTimeLabel.text = [NSString stringWithFormat:@"结束时间: %@", model.endTime];
    } else {
       self.endTimeLabel.text = nil;
    }
    
    [self setLabelSpace:self.noticeTextLabel withValue:model.announcement withFont:[UIFont systemFontOfSize:13]];
}

-(void)setLabelSpace:(UILabel*)label withValue:(NSString*)str withFont:(UIFont*)font {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 5; //设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    //设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f};
    
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:str attributes:dic];
    label.attributedText = attributeStr;
};

- (void)layoutSubviews {
    
    [super layoutSubviews];
}

- (void)clickRemove:(UIButton *)sender {
    
    if (self.delegete && [self.delegete respondsToSelector:@selector(onTouchRemove:)]) {
        [self.delegete onTouchRemove:self.model];
    }
    
}

@end
