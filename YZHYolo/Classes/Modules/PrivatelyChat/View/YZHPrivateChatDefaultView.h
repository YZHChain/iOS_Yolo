//
//  YZHPrivateChatDefaultView.h
//  YZHYolo
//
//  Created by Jersey on 2018/12/14.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YZHSearchView.h"

NS_ASSUME_NONNULL_BEGIN

@interface YZHPrivateChatDefaultView : UIView

@property (weak, nonatomic) IBOutlet YZHSearchView *searchView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end

NS_ASSUME_NONNULL_END
