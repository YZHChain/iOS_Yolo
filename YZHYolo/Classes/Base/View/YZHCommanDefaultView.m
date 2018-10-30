//
//  YZHCommanDefaultView.m
//  YZHYolo
//
//  Created by Jersey on 2018/10/9.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHCommanDefaultView.h"

@interface YZHCommanDefaultView()

@property (weak, nonatomic) IBOutlet UIImageView *defaultImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

@end

@implementation YZHCommanDefaultView

+ (instancetype)commanDefaultViewWithImageName:(NSString *)defaultImageName TitleString:(NSString *)titleString subTitleString:(NSString *)subTitleString {
    
    YZHCommanDefaultView* commandefaultView = [[NSBundle mainBundle] loadNibNamed:@"YZHCommanDefaultView" owner:nil options:nil].lastObject;
    commandefaultView.defaultImageView.image = YZHImage(defaultImageName);
    commandefaultView.titleLabel.text = titleString;
    commandefaultView.subTitleLabel.text = subTitleString;
    
    return commandefaultView;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
}
@end
