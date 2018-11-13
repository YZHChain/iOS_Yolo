//
//  YZHContactMemberModel.m
//  YZHYolo
//
//  Created by Jersey on 2018/11/4.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHContactMemberModel.h"

#import "NIMSpellingCenter.h"
#import "YZHTargetUserDataManage.h"
@implementation YZHContactMemberModel

- (instancetype)initWithInfo:(NIMKitInfo *)info {
    
    self = [super init];
    
    if (self) {
        _info = info;
    }
    
    return self;
}

- (NSString *)groupTitle {
    
    NSString *title = [[NIMSpellingCenter sharedCenter] firstLetter:self.info.showName].capitalizedString;
    unichar character = [title characterAtIndex:0];
    if (character >= 'A' && character <= 'Z') {
        return title;
    }else{
        return @"#";
    }
}
//当前用户标签
- (NSString *)groupTagTitle {
    
    YZHTargetUserExtManage* targetUserExt = [YZHTargetUserExtManage targetUserExtWithUserId:self.info.infoId];
    
    NSString* tagName = targetUserExt.friend_tagName;
    if (!YZHIsString(tagName)) {
        tagName = @"其他好友";
    }
    return tagName;
}

- (NSString *)userId{
    return self.info.infoId;
}

- (UIImage *)icon{
    return self.info.avatarImage;
}

- (NSString *)avatarUrl{
    return self.info.avatarUrlString;
}

- (NSString *)memberId{
    return self.info.infoId;
}

- (NSString *)showName{
    return self.info.showName;
}

- (id)sortKey {
    return [[NIMSpellingCenter sharedCenter] spellingForString:self.info.showName].shortSpelling;
}

- (BOOL)isEqual:(id)object{
    if (![object isKindOfClass:[self class]]) {
        return NO;
    }
    return [self.info.infoId isEqualToString:[[object info] infoId]];
}

@end
