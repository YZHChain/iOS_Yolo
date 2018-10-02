//
//  YZHRouterConfig.h
//  YZHYolo
//
//  Created by Jersey on 2018/9/11.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZHRouterConfig : NSObject

#pragma mark -- RouterKey

extern NSString *const kYZHRouteViewControllerClassKey;
extern NSString *const kYZHRouteViewControllerNameKey;
extern NSString *const kYZHRouteViewControllerNotesKey;
extern NSString *const kYZHRouteViewControllerNeedLoginKey;

#pragma mark -- RouteSkipConst

extern NSString * const kYZHRouteSegue;
extern NSString * const kYZHRouteAnimated;
extern NSString * const kYZHRouteBackIndex;
extern NSString * const kYZHRouteBackPage;
extern NSString * const kYZHRouteBackPageOffset;
extern NSString * const kYZHRouteFromOutside;
extern NSString * const kYZHRouteNeedLogin;

extern NSString * const kYZHRouteIndexRoot;
extern NSString * const kYZHRouteSeguePush;

#pragma mark -- GuidePage

extern NSString *const kYZHRouterWelcome;
extern NSString *const kYZHRouterLogin;
extern NSString *const kYZHRouterRegister;
extern NSString *const kYZHRouterFindPassword;
extern NSString *const kYZHRouterSettingPassword;
extern NSString *const kYZHRouterMyInformation;
extern NSString *const kYZHRouterMyInformationPhoto;
extern NSString *const kYZHRouterMyInformationSetName;
extern NSString *const kYZHRouterMyInformationSetGender;
extern NSString *const kYZHRouterMyInformationMyQRCode;
extern NSString *const kYZHRouterMyInformationYoloID;
extern NSString *const kYZHRouterMyInformationMyPlace;
extern NSString *const kYZHRouterMyPlaceCity;
extern NSString *const kYZHRouterAboutYolo;
extern NSString *const kYZHRouterSettingCenter;
extern NSString *const kYZHRouterPrivacySetting;

#pragma mark -- AddressBook

extern NSString *const kYZHRouterAddressBookDetails;
extern NSString *const kYZHRouterAddressBookSetNote;
extern NSString *const kYZHRouterAddressBookSetTag;
extern NSString *const kYZHRouterAddressBookSetting;

+ (NSDictionary* )configInfo;

@end
