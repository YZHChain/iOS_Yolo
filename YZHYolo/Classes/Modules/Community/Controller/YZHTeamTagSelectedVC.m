//
//  YZHTeamTagSelectedVC.m
//  YZHYolo
//
//  Created by Jersey on 2018/11/17.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHTeamTagSelectedVC.h"

#import "UIButton+YZHClickHandle.h"
#import "CollectionViewCell.h"
#import "YZHAlertManage.h"
#import "CYLDBManager.h"

@interface YZHTeamTagSelectedVC ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray<NSIndexPath *>* selectedPathArray;

@end

@implementation YZHTeamTagSelectedVC


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

#pragma mark - 2.SettingView and Style

- (void)setupNavBar {
    
    self.navigationItem.title = @"选择群标签";
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(onTouchCancel:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(onTouchSave:)];
}

- (void)setupView {
    
    self.view.backgroundColor = [UIColor yzh_backgroundThemeGray];
    
}

- (void)reloadView {
    
}

#pragma mark - 3.Request Data

- (void)setupData {
    
    [self currentSelectedPathArray];
    [self.collectionView reloadData];
}

#pragma mark - 4.UITableViewDataSource and UITableViewDelegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CollectionViewCell *cell = [super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    BOOL isSelectedCell = NO;
    if (self.selectedPathArray.count) {
        for (NSIndexPath* selectedPath in self.selectedPathArray) {
            if ([selectedPath isEqual:indexPath]) {
                isSelectedCell = YES;
            }
        }
    }
    cell.button.selected = isSelectedCell;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.selectedPathArray containsObject:indexPath]) {
        [self.selectedPathArray removeObject:indexPath];
    } else {
        if (self.selectedPathArray.count < 10) {
            [self.selectedPathArray addObject:indexPath];
        } else {
            [YZHAlertManage showAlertMessage:@"每个群标签最多可选择10个"];
        }
    }
    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
}

#pragma mark - 5.Event Response

#pragma mark - 6.Private Methods

- (void)setupNotification {
    
}

- (void)onTouchCancel:(UIBarButtonItem *)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)onTouchSave:(UIBarButtonItem *)sender {
    //通过 selectedIndex 获取当前已选择标签名字
    [self currentSelectedLabel];
    //TODO:提前执行刷新展示已选择标签视图
    self.selectedLabelSaveHandle ? self.selectedLabelSaveHandle(self.selectedLabelArray ? self.selectedLabelArray : NULL) : NULL;
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark - 7.GET & SET

- (NSMutableArray<NSIndexPath* > *)selectedPathArray {
    
    if (!_selectedPathArray) {
        _selectedPathArray = [[NSMutableArray alloc] init];
    }
    return _selectedPathArray;
}

- (void)currentSelectedLabel {
    
    if (self.selectedPathArray) {
        self.selectedLabelArray = [[NSMutableArray alloc] init];
        @weakify(self)
        [self.selectedPathArray enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            @strongify(self)
            NSString* labelNaem = [self.dataSource[obj.section] objectForKey:kDataSourceSectionKey][obj.row];
            [self.selectedLabelArray addObject:labelNaem];
        }];
    }
}

- (void)currentSelectedPathArray {
    
    if (self.selectedLabelArray) {
        @weakify(self)
        [self.dataSource enumerateObjectsUsingBlock:^(NSDictionary* itmes, NSUInteger section, BOOL * _Nonnull stop) {
            @strongify(self)
            [[itmes objectForKey:kDataSourceSectionKey] enumerateObjectsUsingBlock:^(NSString*  _Nonnull labelName, NSUInteger row, BOOL * _Nonnull stop) {
                if ([self.selectedLabelArray containsObject:labelName]) {
                    [self.selectedPathArray addObject:[NSIndexPath indexPathForRow:row inSection:section]];
                }
            }];
        }];
    }
}

@end
