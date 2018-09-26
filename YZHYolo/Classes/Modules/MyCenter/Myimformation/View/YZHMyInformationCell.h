//
//  YZHMyInformationCell.h
//  YZHYolo
//
//  Created by 😘王艳 on 2018/9/20.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YZHMyInformationModel.h"
@interface YZHMyInformationCell : UITableViewCell

@property(nonatomic, strong)YZHMyInformationModel* viewModel;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;


@end
