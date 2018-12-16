//
//  YZHCacheManager.m
//  YZHYolo
//
//  Created by Jersey on 2018/12/16.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHCacheManager.h"

#import "EGOCache.h"
#import <CommonCrypto/CommonDigest.h>
#import "SDImageCache.h"

static NSString * const kJsonCacheTimeKey = @"currentTime";

@interface YZHCacheManager ()

@property (nonatomic, copy) NSString *directory;
@property (nonatomic, strong) EGOCache *apiCache;

@end

@implementation YZHCacheManager

+ (void)load {
    [self performSelectorOnMainThread:@selector(shareManager) withObject:nil waitUntilDone:NO];
}

+ (instancetype)shareManager {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

- (id)init {
    self = [super init];
    if (self) {
        _apiCache = [EGOCache globalCache];
        _apiCache.defaultTimeoutInterval = 3600*24*7; //设置过期时间为7天
        
        NSString *libraryDirectory = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
        NSString *bundleMD5 = [self MD5WithString:[[NSBundle mainBundle] bundleIdentifier]];
        NSString *cachesDirectory = [[libraryDirectory stringByAppendingPathComponent:bundleMD5] copy];
        [[NSFileManager defaultManager] createDirectoryAtPath:cachesDirectory withIntermediateDirectories:YES attributes:nil error:NULL];
        _directory = cachesDirectory;
    }
    return self;
}

#pragma mark - Base

- (void)saveObject:(id<NSCoding>)object forName:(NSString *)name
{
    [NSKeyedArchiver archiveRootObject:object toFile:[self pathWithName:name]];
    NSLog(@"%s %p %@",__func__ ,object ,name);
}

- (id<NSCoding>)objectForName:(NSString *)name
{
    id object = [NSKeyedUnarchiver unarchiveObjectWithFile:[self pathWithName:name]];
    NSLog(@"%s %p %@",__func__ ,object ,name);
    return object;
}

- (void)removeObjectForName:(NSString *)name;
{
    [[NSFileManager defaultManager] removeItemAtPath:[self pathWithName:name] error:nil];
    NSLog(@"%s %@",__func__ ,name);
}

#pragma mark - Size

- (void)getCacheSize:(void (^)(NSString *size))completion
{
    NSString *cacheFilePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        float folderSize = 0;
        if ([fileManager fileExistsAtPath:cacheFilePath]) {
            NSArray *subPaths = [fileManager subpathsAtPath:cacheFilePath];
            for (NSString *fileName in subPaths) {
                NSString *absolutePath = [cacheFilePath stringByAppendingPathComponent:fileName];
                folderSize += [[fileManager attributesOfItemAtPath:absolutePath error:nil] fileSize];
            }
            folderSize = folderSize / (1000*1000);
        }
        
        NSString *sumSize;
        if (folderSize < 0.1) {
            sumSize = @"0M";
        } else {
            sumSize = [NSString stringWithFormat:@"%.2fM",folderSize];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(sumSize);
        });
    });
}

- (void)cleanCache:(void(^)(void))completion
{
    NSString *cacheFilePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([fileManager fileExistsAtPath:cacheFilePath]) {
            NSArray *subPaths = [fileManager subpathsAtPath:cacheFilePath];
            for (NSString *fileName in subPaths) {
                NSString *absolutePath = [cacheFilePath stringByAppendingPathComponent:fileName];
                BOOL isDirectory = NO;
                [fileManager fileExistsAtPath:absolutePath isDirectory:&isDirectory];
                if (!isDirectory) {
                    NSError *error;
                    [fileManager removeItemAtPath:absolutePath error:&error];
                    NSLog(@"Error removing file at path: %@", error.localizedDescription);
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                completion();
            });
        }
    });
}

#pragma mark - Method

- (NSString *)pathWithName:(NSString *)name
{
    NSString *nameMD5 = [self MD5WithString:name];
    NSString *path = [self.directory stringByAppendingPathComponent:nameMD5];
    return path;
}

- (NSString *)MD5WithString:(NSString *)str
{
    //1.首先将字符串转换成UTF-8编码, 因为MD5加密是基于C语言的,所以要先把字符串转化成C语言的字符串
    const char *fooData = [str UTF8String];
    //2.然后创建一个字符串数组,接收MD5的值
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    //3.计算MD5的值, 这是官方封装好的加密方法:把我们输入的字符串转换成16进制的32位数,然后存储到result中
    CC_MD5(fooData, (CC_LONG)strlen(fooData), result);
    /**
     第一个参数:要加密的字符串
     第二个参数: 获取要加密字符串的长度
     第三个参数: 接收结果的数组
     */
    //4.创建一个字符串保存加密结果
    NSMutableString *saveResult = [NSMutableString string];
    //5.从result 数组中获取加密结果并放到 saveResult中
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [saveResult appendFormat:@"%02x", result[i]];
    }
    /*
     x表示十六进制，%02X(大写)，%02x(小写)  意思是不足两位将用0补齐，如果多余两位则不影响
     NSLog("%02X", 0x888);  //888
     NSLog("%02X", 0x4); //04
     */
    return saveResult;
}

#pragma mark - API JSON Data Cache

- (BOOL)cacheJsonData:(NSDictionary *)info forNameSpace:(NSString *)nameSpace
{
    BOOL isSucceed = NO;
    if (nameSpace.length == 0) {
        isSucceed = NO;
    } else {
        [self setJson:info forKey:nameSpace];
        isSucceed = YES;
    }
    return isSucceed;
}

- (NSDictionary *)freshJsonData:(NSDictionary *)info ForNameSpace:(NSString *)nameSpace
{
    NSMutableDictionary *mixInfo = [NSMutableDictionary dictionaryWithDictionary:[self jsonForKey:nameSpace]];
    [mixInfo addEntriesFromDictionary:info];
    [self cacheJsonData:mixInfo forNameSpace:nameSpace];
    return mixInfo;
}

- (NSString *)cacheTimeForNameSpace:(NSString *)nameSpace
{
    return [self jsonForKey:nameSpace][kJsonCacheTimeKey];
}

- (void)setJson:(NSDictionary *)info forKey:(NSString *)key
{
    [self.apiCache setObject:info forKey:[self MD5WithString:key]];
}

- (NSDictionary *)jsonForKey:(NSString *)key
{
    id cacheData = [self.apiCache objectForKey:[self MD5WithString:key]];
    return [cacheData isKindOfClass:[NSDictionary class]] ? cacheData : nil;
}

#pragma mark - Getter & Setter

- (NSUInteger)size {
    return [[SDImageCache sharedImageCache] getSize];
}


@end


