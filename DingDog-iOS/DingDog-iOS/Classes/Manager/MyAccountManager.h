//
//  MyAccountManager.h
//  DingDog-iOS
//
//  Created by james on 18/06/07.
//  Copyright © 2018年 耿功发. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyAccountManager : NSObject

+ (MyAccountManager *)sharedManager;

// 保存登录成功返回的Token，后续所有需要验证cookie的接口都必须传入此参数token
- (void)saveToken:(NSString *)token;

- (NSString *)getToken;

#pragma mark - logout
- (void)logoutAndClearBuffer;

@end
