//
//  YZHImageContentCell.m
//  YZHYolo
//
//  Created by Jersey on 2018/12/3.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHImageContentCell.h"

#import "UIImageView+YZHImage.h"
#import "UIView+NIM.h"

@interface YZHImageContentCell()<NIMMessageContentViewDelegate>

@end

@implementation YZHImageContentCell

- (instancetype)init {
    
    self = [super init];
    if (self) {
//        self.layer.cornerRadius = 2;
//        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void)refreshData:(NIMMessageModel *)data
{
    self.model = data;
    if ([self checkData])
    {
        [self refresh];
    }
}

- (BOOL)checkData{
    
    return [self.model isKindOfClass:[NIMMessageModel class]];
}

- (void)refresh {
    
    self.backgroundColor = [NIMKit sharedKit].config.cellBackgroundColor;
    
    [self addContentViewIfNotExist];

    NIMImageObject * imageObject = (NIMImageObject*)self.model.message.messageObject;
    UIImage * image              = [UIImage imageWithContentsOfFile:imageObject.thumbPath];
    self.imageContentView.image         = image;
//    [_imageContentView yzh_cornerRadiusAdvance:2 rectCornerType:UIRectCornerAllCorners];
    [_imageContentView setNeedsLayout];
    
    _imageContentView.frame = CGRectMake(0, 0, self.width, self.height);
    
    [self setNeedsLayout];
}

- (void)addContentViewIfNotExist
{
    if (_imageContentView == nil)
    {
        _imageContentView  = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageContentView.backgroundColor = [UIColor blackColor];
        _imageContentView.contentMode = UIViewContentModeScaleToFill;
        
        [self.contentView addSubview:_imageContentView];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

#pragma mark - NIMMessageContentViewDelegate
- (void)onCatchEvent:(NIMKitEvent *)event{
    if ([self.delegate respondsToSelector:@selector(onTapCell:)]) {
        [self.delegate onTapCell:event];
    }
}

@end
