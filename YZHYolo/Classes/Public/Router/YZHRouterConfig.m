//
//  YZHRouterConfig.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/11.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHRouterConfig.h"

//TODO:规范Segue参数与非Segue参数(YZHRouteFromOutside,YZHRouteNeedLogin等)，Segue参数统一以YZHRouteSegue开头。
NSString* const kYZHRouteSegue           = @"YZHRouteSegue";
NSString* const kYZHRouteSeguePush       = @"YZHRouteSeguePush";
NSString* const kYZHRouteSegueModal      = @"YZHRouteSegueModal";
NSString* const kYZHRouteSegueNewNavigation = @"YZHRouteNewNavigation";
NSString* const kYZHRouteAnimated        = @"YZHRouteAnimated";
NSString* const kYZHRouteBackIndex       = @"YZHRouteBackIndex";
NSString* const kYZHRouteBackPage        = @"YZHRouteBackPage";
NSString* const kYZHRouteBackPageOffset  = @"YZHRouteBackPageOffset";
NSString* const kYZHRouteFromOutside     = @"YZHRouteFromOutside";

NSString* const kYZHRouteIndexRoot       = @"YZHRouteIndexRoot";

NSString* const kYZHRouteCommunityTab        = @"/rootTab/0";
NSString* const kYZHRoutePrivatelyChatTab    = @"/rootTab/1";
NSString* const kYZHRouteAddressBookTab      = @"/rootTab/2";
NSString* const kYZHRouteDiscoverTab         = @"/rootTab/3";
NSString* const kYZHRouteMyCenterthTab       = @"/rootTab/4";

NSString* const kYZHRouteViewControllerClassKey = @"class";
NSString* const kYZHRouteViewControllerNameKey = @"name";
NSString* const kYZHRouteViewControllerNotesKey = @"notes";
NSString* const kYZHRouteViewControllerNeedLoginKey = @"needLogin";

#pragma mark -- GuidePage

NSString* const kYZHRouterWelcome                 = @"/guidePage/welcome";
NSString* const kYZHRouterLogin                   = @"/guidePage/login";
NSString* const kYZHRouterRegister                = @"/guidePage/register";
NSString* const kYZHRouterFindPassword            = @"/guidePage/findPassword";
NSString* const kYZHRouterSettingPassword         = @"/guidePage/settingPassword";
NSString* const kYZHRouterModifyPassword         = @"/guidePage/modifyPassword";

#pragma mark -- Mycenter

NSString* const kYZHRouterMyInformation           = @"/myCenter/myInformation";
NSString* const kYZHRouterMyInformationPhoto      = @"/myInformation/photo";
NSString* const kYZHRouterMyInformationSetName    = @"/myInformation/setName";
NSString* const kYZHRouterMyInformationSetGender  = @"/myInformation/setGender";
NSString* const kYZHRouterMyInformationMyQRCode   = @"/myInformation/myQRCode";
NSString* const kYZHRouterMyInformationYoloID     = @"/myInformation/YoloID";
NSString* const kYZHRouterMyInformationMyPlace    = @"/myInformation/myPlace";
NSString* const kYZHRouterMyPlaceCity             = @"/myInformation/myPlaceCity";
NSString* const kYZHRouterAboutYolo               = @"/myCenter/aboutYolo";
NSString* const kYZHRouterDiscount                = @"/myCenter/discount";
NSString* const kYZHRouterPrivacySetting          = @"/myCenter/privacySetting";
NSString *const kYZHRouterPrivacyPassword          = @"/myCenter/privacySetting/password";
NSString* const kYZHRouterSettingCenter           = @"/myCenter/settingCenter";
NSString* const kYZHRouterMyIntegral              = @"/myCenter/myIntegral";
NSString* const kYZHRouterWKWeb                   = @"/myCenter/wkWeb";


#pragma mark -- AddressBook

NSString* const kYZHRouterAddressBookDetails   = @"/addressBook/details/";
NSString* const kYZHRouterTeamMemberBookDetails = @"/teamMember/details/";
NSString* const kYZHRouterAddressBookBlackList = @"/teamMember/blackList/";
NSString* const kYZHRouterAddressBookAddFriendShow   = @"/addressBook/addFirendShow/";
NSString* const kYZHRouterAddressBookSetNote   = @"/addressBook/details/setNote";
NSString* const kYZHRouterAddressBookSetTag   = @"/addressBook/details/setTag";
NSString* const kYZHRouterAddressBookSetting   = @"/addressBook/details/setting";
NSString* const kYZHRouterAddressBookAddFirend   = @"/addressBook/addFriend";
NSString* const kYZHRouterAddressBookAddFirendSearch   = @"/addressBook/addFriend/search";
NSString* const kYZHRouterAddressBookAddFirendSendVerify = @"/addressBook/addFriend/sendVerify";
NSString* const kYZHRouterAddressBookPhoneContact  = @"/addressBook/phoneContact";
NSString* const kYZHRouterAddressBookScanQRCode  = @"/addressBook/scanQRCode";
NSString* const kYZHRouterAddressBookAddFirendRecord = @"/addressBook/addFirendRecord";
NSString *const kYZHRouterAddressBookSearchTeam = @"/addressBook/searchTeam";
NSString *const kYZHRouterAddressBookSearchFirend  = @"/teamChat/searchFriend";

#pragma mark -- Session

NSString *const kYZHRouterSessionSharedCard = @"/community/sharedCard";
NSString *const kYZHRouterCommunityCreateTeam = @"/community/createTeam";
NSString *const kYZHRouterCommunityCreateTeamAddition = @"/community/createTeam/addition";
NSString *const kYZHRouterCommunityCreateTeamResult = @"/community/createTeam/result";
NSString *const kYZHRouterCommunityCreateTeamTagSelected = @"/community/createTeam/tagSelected";
NSString *const kYZHRouterCommunityCard = @"/community/card";
NSString *const kYZHRouterCommunityCardIntro = @"/community/cardIntro";
NSString *const kYZHRouterCommunityRecruitCardIntro = @"/community/cardIntro/recruit";
NSString *const kYZHRouterCommunityCardHeaderEdit = @"/community/headerEdit";
NSString *const kYZHRouterCommunityCardShared = @"/community/cardShared";
NSString *const kYZHRouterCommunityCardSharedCheck = @"/community/cardSharedCheck";
NSString *const kYZHRouterCommunityCardQRCodeShared = @"/community/qrCodeShared";
NSString *const kYZHRouterCommunityCardSetNickName = @"/community/setNickName";
NSString *const kYZHRouterCommunityCardTeamNotice = @"/community/teamNotice";
NSString *const kYZHRouterCommunityCardSendTeamNotice = @"/community/teamSendNotice";
NSString *const kYZHRouterCommunityCardSelectedTeam = @"/community/teamNotice/selectedTeam";
NSString *const kYZHRouterSessionChatContent = @"/session/chatContent";
NSString *const kYZHRouterSessionSearchChatContent = @"/session/searchChatContent";
NSString *const kYZHRouterCommunitySetTeamTag = @"/community/setTeamTag";
NSString *const kYZHRouterCommunityAtTeamMember = @"/community/AtMember/";
NSString *const kYZHRouterPrivateChatSearch = @"/privateChat/search";
NSString *const kYZHRouterTeamChatSearch  = @"/teamChat/search";
NSString *const kYZHRouterTeamRecruitSearch = @"/teamRecruit/search";

NSString *const kYZHRouterAppConfig = @"debug/appConfig";


@implementation YZHRouterConfig

+ (NSDictionary *)configInfo{
    
    return @{kYZHRouterWelcome: @{
                 kYZHRouteViewControllerClassKey: @"YZHWelcomeVC",
                 kYZHRouteViewControllerNameKey: @"欢迎引导",
                 kYZHRouteViewControllerNotesKey: @"",
                 kYZHRouteViewControllerNeedLoginKey:@"0",
                     },
             kYZHRouterLogin: @{
                     kYZHRouteViewControllerClassKey: @"YZHLoginVC",
                     kYZHRouteViewControllerNameKey: @"登录",
                     kYZHRouteViewControllerNotesKey: @"",
                     kYZHRouteViewControllerNeedLoginKey:@"0",
                     },
             kYZHRouterRegister: @{
                     kYZHRouteViewControllerClassKey: @"YZHRegisterVC",
                     kYZHRouteViewControllerNameKey: @"注册",
                     kYZHRouteViewControllerNotesKey: @"",
                     kYZHRouteViewControllerNeedLoginKey:@"0",
                     },
             kYZHRouterFindPassword: @{
                     kYZHRouteViewControllerClassKey: @"YZHFindPasswordVC",
                     kYZHRouteViewControllerNameKey: @"找回密码",
                     kYZHRouteViewControllerNotesKey: @"",
                     kYZHRouteViewControllerNeedLoginKey:@"0",
                     },
             kYZHRouterSettingPassword: @{
                     kYZHRouteViewControllerClassKey: @"YZHSettingPasswordVC",
                     kYZHRouteViewControllerNameKey: @"设置密码",
                     kYZHRouteViewControllerNotesKey: @"",
                     kYZHRouteViewControllerNeedLoginKey:@"0",
                     },
             kYZHRouterModifyPassword: @{
                     kYZHRouteViewControllerClassKey: @"YZHModifyPasswordVC",
                     kYZHRouteViewControllerNameKey: @"修改密码",
                     kYZHRouteViewControllerNotesKey: @"",
                     kYZHRouteViewControllerNeedLoginKey:@"1",
                                          },
             kYZHRouterMyInformation: @{
                     kYZHRouteViewControllerClassKey: @"YZHMyInformationVC",
                     kYZHRouteViewControllerNameKey: @"个人信息",
                     kYZHRouteViewControllerNotesKey: @"",
                     kYZHRouteViewControllerNeedLoginKey:@"1",
                     },
             kYZHRouterMyInformationPhoto: @{
                     kYZHRouteViewControllerClassKey: @"YZHMyInformationPhotoVC",
                     kYZHRouteViewControllerNameKey: @"更换头像",
                     kYZHRouteViewControllerNotesKey: @"",
                     kYZHRouteViewControllerNeedLoginKey:@"1",
                     },
             kYZHRouterMyInformationSetName: @{
                     kYZHRouteViewControllerClassKey: @"YZHMyInformationSetNameVC",
                     kYZHRouteViewControllerNameKey: @"设置昵称",
                     kYZHRouteViewControllerNotesKey: @"",
                     kYZHRouteViewControllerNeedLoginKey:@"1",
                     },
             kYZHRouterMyInformationSetGender: @{
                     kYZHRouteViewControllerClassKey: @"YZHMyInformationSetGenderVC",
                     kYZHRouteViewControllerNameKey: @"设置性别",
                     kYZHRouteViewControllerNotesKey: @"",
                     kYZHRouteViewControllerNeedLoginKey:@"1",
                     },
             kYZHRouterMyInformationMyQRCode: @{
                     kYZHRouteViewControllerClassKey: @"YZHMyInformationMyQRCodeVC",
                     kYZHRouteViewControllerNameKey: @"我的二维码",
                     kYZHRouteViewControllerNotesKey: @"",
                     kYZHRouteViewControllerNeedLoginKey:@"1",
                     },
             kYZHRouterMyInformationYoloID: @{
                     kYZHRouteViewControllerClassKey: @"YZHMyInformationYoloIDVC",
                     kYZHRouteViewControllerNameKey: @"设置 YoloID",
                     kYZHRouteViewControllerNotesKey: @"",
                     kYZHRouteViewControllerNeedLoginKey:@"1",
                     },
             kYZHRouterMyInformationMyPlace: @{
                     kYZHRouteViewControllerClassKey: @"YZHMyInformationMyPlaceVC",
                     kYZHRouteViewControllerNameKey: @"设置地址",
                     kYZHRouteViewControllerNotesKey: @"",
                     kYZHRouteViewControllerNeedLoginKey:@"1",
                     },
             kYZHRouterMyPlaceCity: @{
                     kYZHRouteViewControllerClassKey: @"YZHMyplaceCityVC",
                     kYZHRouteViewControllerNameKey: @"设置地址",
                     kYZHRouteViewControllerNotesKey: @"",
                     kYZHRouteViewControllerNeedLoginKey:@"1",
                     },
             kYZHRouterAboutYolo: @{
                     kYZHRouteViewControllerClassKey: @"YZHAboutYoloVC",
                     kYZHRouteViewControllerNameKey: @"关于",
                     kYZHRouteViewControllerNotesKey: @"",
                     kYZHRouteViewControllerNeedLoginKey:@"1",
                     },
             kYZHRouterDiscount: @{
                     kYZHRouteViewControllerClassKey: @"YZHDiscountVC",
                     kYZHRouteViewControllerNameKey: @"异业联盟",
                     kYZHRouteViewControllerNotesKey: @"",
                     kYZHRouteViewControllerNeedLoginKey:@"1",
                     },
             kYZHRouterSettingCenter: @{
                     kYZHRouteViewControllerClassKey: @"YZHSettingCenterVC",
                     kYZHRouteViewControllerNameKey: @"设置",
                     kYZHRouteViewControllerNotesKey: @"",
                     kYZHRouteViewControllerNeedLoginKey:@"1",
                     },
             kYZHRouterMyIntegral: @{
                     kYZHRouteViewControllerClassKey: @"YZHMyIntegralVC",
                     kYZHRouteViewControllerNameKey: @"我的积分",
                     kYZHRouteViewControllerNotesKey: @"",
                     kYZHRouteViewControllerNeedLoginKey:@"1",
                     },
             kYZHRouterPrivacySetting: @{
                     kYZHRouteViewControllerClassKey: @"YZHPrivacySettingVC",
                     kYZHRouteViewControllerNameKey: @"隐私设置",
                     kYZHRouteViewControllerNotesKey: @"",
                     kYZHRouteViewControllerNeedLoginKey:@"1",
                     },
             kYZHRouterPrivacyPassword: @{
                     kYZHRouteViewControllerClassKey: @"YZHPrivacyReadPasswordVC",
                     kYZHRouteViewControllerNameKey: @"阅读密码",
                     kYZHRouteViewControllerNotesKey: @"",
                     kYZHRouteViewControllerNeedLoginKey:@"1",
                     },
             kYZHRouterWKWeb: @{
                     kYZHRouteViewControllerClassKey: @"YZHWKWebVC",
                     kYZHRouteViewControllerNameKey: @"阅读密码",
                     kYZHRouteViewControllerNotesKey: @"",
                     kYZHRouteViewControllerNeedLoginKey:@"1",
                     },
             kYZHRouterAddressBookDetails: @{
                     kYZHRouteViewControllerClassKey: @"YZHAddBookDetailsVC",
                     kYZHRouteViewControllerNameKey: @"详细资料",
                     kYZHRouteViewControllerNotesKey: @"",
                     kYZHRouteViewControllerNeedLoginKey:@"1",
                     },
             kYZHRouterTeamMemberBookDetails: @{
                     kYZHRouteViewControllerClassKey: @"YZHTeamMemberDetailsVC",
                     kYZHRouteViewControllerNameKey: @"群成员详细资料",
                     kYZHRouteViewControllerNotesKey: @"",
                     kYZHRouteViewControllerNeedLoginKey:@"1",
                     },
             kYZHRouterAddressBookBlackList: @{
                     kYZHRouteViewControllerClassKey: @"YZHAddressBookBlackListVC",
                     kYZHRouteViewControllerNameKey: @"黑名单管理",
                     kYZHRouteViewControllerNotesKey: @"",
                     kYZHRouteViewControllerNeedLoginKey:@"1",
                     },
             kYZHRouterAddressBookAddFriendShow: @{
                     kYZHRouteViewControllerClassKey: @"YZHAddBookAddFirendShowVC",
                     kYZHRouteViewControllerNameKey: @"详细资料",
                     kYZHRouteViewControllerNotesKey: @"",
                     kYZHRouteViewControllerNeedLoginKey:@"1",
                     },
             kYZHRouterAddressBookSetNote: @{
                     kYZHRouteViewControllerClassKey: @"YZHAddBookSetNoteVC",
                     kYZHRouteViewControllerNameKey: @"设置备注",
                     kYZHRouteViewControllerNotesKey: @"",
                     kYZHRouteViewControllerNeedLoginKey:@"1",
                     },
             kYZHRouterAddressBookSetTag: @{
                     kYZHRouteViewControllerClassKey: @"YZHAddBookSetTagVC",
                     kYZHRouteViewControllerNameKey: @"设置标签",
                     kYZHRouteViewControllerNotesKey: @"",
                     kYZHRouteViewControllerNeedLoginKey:@"1",
                     },
             kYZHRouterAddressBookSetting: @{
                     kYZHRouteViewControllerClassKey: @"YZHDetailsSettingVC",
                     kYZHRouteViewControllerNameKey: @"其他设置",
                     kYZHRouteViewControllerNotesKey: @"",
                     kYZHRouteViewControllerNeedLoginKey:@"1",
                     },
             kYZHRouterAddressBookAddFirend: @{
                     kYZHRouteViewControllerClassKey: @"YZHAddBookAddFirendVC",
                     kYZHRouteViewControllerNameKey: @"添加好友",
                     kYZHRouteViewControllerNotesKey: @"",
                     kYZHRouteViewControllerNeedLoginKey:@"1",
                     },
             kYZHRouterAddressBookAddFirendSearch: @{
                 kYZHRouteViewControllerClassKey: @"YZHAddFirendSearchVC",
                 kYZHRouteViewControllerNameKey: @"搜索添加好友",
                 kYZHRouteViewControllerNotesKey: @"",
                 kYZHRouteViewControllerNeedLoginKey:@"1",
                 },
             kYZHRouterAddressBookAddFirendSendVerify: @{
                     kYZHRouteViewControllerClassKey: @"YZHAddFirendSendVerifyVC",
                     kYZHRouteViewControllerNameKey: @"添加好友验证消息",
                     kYZHRouteViewControllerNotesKey: @"",
                     kYZHRouteViewControllerNeedLoginKey:@"1",
                     },
             kYZHRouterAddressBookPhoneContact: @{
                     kYZHRouteViewControllerClassKey: @"YZHAddBookPhoneContactVC",
                     kYZHRouteViewControllerNameKey: @"手机联系人",
                     kYZHRouteViewControllerNotesKey: @"",
                     kYZHRouteViewControllerNeedLoginKey:@"1",
                     },
             kYZHRouterAddressBookAddFirendRecord: @{
                     kYZHRouteViewControllerClassKey: @"YZHAddBookAddFirendRecordVC",
                     kYZHRouteViewControllerNameKey: @"好友申请",
                     kYZHRouteViewControllerNotesKey: @"",
                     kYZHRouteViewControllerNeedLoginKey:@"1",
                     },
             kYZHRouterAddressBookScanQRCode: @{
                     kYZHRouteViewControllerClassKey: @"YZHScanQRCodeVC",
                     kYZHRouteViewControllerNameKey: @"扫码",
                     kYZHRouteViewControllerNotesKey: @"",
                     kYZHRouteViewControllerNeedLoginKey:@"1",
                     },
             kYZHRouterAddressBookSearchTeam: @{
                     kYZHRouteViewControllerClassKey: @"YZHSearchTeamVC",
                     kYZHRouteViewControllerNameKey: @"社群搜索",
                     kYZHRouteViewControllerNotesKey: @"",
                     kYZHRouteViewControllerNeedLoginKey:@"1",
                     },
             kYZHRouterAddressBookSearchFirend: @{
                     kYZHRouteViewControllerClassKey: @"YZHAddBookSearchVC",
                     kYZHRouteViewControllerNameKey: @"搜索好友",
                     kYZHRouteViewControllerNotesKey: @"",
                     kYZHRouteViewControllerNeedLoginKey:@"1",
                     },
             
             kYZHRouterSessionSharedCard: @{
                 kYZHRouteViewControllerClassKey: @"YZHSharedContactVC",
                 kYZHRouteViewControllerNameKey: @"好友或群分享等",
                 kYZHRouteViewControllerNotesKey: @"",
                 kYZHRouteViewControllerNeedLoginKey:@"1",
                 },
             kYZHRouterCommunityCreateTeam: @{
                     kYZHRouteViewControllerClassKey: @"YZHCreatTeamVC",
                     kYZHRouteViewControllerNameKey: @"填写群信息",
                     kYZHRouteViewControllerNotesKey: @"",
                     kYZHRouteViewControllerNeedLoginKey:@"1",
                     },
             kYZHRouterCommunityCreateTeamAddition: @{
                     kYZHRouteViewControllerClassKey: @"YZHCreateTeamAdditionVC",
                     kYZHRouteViewControllerNameKey: @"填写公开群信息",
                     kYZHRouteViewControllerNotesKey: @"",
                     kYZHRouteViewControllerNeedLoginKey:@"1",
                     },
             kYZHRouterCommunityCreateTeamResult: @{
                     kYZHRouteViewControllerClassKey: @"YZHCreateTeamResultVC",
                     kYZHRouteViewControllerNameKey: @"填写公开群信息",
                     kYZHRouteViewControllerNotesKey: @"",
                     kYZHRouteViewControllerNeedLoginKey:@"1",
                     },
             kYZHRouterCommunityCreateTeamTagSelected : @{
             kYZHRouteViewControllerClassKey: @"YZHTeamTagSelectedVC",
             kYZHRouteViewControllerNameKey: @"选择群标签",
             kYZHRouteViewControllerNotesKey: @"",
             kYZHRouteViewControllerNeedLoginKey:@"1",
             },
             kYZHRouterCommunityCard : @{
                     kYZHRouteViewControllerClassKey: @"YZHTeamCardVC",
                     kYZHRouteViewControllerNameKey: @"群信息",
                     kYZHRouteViewControllerNotesKey: @"",
                     kYZHRouteViewControllerNeedLoginKey:@"1",
                     },
             kYZHRouterCommunityCardIntro : @{
                     kYZHRouteViewControllerClassKey: @"YZHTeamCardIntroVC",
                     kYZHRouteViewControllerNameKey: @"非群成员群信息",
                     kYZHRouteViewControllerNotesKey: @"",
                     kYZHRouteViewControllerNeedLoginKey:@"1",
                     },
             kYZHRouterCommunityRecruitCardIntro : @{
                     kYZHRouteViewControllerClassKey: @"YZHTeamRecruitCardIntroVC",
                     kYZHRouteViewControllerNameKey: @"非群成员招募群信息",
                     kYZHRouteViewControllerNotesKey: @"",
                     kYZHRouteViewControllerNeedLoginKey:@"1",
                     },
             
             kYZHRouterCommunityCardHeaderEdit : @{
                     kYZHRouteViewControllerClassKey: @"YZHTeamDataEditVC",
                     kYZHRouteViewControllerNameKey: @"群基本信息",
                     kYZHRouteViewControllerNotesKey: @"",
                     kYZHRouteViewControllerNeedLoginKey:@"1",
                     },
             kYZHRouterCommunityCardShared : @{
                     kYZHRouteViewControllerClassKey: @"YZHTeamSharedVC",
                     kYZHRouteViewControllerNameKey: @"互相申请",
                     kYZHRouteViewControllerNotesKey: @"",
                     kYZHRouteViewControllerNeedLoginKey:@"1",
                     },
             kYZHRouterCommunityCardSharedCheck : @{
                     kYZHRouteViewControllerClassKey: @"YZHTeamSharedCheckVC",
                     kYZHRouteViewControllerNameKey: @"互相群信息",
                     kYZHRouteViewControllerNotesKey: @"",
                     kYZHRouteViewControllerNeedLoginKey:@"1",
                     },
             kYZHRouterCommunityCardQRCodeShared : @{
             kYZHRouteViewControllerClassKey: @"YZHTeamQRCodeSharedVC",
             kYZHRouteViewControllerNameKey: @"群二维码分享",
             kYZHRouteViewControllerNotesKey: @"",
             kYZHRouteViewControllerNeedLoginKey:@"1",
             },
             kYZHRouterCommunityCardSetNickName : @{
             kYZHRouteViewControllerClassKey: @"YZHTeamSetNameVC",
             kYZHRouteViewControllerNameKey: @"群内昵称",
             kYZHRouteViewControllerNotesKey: @"",
             kYZHRouteViewControllerNeedLoginKey:@"1",
             },
             kYZHRouterCommunityCardTeamNotice : @{
             kYZHRouteViewControllerClassKey: @"YZHTeamNoticeVC",
             kYZHRouteViewControllerNameKey: @"群公告内容",
             kYZHRouteViewControllerNotesKey: @"",
             kYZHRouteViewControllerNeedLoginKey:@"1",
             },
             kYZHRouterCommunityCardSendTeamNotice: @{
             kYZHRouteViewControllerClassKey: @"YZHTeamSendNoticeVC",
             kYZHRouteViewControllerNameKey: @"发布群公告",
             kYZHRouteViewControllerNotesKey: @"",
             kYZHRouteViewControllerNeedLoginKey:@"1",
             },
             kYZHRouterCommunityCardSelectedTeam: @{
             kYZHRouteViewControllerClassKey: @"YZHTeamNoticeSelectTeamVC",
             kYZHRouteViewControllerNameKey: @"我的群",
             kYZHRouteViewControllerNotesKey: @"",
             kYZHRouteViewControllerNeedLoginKey:@"1",
             },
             kYZHRouterSessionChatContent: @{
             kYZHRouteViewControllerClassKey: @"YZHChatContentVC",
             kYZHRouteViewControllerNameKey: @"聊天内容",
             kYZHRouteViewControllerNotesKey: @"",
             kYZHRouteViewControllerNeedLoginKey:@"1",
             },
             kYZHRouterSessionSearchChatContent: @{
             kYZHRouteViewControllerClassKey: @"YZHSearchChatContentVC",
             kYZHRouteViewControllerNameKey: @"搜索聊天内容",
             kYZHRouteViewControllerNotesKey: @"",
             kYZHRouteViewControllerNeedLoginKey:@"1",
             },
             kYZHRouterCommunitySetTeamTag: @{
             kYZHRouteViewControllerClassKey: @"YZHSetTeamTagVC",
             kYZHRouteViewControllerNameKey: @"设置群标签",
             kYZHRouteViewControllerNotesKey: @"",
             kYZHRouteViewControllerNeedLoginKey:@"1",
             },
             kYZHRouterCommunityAtTeamMember: @{
             kYZHRouteViewControllerClassKey: @"YZHCommunityAtMemberVC",
             kYZHRouteViewControllerNameKey: @"选择@的人",
             kYZHRouteViewControllerNotesKey: @"",
             kYZHRouteViewControllerNeedLoginKey:@"1",
             },
             kYZHRouterPrivateChatSearch: @{
                     kYZHRouteViewControllerClassKey: @"YZHPrivatelyChatSearchVC",
                     kYZHRouteViewControllerNameKey: @"私聊搜索",
                     kYZHRouteViewControllerNotesKey: @"",
                     kYZHRouteViewControllerNeedLoginKey:@"1",
                     },
             kYZHRouterTeamChatSearch: @{
                     kYZHRouteViewControllerClassKey: @"YZHCommunitySearchVC",
                     kYZHRouteViewControllerNameKey: @"群聊搜索",
                     kYZHRouteViewControllerNotesKey: @"",
                     kYZHRouteViewControllerNeedLoginKey:@"1",
                     },
             kYZHRouterTeamRecruitSearch: @{
                     kYZHRouteViewControllerClassKey: @"YZHTeamRecruitSearch",
                     kYZHRouteViewControllerNameKey: @"招募搜索",
                     kYZHRouteViewControllerNotesKey: @"",
                     kYZHRouteViewControllerNeedLoginKey:@"1",
                     },
             kYZHRouterAppConfig: @{
                 kYZHRouteViewControllerClassKey: @"YMAppConfigVC",
                 kYZHRouteViewControllerNameKey: @"调试台",
                 kYZHRouteViewControllerNotesKey: @"",
                 kYZHRouteViewControllerNeedLoginKey:@"1",
                 },
        };
    
}

@end
