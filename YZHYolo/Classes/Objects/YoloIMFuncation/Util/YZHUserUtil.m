//
//  YZHUserUtil.m
//  YZHYolo
//
//  Created by Jersey on 2018/10/14.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHUserUtil.h"

static NSString* const kYZHMaleDefaultImageName = @"my_informationCell_gender_boy";
static NSString* const kYZHFemaleDefaultImageName = @"my_informationCell_gender_girl";
@implementation YZHUserUtil

+ (NSString *)genderString:(NIMUserGender)gender{
    NSString *genderStr = @"";
    switch (gender) {
        case NIMUserGenderMale:
            genderStr = @"男";
            break;
        case NIMUserGenderFemale:
            genderStr = @"女";
            break;
        case NIMUserGenderUnknown:
            genderStr = @"男";
        default:
            break;
    }
    return genderStr;
}

+ (NSString *)genderImageNameString:(NIMUserGender)gender{
    NSString *imageName = kYZHMaleDefaultImageName;
    switch (gender) {
        case NIMUserGenderMale:
            break;
        case NIMUserGenderFemale:
            imageName = kYZHFemaleDefaultImageName;
            break;
        case NIMUserGenderUnknown:
        default:
            break;
    }
    return imageName;
}

@end
