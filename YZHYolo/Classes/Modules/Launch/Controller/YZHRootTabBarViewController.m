//
//  YZHRootTabBarViewController.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/11.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHRootTabBarViewController.h"
#import "YZHTabBarModel.h"

@interface YZHRootTabBarViewController ()<UITabBarControllerDelegate>

@end

@implementation YZHRootTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- SetView

- (void)setupView{
    
    self.tabBar.translucent = NO;
    self.tabBar.tintColor = [UIColor redColor];
    self.tabBar.barTintColor = [UIColor whiteColor];
    
    YZHTabBarItems *viewModel = [[YZHTabBarItems alloc] init];
    NSMutableArray *vcs = [[NSMutableArray alloc] init];
    for (int i=0; i<viewModel.itemsModel.count; i++) {
        YZHTabBarModel *itemModel = viewModel.itemsModel[i];
        Class clazz = NSClassFromString(itemModel.viewController);
        UIViewController *vc = [[clazz alloc] init];
        if (itemModel.hasNavigation) {
            vc = [[UINavigationController alloc] initWithRootViewController:vc];
        }
        [vcs addObject:vc];
    }
    [self setViewControllers:vcs];
    
    for (int i=0; i < self.tabBar.items.count; i++) {
        YZHTabBarModel *itemModel = viewModel.itemsModel[i];
        UITabBarItem *tabBarItem = [self.tabBar.items objectAtIndex:i];
        tabBarItem.title = itemModel.title;
        tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -2);
        //图片
        /*
        UIImage *img = [[UIImage ym_imageWithString:itemModel.image] ym_imageForTabBarItem];
        UIImage *selImg = [[UIImage ym_imageWithString:itemModel.selectedImage] ym_imageForTabBarItem];
        tabBarItem.image = [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        tabBarItem.selectedImage = [selImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        //文字颜色
        [tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor ym_colorWithHexString:itemModel.color]}
                                  forState:UIControlStateNormal];
        [tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor ym_colorWithHexString:itemModel.selectedColor]}
                                  forState:UIControlStateSelected];
         */
    }
    
    self.delegate = self;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
