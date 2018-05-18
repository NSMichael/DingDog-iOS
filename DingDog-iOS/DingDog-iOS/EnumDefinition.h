//
//  EnumDefinition.h
//  DingDog-iOS
//
//  Created by 耿功发 on 2018/3/14.
//  Copyright © 2018年 耿功发. All rights reserved.
//

#ifndef EnumDefinition_h
#define EnumDefinition_h

typedef NS_ENUM(NSInteger, LoginType) {
    LoginType_login = 0,            // 登录
    LoginType_register,             // 注册
    LoginType_bind,                 // 绑定手机号
};

typedef NS_ENUM(NSInteger, EditInfoType) {
    EditInfoType_City = 0,          // 修改城市
    EditInfoType_Phone,             // 修改手机号
};

typedef NS_ENUM(NSInteger, WeChatType) {
    WeChatType_Login = 0,          // 微信登录
    WeChatType_Bind,               // 绑定微信
};

#endif /* EnumDefinition_h */
