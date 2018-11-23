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
extern NSString * const kYZHRouteSegueModal;
extern NSString * const kYZHRouteSegueNewNavigation;

extern NSString * const kYZHRouteCommunityTab;
extern NSString * const kYZHRoutePrivatelyChatTab;
extern NSString * const kYZHRouteAddressBookTab;
extern NSString * const kYZHRouteDiscoverTab;
extern NSString * const kYZHRouteMyCenterthTab;

#pragma mark -- GuidePage

extern NSString *const kYZHRouterWelcome;
extern NSString *const kYZHRouterLogin;
extern NSString *const kYZHRouterRegister;
extern NSString *const kYZHRouterFindPassword;
extern NSString *const kYZHRouterSettingPassword;
extern NSString *const kYZHRouterModifyPassword;

#pragma mark -- MyCenter

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
extern NSString *const kYZHRouterAddressBookAddFriendShow;
extern NSString *const kYZHRouterAddressBookSetNote;
extern NSString *const kYZHRouterAddressBookSetTag;
extern NSString *const kYZHRouterAddressBookSetting;
extern NSString *const kYZHRouterAddressBookAddFirend;
extern NSString *const kYZHRouterAddressBookAddFirendSendVerify;
extern NSString *const kYZHRouterAddressBookPhoneContact;
extern NSString *const kYZHRouterAddressBookAddFirendRecord;
extern NSString *const kYZHRouterAddressBookScanQRCode;

#pragma mark -- Session

extern NSString *const kYZHRouterSessionSharedCard;
extern NSString *const kYZHRouterCommunityCreateTeam;
extern NSString *const kYZHRouterCommunityCreateTeamAddition;
extern NSString *const kYZHRouterCommunityCreateTeamResult;
extern NSString *const kYZHRouterCommunityCreateTeamTagSelected;
extern NSString *const kYZHRouterCommunityCard;
extern NSString *const kYZHRouterCommunityCardHeaderEdit;
extern NSString *const kYZHRouterCommunityCardShared;
extern NSString *const kYZHRouterCommunityCardSharedCheck;
extern NSString *const kYZHRouterCommunityCardQRCodeShared;
extern NSString *const kYZHRouterCommunityCardSetNickName;
extern NSString *const kYZHRouterCommunityCardTeamNotice;
extern NSString *const kYZHRouterCommunityCardSendTeamNotice;
extern NSString *const kYZHRouterCommunityCardSelectedTeam;
extern NSString *const kYZHRouterSessionChatContent;
extern NSString *const kYZHRouterCommunitySetTeamTag;
extern NSString *const kYZHRouterCommunityAtTeamMember;


+ (NSDictionary* )configInfo;

@end
