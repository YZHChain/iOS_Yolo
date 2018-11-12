//
//  JKRSearchBar.h
//  JKRSearchDemo
//
//  Created by Joker on 2017/4/5.
//  Copyright © 2017年 Lucky. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NSString JKRNotificationName;
extern JKRNotificationName * const UISearchBarCancelNotification;

@class JKRSearchBar;

@protocol JKRSearchBarDelegate <NSObject>

@optional
- (void)searchBarTextDidBeginEditing:(JKRSearchBar *)searchBar;
- (void)searchBarTextDidEndEditing:(JKRSearchBar *)searchBar;
- (void)searchBar:(JKRSearchBar *)searchBar textDidChange:(NSString *)searchText;
- (void)searchBarTextFieldShouldReturn:(JKRSearchBar *)searchBar textDidChange:(NSString *)searchText;

@end

@interface JKRSearchBar : UIView

@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, weak) id<JKRSearchBarDelegate> delegate;
@property (nonatomic, strong) NSString *text;

@end
