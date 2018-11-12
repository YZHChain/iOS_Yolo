//
//  YZHPathConst.h
//  YZHYolo
//
//  Created by Jersey on 2018/9/12.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#ifndef YZHPathConst_h
#define YZHPathConst_h

#define PATH_USER_REGISTERED_SENDSMSCODE        @"/sms/sendSMSVerifyCode"   //短信验证码发送
#define PATH_USER_REGISTERED_SMSVERIFYCODE      @"/sms/verifySMSVerifyCode" //短信验证码校验
#define PATH_USER_LOGIN_FORGETPASSWORD          @"/user/forgetPassword"     // 客户端用户忘记密码
#define PATH_USER_MODIFI_PASSWORD               @"/user/updatePassword"     // 客户端用户修改密码
#define PATH_USER_LOGIN_LOGINVERIFY             @"/user/login"              // 客户端用户登录
#define PATH_USER_REGISTERED_REGISTEREDNVERIFY  @"/user/register"           // 客户端用户注册
#define PATH_USER_CHECKOUTYOLOID                @"/user/checkYoloNo"        // 检测YoloID 是否可用包括手机号
#define PATH_USER_UPDATELOGIN                   @"/user/updateLogin"        //修改 Yolo 号
#define PATH_USER_CHECKOUPHONE                  @"/user/checkPhone"         //检测Phone 是否已经注册
#define PATH_FRIENDS_MOBILEFRIENDS              @"/friendsManage/getMobileFriends" //获取通讯录好友
#define PATH_FRIENDS_SEARCHUSER                 @"/user/searchuser" //用户搜索

#endif /* YZHPathConst_h */
