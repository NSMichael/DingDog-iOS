//
//  NetworkAPIManager.h
//  vdangkou
//
//  Created by 耿功发 on 15/3/9.
//  Copyright (c) 2015年 9tong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseCmd.h"
#import "GetCaptchaCmd.h"
#import "UserCmd.h"

@interface NetworkAPIManager : NSObject

+ (instancetype)sharedManager;

#pragma mark - 登录

// 微信登录
+ (void)login_weChatWithParams:(id)params andBlock:(void (^)(BaseCmd *cmd, NSError *error))block;

// 获取图形验证码
+ (void)register_getCaptchaWithRefresh:(NSInteger)refresh andBlock:(void (^)(BaseCmd *cmd, NSError *error))block;

// 获取短信验证码
+ (void)register_getSMSWithMobile:(NSString *)mobile Captcha:(NSString *)captcha andBlock:(void (^)(BaseCmd *cmd, NSError *error))block;

// 快速登录
+ (void)site_fastloginWithParams:(id)params andBlock:(void (^)(UserCmd *cmd, NSError *error))block;

#pragma mark - 资源
/**
 从档口server获取token,然后在上传图片时发送给七牛的server
 qiniu/getUpToken.do
 */
+ (void)common_getUpToken:(void(^)(BaseCmd *cmd,NSError *error))block;

/**
 七牛上传图片/语音获取key
 盯盘狗——七牛上传图片获取key
 参数type说明：
 common/getResKey.do
 */
+ (void)common_getResKey:(NSNumber*)type block:(void(^)(BaseCmd *cmd,NSError *error))block;

@end
