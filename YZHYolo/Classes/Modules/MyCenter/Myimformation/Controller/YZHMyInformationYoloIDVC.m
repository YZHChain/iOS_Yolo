//
//  YZHMyInformationYoloIDVC.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/23.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHMyInformationYoloIDVC.h"

@interface YZHMyInformationYoloIDVC ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *yoloIDTextField;
@property (weak, nonatomic) IBOutlet UILabel *remindLabel;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;
@property (weak, nonatomic) IBOutlet UIImageView *checkResultImageView;
@property (weak, nonatomic) IBOutlet UILabel *checkResultLabel;
@property (weak, nonatomic) IBOutlet UIView *checkResultView;

@end

@implementation YZHMyInformationYoloIDVC

#pragma mark - 1.View Controller Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //1.设置导航栏
    [self setupNavBar];
    //2.设置view
    [self setupView];
    //3.请求数据
    [self setupData];
    //4.设置通知
    [self setupNotification];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
}

#pragma mark - 2.SettingView and Style

- (void)setupNavBar
{
    self.navigationItem.title = @"设置 YOLO号";
    self.hideNavigationBarLine = YES;
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveSetting)];
    
    self.navigationItem.rightBarButtonItem = item;
}

- (void)setupView
{
    self.view.backgroundColor = [UIColor yzh_backgroundThemeGray];
    
    [self.yoloIDTextField becomeFirstResponder];
    
    self.remindLabel.text = @"请注意:\nyolo号支持英文大小写、数字和特殊字符，必须是英文开头 且仅可设置一次，设置后不能再更改.";
    self.checkResultView.hidden = YES;
    
}

- (void)reloadView
{
    
}

#pragma mark - 3.Request Data

- (void)setupData
{
    
}

#pragma mark - 4.UITableViewDataSource and UITableViewDelegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (string.length == 0) {
        return YES;
    }
    if (textField.text.length >= 30) {
        return NO;
    }
    return YES;
}


#pragma mark - 5.Event Response

- (void)saveSetting{
    
    
    
}

- (IBAction)detectionYoloID:(UIButton *)sender {
    
    static BOOL ckeckRsult = YES;
    self.checkResultView.hidden = NO;
    if (ckeckRsult) {

        self.checkResultImageView.image = [UIImage imageNamed:@"my_information_setYoloID_correct"];
        self.checkResultLabel.text = @"YOLO号可以正常使用";
    } else {
        
        self.checkResultImageView.image = [UIImage imageNamed:@"my_information_setYoloID_fault"];
        self.checkResultLabel.text = @"该YOLO号已存在，请重新设置";
    }
}

#pragma mark - 6.Private Methods

- (void)setupNotification
{
    
}

#pragma mark - 7.GET & SET

@end
