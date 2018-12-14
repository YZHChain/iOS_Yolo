//
//  YZHUserDataManage.m
//  YZHYolo
//
//  Created by Jersey on 2018/12/10.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHUserDataManage.h"

#import "NIMKitFileLocationHelper.h"
#import "YZHUserLoginManage.h"

static NSString* kYZHUserTeamLabelKey   = @"teamLabel";
static NSString* kYZHUserTeamtaskCompleDateKey   = @"taskCompleDate";

@interface YZHUserDataModel()

@end

@implementation YZHUserDataModel

+ (BOOL)supportsSecureCoding {
    
    return YES;
}
- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
    
    if (_teamLabel.count) {
        [aCoder encodeObject:_teamLabel.mutableCopy forKey:kYZHUserTeamLabelKey];
    }
    if ([_taskCompleDate isEqualToDate:[NSDate date]]) {
        [aCoder encodeObject:_taskCompleDate forKey:kYZHUserTeamtaskCompleDateKey];
    }
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)aDecoder {

    self = [super init];
    if (!self) {
        return nil;
    }
    self.teamLabel = [[aDecoder decodeObjectOfClass:[NSMutableArray class] forKey: kYZHUserTeamLabelKey] mutableCopy];
    self.taskCompleDate = [aDecoder decodeObjectOfClass:[NSDate class] forKey:kYZHUserTeamtaskCompleDateKey];
    return self;
}

@end

@interface YZHUserDataManage()

@property (nonatomic,copy) NSString *filepath;

@end

@implementation YZHUserDataManage

#pragma mark -- init

+ (instancetype)sharedManager
{
    static YZHUserDataManage *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //使用每个用户账号来作为, 文件路径
        NSString* userAccount = [[[YZHUserLoginManage sharedManager] currentLoginData] account];
        NSString *filepath = [[NIMKitFileLocationHelper getAppDocumentPath] stringByAppendingPathComponent: userAccount];
        instance = [[YZHUserDataManage alloc] initWithPath:filepath];
    });
    //当切换账号时.需要重新初始化。TODO:
    return instance;
}

- (instancetype)initWithPath:(NSString* )filePath {
    
    self = [super init];
    if (!self) {
        return nil;
    }
    _filepath = filePath;
    [self readData];
    return self;
}

//TODO:从文件中读取和保存用户名密码,建议上层开发对这个地方做加密. 对账号密码进行加密
- (void)readData {
    
    NSString *filepath = self.filepath;
    if ([[NSFileManager defaultManager] fileExistsAtPath:filepath])
    {
        id object = [NSKeyedUnarchiver unarchiveObjectWithFile:filepath];
        _currentUserData = [object isKindOfClass:[YZHUserDataModel class]] ? object : nil;
    } else {
        _currentUserData = [[YZHUserDataModel alloc] init];
    }
}

- (void)saveData
{
    NSData *data = [NSData data];
    if (_currentUserData)
    {
        data = [NSKeyedArchiver archivedDataWithRootObject:_currentUserData];
    }
    [data writeToFile:[self filepath] atomically:YES];
}


#pragma mark - GET & SET

- (NSString *)filepath {
    
    if (!_filepath) {
        _filepath = [[[YZHUserLoginManage sharedManager] currentLoginData] account];
    }
    return _filepath;
}

- (void)setCurrentUserData:(YZHUserDataModel *)currentUserData {
    
    [self readData];
    _currentUserData = currentUserData;
    [self saveData];
}

@end
