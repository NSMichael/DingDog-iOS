//
//  DeviceAuthHelper.h
//  vdangkou
//
//  Created by james on 15/3/15.
//  Copyright (c) 2015年 9tong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>

@interface DeviceAuthHelper : NSObject

+ (void)showSettingAlertStr:(NSString *)tipStr;

/**
 * 检查系统"照片"授权状态, 如果权限被关闭, 提示用户去隐私设置中打开.
 */
+ (BOOL)checkPhotoLibraryAuthorizationStatus;

/**
 * 检查系统"相机"授权状态, 如果权限被关闭, 提示用户去隐私设置中打开.
 */
+ (BOOL)checkCameraAuthorizationStatus;

/**
 * 检查系统"麦克风"授权状态, 如果权限被关闭, 提示用户去隐私设置中打开.
 */
+ (BOOL)checkRecordPermission;

/**
 * 检查系统“定位服务”的授权状态，如果权限被关闭，提示用户去隐私设置中打开.
 */
+ (BOOL)checkLocationPermission;

/**
 * 检查 “手机通讯录” 的授权状态，如果权限关闭，提示用户去隐私设置中打开.
 */
+ (void)checkMobileContactsPermission:(void(^)(BOOL granted))block;

+ (BOOL)checkMobileContactsPermission;

@end
