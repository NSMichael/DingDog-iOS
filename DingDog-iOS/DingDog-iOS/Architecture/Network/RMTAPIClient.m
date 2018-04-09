//
//  RMTAPIClient.m
//  ZhaoBu
//
//  Created by 姚卓禹 on 15/12/14.
//  Copyright © 2015年 9tong. All rights reserved.
//

#import "RMTAPIClient.h"
#import "AFNetworkActivityIndicatorManager.h"

#define RMT_SERVER_PATH [NSString stringWithFormat:@"http://%@/",@"v1.api.bulldogo.com"]

@implementation RMTAPIClient

+ (RMTAPIClient *)sharedClient {
    
    static RMTAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[RMTAPIClient alloc] initWithBaseURL:[NSURL URLWithString:RMT_SERVER_PATH]];
        
        [_sharedClient.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
        [_sharedClient.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        //[_sharedClient.requestSerializer setValue:[self appVersion] forHTTPHeaderField:@"ClientVersion"];
        
        _sharedClient.responseSerializer.acceptableContentTypes = [_sharedClient.responseSerializer.acceptableContentTypes setByAddingObjectsFromArray: @[@"application/json", @"text/html",@"application/octet-stream"]];  // 感觉这样更合理些.
        
        // 设置超时时间
        [_sharedClient.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        _sharedClient.requestSerializer.timeoutInterval = 20.0f;
        [_sharedClient.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        
        [_sharedClient.securityPolicy setAllowInvalidCertificates:YES];
        [_sharedClient.securityPolicy setValidatesDomainName:NO];
        
    });
    return _sharedClient;
}

- (instancetype)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    // Ensure terminal slash for baseURL path, so that NSURL +URLWithString:relativeToURL: works as expected
    if ([[url path] length] > 0 && ![[url absoluteString] hasSuffix:@"/"]) {
        url = [url URLByAppendingPathComponent:@""];
    }
    
    self.requestSerializer = [AFHTTPRequestSerializer serializer];
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    
    self.securityPolicy = [AFSecurityPolicy defaultPolicy];
    
    self.reachabilityManager = [AFNetworkReachabilityManager sharedManager];
    
//    self.operationQueue = [[NSOperationQueue alloc] init];
//    
//    self.shouldUseCredentialStorage = YES;
    
    return self;
}


- (AFHTTPSessionManager *)postPath:(NSString *)path
                          parameters:(NSDictionary *)parameters
                             success:(void (^)(id operation, id responseObject))success
                             failure:(void (^)(id operation, NSError *error))failure
{
    
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:NO];
    
    //过滤 emoji表情
    NSMutableDictionary *parametersWithoutEmoji=[NSMutableDictionary dictionaryWithCapacity:1];
    for (NSString *key in [parameters allKeys]) {
        [parametersWithoutEmoji setObject:[parameters objectForKey:key] forKey:key];
    }
//    NSString *snid = [SysInfo GetSNID];
//    NSString *actf = [SysInfo GetActF];
//    if (snid&&![snid isEqualToString:@""]
//        && actf && ![actf isEqualToString:@""]) {
//        [parametersWithoutEmoji setObject:snid forKey:@"_SNID"];
//        [parametersWithoutEmoji setObject:actf forKey:@"_ActF"];
//    }
    
//    //版本号
//    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
//    // app版本
//    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
//    
//    //追加vflag字段在所有请求中
//    if([self needAppendVflag:parameters]){
//        [parametersWithoutEmoji setObject:app_Version forKey:@"vflag"];
//    }
    
//    if(DEBUG_VERSION){
//        NSMutableString *paraStr = [NSMutableString stringWithString:@"?"];
//        if([parametersWithoutEmoji isKindOfClass:[NSDictionary class]]){
//            NSDictionary *dict = (NSDictionary*)parametersWithoutEmoji;
//            for(NSString *keystr in dict){
//                [paraStr appendFormat:@"%@=%@&",keystr,[parametersWithoutEmoji objectForKey:keystr]];
//            }
//        }
//        SLOG(@"\n>>>%@%@\n",[[NSURL URLWithString:path relativeToURL:self.baseURL] absoluteString]  ,paraStr);
//    }
    
    /*
    __weak typeof(self)weakSelf = self;
    AFHTTPRequestOperation *requestOperation = [self POST:path
                                               parameters:parametersWithoutEmoji
                                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                      
                                                      SLOG(@"\n");
                                                      SLOG(@"\n【sys 数据请求的Header值】:%@",weakSelf.requestSerializer.HTTPRequestHeaders);
                                                      SLOG(@"\n");
                                                      SLOG(@"\n>>>result: %@\n", operation.responseString);
                                                      success(operation,responseObject);
                                                  }
                                                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                      ;
                                                      SLOG(@"\n>>>Error: %@\n", error);
                                                      failure(operation,error);
                                                  }];
    
    return requestOperation;
     */
    
    __weak typeof(self)weakSelf = self;

    AFHTTPSessionManager *requestOperation = [self postPath:path parameters:parametersWithoutEmoji success:^(id operation, id responseObject) {
        
        SLOG(@"\n");
        SLOG(@"\n【sys 数据请求的Header值】:%@",weakSelf.requestSerializer.HTTPRequestHeaders);
        SLOG(@"\n");
//        SLOG(@"\n>>>result: %@\n", operation.responseString);
        success(operation,responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        SLOG(@"\n>>>Error: %@\n", error);
        failure(operation,error);
        
    }];
    
    return requestOperation;
}


@end
