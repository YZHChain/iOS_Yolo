//
//  YZHSessionMsgConverter.h
//  YZHYolo
//
//  Created by Jersey on 2018/10/23.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YZHUserCardAttachment.h"
#import "YZHTeamCardAttachment.h"
#import "YZHSpeedyResponseAttachment.h"
#import "YZHAddFirendAttachment.h"
#import "YZHRequstAddFirendAttachment.h"
NS_ASSUME_NONNULL_BEGIN

@interface YZHSessionMsgConverter : NSObject

+ (NIMMessage *)msgWithText:(NSString *)text;

//+ (NIMMessage *)msgWithImage:(UIImage *)image;

//+ (NIMMessage *)msgWithImagePath:(NSString *)path;

+ (NIMMessage *)msgWithAudio:(NSString *)filePath;

+ (NIMMessage *)msgWithVideo:(NSString *)filePath;

//+ (NIMMessage *)msgWithFilePath:(NSString *)path;

//+ (NIMMessage *)msgWithFileData:(NSData *)data extension:(NSString *)extension;

+ (NIMMessage *)msgWithTip:(NSString *)tip;

+ (NIMMessage *)msgWithUserCard:(YZHUserCardAttachment* )attachment;

+ (NIMMessage *)msgWithTeamCard:(YZHTeamCardAttachment* )attachment;

+ (NIMMessage *)msgWithSeepdyReponse:(YZHSpeedyResponseAttachment* )attachment text:(NSString *)text;

+ (NIMMessage *)msgWithAddFirend:(YZHAddFirendAttachment* )attachment;

+ (NIMMessage *)msgWithRequstAddFirend:(YZHRequstAddFirendAttachment* )attachment;

@end


NS_ASSUME_NONNULL_END
