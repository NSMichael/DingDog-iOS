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
#import "UploadTokenCmd.h"
#import "TagListCmd.h"
#import "CustomerListCmd.h"
#import "CreateMessageCmd.h"

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

// 快速登录
+ (void)site_fastloginWithParams:(id)params andBlock:(void (^)(UserCmd *cmd, NSError *error))block {
    [[NetworkAPIClient sharedJsonClient] requestJsonDataWithPath:@"home/site/fastlogin" withParams:params withMethodType:Post andBlock:^(id data, NSError *error) {
        if (error) {
            block(nil, error);
        } else {
            UserCmd *cmd = [NetworkAPIManager modelOfClass:[UserCmd class] fromJSONDictionary:data error:&error];
            block(cmd, nil);
        }
    }];
}

#pragma mark - 资源
/**
 从档口server获取token,然后在上传图片时发送给七牛的server
 qiniu/getUpToken.do
 */
+ (void)common_getUpToken:(void(^)(BaseCmd *cmd,NSError *error))block {
    [[NetworkAPIClient sharedJsonClient] requestJsonDataWithPath:@"message/setting/qiniu" withParams:nil withMethodType:Post andBlock:^(id data, NSError *error) {
        if (error) {
            block(nil, error);
        } else {
            BaseCmd *cmd = [NetworkAPIManager modelOfClass:[UploadTokenCmd class] fromJSONDictionary:data error:&error];
            block(cmd, nil);
        }
    }];
}

/**
 七牛上传图片/语音获取key
 盯盘狗——七牛上传图片获取key
 参数type说明：
 common/getResKey.do
 */
+ (void)common_getResKey:(NSNumber*)type block:(void(^)(BaseCmd *cmd,NSError *error))block {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:type,@"type", nil];
    
    [[NetworkAPIClient sharedJsonClient] requestJsonDataWithPath:@"common/getResKey.do" withParams:params withMethodType:Post andBlock:^(id data, NSError *error) {
        if (error) {
            block(nil, error);
        } else {
            //data中的值就是 key,形如："data":"buy_pic/79/185844be99181a34"
            BaseCmd *cmd = [NetworkAPIManager modelOfClass:[UploadTokenCmd class] fromJSONDictionary:data error:&error];
            block(cmd, nil);
        }
    }];
}

#pragma mark - 标签

// 标签列表
+ (void)customer_tagList:(void(^)(BaseCmd *cmd,NSError *error))block {
    [[NetworkAPIClient sharedJsonClient] requestJsonDataWithPath:@"my/customer/tag/list" withParams:nil withMethodType:Post andBlock:^(id data, NSError *error) {
        if (error) {
            block(nil, error);
        } else {
            BaseCmd *cmd = [NetworkAPIManager modelOfClass:[TagListCmd class] fromJSONDictionary:data error:&error];
            block(cmd, nil);
        }
    }];
}

// 添加标签
+ (void)customer_tagCreateWithParams:(id)params andBlock:(void (^)(BaseCmd *cmd, NSError *error))block {
    [[NetworkAPIClient sharedJsonClient] requestJsonDataWithPath:@"my/customer/tag/create" withParams:params withMethodType:Post andBlock:^(id data, NSError *error) {
        if (error) {
            block(nil, error);
        } else {
            BaseCmd *cmd = [NetworkAPIManager modelOfClass:[BaseCmd class] fromJSONDictionary:data error:&error];
            block(cmd, nil);
        }
    }];
}

// 删除标签
+ (void)customer_tagRemoveWithParams:(id)params andBlock:(void (^)(BaseCmd *cmd, NSError *error))block {
    [[NetworkAPIClient sharedJsonClient] requestJsonDataWithPath:@"my/customer/tag/remove" withParams:params withMethodType:Post andBlock:^(id data, NSError *error) {
        if (error) {
            block(nil, error);
        } else {
            BaseCmd *cmd = [NetworkAPIManager modelOfClass:[BaseCmd class] fromJSONDictionary:data error:&error];
            block(cmd, nil);
        }
    }];
}

// 指定标签下的用户列表
+ (void)customer_tagUsersWithParams:(id)params andBlock:(void (^)(BaseCmd *cmd, NSError *error))block {
    [[NetworkAPIClient sharedJsonClient] requestJsonDataWithPath:@"my/customer/tag/users" withParams:params withMethodType:Post andBlock:^(id data, NSError *error) {
        if (error) {
            block(nil, error);
        } else {
            BaseCmd *cmd = [NetworkAPIManager modelOfClass:[CustomerListCmd class] fromJSONDictionary:data error:&error];
            block(cmd, nil);
        }
    }];
}

#pragma mark - 客户

// 客户列表
+ (void)customer_List:(void(^)(BaseCmd *cmd,NSError *error))block {
    [[NetworkAPIClient sharedJsonClient] requestJsonDataWithPath:@"my/customer/list" withParams:nil withMethodType:Post andBlock:^(id data, NSError *error) {
        if (error) {
            block(nil, error);
        } else {
            BaseCmd *cmd = [NetworkAPIManager modelOfClass:[CustomerListCmd class] fromJSONDictionary:data error:&error];
            block(cmd, nil);
        }
    }];
}

// 更新客户信息
+ (void)customer_profileUpdateWithParams:(id)params andBlock:(void (^)(BaseCmd *cmd, NSError *error))block {
    [[NetworkAPIClient sharedJsonClient] requestJsonDataWithPath:@"my/customer/profile/update" withParams:params withMethodType:Post andBlock:^(id data, NSError *error) {
        if (error) {
            block(nil, error);
        } else {
            BaseCmd *cmd = [NetworkAPIManager modelOfClass:[BaseCmd class] fromJSONDictionary:data error:&error];
            block(cmd, nil);
        }
    }];
}

#pragma mark - 消息

// 创建消息
+ (void)message_createWithParams:(id)params andBlock:(void (^)(BaseCmd *cmd, NSError *error))block {
    [[NetworkAPIClient sharedJsonClient] requestJsonDataWithPath:@"my/message/create" withParams:params withMethodType:Post andBlock:^(id data, NSError *error) {
        if (error) {
            block(nil, error);
        } else {
            BaseCmd *cmd = [NetworkAPIManager modelOfClass:[CreateMessageCmd class] fromJSONDictionary:data error:&error];
            block(cmd, nil);
        }
    }];
}

// 群发消息
+ (void)message_multiSendWithParams:(id)params andBlock:(void (^)(BaseCmd *cmd, NSError *error))block {
    [[NetworkAPIClient sharedJsonClient] requestJsonDataWithPath:@"my/message/multi-send" withParams:params withMethodType:Post andBlock:^(id data, NSError *error) {
        if (error) {
            block(nil, error);
        } else {
            BaseCmd *cmd = [NetworkAPIManager modelOfClass:[BaseCmd class] fromJSONDictionary:data error:&error];
            block(cmd, nil);
        }
    }];
}

@end


