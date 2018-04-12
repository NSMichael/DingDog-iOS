//
//  NetworkAPIManager.h
//  vdangkou
//
//  Created by 耿功发 on 15/3/9.
//  Copyright (c) 2015年 9tong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseCmd.h"

@interface NetworkAPIManager : NSObject

+ (instancetype)sharedManager;

#pragma mark - 登录

// 微信登录
+ (void)login_weChatWithParams:(id)params andBlock:(void (^)(BaseCmd *cmd, NSError *error))block;

// 获取图形验证码
+ (void)register_getCaptchaWithRefresh:(NSInteger)refresh andBlock:(void (^)(BaseCmd *cmd, NSError *error))block;

// 获取短信验证码
+ (void)register_getSMSWithMobile:(NSString *)mobile Captcha:(NSString *)captcha andBlock:(void (^)(BaseCmd *cmd, NSError *error))block;

@end