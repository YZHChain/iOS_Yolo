//
//  NIMKitInfoFetchOption.m
//  NIMKit
//
//  Created by chris on 2016/12/26.
//  Copyright © 2016年 NetEase. All rights reserved.
//

#import "NIMKitInfoFetchOption.h"

@implementation NIMKitInfoFetchOption

- (instancetype)initWithIsAddressBook:(BOOL)isAddressBook {
    
    self = [super init];
    if (self) {
        _isAddressBook = isAddressBook;
    }
    return self;
}

@end
