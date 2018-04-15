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
#define kUserDict   @"user_dict"

@implementation MyAccountManager

+ (MyAccountManager *)sharedManager {
    static MyAccountManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[MyAccountManager alloc] init];
    });
    return sharedManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self loadMyAccountInfoFromBuffer];
    }
    return self;
}

- (void)loadMyAccountInfoFromBuffer {
    NSError *error = nil;
    NSDictionary *json = [USER objectForKey:kUserDict];
    if (json) {
        self.currentUser = [MTLJSONAdapter modelOfClass:[UserCmd class] fromJSONDictionary:json error:&error];
        NSLog(@"%@", _currentUser);
        if (error) {
            NSAssert(0, [error localizedDescription]);
        }
    }
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

// 保存用户profile
- (void)saveUserProfile:(UserCmd *)user {
    if(user){
        self.currentUser = user;
        NSDictionary *json = [[MTLJSONAdapter JSONDictionaryFromModel:user error:nil] removeEmptyValue];
        [USER setObject:json forKey:kUserDict];
        [USER synchronize];
    }
}


#pragma mark - logout
- (void)logoutAndClearBuffer {
//    [USER removeObjectForKey:kUserDict];
    [USER removeObjectForKey:@"Cookie_Token"];
//    self.currentStore = nil;
//    self.currentUser = nil;
}

@end
