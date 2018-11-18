//
//  CYLClassifyMenuViewController.h
//  CollectionViewClassifyMenu
//
//  Created by https://github.com/ChenYilong on 15/3/17.
//  Copyright (c)  http://weibo.com/luohanchenyilong/ . All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CYLFilterHeaderView.h"

@interface CYLClassifyMenuViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, FilterHeaderViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray          *dataSource;

@end

