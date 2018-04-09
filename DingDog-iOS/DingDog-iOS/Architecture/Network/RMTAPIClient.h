//
//  RMTAPIClient.h
//  ZhaoBu
//
//  Created by 姚卓禹 on 15/12/14.
//  Copyright © 2015年 9tong. All rights reserved.
//

//#import "AFHTTPRequestOperationManager.h"

#import "AFHTTPSessionManager.h"

@interface RMTAPIClient : AFHTTPSessionManager  // AFHTTPRequestOperationManager

+ (RMTAPIClient *)sharedClient;

- (AFHTTPSessionManager *)postPath:(NSString *)path
                          parameters:(NSDictionary *)parameters
                             success:(void (^)(id operation, id responseObject))success
                             failure:(void (^)(id operation, NSError *error))failure;

@end
