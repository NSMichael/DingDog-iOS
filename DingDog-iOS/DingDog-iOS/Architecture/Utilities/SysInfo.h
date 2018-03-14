//
//  SysInfo.h
//  ZhaoBu
//
//  Created by Smalltask on 15/4/8.
//  Copyright (c) 2015年 9tong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SysInfo : NSObject

#pragma mark - 设置及系统信息
/**
  获取系统信息；
  系统标签及设备型号的对照表见：https://www.theiphonewiki.com/wiki/Models
 */
+ (NSString*)getDeviceInfoForJavaServer;

#pragma mark -
#pragma mark 客户端检查最后一次的登陆时间，如果超过1天没有登陆，则系统自动为其登陆；
///把当前的启动时间保存下来
+(void)SetLastTimeWhileClientStart;

+(long long int)GetLastTimeWhileClientStart;

//保存最后一次将App切换到后台的时间
+(void)SetLastTimeWhenClientBecomeBackground;

/*
 清除最后一次退回到后台的时间；
 原因：为加快启动速度，采用以下两个优化：
 如果在socket超时时间内将APP从后台切换到前台，则系统不重新做socket连接；
 如果APP从后台切换到前的时间小于GPS_TIMEOUT_SECOND的设置（1小时），则不再重新定位；
 
 使用场景：
 登录成功后，在连接socket和启动定位前进行设置；
 */
+(void)SetLastTimeWhenClientBecomeBackgroundToZero;

+(long long int)GetLastTimeWhenClientBecomeBackground;

//获取当前时间到最后一次进入后台的时间差，单位：秒；
+(long long int)GetTimespanSinceLastTimeBecomeBackground;

#pragma mark -
//获取用户登录是否成功的状态；
+(BOOL)GetSignInState;

/**
 *  设置登陆状态
 *
 *  @param signIn <#signIn description#>
 */
+ (void)SetSignInState:(BOOL)signIn;

#pragma mark - APNS
+(void)SetDeviceToken:(NSString*)_deviceToken;

+(NSString*)GetDeviceToken;

//获取当前配置的渠道编号
+ (NSNumber*)getCpId;

/**
 appManager才是logout操作的主入口
 这个方法仅负责本类管理的内容
 */
+ (void)logout;

#pragma mark - 获取设备当前网络IP地址

+ (NSString *)getIPAddress:(BOOL)preferIPv4;

@end
