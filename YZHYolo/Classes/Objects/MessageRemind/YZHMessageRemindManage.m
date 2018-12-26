//
//  YZHMessageRemindManage.m
//  YZHYolo
//
//  Created by Jersey on 2018/12/26.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHMessageRemindManage.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation YZHMessageRemindManage

+ (void)AudioServicesPlaySystemSound {
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

+ (void)AudioServicesPlaySystemSoundVoice {
   
    AudioServicesPlaySystemSound(1007);
}

@end
