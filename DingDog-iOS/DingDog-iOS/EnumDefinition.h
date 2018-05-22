//
//  EnumDefinition.h
//  DingDog-iOS
//
//  Created by 耿功发 on 2018/3/14.
//  Copyright © 2018年 耿功发. All rights reserved.
//

#ifndef EnumDefinition_h
#define EnumDefinition_h
#import <ImSDK/ImSDK.h>

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

typedef NS_ENUM(NSInteger, IMAConType)
{
    IMA_Unknow,                     // 未知
    IMA_C2C = TIM_C2C,              // C2C类型
    IMA_Group = TIM_GROUP,          // 群聊类型
    IMA_System = TIM_SYSTEM,        // 系统消息
    // 定制会话类型
    IMA_Connect,                    // 网络联接
    
    //    kSupportCustomConversation 为 1时有效
    IMA_Sys_NewFriend,              // 新朋友系统消息
    IMA_Sys_GroupTip,               // 群系统消息通知
    
};

#endif /* EnumDefinition_h */
