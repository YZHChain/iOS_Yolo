//
//  YMAppConfigCell.h
//  YEAMoney
//
//  Created by suke on 2016/10/31.
//  Copyright © 2016年 YEAMoney. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMAppConfigCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *keyLabel;
@property (weak, nonatomic) IBOutlet UITextField *valueTextField;
@property (weak, nonatomic) IBOutlet UISwitch *valueSwitch;

@property (nonatomic, copy) void (^switchHandler)(BOOL on);
@property (nonatomic, copy) void (^editEndHandler)(NSString *text);

@end
