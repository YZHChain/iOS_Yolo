//
//  YZHAddBookAddFirendShowModel.m
//  YZHYolo
//
//  Created by Jersey on 2018/11/14.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHAddBookAddFirendShowModel.h"

@implementation YZHAddBookAddFirendShowModel

- (instancetype)initDetailsModelWithUserId:(NSString *)userId addMessage:(nonnull NSString *)addMessage isMySend:(BOOL)isMysend{
    
    self = [super initDetailsModelWithUserId:userId];
    if (self) {
        [self configurationAddMessage:addMessage isMySend:isMysend];
    }
    return self;
}

- (void)configurationAddMessage:(NSString *)message isMySend:(BOOL)isMysend {
    
    YZHAddBookDetailModel* addRequstModel = [[YZHAddBookDetailModel alloc] init];
    
    addRequstModel.cellClass = @"YZHAddFirendSubtitleCell";
    if (!isMysend) {
        addRequstModel.title = @"TA:";
    } else {
        addRequstModel.title = @"我:";
    }
    //TODO:当出现空消息时 应该如何展示.避免成功发送验证消息但是收不到的情况.
    addRequstModel.subtitle = message.length ? message : @"";
    addRequstModel.cellHeight = 126;
    
    [self.viewModel insertObject:@[addRequstModel].mutableCopy atIndex:1];
    
    //如果非好友则需要将备注设置成不可跳转
    if (![[[NIMSDK sharedSDK] userManager] isMyFriend:self.userId]) {
        self.userNotePhoneArray.firstObject.canSkip = NO;
        self.classTagModel.canSkip = NO;
    }
}

@end
