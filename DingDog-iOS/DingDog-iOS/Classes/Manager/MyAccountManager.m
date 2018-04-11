//
//  MyAccountManager.m
//  DingDog-iOS
//
//  Created by james on 18/06/07.
//  Copyright © 2018年 耿功发. All rights reserved.
//

#import "MyAccountManager.h"

#define COOKIE_TOKEN @"Cookie_Token"

#define KEY_Cookie   @"KEY_Cookie"

@implementation MyAccountManager

+ (MyAccountManager *)sharedManager {
    static MyAccountManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[MyAccountManager alloc] init];
    });
    return sharedManager;
}

- (void)saveCookie:(NSString *)cookie {
    if (cookie && ![cookie isEqualToString:@""]) {
        [USER setObject:cookie forKey:KEY_Cookie];
        [USER synchronize];
    } else {
        [USER removeObjectForKey:KEY_Cookie];
        [USER synchronize];
    }
}

- (NSString *)getCookie {
    return [USER objectForKey:KEY_Cookie];
}

// 保存登录成功返回的Token，后续所有需要验证cookie的接口都必须传入此参数token
- (void)saveToken:(NSString *)token {
    if (token && ![token isEqualToString:@""]) {
        [USER setObject:token forKey:COOKIE_TOKEN];
        [USER synchronize];
    } else {
        [USER removeObjectForKey:COOKIE_TOKEN];
        [USER synchronize];
    }
}

- (NSString *)getToken {
    return [USER objectForKey:COOKIE_TOKEN];
}

#pragma mark - logout
- (void)logoutAndClearBuffer {
//    [USER removeObjectForKey:kUserDict];
    [USER removeObjectForKey:@"Cookie_Token"];
//    self.currentStore = nil;
//    self.currentUser = nil;
}

@end
