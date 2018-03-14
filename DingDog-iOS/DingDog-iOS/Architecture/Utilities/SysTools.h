//
//  SysTools.h
//  vdangkou
//
//  Created by Smalltask on 15/3/10.
//  Copyright (c) 2015年 9tong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SysTools : NSObject


#pragma mark 系统函数
/**
 *  生成一个全局唯一的随机数
 *
 *  @return <#return value description#>
 */
+ (NSString *)getUniqueStrByUUID;

//构建一个和具体用户的userId相关的key的字符串
+(NSString*)userKey:(NSString*)identityStr;


#pragma mark 解析Json中的内容
+(NSString*)StringObj:(id)_ob;

+(NSNumber*)NumberObj:(id)_ob;

+(NSMutableArray*)NSMutableArrayObj:(id)_ob;


#pragma mark - Spring MVC HTTP请求 封装格式
/**
 构建用于发送到服务器的请求参数字典,使用 Java spring MVC 的方式
 */
+ (NSMutableDictionary*)getHttpPostParams:(NSDictionary*)json;


#pragma mark - date time
//返回单位：毫秒
+(long long int)GetCurrentTimeNumber;

#pragma mark - 字符串

/**
 *  比较两个版本号，返回版本号中，最大的那个字符串
 *  版本号必须都是3段式的；
 *
 *  @param ver1 <#ver1 description#>
 *  @param ver2 <#ver2 description#>
 *
 *  @return <#return value description#>
 */
+ (NSString*)getMaxVersion:(NSString*)ver1 version2:(NSString*)ver2;

+(NSString*)GetFommatPhoneNumber:(NSString*)_phoneNumber;

@end
