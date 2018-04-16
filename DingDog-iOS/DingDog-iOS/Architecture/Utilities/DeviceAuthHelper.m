//
//  DeviceAuthHelper.m
//  vdangkou
//
//  Created by james on 15/3/15.
//  Copyright (c) 2015年 9tong. All rights reserved.
//

#import "DeviceAuthHelper.h"

@import AVFoundation;

@implementation DeviceAuthHelper

+ (BOOL)checkPhotoLibraryAuthorizationStatus
{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied){
        // 无权限 做一个友好的提示
        [self showSettingAlertStr:@"请在iPhone的“设置->隐私->照片”中打开本应用的访问权限"];
        return NO;
    }
    
//    if ([ALAssetsLibrary respondsToSelector:@selector(authorizationStatus)]) {
//        ALAuthorizationStatus authStatus = [ALAssetsLibrary authorizationStatus];
//        if (ALAuthorizationStatusDenied == authStatus ||
//            ALAuthorizationStatusRestricted == authStatus) {
//            [self showSettingAlertStr:@"请在iPhone的“设置->隐私->照片”中打开本应用的访问权限"];
//            return NO;
//        }
//    }
    
    return YES;
}

+ (BOOL)checkCameraAuthorizationStatus
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self showAlertWithMessage:@"该设备不支持拍照"];
        return NO;
    }
    
    AVAuthorizationStatus videoStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (videoStatus == AVAuthorizationStatusRestricted || videoStatus == AVAuthorizationStatusDenied)
    {
        // 没有权限
        [self showSettingAlertStr:@"请在iPhone的“设置->隐私->相机”中打开本应用的访问权限"];
        return NO;
    }
    
//    if ([AVCaptureDevice respondsToSelector:@selector(authorizationStatusForMediaType:)]) {
//        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
//        if (AVAuthorizationStatusDenied == authStatus ||
//            AVAuthorizationStatusRestricted == authStatus) {
//            [self showSettingAlertStr:@"请在iPhone的“设置->隐私->相机”中打开本应用的访问权限"];
//            return NO;
//        }
//    }
    
    return YES;
}

+ (BOOL)checkRecordPermission {
    
    __block BOOL auth = NO;
    
    AVAudioSession *avSession = [AVAudioSession sharedInstance];
    
    if ([avSession respondsToSelector:@selector(requestRecordPermission:)]) {
        
        [avSession requestRecordPermission:^(BOOL granted) {
            
            if (granted) {
                auth = YES;
            } else {
                //包一层，防止在未决状态的弹窗时，用户点击“取消授权”而导致界面假死
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showSettingAlertStr:@"麦克风未开启，请在“设置>隐私>麦克风”中允许好面料访问，以便语音找布"];
                });
                auth = NO;
            }
            
        }];
    }
    
    return auth;
}

+ (void)showSettingAlertStr:(NSString *)tipStr{
    //iOS8+系统下可跳转到‘设置’页面，否则只弹出提示窗即可
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_8_x_Max) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:tipStr preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            // 跳转到设置 - 相机 / 该应用的设置界面
            NSURL *url1 = [NSURL URLWithString:@"App-Prefs:root=Privacy&path=CAMERA"];
            // iOS10也可以使用url2访问，不过使用url1更好一些，可具体根据业务需求自行选择
            NSURL *url2 = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if (@available(iOS 11.0, *)) {
                [[UIApplication sharedApplication] openURL:url2 options:@{} completionHandler:nil];
            } else {
                if ([[UIApplication sharedApplication] canOpenURL:url1]){
                    if (@available(iOS 10.0, *)) {
                        [[UIApplication sharedApplication] openURL:url1 options:@{} completionHandler:nil];
                    } else {
                        [[UIApplication sharedApplication] openURL:url1];
                    }
                }
            }
            
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [[[UIApplication sharedApplication] keyWindow].rootViewController presentViewController:alertController animated:YES completion:nil];
        
    } else{
        [self showAlertWithMessage:tipStr];
    }
}

+ (void)showAlertWithMessage:(NSString *)msgStr {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:msgStr preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:nil]];
    [[[UIApplication sharedApplication] keyWindow].rootViewController presentViewController:alertController animated:YES completion:nil];
}

/**
 * 检查系统“定位服务”的授权状态，如果权限被关闭，提示用户去隐私设置中打开.
 */
+ (BOOL)checkLocationPermission{
    NSAssert(0, @"请使用 INTULocationManager 类库来进行权限判断");
    return NO;
}

+ (BOOL)checkMobileContactsPermission{
    if(ABAddressBookGetAuthorizationStatus()==kABAuthorizationStatusAuthorized
       ||ABAddressBookGetAuthorizationStatus()==kABAuthorizationStatusNotDetermined)
        return YES;
    else{
        [self showSettingAlertStr:@"在设置>隐私>通讯录>中开启好面料通讯录的访问权限可以保存联系人"];
        return NO;
    }
}

/**
 * 检查 “手机通讯录” 的授权状态，如果权限关闭，提示用户去隐私设置中打开.
 */
+ (void)checkMobileContactsPermission:(void(^)(BOOL granted))block{
    CFErrorRef myError = NULL;
    WS(weakSelf);
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &myError);
    ABAddressBookRequestAccessWithCompletion(addressBook,
                                             ^(bool granted, CFErrorRef error) {
                                                 
                                                 if(error || !granted){
                                                     [weakSelf showSettingAlertStr:@"在设置>隐私>通讯录>中开启好面料通讯录的访问权限可以保存联系人"];
                                                 }
                                                 if(error){
                                                     block(NO);
                                                 }else{
                                                     block(granted);
                                                 }
                                             });
    CFRelease(addressBook);
}

@end
