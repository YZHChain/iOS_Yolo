//
//  YZHPathConst.h
//  YZHYolo
//
//  Created by Jersey on 2018/9/12.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#ifndef YZHPathConst_h
#define YZHPathConst_h

#define PATH_YOLOIP   @"https://yolotest.yzhchain.com/"
#define PATH_YOLOPROT @"9091"

#define PATH_USER_REGISTERED_SENDSMSCODE        @"https://yolotest.yzhchain.com/yolo-login/sms/sendSMSVerifyCode"   //短信验证码发送
#define PATH_USER_REGISTERED_SMSVERIFYCODE      @"https://yolotest.yzhchain.com/yolo-login/sms/verifySMSVerifyCode" //短信验证码校验
#define PATH_USER_LOGIN_FORGETPASSWORD          @"https://yolotest.yzhchain.com/yolo-login/user/forgetPassword"     // 客户端用户忘记密码
#define PATH_USER_MODIFI_PASSWORD               @"https://yolotest.yzhchain.com/yolo-login/user/updatePassword"     // 客户端用户修改密码
#define PATH_USER_LOGIN_LOGINVERIFY             @"https://yolotest.yzhchain.com/yolo-login/user/login"              // 客户端用户登录
#define PATH_USER_REGISTERED_REGISTEREDNVERIFY  @"https://yolotest.yzhchain.com/yolo-login/user/register"           // 客户端用户注册

#define PATH_USER_REGISTERED_CHECKINVITECODE  @"https://yolotest.yzhchain.com/yolo-login/user/checkInviteCode"    // 检测邀请码
#define PATH_USER_CHECKOUTYOLOID              @"https://yolotest.yzhchain.com/yolo-login/user/checkYoloNo"        // 检测YoloID 是否可用包括手机号
#define PATH_USER_CHECKSECRETKEY              @"https://yolotest.yzhchain.com/yolo-login/user/verifySecretKey"              // 校验密钥
#define PATH_USER_GETECRETKEY                 @"https:/yolotest.yzhchain.com/yolo-login/user/getSecretKey"                // 获取密钥
#define PATH_USER_SECRETKEYUPDATEPWD          @"https:/yolotest.yzhchain.com/yolo-login/user/secretKeyUpdatePwd" //用户密钥修改密钥接口
#define PATH_USER_UPDATELOGIN                   @"https://yolotest.yzhchain.com/yolo-login/user/updateLogin"        //修改 Yolo 号
#define PATH_USER_CHECKOUPHONE                  @"https://yolotest.yzhchain.com/yolo-login/user/checkPhone"         //检测Phone 是否已经注册
#define PATH_USER_CHECKOUAPPUPDATE  @"https://yolotest.yzhchain.com/yolo-login/update/searchuser"  // 检测 App 更新

#define PATH_USER_SETTINGSPRIVACY               @"https://yolotest.yzhchain.com/yolo-login/user/settingsPrivacy" //隐私设置
#define PATH_FRIENDS_MOBILEFRIENDS              @"https://yolotest.yzhchain.com/yolo-person/friendsManage/getMobileFriends" //获取通讯录好友
#define PATH_FRIENDS_SEARCHUSER                 @"https://yolotest.yzhchain.com/yolo-login/user/searchuser"         //用户搜索
#define PATH_USER_INVITE_SENDSMS                @"https://yolotest.yzhchain.com/yolo-person/sms/sendSMSInvite"         //用户邀请短信发送接口
#define PATH_TEAM_ADDUPDATEGROUP                @"https://yolotest.yzhchain.com/yolo-square/ymGroup/addGroup"// 增加或修改群资料
#define PATH_TEAM_DELETEGROUP                   @"https://yolotest.yzhchain.com/yolo-square/ymGroup/delete"// 删除群
#define PATH_TEAM_DELETEMYRECRUITS              @"https://yolotest.yzhchain.com/yolo-square/ymRecruit/deleteMyRecruits"// 删除我的招募信息
#define PATH_TEAM_GETMYRECRUITS              @"https://yolotest.yzhchain.com/yolo-square/ymRecruit/myRecruitInfo"// 获取我的招募信息
#define PATH_TEAM_PUBLISHMYRECRUITS             @"https://yolotest.yzhchain.com/yolo-square/ymRecruit/publishMyRecruits"// 发布或编辑招募信息
#define PATH_TEAM_SEARCH_MYRECRUITS             @"https://yolotest.yzhchain.com/yolo-square/ymRecruit/search_myRecruits"// 招募管理列表
#define PATH_TEAM_SEARCH_RECRUITS               @"https://yolotest.yzhchain.com/yolo-square/ymRecruit/search_recruits"// 社群招募搜索列表

#define PATH_TEAM_NOTICE_ADD                    @"https://yolotest.yzhchain.com/yolo-chat/groupNotice/add" //新增
#define PATH_TEAM_NOTICE_DELETE                 @"https://yolotest.yzhchain.com/yolo-chat/groupNotice/delete" //删除
#define PATH_TEAM_NOTICE_LIST                    @"https://yolotest.yzhchain.com/yolo-chat/groupNotice/list" //展示
#define PATH_TEAM_RECOMMENDEDGROUP               @"https://yolotest.yzhchain.com/yolo-square/ymGroup/recommendedGroup" //推荐群列表
#define PATH_TEAM_SEARCHGROUP               @"https://yolotest.yzhchain.com/yolo-square/ymGroup/search_group" //搜索群列表

#endif /* YZHPathConst_h */
