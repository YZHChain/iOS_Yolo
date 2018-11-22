//
//  YZHImportBoxView.h
//  YZHYolo
//
//  Created by Jersey on 2018/11/1.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSTextView.h"
NS_ASSUME_NONNULL_BEGIN

@interface YZHImportBoxView : UIView

@property (nonatomic, strong) FSTextView* importTextView;
@property (nonatomic, strong) UIButton* clearButton;
@property (nonatomic, strong) UILabel* maximumLengthLabel;
@property (nonatomic, strong) UILabel* currentLengthLabel;

@end

NS_ASSUME_NONNULL_END
