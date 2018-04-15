//
//  AppManager.m
//  DingDog-iOS
//
//  Created by james on 18/06/07.
//  Copyright © 2018年 耿功发. All rights reserved.
//

#import "AppManager.h"

static AppManager *instance;

@implementation AppManager

+ (AppManager*)GetInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[AppManager alloc] init];
    });
    return instance;
}

-(instancetype)init{
    self = [super init];
    if(self){
        //账号管理
        _accountManager = [MyAccountManager sharedManager];
        
        //资源上传类
        _uploadManager = [UploadManager GetInstance];
    }
    return self;
}

/**
 系统启动后要做的工作，这些工作不要放到从零启动的那个执行序列中；
 请在系统启动，界面都被正常绘制，且用户已经可以点击操作后，再调用本函数来执行；（目的是为了加快启动速度）
 */
-(void)startUp {
    [self performSelector:@selector(startUpWork) withObject:nil afterDelay:0.5];
}

//具体的启动逻辑写在这个方法里
-(void)startUpWork{
    [self.uploadManager startUp];
}

//登录成功后调用
- (void)onLoginSuccess {
    [self.uploadManager startUp];//获取资源ResToken
}

@end
