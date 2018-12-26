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

#define SERVER_LOGIN(PATH)     ([@"/yolo-login" stringByAppendingString: PATH])
#define SERVER_PERSON(PATH)    ([@"/yolo-person" stringByAppendingString: PATH])
#define SERVER_SQUARE(PATH)    ([@"/yolo-square" stringByAppendingString: PATH])
#define SERVER_CHAT(PATH)      ([@"/yolo-chat" stringByAppendingString: PATH])
#define SERVER_INTEGRAL(PATH)  ([@"/yolo-integral" stringByAppendingString: PATH])

#pragma mark -- SERVER_LOGIN

#define PATH_USER_LOGIN_FORGETPASSWORD          @"/user/forgetPassword"     // 客户端用户忘记密码
#define PATH_USER_MODIFI_PASSWORD               @"/user/updatePassword"     // 客户端用户修改密码
#define PATH_USER_LOGIN_LOGINVERIFY             @"/user/login"              // 客户端用户登录
#define PATH_USER_REGISTERED_REGISTEREDNVERIFY  @"/user/register"           // 客户端用户注册
#define PATH_USER_REGISTERED_CHECKINVITECODE    @"/user/checkInviteCode"    // 检测邀请码
#define PATH_USER_CHECKOUTYOLOID                @"/user/checkYoloNo"        // 检测YoloID 是否可用包括手机号
#define PATH_USER_CHECKSECRETKEY                @"/user/verifySecretKey"              // 校验密钥
#define PATH_USER_GETECRETKEY                   @"/user/getSecretKey"                // 获取密钥
#define PATH_USER_SECRETKEYUPDATEPWD            @"/user/secretKeyUpdatePwd" //用户密钥修改密钥接口
#define PATH_USER_UPDATELOGIN                   @"/user/updateLogin"        //修改 Yolo 号
#define PATH_USER_CHECKOUPHONE                  @"/user/checkPhone"         //检测Phone 是否已经注册
#define PATH_USER_SETTINGSPRIVACY               @"/user/settingsPrivacy" //隐私设置
#define PATH_FRIENDS_SEARCHUSER                 @"/user/searchuser"         //用户搜索
#define PATH_USER_REGISTERED_SENDSMSCODE        @"/sms/sendSMSVerifyCode"   //短信验证码发送
#define PATH_USER_REGISTERED_SMSVERIFYCODE      @"/sms/verifySMSVerifyCode" //短信验证码校验
#define PATH_USER_CHECKOUAPPUPDATE              @"/update/searchuser"  // 检测 App 更新

#pragma mark -- SERVER_PERSON

#define PATH_PERSON_MOBILEFRIENDS                 @"/friendsManage/getMobileFriends" //获取通讯录好友
#define PATH_PERSON_INVITE_SENDSMS                @"/sms/sendSMSInvite"         //用户邀请短信发送接口

#pragma mark -- SERVER_SQUARE

#define PATH_TEAM_ADDUPDATEGROUP                @"/ymGroup/addGroup"// 增加或修改群资料
#define PATH_TEAM_DELETEGROUP                   @"/ymGroup/delete"// 删除群
#define PATH_TEAM_RECOMMENDEDGROUP              @"/ymGroup/recommendedGroup" //推荐群列表
#define PATH_TEAM_SEARCHGROUP                   @"/ymGroup/search_group" //搜索群列表
#define PATH_TEAM_DELETEMYRECRUITS              @"/ymRecruit/deleteMyRecruits"// 删除我的招募信息
#define PATH_TEAM_GETMYRECRUITS                 @"/ymRecruit/myRecruitInfo"// 获取我的招募信息
#define PATH_TEAM_PUBLISHMYRECRUITS             @"/ymRecruit/publishMyRecruits"// 发布或编辑招募信息
#define PATH_TEAM_SEARCH_MYRECRUITS             @"/ymRecruit/search_myRecruits"// 招募管理列表
#define PATH_TEAM_SEARCH_RECRUITS               @"/ymRecruit/search_recruits"// 社群招募搜索列表

#pragma mark -- SERVER_CHAT

#define PATH_TEAM_NOTICE_ADD                    @"/groupNotice/add" //新增
#define PATH_TEAM_NOTICE_DELETE                 @"/groupNotice/delete" //删除
#define PATH_TEAM_NOTICE_LIST                   @"/groupNotice/list" //展示

#pragma mark -- SERVER_INTEGRAL

// 积分
#define PATH_INTEGRL_COLLARTASK                 @"/api/collarTaskIntegral" //搜索群列表

#pragma mark -- H5 PATH

#define PATH_WEB_SQUARE                         @"/yolo-web/index.html" //广场
#define PATH_WEB_INTEGRL                        @"/yolo-web/html/integral/index_page.html" //我的积分
#define PATH_WEB_DISCOUNT                       @"/yylm-web/entrance.html" //异业联盟
#define PATH_WEB_ABOUTYOLO                      @"/yolo-web/html/about/new_des.html" //关于YOLO
#define PATH_WEB_ABOUTYOLO_PROBLEM              @"/yolo-web/html/about/common_problem.html" //常见问题
#define PATH_WEB_ABOUTYOLO_INTRODUCE            @"/yolo-web/html/about/characteristic.html" //特色介绍
#define PATH_WEB_ABOUTYOLO_FEEDBACK             @"/yolo-web/html/about/feedback.html" //问题反馈


#endif /* YZHPathConst_h */
