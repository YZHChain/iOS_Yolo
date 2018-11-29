//
//  YZHPathConst.h
//  YZHYolo
//
//  Created by Jersey on 2018/9/12.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#ifndef YZHPathConst_h
#define YZHPathConst_h

#define PATH_USER_REGISTERED_SENDSMSCODE        @"http://192.168.3.47:8084/sms/sendSMSVerifyCode"   //短信验证码发送
#define PATH_USER_REGISTERED_SMSVERIFYCODE      @"http://192.168.3.47:8084/sms/verifySMSVerifyCode" //短信验证码校验
#define PATH_USER_LOGIN_FORGETPASSWORD          @"http://192.168.3.47:8084/user/forgetPassword"     // 客户端用户忘记密码
#define PATH_USER_MODIFI_PASSWORD               @"http://192.168.3.47:8084/user/updatePassword"     // 客户端用户修改密码
#define PATH_USER_LOGIN_LOGINVERIFY             @"http://192.168.3.47:8084/user/login"              // 客户端用户登录
#define PATH_USER_REGISTERED_REGISTEREDNVERIFY  @"http://192.168.3.47:8084/user/register"           // 客户端用户注册
#define PATH_USER_CHECKOUTYOLOID                @"http://192.168.3.47:8084/user/checkYoloNo"        // 检测YoloID 是否可用包括手机号
#define PATH_USER_UPDATELOGIN                   @"http://192.168.3.47:8084/user/updateLogin"        //修改 Yolo 号
#define PATH_USER_CHECKOUPHONE                  @"http://192.168.3.47:8084/user/checkPhone"         //检测Phone 是否已经注册
#define PATH_USER_SETTINGSPRIVACY               @"http://192.168.3.47:8084/user/settingsPrivacy" //隐私设置
#define PATH_FRIENDS_MOBILEFRIENDS              @"http://192.168.3.47:8081/friendsManage/getMobileFriends" //获取通讯录好友
#define PATH_FRIENDS_SEARCHUSER                 @"http://192.168.3.47:8084/user/searchuser"         //用户搜索
#define PATH_USER_INVITE_SENDSMS                @"http://192.168.3.47:8084/sms/sendSMSInvite"         //用户邀请短信发送接口

#endif /* YZHPathConst_h */
