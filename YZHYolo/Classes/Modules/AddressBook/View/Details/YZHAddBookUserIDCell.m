//
//  YZHAddBookUserIDCell.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/28.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHAddBookUserIDCell.h"

#import "UIImageView+YZHImage.h"

@implementation YZHAddBookUserIDCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.userpicImageView yzh_cornerRadiusAdvance:self.userpicImageView.height / 2 rectCornerType:UIRectCornerAllCorners];
    
    self.userpicImageView.userInteractionEnabled = YES;
    [self.userpicImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(displayLargePhoto)]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(YZHAddBookHeaderModel *)model {
    
    if (model.photoImageName) {
        [self.userpicImageView yzh_setImageWithString:model.photoImageName placeholder:@"my_cover_headPhoto_default"];
    } 
    self.notoNameLabel.text = model.remarkName;
    self.nickNameLabel.text = @"";
    if (YZHIsString(model.yoloId)) {
        self.userYoloIDLabel.text = [NSString stringWithFormat:@"YOLO号：%@",model.yoloId];
    } else {
        self.userYoloIDLabel.text = @"YOLO号";
    }
}

- (void) displayLargePhoto {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(onTouchPicImageView:)]) {
        [self.delegate onTouchPicImageView:self.userpicImageView];
    }
}

@end
