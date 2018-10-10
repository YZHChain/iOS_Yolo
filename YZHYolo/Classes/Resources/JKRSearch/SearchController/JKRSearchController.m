//
//  JKRSearchController.m
//  JKRSearchDemo
//
//  Created by Joker on 2017/4/5.
//  Copyright © 2017年 Lucky. All rights reserved.
//

#import "JKRSearchController.h"
#import "JKRSearchHeader.h"
#import "UIViewController+YZHTool.h"

#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125,2436), [[UIScreen mainScreen] currentMode].size) : NO)

/// navigaionbar高度
#define kSafeAreaNavHeight (([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125,2436), [[UIScreen mainScreen] currentMode].size) : NO) ? 88 : 64)

@interface JKRSearchController ()

@property (nonatomic, strong) UIView *bgView;

@end

@implementation JKRSearchController

- (instancetype)initWithSearchResultsController:(UIViewController *)searchResultsController {
    self = [super init];
    self.searchResultsController = searchResultsController;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.bgView];
    self.view.unTouchRect = CGRectMake(0, 0, self.view.width, kSafeAreaNavHeight);
    self.searchResultsController.view.frame = self.bgView.bounds;
    [self.bgView addSubview:self.searchResultsController.view];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endSearch) name:UISearchBarCancelNotification object:nil];
    [self setStatusBarBackgroundColor:[UIColor yzh_backgroundDarkBlue]];
}

//设置状态栏颜色
- (void)setStatusBarBackgroundColor:(UIColor *)color {
    //TODO: 最好做个异常捕获
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}


- (void)tapSearchBarAction {
    //点击方法应该优化
    if ([self.delegate respondsToSelector:@selector(willPresentSearchController:)]) [self.delegate willPresentSearchController:self];

    // 这里是添加一个方法？为了让每次点击时执行相应事件？
    [self.searchBar addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handGesture)]];
    [self.searchBar addGestureRecognizer:[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handGesture)]];
    //不应该要每次点击添加哦.虽然没什么影响
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:self.view];
    // 尽量别用省略.....
    if ([self.delegate respondsToSelector:@selector(didPresentSearchController:)]) {
        [self.delegate didPresentSearchController:self];
    }
    // 通过 KVC 键值编码来修改私有属性.
    [self.searchBar setValue:@(YES) forKey:@"isEditing"];
    // 这里应该直接调用查找根控制器的导航控制器,直接隐藏.
    if (self.hidesNavigationBarDuringPresentation) {
        UINavigationController* navigationController = (UINavigationController*)[UIViewController yzh_findTopViewController].parentViewController;
        if ([navigationController isKindOfClass:[UINavigationController class]]) {
            [navigationController setNavigationBarHidden:YES animated:YES];
        }
    } else {
        
    }
}

- (void)handGesture {
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"text"] && [self.searchResultsUpdater respondsToSelector:@selector(updateSearchResultsForSearchController:)]) {
        [self.searchResultsUpdater updateSearchResultsForSearchController:self];
    }
}

- (void)endSearch {
    if ([self.delegate respondsToSelector:@selector(willDismissSearchController:)]) [self.delegate willDismissSearchController:self];
    self.searchBar.jkr_viewController.jkr_lightStatusBar = YES;
    NSArray *searchBarGestures = self.searchBar.gestureRecognizers;
    if (searchBarGestures.count == 3) {
        [self.searchBar removeGestureRecognizer:searchBarGestures.lastObject];
        [self.searchBar removeGestureRecognizer:searchBarGestures.lastObject];
    }
    if (searchBarGestures.count == 2) {
        [self.searchBar removeGestureRecognizer:searchBarGestures.lastObject];
    }
    
    [self.view removeFromSuperview];
    if ([self.delegate respondsToSelector:@selector(didDismissSearchController:)]) [self.delegate didDismissSearchController:self];
    [self.searchBar setValue:@(NO) forKey:@"isEditing"];
    if (self.searchBar.jkr_viewController.parentViewController && [self.searchBar.jkr_viewController.parentViewController isKindOfClass:[UINavigationController class]] && self.hidesNavigationBarDuringPresentation) {
        [(UINavigationController *)self.searchBar.jkr_viewController.parentViewController setNavigationBarHidden:NO animated:YES];
    }
}

- (void)endSearchTextFieldEditing:(UITapGestureRecognizer *)sender {
    UITextField *searchTextField = [self.searchBar valueForKey:@"searchTextField"];
    [searchTextField resignFirstResponder];
}

- (JKRSearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[JKRSearchBar alloc] init];
        [_searchBar addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSearchBarAction)]];
        [_searchBar addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _searchBar;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        //TODO:  SearchBar + 状态栏高度.
        _bgView.frame = CGRectMake(0, 50 + 20, kScreenWidth, kScreenHeight - 50 + 20);
        _bgView.backgroundColor = [UIColor yzh_backgroundThemeGray];
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endSearchTextFieldEditing:)];
        tapGestureRecognizer.cancelsTouchesInView = NO;
        [_bgView addGestureRecognizer:tapGestureRecognizer];
    }
    return _bgView;
}

- (void)dealloc {
    
    [self.searchBar removeObserver:self forKeyPath:@"text"];
    NSLog(@"JKRSearchController dealloc");
}

@end
