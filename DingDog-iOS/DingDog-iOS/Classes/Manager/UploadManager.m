//
//  UploadManager.m
//  DingDog-iOS
//
//  Created by james on 18/06/07.
//  Copyright © 2018年 耿功发. All rights reserved.
//

#import "UploadManager.h"
#import "UploadTokenCmd.h"

static UploadManager *instance;

@implementation UploadManager

+ (UploadManager*)GetInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[UploadManager alloc] init];
        
    });
    return instance;
}

- (void)startUp
{
    NSString *userToken = [[MyAccountManager sharedManager] getToken];
    if(userToken && ![userToken isEqualToString:@""]){
        __weak __typeof(self) weakself = self;
        [self getResTokenFromServer:^(NSString *token, NSError *error) {
            if(error){
                // 10 秒钟后重试
                [weakself performSelector:@selector(startUp) withObject:nil afterDelay:10.];
                SLOG(@"警告：无法获取用于上传资源用的token.");
            }else{
                SLOG(@"获取上传资源用的token成功！token:%@",token);
            }
        }];
    }else{
        SLOG(@"用户还没有登录，无法进行获取资源resToken");
    }
}

/**
 从档口服务器获得token
 */
- (void)getResTokenFromServer :(void(^)(NSString *token,NSError *error))block{
    __weak __typeof(self) weakself = self;
    [NetworkAPIManager common_getUpToken:^(BaseCmd *cmd, NSError *error) {
        if(error){
            block(nil,error);
        }else{
            [cmd errorCheckSuccess:^{
                
                if ([cmd isKindOfClass:[UploadTokenCmd class]]) {
                    UploadTokenCmd *uploadCmd = (UploadTokenCmd *)cmd;
                    
                    weakself.token = uploadCmd.upload_Token;
                    [USER setObject:weakself.token forKey:@"AppResToken"];
                    [USER synchronize];
                    
                    block(uploadCmd.upload_Token,nil);
                }
                
            } failed:^(NSInteger errCode) {
                block(nil,[NSError errorWithDomain:@"" code:errCode userInfo:nil]);
            }];
        }
    }];
    
}

@end
