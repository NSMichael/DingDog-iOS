//
//  NetworkAPIManager.m
//  vdangkou
//
//  Created by 耿功发 on 15/3/9.
//  Copyright (c) 2015年 9tong. All rights reserved.
//

#import "NetworkAPIManager.h"
#import "NetworkAPIClient.h"
#import "RMTAPIClient.h"
#import "GetCaptchaCmd.h"

@implementation NetworkAPIManager

+ (instancetype)sharedManager {
    static NetworkAPIManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

/**
 调用本方法来解析Mantle,可自动将code，message封装到对象当中；
 优先将data中的内容还原为对像；
 如果data不是NSDictionay，则
 */
+(id)modelOfClass:(Class)class fromJSONDictionary:(NSDictionary *)dict error:(NSError **)error{
    if([dict isKindOfClass:[NSDictionary class]]){
        id data = [dict objectForKey:@"data"];
        BaseCmd *object = nil;
        if([data isKindOfClass:[NSDictionary class]]){
            object = [MTLJSONAdapter modelOfClass:class fromJSONDictionary:data error:error];
        }else if([data isKindOfClass:[NSArray class]]){
            object = [MTLJSONAdapter modelOfClass:class fromJSONDictionary:dict error:error];
        }else if(!data){
            object = [MTLJSONAdapter modelOfClass:class fromJSONDictionary:[NSDictionary dictionary] error:error];
            object.msgData = data;
        }else{
            object = [MTLJSONAdapter modelOfClass:[BaseCmd class] fromJSONDictionary:dict error:error];
            object.msgData = data;
        }
        object.code = [SysTools NumberObj:[dict objectForKey:@"code"]];
        object.message = [SysTools StringObj:[dict objectForKey:@"message"]];
        return object;
    }else{
        BaseCmd *cmd = [[BaseCmd alloc] init];
        if([dict objectForKey:@"code"]){
            cmd.code = [SysTools NumberObj:[dict objectForKey:@"code"]];
        }else{
            cmd.code = @(ERRORCODE_SYS_CLASS_TRANSFORM);
            NSAssert(0, @"警告：服务器端返回的网络消息包装格式不正确！！");
        }
        
        if([dict objectForKey:@"message"]){
            cmd.message = [SysTools StringObj:[dict objectForKey:@"message"]];
        }else{
            cmd.message = @"服务器故障";
        }
        cmd.msgData = [dict objectForKey:@"data"];
        return cmd;
    }
}

#pragma mark - 登录

// 微信登录
+ (void)login_weChatWithParams:(id)params andBlock:(void (^)(BaseCmd *cmd, NSError *error))block {
    [[NetworkAPIClient sharedJsonClient] requestJsonDataWithPath:@"home/site/wechatlogin" withParams:params withMethodType:Post andBlock:^(id data, NSError *error) {
        if (error) {
            block(nil, error);
        } else {
            BaseCmd *cmd = [NetworkAPIManager modelOfClass:[BaseCmd class] fromJSONDictionary:data error:&error];
            block(cmd, nil);
        }
    }];
}

// 获取图形验证码
+ (void)register_getCaptchaWithRefresh:(NSInteger)refresh andBlock:(void (^)(BaseCmd *cmd, NSError *error))block {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@(refresh),@"refresh", nil];
    
    [[NetworkAPIClient sharedJsonClient] requestJsonDataWithPath:@"home/site/captcha" withParams:params withMethodType:Get andBlock:^(id data, NSError *error) {
        if (error) {
            block(nil, error);
        } else {
            BaseCmd *cmd = [NetworkAPIManager modelOfClass:[GetCaptchaCmd class] fromJSONDictionary:data error:&error];
            block(cmd, nil);
        }
    }];
}

// 获取短信验证码
+ (void)register_getSMSWithMobile:(NSString *)mobile Captcha:(NSString *)captcha andBlock:(void (^)(BaseCmd *cmd, NSError *error))block {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   mobile,@"mobile", nil];
    // captcha, @"captcha",
    
    [[NetworkAPIClient sharedJsonClient] requestJsonDataWithPath:@"home/site/sms" withParams:params withMethodType:Post andBlock:^(id data, NSError *error) {
        if (error) {
            block(nil, error);
        } else {
            BaseCmd *cmd = [NetworkAPIManager modelOfClass:[BaseCmd class] fromJSONDictionary:data error:&error];
            block(cmd, nil);
        }
    }];
}

@end


