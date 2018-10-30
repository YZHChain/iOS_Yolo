//
//  YZHMyCenterHeaderView.h
//  YZHYolo
//
//  Created by Jersey on 2018/9/19.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YZHUserDetailsModel.h"
@interface YZHMyCenterHeaderView : UIView


@property (nonatomic, copy) YZHButtonExecuteBlock executeHeaderBlock;
@property (nonatomic, copy) YZHButtonExecuteBlock executeQRCodeBlock;

@property (nonatomic, strong) YZHUserDetailsModel* userModel;

@end
