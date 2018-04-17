//
//  NetworkAPIClient.m
//  vdangkou
//
//  Created by 耿功发 on 15/3/9.
//  Copyright (c) 2015年 9tong. All rights reserved.
//

#import "NetworkAPIClient.h"
#import "NSString+EmojiExtension.h"

@implementation NetworkAPIClient

+ (NetworkAPIClient *)sharedJsonClient {
    static NetworkAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[NetworkAPIClient alloc] initWithBaseURL:[NSURL URLWithString:SERVER_PATH]];
        
        [_sharedClient.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
        [_sharedClient.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
        //        _sharedClient.responseSerializer.acceptableContentTypes = [_sharedClient.responseSerializer.acceptableContentTypes setByAddingObjectsFromArray: @[@"text/html",@"application/octet-stream"]];  // 感觉这样更合理些.
        
        [_sharedClient.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json",@"text/html",@"application/octet-stream",@"text/javascript",@"text/plain", nil]];
        
        _sharedClient.requestSerializer.HTTPShouldHandleCookies = YES;
        
        // 设置超时时间
        [_sharedClient.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        _sharedClient.requestSerializer.timeoutInterval = 20.0f;
        [_sharedClient.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        
        [_sharedClient.securityPolicy setAllowInvalidCertificates:YES];
        [_sharedClient.securityPolicy setValidatesDomainName:NO];
    });
    
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    /*
    [self.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [self.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json",@"text/html",@"application/octet-stream", @"text/json", @"text/javascript",@"text/plain", nil]];
    
    // 设置超时时间
    [self.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    self.requestSerializer.timeoutInterval = 20.0f;
    [self.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [self.securityPolicy setAllowInvalidCertificates:YES];
    [self.securityPolicy setValidatesDomainName:NO];
     */
    
    self.requestSerializer = [AFHTTPRequestSerializer serializer];
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    
    self.securityPolicy = [AFSecurityPolicy defaultPolicy];
    
    self.reachabilityManager = [AFNetworkReachabilityManager sharedManager];
    
    return self;
}

- (void)requestJsonDataWithPath:(NSString *)aPath
                     withParams:(NSDictionary*)params
                 withMethodType:(int)NetworkMethod
                       andBlock:(void (^)(id data, NSError *error))block{
    
    if([aPath rangeOfString:@"?"].location == NSNotFound){
        //m=1:表示iOS客户端
        aPath = [NSString stringWithFormat:@"%@?",aPath];
    }else{
        aPath = [NSString stringWithFormat:@"%@?",aPath];
    }
    aPath = [aPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //过滤 emoji表情
    NSMutableDictionary *parametersWithoutEmoji=[NSMutableDictionary dictionaryWithCapacity:1];
    for (NSString *key in [params allKeys]) {
        if ([params objectForKey:key]&&[[params objectForKey:key] isKindOfClass:[NSString class]]) {
            [parametersWithoutEmoji setObject:[[params objectForKey:key] removeEmoji] forKey:key];
        }
        else
        {
            [parametersWithoutEmoji setObject:[params objectForKey:key] forKey:key];
        }
    }
    
    NSString *token = [[MyAccountManager sharedManager] getToken];
    if (token && ![token isEqualToString:@""]) {
//        [parametersWithoutEmoji setObject:token forKey:@"token"];
        [self.requestSerializer setValue:token forHTTPHeaderField:@"X-AUTH-TOKEN"];
    }
    
    NSString *cookie = [[MyAccountManager sharedManager] getCookie];
    if (cookie && ![cookie isEqualToString:@""]) {
        [self.requestSerializer setValue:cookie forHTTPHeaderField:@"Cookie"];
    }
    
    //添加版本号
    if(DEBUG_VERSION){
        //打印请求内容，使用GET方式打印，便于在浏览器中调试或发给server端同学调试
        NSMutableString *paraStr = [NSMutableString stringWithString:@"&"];
        if([parametersWithoutEmoji isKindOfClass:[NSDictionary class]]){
            NSDictionary *dict = (NSDictionary*)parametersWithoutEmoji;
            for(NSString *keystr in dict){
                [paraStr appendFormat:@"%@=%@&",keystr,[parametersWithoutEmoji objectForKey:keystr]];
            }
        }
        SLOG(@"\n>>>\n%@%@\n",[[NSURL URLWithString:aPath relativeToURL:self.baseURL] absoluteString]  ,paraStr);
    }
    
    switch (NetworkMethod) {
            case Get:{
                [self GET:aPath parameters:parametersWithoutEmoji success:^(NSURLSessionDataTask *task, id responseObject) {
                    if(DEBUG_VERSION){
                        SLOG(@"\n");
                        SLOG(@"\n【sys 数据请求的Header值】:%@",self.requestSerializer.HTTPRequestHeaders);
                        SLOG(@"\n");
                        SLOG(@"\n>>>result: %@\n", responseObject);
                    }
                    
                    NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
                    SLOG(@"\n");
                    SLOG(@"====currentRequest====%@", task.currentRequest.allHTTPHeaderFields);
                    SLOG(@"\n");
                    SLOG(@"====task.response====%@", response.allHeaderFields[@"Set-cookie"]);
                    
                    NSString *cookie = [[MyAccountManager sharedManager] getCookie];
                    if (!cookie || cookie.length == 0) {
                        NSString* dataCookie = [NSString stringWithFormat:@"%@",[[response.allHeaderFields[@"Set-Cookie"]componentsSeparatedByString:@";"]objectAtIndex:0]];
                        [[MyAccountManager sharedManager] saveCookie:dataCookie];
                    }
                    
                    block(responseObject, nil);
                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                    SLOG(@"\n>>>Error: %@\n", error);
                    block(task, error);
                }];
                
                break;
            }
            
            case Post: {
                [self POST:aPath parameters:parametersWithoutEmoji success:^(NSURLSessionDataTask *task, id responseObject) {
                    if(DEBUG_VERSION){
                        SLOG(@"\n");
                        SLOG(@"\n【sys 数据请求的Header值】:%@",self.requestSerializer.HTTPRequestHeaders);
                        SLOG(@"\n");
                        SLOG(@"\n>>>result: %@\n", responseObject);
                    }
                    
                    NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
                    SLOG(@"\n");
                    SLOG(@"====currentRequest====%@", task.currentRequest.allHTTPHeaderFields);
                    SLOG(@"\n");
                    SLOG(@"====task.response====%@", response.allHeaderFields[@"Set-cookie"]);
                    
                    NSString *cookie = [[MyAccountManager sharedManager] getCookie];
                    if (!cookie || cookie.length == 0) {
                        [[MyAccountManager sharedManager] saveCookie:response.allHeaderFields[@"Set-cookie"]];
                    }
                    
                    block(responseObject, nil);
                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                    SLOG(@"\n>>>Error: %@\n", error);
                    block(task, error);
                }];
                
                break;
            }
            
            case Put: {
                [self PUT:aPath parameters:parametersWithoutEmoji success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    
                    SLOG(@"\n[Resp]:\n%@:\n", responseObject);
                    block(responseObject, nil);
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    
                    SLOG(@"\n[Resp Error]:\n%@", error);
                    block(nil, error);
                    
                }];
                
                break;
            }
            
            case Delete: {
                [self DELETE:aPath parameters:parametersWithoutEmoji success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    
                    SLOG(@"\n[Resp]:\n%@:\n", responseObject);
                    block(responseObject, nil);
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    
                    SLOG(@"\n[Resp Error]:\n%@", error);
                    block(nil, error);
                    
                }];
                
                break;
            }
        default:
            break;
    }
    
    //发起请求
    /*
    switch (NetworkMethod) {
        case Get:{
            [self GET:aPath parameters:parametersWithoutEmoji success:^(AFHTTPRequestOperation *operation, id responseObject) {
                SLOG(@"\n[Resp]:\n%@:\n", responseObject);
                block(responseObject, nil);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                SLOG(@"\n[Resp Error]:\n%@", error);
                block(nil, error);
            }];
            break;}
        case Post:{
            [self POST:aPath parameters:parametersWithoutEmoji success:^(AFHTTPRequestOperation *operation, id responseObject) {
                SLOG(@"\n[获取的数据]:\n%@ \n", [operation responseString]);
                block(responseObject,nil);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                SLOG(@"\n[Resp Error]:\n%@", error);
                block(nil, error);
            }];
            break;}
        case Put:{
            [self PUT:aPath parameters:parametersWithoutEmoji success:^(AFHTTPRequestOperation *operation, id responseObject) {
                SLOG(@"\n[Resp]:\n%@:\n", responseObject);
                block(responseObject, nil);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                SLOG(@"\n[Resp Error]:\n%@", error);
                block(nil, error);
            }];
            break;}
        case Delete:{
            [self DELETE:aPath parameters:parametersWithoutEmoji success:^(AFHTTPRequestOperation *operation, id responseObject) {
                SLOG(@"\n[Resp]:\n%@:\n", responseObject);
                block(responseObject, nil);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                SLOG(@"\n[Resp Error]:\n%@", error);
                block(nil, error);
            }];}
        default:
            break;
    }
     */
}

- (void)downloadDataWithFullPath:(NSString *)aPath
                       andBlock:(void (^)(id data, NSError *error))block{
    
    aPath = [aPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    SLOG(@"%@",aPath);
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.operationQueue setMaxConcurrentOperationCount:6];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setTimeoutInterval:20];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject: @"application/octet-stream"];
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"GET" URLString:[[NSURL URLWithString:aPath relativeToURL:manager.baseURL] absoluteString] parameters:params error:nil];
    
    
    AFHTTPSessionManager *operation = [AFHTTPSessionManager manager];
    
//    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = manager.responseSerializer;
//    operation.shouldUseCredentialStorage = manager.shouldUseCredentialStorage;
//    operation.credential = manager.credential;
    operation.securityPolicy = manager.securityPolicy;
    
    [operation GET:[[NSURL URLWithString:aPath relativeToURL:manager.baseURL] absoluteString] parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        SLOG(@"下载成功!");
        block(responseObject, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        SLOG(@"\n[Resp]:\n%@:\n", error);
        block(nil, error);
    }];
    
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject){
//        SLOG(@"下载成功!");
//        block(responseObject, nil);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
//        SLOG(@"\n[Resp]:\n%@:\n", error);
//        block(nil, error);
//    }];
    operation.completionQueue = manager.completionQueue;
    operation.completionGroup = manager.completionGroup;
    
    
//    [manager.operationQueue addOperation:operation];
    
    
}

/*
- (void)downloadDataWithFullPath:(NSString *)aPath
                        andBlock:(void (^)(id data, NSError *error))block{
    
    aPath = [aPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    SLOG(@"%@",aPath);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.operationQueue setMaxConcurrentOperationCount:6];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setTimeoutInterval:20];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject: @"application/octet-stream"];
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"GET" URLString:[[NSURL URLWithString:aPath relativeToURL:manager.baseURL] absoluteString] parameters:params error:nil];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = manager.responseSerializer;
    operation.shouldUseCredentialStorage = manager.shouldUseCredentialStorage;
    operation.credential = manager.credential;
    operation.securityPolicy = manager.securityPolicy;
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject){
        SLOG(@"下载成功!");
        block(responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        SLOG(@"\n[Resp]:\n%@:\n", error);
        block(nil, error);
    }];
    operation.completionQueue = manager.completionQueue;
    operation.completionGroup = manager.completionGroup;
    
    
    [manager.operationQueue addOperation:operation];
 
}
 */


@end
