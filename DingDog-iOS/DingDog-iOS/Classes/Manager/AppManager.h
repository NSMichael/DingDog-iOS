//
//  AppManager.h
//  DingDog-iOS
//
//  Created by james on 18/06/07.
//  Copyright © 2018年 耿功发. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyAccountManager.h"
#import "UploadManager.h"

@interface AppManager : NSObject

@property(nonatomic,strong) MyAccountManager *accountManager;

@property(nonatomic,strong) UploadManager *uploadManager;

+ (AppManager*)GetInstance;

/**
 系统启动后要做的工作，这些工作不要放到从零启动的那个执行序列中；
 请在系统启动，界面都被正常绘制，且用户已经可以点击操作后，再调用本函数来执行；（目的是为了加快启动速度）
 */
-(void)startUp;

//登录成功后调用
- (void)onLoginSuccess;

@end
